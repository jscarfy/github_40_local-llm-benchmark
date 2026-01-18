#!/usr/bin/env bash
set -euo pipefail
QFILE="data/autogen_queue.jsonl"
if [ $# -lt 2 ]; then
  echo "Usage: $0 <job_name> <job_prompt>"
  exit 2
fi
JOB_NAME="$1"; shift
PROMPT="$*"
mkdir -p data
TIMESTAMP=$(date --iso-8601=seconds 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S%z")
jq -n --arg n "${JOB_NAME}" --arg p "${PROMPT}" --arg t "${TIMESTAMP}" \
  '{name:$n, prompt:$p, ts:$t, status:"queued"}' >> "${QFILE}"
echo "enqueued -> ${QFILE}: ${JOB_NAME}"
