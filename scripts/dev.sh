#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
cd "$ROOT"

mkdir -p build/amsart build/beamer

echo "[BUILD] AMSArt..."
( cd amsart && pdflatex -interaction=nonstopmode -halt-on-error -output-directory=../build/amsart main.tex >/dev/null )
( cd amsart && pdflatex -interaction=nonstopmode -halt-on-error -output-directory=../build/amsart main.tex >/dev/null )

echo "[BUILD] Beamer..."
( cd beamer && pdflatex -interaction=nonstopmode -halt-on-error -output-directory=../build/beamer slides.tex >/dev/null )
( cd beamer && pdflatex -interaction=nonstopmode -halt-on-error -output-directory=../build/beamer slides.tex >/dev/null )

echo "[OK] Outputs:"
echo "  build/amsart/main.pdf"
echo "  build/beamer/slides.pdf"
