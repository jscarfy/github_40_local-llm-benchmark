#!/usr/bin/env bash
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJ"
touch logs/autogen.log
tail -n 200 -f logs/autogen.log
