#!/bin/bash
v="$1"
length="$2"
backlength="${3:-0}"

echo "#if ${v}c == 0"
echo "#   define HALT 1"
echo "#   error \"${v} contains no more values\""
echo "#endif"
echo "#define ${v}c_NEXT (${v}c > 0 ? ${v}c - 1 : 0)"
echo "#include \"literals/${v}c.h\""
echo "#define ${v}r_NEXT (${v}r + 1)"
echo "#include \"literals/${v}r.h\""

for i in $(seq "$backlength" -1 1); do
    if [[ $i -eq 1 ]]; then
        next="${v}0"
    else
        next="${v}m$((i - 1))"
    fi
    echo "#define ${v}m${i}_NEXT $next"
    echo "#include \"literals/${v}m${i}.h\""
done

for i in $(seq 0 $((length - 2))); do
    next="${v}$((i + 1))"
    echo "#define ${v}${i}_NEXT $next"
    echo "#include \"literals/${v}${i}.h\""
done
