#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
echo "=== repo ==="
echo "root: $ROOT"
echo "branch: $(git branch --show-current || true)"
echo
echo "=== git status ==="
git status -sb || true
echo
echo "=== untracked (top) ==="
git ls-files --others --exclude-standard | sed -n '1,120p' || true
