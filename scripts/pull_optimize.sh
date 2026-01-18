#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

# repo size in KB (portable-ish)
repo_kb="$(du -sk . | awk '{print $1}')"
echo "[optimize] repo size: ${repo_kb} KB"

# Threshold: 1,000,000 KB ~= ~1 GB
if [[ "${repo_kb}" -ge 1000000 ]]; then
  echo "[optimize] large repo: using depth=1 fast-forward pull"
  git pull --ff-only --depth=1 || {
    echo "[optimize] depth pull failed; falling back to normal ff-only pull"
    git pull --ff-only
  }
else
  echo "[optimize] normal repo: ff-only pull"
  git pull --ff-only
fi
