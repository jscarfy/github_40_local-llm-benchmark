#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

mkdir -p build

echo "=== build_preview: paper ==="
if [ -f docs/amsart/paper.tex ]; then
  (cd docs/amsart && latexmk -pdf -quiet paper.tex) || true
  if [ -f docs/amsart/paper.pdf ]; then
    cp -f docs/amsart/paper.pdf build/paper.pdf
    echo "paper -> build/paper.pdf"
  fi
else
  echo "docs/amsart/paper.tex not found; skipping."
fi

echo "=== build_preview: slides ==="
if [ -f slides/beamer/slides.tex ]; then
  (cd slides/beamer && latexmk -pdf -quiet slides.tex) || true
  if [ -f slides/beamer/slides.pdf ]; then
    cp -f slides/beamer/slides.pdf build/slides.pdf
    echo "slides -> build/slides.pdf"
  fi
else
  echo "slides/beamer/slides.tex not found; skipping."
fi
