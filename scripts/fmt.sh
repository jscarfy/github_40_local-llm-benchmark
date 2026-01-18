#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

echo "=== fmt: TeX (latexindent if available) ==="
if command -v latexindent >/dev/null 2>&1; then
  # Only format tracked TeX files (avoid touching huge untracked sets accidentally)
  mapfile -t TEX < <(git ls-files '*.tex' || true)
  if [ "${#TEX[@]}" -gt 0 ]; then
    for f in "${TEX[@]}"; do
      latexindent -w -s "$f" >/dev/null 2>&1 || true
    done
  fi
else
  echo "latexindent not installed; skipping TeX auto-format."
fi

echo "=== fmt: Python (ruff/black if available; otherwise skip) ==="
if command -v ruff >/dev/null 2>&1; then
  ruff check . --fix || true
fi
if command -v black >/dev/null 2>&1; then
  black . || true
fi

echo "=== fmt: Go (gofmt) ==="
if command -v go >/dev/null 2>&1; then
  if git ls-files '*.go' >/dev/null 2>&1; then
    git ls-files '*.go' | xargs -I{} gofmt -w "{}" || true
  fi
fi

echo "=== fmt: done ==="
