#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=== CGPT Doctor ==="
echo "ROOT: $ROOT"
echo

need_dirs=(
  "docs/amsart"
  "docs/amsart/sections"
  "docs/texmacros"
  "slides/beamer"
  "slides/beamer/sections"
  "scripts"
  "src/lean"
  "src/coq"
)
for d in "${need_dirs[@]}"; do
  if [ -d "$d" ]; then
    echo "[OK] dir: $d"
  else
    echo "[MISSING] dir: $d"
  fi
done
echo

need_files=(
  "docs/amsart/paper.tex"
  "slides/beamer/slides.tex"
  "docs/texmacros/entropy_macros.tex"
  "Makefile"
)
for f in "${need_files[@]}"; do
  if [ -f "$f" ]; then
    echo "[OK] file: $f"
  else
    echo "[MISSING] file: $f"
  fi
done
echo

echo "=== Tools ==="
for t in latexmk pdflatex bibtex biber git; do
  if command -v "$t" >/dev/null 2>&1; then
    echo "[OK] $t: $(command -v "$t")"
  else
    echo "[WARN] $t: not found"
  fi
done
echo

echo "=== Git status ==="
git status --porcelain || true
