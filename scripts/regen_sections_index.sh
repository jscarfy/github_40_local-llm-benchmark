#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
DIR="$ROOT/docs/amsart/sections"
OUT="$DIR/sections.tex"
{
  echo "% Auto-generated sections index"
  ls "$DIR"/*.tex 2>/dev/null \
    | xargs -I{} basename "{}" \
    | grep -v '^sections\.tex$' \
    | awk -F'_' '{print $1 "\t" $0}' \
    | sort -n \
    | cut -f2- \
    | while read -r f; do
        echo "\\input{sections/$f}"
      done
} > "$OUT"
echo "[UPDATED] $OUT"
