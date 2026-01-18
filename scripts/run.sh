#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  doctor) exec ./scripts/doctor_git.sh ;;
  pull)   exec ./scripts/pull_ff_only.sh ;;
  test)   exec ./scripts/test_all.sh ;;
  lean-setup) exec ./scripts/setup_lean.sh ;;
  *) echo "usage: $0 {doctor|pull|test|lean-setup}" ; exit 2 ;;
esac
