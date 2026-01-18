#!/usr/bin/env bash
set -euo pipefail
echo "=== running run-tests.sh (best-effort) ==="
# run go tests if go.mod exists
if [ -f go.mod ] && command -v go >/dev/null 2>&1; then
  echo " - go test ./..."
  (go test ./... || echo "Go tests failed or none") || true
fi
# run pytest if project looks pythonic
if ([ -f pyproject.toml ] || [ -f requirements.txt ]) && command -v pytest >/dev/null 2>&1; then
  echo " - pytest"
  (pytest || echo "pytest returned non-zero") || true
fi
# fallback to make test
if command -v make >/dev/null 2>&1; then
  echo " - make test (fallback)"
  (make test || echo "make test failed or not defined") || true
fi
echo "=== run-tests.sh finished ==="
