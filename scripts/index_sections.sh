#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

mkdir -p amsart/sections beamer/sections build
OUT="build/SECTIONS_INDEX.txt"
: > "$OUT"

echo "## AMSArt sections" >> "$OUT"
if [ -d amsart/sections ]; then
  find amsart/sections -maxdepth 2 -type f \( -name '*.tex' -o -name '*.md' \) -print | sort >> "$OUT"
fi

echo "" >> "$OUT"
echo "## Beamer sections" >> "$OUT"
if [ -d beamer/sections ]; then
  find beamer/sections -maxdepth 2 -type f \( -name '*.tex' -o -name '*.md' \) -print | sort >> "$OUT"
fi

echo "" >> "$OUT"
echo "Wrote: $OUT"
