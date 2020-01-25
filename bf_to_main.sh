#!/bin/bash
prog="$1"
input="${2:-/dev/null}"

i=0
while read -rn1 char; do
    code=$(printf "0x%02x" "'$char")
    echo "#define C$i $code"
    i=$((i + 1))
done < "$prog"
echo
echo "#define Cc $i"

i=0
while read -rn1 char; do
    code=$(printf "0x%02x" "'$char")
    echo "#define I$i $code"
    i=$((i + 1))
done < "$input"
echo
echo "#define Ic $i"

echo
echo "#include \"bf_run.h\""
