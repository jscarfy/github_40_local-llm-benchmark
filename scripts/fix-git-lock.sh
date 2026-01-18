#!/usr/bin/env bash
set -euo pipefail
LOCK=".git/index.lock"
MAX_AGE=${MAX_AGE:-600} # seconds
if [ ! -f "$LOCK" ]; then
  echo "No git index.lock present."
  exit 0
fi
mtime=$(stat -f %m "$LOCK" 2>/dev/null || stat -c %Y "$LOCK" 2>/dev/null)
age=$(( $(date +%s) - mtime ))
echo "index.lock age: ${age}s"
if [ "$age" -ge "$MAX_AGE" ]; then
  echo "Removing stale lock: $LOCK"
  rm -f "$LOCK"
  echo "Removed."
else
  echo "Lock is not old enough to remove (threshold $MAX_AGE s)."
  echo "If you're sure, run: rm -f $LOCK"
fi
