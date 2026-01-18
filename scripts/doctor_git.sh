#!/usr/bin/env bash
set -euo pipefail

echo "[doctor_git] repo root: $(git rev-parse --show-toplevel)"
echo "[doctor_git] branch: $(git branch --show-current || true)"
echo "[doctor_git] remotes:"
git remote -v || true
echo "[doctor_git] upstream:"
git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "(none)"
echo "[doctor_git] status:"
git status -sb || true

echo "[doctor_git] done"
