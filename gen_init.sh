#!/bin/bash
v="$1"
length="$2"

for i in $(seq 0 $((length - 1))); do
    echo "#define ${v}${i} 0"
done
