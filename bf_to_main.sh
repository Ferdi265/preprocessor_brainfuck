#!/bin/bash
prog="$1"
input="${2:-/dev/null}"

i=0
while IFS="" read -rn1 char; do
    [[ -z "$char" ]] && break
    code=$(printf "0x%02x" "'$char'")
    echo "#define C$i $code"
    i=$((i + 1))
done < "$prog"
echo "#define Cc $i"
echo

i=0
while IFS="" read -rn1 char; do
    [[ -z "$char" ]] && break
    code=$(printf "0x%02x" "'$char'")
    echo "#define I$i $code"
    i=$((i + 1))
done < "$input"
echo "#define Ic $i"

echo
echo "#include \"bf_run.h\""
