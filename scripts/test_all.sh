#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

mkdir -p logs
LOG="logs/test_all_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1

echo "[test_all] repo: $REPO_ROOT"
echo "[test_all] starting..."

echo
echo "== Git Doctor =="
./scripts/doctor_git.sh

echo
echo "== Git Pull (ff-only) =="
./scripts/pull_ff_only.sh || { echo "[test_all] FAIL: pull_ff_only"; exit 1; }

echo
echo "== Python test (optional) =="
if command -v python3 >/dev/null 2>&1; then
  if [[ -f tests/test_git_pull_python.py ]]; then
    python3 tests/test_git_pull_python.py || { echo "[test_all] FAIL: python test"; exit 1; }
  else
    echo "[test_all] SKIP: tests/test_git_pull_python.py missing"
  fi
else
  echo "[test_all] SKIP: python3 not installed"
fi

echo
echo "== Coq test (optional) =="
if command -v coqc >/dev/null 2>&1; then
  if [[ -f formal/coq/test_git_pull_coq.v ]]; then
    coqc -q formal/coq/test_git_pull_coq.v || { echo "[test_all] FAIL: coq"; exit 1; }
  else
    echo "[test_all] SKIP: formal/coq/test_git_pull_coq.v missing"
  fi
else
  echo "[test_all] SKIP: coqc not installed"
fi

echo
echo "== Lean test (optional) =="
if command -v elan >/dev/null 2>&1 || command -v lean >/dev/null 2>&1; then
  if [[ -f formal/lean/TestPull.lean ]]; then
    # Prefer lake env if present
    if command -v lake >/dev/null 2>&1 && [[ -f lakefile.lean ]]; then
      lake env lean formal/lean/TestPull.lean || { echo "[test_all] FAIL: lean (lake env)"; exit 1; }
    else
      lean formal/lean/TestPull.lean || { echo "[test_all] FAIL: lean"; exit 1; }
    fi
  else
    echo "[test_all] SKIP: formal/lean/TestPull.lean missing"
  fi
else
  echo "[test_all] SKIP: lean/elan not installed"
fi

echo
echo "[test_all] SUCCESS"
echo "[test_all] log: $LOG"
