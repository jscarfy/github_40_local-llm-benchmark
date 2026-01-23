#!/usr/bin/env bash
set -euo pipefail
ROOT="$(bash "$(dirname "${BASH_SOURCE[0]}")/find_root.sh")"
cd "$ROOT"
num="${1:?num required}"
slug="${2:?slug required}"
title="${3:?title required}"
bodyfile="${4:-}"

if [[ ! "$num" =~ ^[0-9]+$ ]]; then echo "ERROR: num must be integer: $num" >&2; exit 2; fi
if [[ ! "$slug" =~ ^[a-z0-9_]+$ ]]; then echo "ERROR: bad slug: $slug" >&2; exit 2; fi

file="sections/${num}_${slug}.tex"
if [[ -f "$file" ]]; then
  echo "[SKIP] $file already exists"
  exit 0
fi

{
  cat <<TEX
% ============================================================
% Section ${num}: ${title}
% ============================================================
\\section{${title}}
\\label{sec:${num}_${slug}}

TEX
  if [[ -n "$bodyfile" && -f "$bodyfile" ]]; then
    cat "$bodyfile"
  else
    cat <<'BODY'
\subsection{Motivation}
Placeholder motivation: expand and refine as you iterate.

\subsection{Definitions}
Provide rigorous definitions, examples, and short lemmas.

\subsection{Remarks}
Add references and implementation notes for software hooks.
BODY
  fi
} > "$file"
echo "[OK] created $file"
