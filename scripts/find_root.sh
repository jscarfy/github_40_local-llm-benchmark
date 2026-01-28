#!/usr/bin/env bash
set -euo pipefail
git rev-parse --show-toplevel 2>/dev/null || {
  d="$PWD"
  while [[ "$d" != "/" ]]; do
    [[ -d "$d/.git" ]] && { echo "$d"; exit 0; }
    d="$(cd "$d/.." && pwd)"
  done
  exit 1
}
