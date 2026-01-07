#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "ROOT: $ROOT"
echo "---"
echo "Paper:   $ROOT/build/paper.pdf"
echo "Slides:  $ROOT/build/slides.pdf"
echo "---"
echo "Git:"
git -C "$ROOT" status --porcelain || true
