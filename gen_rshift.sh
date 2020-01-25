#!/bin/bash
v="$1"
length="$2"
backlength="${3:-0}"

echo "#if ${v}r == 0"
echo "#   error \"${v} backbuffer contains no more values\""
echo "#endif"
echo "#define ${v}c_NEXT (${v}c + 1)"
echo "#include \"literals/${v}c.h\""
echo "#define ${v}r_NEXT (${v}r > 0 ? ${v}r - 1 : 0)"
echo "#include \"literals/${v}r.h\""

for i in $(seq $((length - 1)) -1 1); do
    next="${v}$((i - 1))"
    echo "#define ${v}${i}_NEXT $next"
    echo "#include \"literals/${v}${i}.h\""
done

for i in $(seq 0 $((backlength - 1))); do
    if [[ $i -eq 0 ]]; then
        echo "#define ${v}0_NEXT ${v}m$((i + 1))"
        echo "#include \"literals/${v}0.h\""
    else
        echo "#define ${v}m${i}_NEXT ${v}m$((i + 1))"
        echo "#include \"literals/${v}m${i}.h\""
    fi
done
