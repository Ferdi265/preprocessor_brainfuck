#!/bin/bash
name="$1"
max="$2"
echo "#if 0"
for i in $(seq 0 $max); do
    echo "#elif (${name}_NEXT) == $i"
    echo "#   undef $name"
    echo "#   define $name $i"
done
echo "#else"
echo "FATAL: ${name}_NEXT is not a valid number"
echo "#   error \"invalid number\""
echo "#endif"
echo "#undef ${name}_NEXT"
