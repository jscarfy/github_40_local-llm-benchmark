#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
bash bin/setup_python.sh
# shellcheck disable=SC1091
source .venv/bin/activate
python dashboard/app.py
