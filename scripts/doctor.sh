#!/usr/bin/env bash
set -euo pipefail
echo "=== python ==="
echo "python3=$(command -v python3 || true)"
python3 -V || true
python3 - <<'PY'
import sys, os
print("sys.executable =", sys.executable)
print("PYTHONPATH    =", os.environ.get("PYTHONPATH"))
try:
    import kraken_bot
    print("kraken_bot import OK =>", getattr(kraken_bot, "__file__", "module_loaded"))
except Exception as e:
    print("kraken_bot import error:", repr(e))
PY

echo
echo "=== Ollama CLI (if installed) ==="
echo "ollama=$(command -v ollama || true)"
if command -v ollama >/dev/null 2>&1; then
  ollama --version 2>/dev/null || true
  echo "--- ollama list (first 40 lines) ---"
  ollama list 2>/dev/null | head -n 40 || true
else
  echo "ollama=MISSING"
fi

echo
echo "=== Ollama server check (port ${OLLAMA_PORT}) ==="
if command -v lsof >/dev/null 2>&1; then
  if lsof -iTCP:${OLLAMA_PORT} -sTCP:LISTEN -n -P >/dev/null 2>&1; then
    echo "ollama_server=LISTENING"
  else
    echo "ollama_server=NOT_LISTENING"
  fi
elif command -v nc >/dev/null 2>&1; then
  if nc -z 127.0.0.1 ${OLLAMA_PORT} >/dev/null 2>&1; then
    echo "ollama_server=LISTENING"
  else
    echo "ollama_server=NOT_LISTENING"
  fi
else
  echo "ollama_server=UNKNOWN(no_lsof_or_nc)"
fi

echo
echo "=== env preview ==="
echo "OLLAMA_HOST=${OLLAMA_HOST:-}"
echo "OLLAMA_BASE_URL=${OLLAMA_BASE_URL:-}"
echo "OLLAMA_MODEL=${OLLAMA_MODEL:-}"
