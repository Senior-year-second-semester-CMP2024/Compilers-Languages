#!/bin/bash

# remove old output directory
rm -r output

# Create the output directory if it doesn't exist
mkdir -p output

touch output/symbol_table.txt
touch output/errors.txt
touch output/quadruples.txt

# Compile the yacc and lex files
bison -d spider.y
flex spider.l

# Move the generated files to the output directory
mv spider.tab.c spider.tab.h lex.yy.c output/

# Compile the generated C files
gcc -g output/lex.yy.c output/spider.tab.c -o output/program -w

# Execute the compiled program and redirect output to output.txt
./output/program.exe < operations_TC2.txt > output/output.txt

# Remove the input.txt file
# rm input.txt