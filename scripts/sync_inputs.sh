#!/usr/bin/env bash
set -euo pipefail
ROOT="$(bash "$(dirname "${BASH_SOURCE[0]}")/find_root.sh")"
cd "$ROOT"
mkdir -p amsart beamer
# Build amsart/sections_auto.tex and beamer/sections_auto.tex from sections/*.tex sorted numerically.
echo "% auto-generated: DO NOT EDIT BY HAND" > amsart/sections_auto.tex
for f in $(ls -1 sections/*.tex 2>/dev/null | sort -V); do
  echo "\\input{$f}" >> amsart/sections_auto.tex
done
echo "% auto-generated: DO NOT EDIT BY HAND" > beamer/sections_auto.tex
for f in $(ls -1 sections/*.tex 2>/dev/null | sort -V); do
  echo "\\input{$f}" >> beamer/sections_auto.tex
done
echo "[OK] wrote amsart/sections_auto.tex and beamer/sections_auto.tex"
