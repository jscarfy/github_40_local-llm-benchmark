#!/usr/bin/env bash
set -euo pipefail
if command -v docker >/dev/null 2>&1; then
  echo "Tailing docker logs for github_29_monorepo-starter-api (if exists)..."
  docker logs -f github_29_monorepo-starter-api || echo "No container logs."
else
  echo "docker not found; fallback to tailing repo log file if exists."
  if [ -f autogen_devloop.log ]; then
    tail -F autogen_devloop.log
  else
    echo "No autogen_devloop.log found."
  fi
fi
