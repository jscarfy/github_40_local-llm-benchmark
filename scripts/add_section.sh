#!/usr/bin/env bash
set -euo pipefail
ROOT="$(bash "$(dirname "${BASH_SOURCE[0]}")/find_root.sh")"
cd "$ROOT"

num="${1:?num required}"
slug="${2:?slug required}"
title="${3:?title required}"
BODY_FILE="${4:-}"

# hard guard against paste-mangled inputs
if [[ ! "$num" =~ ^[0-9]+$ ]]; then
  echo "ERROR: num must be integer, got: $num" >&2
  exit 2
fi
if [[ ! "$slug" =~ ^[a-z0-9_]+$ ]]; then
  echo "ERROR: slug must match ^[a-z0-9_]+$, got: $slug" >&2
  exit 2
fi

file="sections/${num}_${slug}.tex"

if [[ -f "$file" ]]; then
  echo "[SKIP] $file"
  exit 0
fi

if [[ -n "$BODY_FILE" && ! -f "$BODY_FILE" ]]; then
  echo "ERROR: BODY_FILE not found: $BODY_FILE" >&2
  exit 3
fi

{
  cat <<TEX
% ============================================================
% Section ${num}: ${title}
% ============================================================
\\section{${title}}
\\label{sec:${num}_${slug}}

TEX

  if [[ -n "$BODY_FILE" ]]; then
    cat "$BODY_FILE"
  else
    cat <<'TEX'
\subsection{Motivation}
This section advances the entropy/trace–bifurcation program by introducing a new structural layer and verifying its stability.

\subsection{Core definitions}
\begin{definition}[Admissible entropy morphism]
A morphism \(f:\mathcal{E}\to\mathcal{E}'\) is admissible if it preserves trace-compatibility and entropy-window bounds.
\end{definition}

\subsection{Main theorem}
\begin{theorem}
Under admissible morphisms, bounded-window entropy stratifications are functorial and stable away from wall events.
\end{theorem}

\begin{proof}
Transport operators and compare entropy functionals under admissibility bounds; wall-freeness implies constancy.
\end{proof}
TEX
  fi
} > "$file"

echo "[OK] created $file"
