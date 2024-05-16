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
  theme: dark ? "dracula" : "default",
  autoCloseTags: true,
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
      var cursor = cm.getCursor();
      var token = cm.getTokenAt(cursor);

      var templates = {
        for: "for (i = 0; i < N; i = i + 1) {}",
        while: "while (condition) {}",
        if: "if (condition) {}",
        else: "else {}",
        "else if": "else if (condition) {}",
        switch: "switch (expression) {}",
        case: "case value: break;",
        default: "default: break;",
        repeat: "repeat {} until (condition);",
        enum: "enum E{a,b,c};",
      };

      if (token.type === "keyword" && templates[token.string]) {
        var rep = templates[token.string];
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
  var titles = $("h2");
  var body = $("body");
  var sym_items = $("td");
  if (dark) {
    editor.setOption("theme", "default");
    themeToggle.innerHTML = '<i class="fas fa-moon icon"></i> Dark Theme';
    themeToggle.style.backgroundColor = "#343a40";
    titles.each(function () {
      this.style.color = "#000";
    });
    sym_items.each(function () {
      this.style.color = "#000";
    });
    body.css("background-color", "#f8f9fa");
  } else {
    editor.setOption("theme", "dracula");
    themeToggle.innerHTML = '<i class="fas fa-sun icon"></i> Light Theme';
    themeToggle.style.backgroundColor = "#007bff";
    titles.each(function () {
      this.style.color = "#FFF";
    });
    sym_items.each(function () {
      this.style.color = "#FFF";
    });
    body.css("background-color", "#282a30");
  }
  dark = !dark;
}
