#!/usr/bin/env bash
set -euo pipefail
# Reads prompt on stdin, outputs a single-line answer on stdout.
# A deterministic mock: echoes a short transformation.
prompt="$(cat)"
# Keep single-line output:
prompt="${prompt//$'\n'/ }"
echo "MOCK_ANSWER: ${prompt:0:80}"
