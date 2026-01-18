#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   scripts/append_before_end_document.sh <file> <marker> <<'BLOCK'
#   ... latex ...
#   BLOCK
#
# Inserts BLOCK before \end{document} if <marker> not already present in <file>.

FILE="${1:?file required}"
MARKER="${2:?marker required}"

if [ ! -f "$FILE" ]; then
  echo "ERROR: file not found: $FILE"
  exit 1
fi

if grep -q "$MARKER" "$FILE"; then
  exit 0
fi

tmp="$(mktemp)"
block="$(mktemp)"
cat > "$block"

awk -v blockfile="$block" '
  function emit_block() {
    while ((getline line < blockfile) > 0) print line
    close(blockfile)
  }
  {
    if ($0 ~ /\\end\{document\}/ && inserted==0) {
      emit_block()
      inserted=1
    }
    print $0
  }
  END {
    if (inserted==0) emit_block()
  }
' "$FILE" > "$tmp"

mv "$tmp" "$FILE"
rm -f "$block"
