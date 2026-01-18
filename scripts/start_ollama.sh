#!/usr/bin/env bash
set -euo pipefail
command -v ollama >/dev/null 2>&1 || { echo "ERROR: ollama not found in PATH"; exit 1; }
if command -v lsof >/dev/null 2>&1; then
  if ! lsof -iTCP:11434 -sTCP:LISTEN -n -P >/dev/null 2>&1; then
    echo "Starting ollama server on localhost:11434 ..."
    ollama serve >/tmp/ollama_serve.log 2>&1 &
    sleep 1
  fi
else
  ollama serve >/tmp/ollama_serve.log 2>&1 &
  sleep 1
fi
ollama pull deepseek-r1:7b >/dev/null 2>&1 || true
echo "ollama_ready=1"
