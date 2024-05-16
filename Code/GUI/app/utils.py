import re
import os

lexer_line_pattern = r"Lex\((\d+)\).+"
quads_line_pattern = r"Quad\((\d+)\).+"
syntax_error_line_pattern = r"Syntax error \((\d+)\).+"
semantic_error_line_pattern = r"Semantic error \((\d+)\).+"
semantic_warning_line_pattern = r"Semantic warning \((\d+)\).+"


def execute_compilation():
    os.system("program.exe < code_file.txt > output/output.txt")


def parse_output_file():
    # Read the output file
    with open("output/output.txt", "r") as f:
        output = f.read().splitlines()

    lexer_lines = []
    quads_lines = []
    console_lines = []
    for line in output:
        if re.match(lexer_line_pattern, line):
            lexer_lines.append(line)
        elif re.match(quads_line_pattern, line):
            new_line = re.sub(r"Quad\(.*\)", "", line)
            quads_lines.append(new_line)
        elif line != "":
            console_lines.append(line)

    return lexer_lines, quads_lines, console_lines


def parse_symbol_table():
    # Parse the symbol table
    symbol_table = []
    with open("output/symbol_table.txt", "r") as f:
        output = f.read().splitlines()
    for line in output:
        if line != "Symbol Table:" and line.strip() != "":
            temp_map = {}
            elements = line.split(",")
            for element in elements:
                key, value = element.split(":")
                temp_map[key] = value
            symbol_table.append(temp_map)
    return symbol_table
