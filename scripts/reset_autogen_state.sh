#!/usr/bin/env bash
set -euo pipefail
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJ"
# shellcheck disable=SC1091
source .venv/bin/activate
export PYTHONPATH="$PROJ${PYTHONPATH:+:$PYTHONPATH}"

python3 - <<'PY'
from kraken_bot.tools.autogen_queue import clear_all, counts
clear_all()
print("reset_ok", counts())
PY
