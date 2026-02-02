#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
./scripts/guard.sh
dirs="$(go list -f '{{.Dir}}' ./... 2>/dev/null || true)"
if [ -z "${dirs:-}" ]; then
  echo "FMT_FAIL: go list returned no packages"
  exit 2
fi
# shellcheck disable=SC2086
gofmt -w $dirs
