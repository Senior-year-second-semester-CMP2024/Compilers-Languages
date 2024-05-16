from app import app
from flask import request, jsonify, render_template
from app.utils import parse_output_file, parse_symbol_table, execute_compilation


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/compile", methods=["POST"])
def compile_code():
    code = request.json.get("code", "")

    # Write the code to a file
    with open("code_file.txt", "w") as f:
        f.write(code)

    # Execute the compilation command
    execute_compilation()

    lexer, quadruples, console = parse_output_file()
    symbol_table = parse_symbol_table()
    code = code

    res = {
        "lexer": lexer,
        "quadruples": quadruples,
        "symbol_table": symbol_table,
        "console": console,
        "code": code,
    }
    return jsonify(res)
