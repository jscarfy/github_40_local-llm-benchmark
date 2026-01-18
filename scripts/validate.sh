#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

rm -f ".git/index.lock" || true
test -x scripts/index_sections.sh

# Non-fatal readability scan
if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PY' || true
import glob
paths = glob.glob("amsart/**/*.tex", recursive=True) + glob.glob("beamer/**/*.tex", recursive=True)
bad=[]
for p in paths:
  try:
    open(p,"rb").read()
  except Exception as e:
    bad.append((p,str(e)))
if bad:
  print("TeX read errors:")
  for p,e in bad:
    print(" -",p,":",e)
PY
fi

echo "Validation complete."
