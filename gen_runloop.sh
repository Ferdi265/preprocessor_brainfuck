#!/bin/bash
depth="$1"
width="$2"

for i in $(seq 0 $((depth - 1))); do
    file="bf_run_d$i.h"
    if [[ $i -eq $((depth - 1)) ]]; then
        next="bf_iter.h"
    else
        next="bf_run_d$((i + 1)).h"
    fi

    for _ in $(seq 0 $((width - 1))); do
        echo "#ifndef HALT"
        echo "#   include \"$next\""
        echo "#endif"
    done > "$file"
done
