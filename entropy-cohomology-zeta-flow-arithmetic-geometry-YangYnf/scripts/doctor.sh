#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

echo "=== doctor: host ==="
uname -a || true
echo

echo "=== doctor: tools ==="
command -v git >/dev/null 2>&1 && git --version || echo "git: MISSING"
command -v make >/dev/null 2>&1 && make --version | head -n 1 || echo "make: MISSING"
command -v python3 >/dev/null 2>&1 && python3 --version || echo "python3: MISSING"
command -v latexmk >/dev/null 2>&1 && latexmk -v | head -n 2 || echo "latexmk: MISSING (install TeXLive/MacTeX)"
command -v pdflatex >/dev/null 2>&1 && pdflatex --version | head -n 2 || echo "pdflatex: MISSING"
command -v latexindent >/dev/null 2>&1 && latexindent -v | head -n 2 || echo "latexindent: MISSING (optional)"
command -v go >/dev/null 2>&1 && go version || echo "go: not found (ok if not used)"
command -v lake >/dev/null 2>&1 && lake --version || echo "lake: not found (ok if not used)"
echo

echo "=== doctor: repo structure ==="
[ -d docs/amsart ] && echo "docs/amsart: OK" || echo "docs/amsart: MISSING"
[ -d slides/beamer ] && echo "slides/beamer: OK" || echo "slides/beamer: MISSING"
[ -f Makefile ] && echo "Makefile: OK" || echo "Makefile: MISSING"
echo

echo "=== doctor: latex entrypoints ==="
[ -f docs/amsart/paper.tex ] && echo "paper.tex: OK" || echo "paper.tex: MISSING"
[ -f slides/beamer/slides.tex ] && echo "slides.tex: OK" || echo "slides.tex: MISSING"
echo

echo "=== doctor: try parsing Makefile ==="
make -n help >/dev/null 2>&1 || true
make -n 2>&1 | sed -n '1,80p' || true
