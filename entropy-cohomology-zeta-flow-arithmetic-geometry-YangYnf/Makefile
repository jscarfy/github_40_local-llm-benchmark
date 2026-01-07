.PHONY: all paper slides clean lean coq status doctor

all: paper slides

paper:
cd docs/amsart && latexmk -pdf -quiet paper.tex
mkdir -p build
cp -f docs/amsart/paper.pdf build/paper.pdf

slides:
cd slides/beamer && latexmk -pdf -quiet slides.tex
mkdir -p build
cp -f slides/beamer/slides.pdf build/slides.pdf

clean:
cd docs/amsart && latexmk -C || true
cd slides/beamer && latexmk -C || true
rm -rf build

lean:
cd src/lean && lake build

coq:
cd src/coq && make -j1

status:
bash scripts/status.sh

doctor:
bash scripts/doctor.sh
