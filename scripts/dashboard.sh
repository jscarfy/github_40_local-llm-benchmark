#!/usr/bin/env bash
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
cd c$PROJ"
# shellcheck disable=SC1091
source .source .source .sourport PYTHONPATH="$PROJ${PYTHONPATH:+:$PYTHONPATH}"

cd dashboard
python3 app.py
