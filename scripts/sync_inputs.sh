#!/usr/bin/env bash
set -euo pipefail
ROOT="$(bash "$(dirname "${BASH_SOURCE[0]}")/find_root.sh")"
cd "$ROOT"

list() {
  ls -1 sections/*.tex 2>/dev/null | sort -V | sed 's|^|../|'
}

printf "%% auto\n" > amsart/sections_auto.tex
for f in $(list); do
  echo "\\input{$f}" >> amsart/sections_auto.tex
done

printf "%% auto\n" > beamer/sections_auto.tex
for f in $(list); do
  echo "\\input{$f}" >> beamer/sections_auto.tex
done

echo "[OK] wrote: amsart/sections_auto.tex"
echo "[OK] wrote: beamer/sections_auto.tex"
