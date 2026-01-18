#!/usr/bin/env bash
set -euo pipefail
# Run this in a terminal YOU control. Ctrl-C to stop.
if [ ! -x "./scripts/autogen_once.sh" ]; then
  echo "ERROR: ./scripts/autogen_once.sh missing or not executable"
  exit 2
fi
echo "[autogen_loop] starting; Ctrl-C to stop"
while true; do
  ./scripts/autogen_once.sh || true
  sleep 1
done
