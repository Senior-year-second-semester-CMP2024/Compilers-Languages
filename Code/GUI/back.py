from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import re

app = Flask(__name__)
CORS(app) 

lexer_line_pattern = r'Lex\((\d+)\).+'
quads_line_pattern = r'Quad\((\d+)\).+'
syntax_error_line_pattern = r'Syntax error \((\d+)\).+'
semantic_error_line_pattern = r'Semantic error \((\d+)\).+'
semantic_warning_line_pattern = r'Semantic warning \((\d+)\).+'

@app.route('/compile', methods=['POST'])
def compile_code():
    code = request.json.get('code', '')

    # Write the code to a file
    with open('code_file.txt', 'w') as f:
        f.write(code)

    # Execute the compilation command
    os.system('program.exe < code_file.txt > output/output.txt')


    lexer, quadruples, console = parse_output_file()
    symbol_table = parse_symbol_table()
    code = code

    res = {
        'lexer': lexer,
        'quadruples': quadruples,
        'symbol_table': symbol_table,
        'console': console,
        'code': code
    }
    return jsonify(res)
    
def parse_output_file():
    # Read the output file
    with open('output/output.txt', 'r') as f:
        output = f.read().splitlines()

    lexer_lines = []
    quads_lines = []
    console_lines = []
    for line in output:
        if re.match(lexer_line_pattern, line):
            lexer_lines.append(line)
        elif re.match(quads_line_pattern, line):
            new_line = re.sub(r'Quad\(.*\)', '', line)
            quads_lines.append(new_line)
        elif line != '':
            console_lines.append(line)

    return lexer_lines, quads_lines, console_lines

def parse_symbol_table():
    # Parse the symbol table
    symbol_table = []
    with open('output/symbol_table.txt', "r") as f:
        output = f.read().splitlines()
    for line in output:
        if line != 'Symbol Table:' and line.strip() != '':
            temp_map = {}
            elements = line.split(',')
            for element in elements:
                key, value = element.split(':')
                temp_map[key] = value
            symbol_table.append(temp_map)
    return symbol_table

if __name__ == '__main__':
    app.run(debug=True)  # You can set debug=False in production
