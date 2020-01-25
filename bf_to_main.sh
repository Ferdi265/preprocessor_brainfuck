#!/bin/bash
prog="$1"
input="${2:-/dev/null}"

i=0
hexdump="$(xxd -p "$prog")"
while read -rn2 hex; do
    [[ -z "$hex" ]] && continue
    code="0x$hex"
    echo "#define C$i $code"
    i=$((i + 1))
done <<< "$hexdump"
echo "#define Cc $i"
echo

i=0
hexdump="$(xxd -p "$input")"
while IFS="" read -rn2 hex; do
    [[ -z "$hex" ]] && continue
    code="0x$hex"
    echo "#define I$i $code"
    i=$((i + 1))
done <<< "$hexdump"
echo "#define Ic $i"

echo
echo "#include \"bf_run.h\""
