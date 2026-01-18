.PHONY: all paper slides clean lean coq status doctor test venv

all: paper slides

paper:
\tcd docs/amsart && latexmk -pdf -quiet paper.tex || true
\tmkdir -p build
\tif [ -f docs/amsart/paper.pdf ]; then cp -f docs/amsart/paper.pdf build/paper.pdf; fi

slides:
\tcd slides/beamer && latexmk -pdf -quiet slides.tex || true
\tmkdir -p build
\tif [ -f slides/beamer/slides.pdf ]; then cp -f slides/beamer/slides.pdf build/slides.pdf; fi

clean:
\tcd docs/amsart && latexmk -C || true
\tcd slides/beamer && latexmk -C || true
\trm -rf build

lean:
\t@echo "=== running lean build (if configured) ==="
\tcd src/lean && lake build || true

coq:
\t@echo "=== running coq build (if configured) ==="
\tcd src/coq && make -j1 || true

status:
\tbash scripts/status.sh

doctor:
\tbash scripts/doctor.sh

venv:
\tpython3 -m venv .venv
\t. .venv/bin/activate && pip install -U pip setuptools wheel

test:
\t. .venv/bin/activate && pytest -q || true

fmt:
@echo "=== fmt: normalize tex + go + python (best-effort) ==="
@bash scripts/fmt.sh || true

build: all
@echo "=== build: (alias) ==="

help:
@echo "Targets:"
@echo "  all      : build paper + slides"
@echo "  paper    : latexmk docs/amsart/paper.tex -> build/paper.pdf"
@echo "  slides   : latexmk slides/beamer/slides.tex -> build/slides.pdf"
@echo "  fmt      : run scripts/fmt.sh (best-effort formatting)"
@echo "  venv     : create .venv + upgrade pip tooling"
@echo "  test     : run pytest if configured"
@echo "  doctor   : run scripts/doctor.sh"
@echo "  status   : run scripts/status.sh"
@echo "  clean    : clean latex outputs + build/"
