#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

branch="$(git branch --show-current)"
if [[ -z "${branch}" ]]; then
  echo "[pull] ERROR: detached HEAD; checkout a branch first."
  exit 2
fi

# Choose a default remote
remote="$(git remote 2>/dev/null | head -n 1 || true)"
if [[ -z "${remote}" ]]; then
  echo "[pull] ERROR: no git remotes configured."
  exit 2
fi

# If upstream is missing, set it to remote/branch if it exists; otherwise create it.
if ! git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  if git show-ref --verify --quiet "refs/remotes/${remote}/${branch}"; then
    echo "[pull] setting upstream to ${remote}/${branch}"
    git branch --set-upstream-to="${remote}/${branch}" "${branch}"
  else
    echo "[pull] remote branch ${remote}/${branch} not found; pushing to create it and set upstream"
    git push -u "${remote}" "${branch}"
  fi
fi

echo "[pull] fetching..."
git fetch --prune "${remote}"

echo "[pull] pulling (ff-only)..."
git pull --ff-only

echo "[pull] status:"
git status -sb
