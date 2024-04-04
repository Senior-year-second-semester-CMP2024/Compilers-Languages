#!/bin/bash

# Check if arguments are provided, if not, set default values
if [ "$#" -eq 0 ]; then
    flex_file=$(find . -maxdepth 1 -type f -name "*.l" | head -n 1)
    bison_file=$(find . -maxdepth 1 -type f -name "*.y" | head -n 1)
elif [ "$#" -eq 2 ]; then
    flex_file="$1"
    bison_file="$2"
else
    echo "Usage: $0 [<flex_file> <bison_file>]"
    exit 1
fi

# Check if files exist
if [ ! -f "$flex_file" ]; then
    echo "Flex file '$flex_file' not found."
    exit 1
fi

if [ ! -f "$bison_file" ]; then
    echo "Bison file '$bison_file' not found."
    exit 1
fi

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
