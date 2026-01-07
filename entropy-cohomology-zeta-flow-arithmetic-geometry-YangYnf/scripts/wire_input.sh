#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "usage: $0 <driver.tex> <insert_before_regex> <input_line>"
  echo "example: $0 docs/amsart/paper.tex '\\\\begin\\{thebibliography\\}' '\\\\input{sections/07-wall-crossing.tex}'"
  exit 2
fi

DRIVER="$1"
BEFORE_REGEX="$2"
INPUT_LINE="$3"

if ! [ -f "$DRIVER" ]; then
  echo "driver not found: $DRIVER"
  exit 1
fi

grep -Fq "$INPUT_LINE" "$DRIVER" && exit 0

perl -0777 -i -pe "s/($BEFORE_REGEX)/\n$INPUT_LINE\n\$1/s" "$DRIVER"
