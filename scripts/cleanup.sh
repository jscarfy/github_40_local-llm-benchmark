#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Cleaning up output and state directories..."

# Remove all job files and logs
rm -rf .state/{ok,bad,quarantine}/* .logs/* .out/*

echo "[INFO] Cleanup complete."
