#!/usr/bin/env bash
set -euo pipefail
ROOT="${ROOT:-$HOME/cgpt_autogen}"
SCRIPTS="${SCRIPTS:-$ROOT/scripts}"
STATE="${STATE:-$ROOT/state}"
source "$SCRIPTS/common.sh"

interval="${1:-1}"
mkdir -p "$STATE"

echo "autogen_loop: running (interval=${interval}s). Ctrl+C to stop."
trap 'echo "autogen_loop: stopped."; exit 0' INT

while true; do
  if out="$("$SCRIPTS/autogen_step.sh" 2>/dev/null)"; then
    if [ -n "$out" ]; then
      echo "autogen_loop: payload materialized -> $out"
    fi
  else
    :
  fi
  sleep "$interval"
done
