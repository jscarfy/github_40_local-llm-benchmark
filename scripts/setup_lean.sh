#!/usr/bin/env bash
set -euo pipefail

if command -v elan >/dev/null 2>&1; then
  echo "[lean] elan found"
else
  echo "[lean] elan not found. Installing..."
  curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
  export PATH="$HOME/.elan/bin:$PATH"
fi

# Ensure a default toolchain exists
elan default stable

echo "[lean] lean version:"
lean --version
