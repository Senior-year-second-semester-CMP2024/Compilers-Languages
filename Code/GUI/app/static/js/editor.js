function duplicateLine(cm) {
  var cursor = cm.getCursor();
  var line = cm.getLine(cursor.line);
  cm.replaceRange(line + "\n", { line: cursor.line, ch: 0 });
  cm.setCursor({ line: cursor.line + 1, ch: cursor.ch });
}
var dark = false;
var editor = CodeMirror.fromTextArea(document.getElementById("code-input"), {
  lineNumbers: true,
  mode: "text/x-csrc",
  autoCloseBrackets: true,
  theme: dark ? "dracula" : "defauls",
  autoCloseTags: true,
  matchBrackets: true,
  matchBrackets: true,
  matchTags: { bothTags: true },
  styleActiveLine: true,
  smartIndent: true,
  indentUnit: 4,
  foldGutter: true,
  gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
  extraKeys: {
    "Ctrl-F": "findPersistent",
    "Ctrl-H": "replace",
    "Ctrl-J": "toMatchingTag",
    "Ctrl-Q": function (cm) {
      cm.foldCode(cm.getCursor());
    },
    "Ctrl-Alt-Down": function (cm) {
      duplicateLine(cm);
    },
    Tab: function (cm) {
      // Custom handling for Tab key
      var cursor = cm.getCursor();
      var line = cm.getLine(cursor.line);
      var token = cm.getTokenAt(cursor);

      // Check if cursor is inside or next to a word
      if (token.type === "keyword" && token.string === "for") {
        rep = "for (i = 0; i < N; i++) {}";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({
          line: cursor.line,
          ch: token.start + rep.length - 1,
        });
      } else if (token.type === "keyword" && token.string === "while") {
        rep = "while (condition) {}";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({ line: cursor.line, ch: token.start + rep.length - 1 });
      } else if (token.type === "keyword" && token.string === "if") {
        rep = "if (condition) {}";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({ line: cursor.line, ch: token.start + rep.length - 1 });
      } else if (token.type === "keyword" && token.string === "else") {
        rep = "else {}";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({ line: cursor.line, ch: token.start + rep.length - 1 });
      } else if (token.type === "keyword" && token.string === "else if") {
        rep = "else if (condition) {}";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({ line: cursor.line, ch: token.start + rep.length - 1 });
      } else if (token.type === "keyword" && token.string === "switch") {
        rep = "switch (expression) {}";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({ line: cursor.line, ch: token.start + rep.length - 1 });
      } else if (token.type === "keyword" && token.string === "case") {
        rep = "case value: break;";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({ line: cursor.line, ch: token.start + rep.length - 1 });
      } else if (token.type === "keyword" && token.string === "default") {
        rep = "default: break;";
        cm.replaceRange(
          rep,
          { line: cursor.line, ch: token.start },
          { line: cursor.line, ch: token.end }
        );
        cm.setCursor({ line: cursor.line, ch: token.start + rep.length - 1 });
      }
    },
  },
});
function toggleTheme() {
  var themeToggle = document.getElementById("theme-toggle");
  if (dark) {
    editor.setOption("theme", "default");
    themeToggle.innerHTML = '<i class="fas fa-moon icon"></i> Dark Theme';
    themeToggle.style.backgroundColor = "#343a40";
  } else {
    editor.setOption("theme", "dracula");
    themeToggle.innerHTML = '<i class="fas fa-sun icon"></i> Light Theme';
    themeToggle.style.backgroundColor = "#007bff";
  }
  dark = !dark;
}
