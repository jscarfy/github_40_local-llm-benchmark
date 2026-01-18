#!/usr/bin/env bash
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJ"
# shellcheck disable=SC1091
source .venv/bin/activate
export PYTHONPATH="$PROJ${PYTHONPATH:+:$PYTHONPATH}"
export KRAKEN_AUTOGEN_MODEL="${KRAKEN_AUTOGEN_MODEL:-deepseek-r1:7b}"

python3 - <<'PY'
from kraken_bot.tools.autogen_daemon import process_one
did = process_one()
print("processed_one=" + str(did))
PY
