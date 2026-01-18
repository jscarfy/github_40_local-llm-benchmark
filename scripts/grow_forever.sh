#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

BATCH="${1:-10}"
SLEEP_SECS="${2:-5}"

LOCKDIR=".locks/grow_forever.lock"
mkdir -p ".locks"
if ! mkdir "$LOCKDIR" 2>/dev/null; then
  echo "[WARN] Another grow_forever.sh appears to be running (lock exists: $LOCKDIR)."
  echo "       If you're sure it's stale, run: rmdir '$LOCKDIR'"
  exit 0
fi
trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT

safe_git() {
  rm -f ".git/index.lock" 2>/dev/null || true
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1
  return 0
}

for (;;) do
  echo "=== Growth loop: batch=${BATCH} sleep=${SLEEP_SECS}s @ $(date) ==="
  for _ in $(seq 1 "$BATCH"); do
    if ! safe_git; then
      echo "[WARN] Git not ready; sleeping ${SLEEP_SECS}s..."
      sleep "$SLEEP_SECS"
      continue
    fi

    ./scripts/index_sections.sh
    ./scripts/validate.sh

    if git status --porcelain | grep -q .; then
      # Scoped staging only (prevents adding $HOME/Library etc.)
      git add -A scripts amsart beamer build .gitignore .gitattributes README.md LICENSE 2>/dev/null || true

      if git diff --cached --quiet; then
        echo "No staged changes after scoped add. Sleeping ${SLEEP_SECS}s..."
        sleep "$SLEEP_SECS"
        continue
      fi

      # Avoid editor locks: force non-interactive commits
      GIT_EDITOR=true git commit -m "Growth: update project artifacts" --no-edit || true
      echo "Committed. Sleeping ${SLEEP_SECS}s..."
      sleep "$SLEEP_SECS"
    else
      echo "No changes detected. Sleeping ${SLEEP_SECS}s..."
      sleep "$SLEEP_SECS"
    fi
  done
done
