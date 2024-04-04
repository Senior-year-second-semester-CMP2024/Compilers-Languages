#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <flex_file> <bison_file>"
    exit 1
fi

flex_file="$1"
bison_file="$2"

# Compile Flex file
flex "$flex_file"

# Check if Flex compilation was successful
if [ $? -ne 0 ]; then
    echo "Flex compilation failed"
    exit 1
fi

# Compile Bison file
bison -d "$bison_file"

# Check if Bison compilation was successful
if [ $? -ne 0 ]; then
    echo "Bison compilation failed"
    exit 1
fi

# Compile the generated C source files and link them
executable="${bison_file%.*}"
gcc  lex.yy.c "${bison_file%.*}.tab.c" -o "$executable"

# Check if compilation and linking were successful
if [ $? -ne 0 ]; then
    echo "Compilation failed"
    exit 1
fi

echo "Executable generated: $executable"
