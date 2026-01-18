#!/usr/bin/env bash
set -euo pipefail
NN="$1"; TITLE="$2"
ROOT="$(git rev-parse --show-toplevel)"
OUTDIR="$ROOT/docs/amsart/sections"
mkdir -p "$OUTDIR"
slug="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_' )"
OUT="$OUTDIR/${NN}_${slug}.tex"
[ -f "$OUT" ] && exit 0

PROMPT=$(cat <<EOF
Generate a rigorous AMSArt LaTeX section for chapter $NN titled "$TITLE".
Include:
- 1 Definition
- 1 Lemma + proof
- 1 Theorem + proof
- Highlighted Syntax Phenomenon subsection
Avoid Ext/cohomology language; use trace/bracket syntax.
EOF
)

ollama run deepseek-autogen "$PROMPT" > "$OUT"
echo "[CREATED] $OUT"
