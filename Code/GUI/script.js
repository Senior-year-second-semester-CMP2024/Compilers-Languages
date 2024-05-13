var editor = CodeMirror.fromTextArea(document.getElementById("code-input"), {
  lineNumbers: true,
  mode: "text/x-csrc",
});

$(document).ready(function () {
  $("#compile-button").click(function (event) {
    event.preventDefault();
    var code = $("#code-input").val();
    $.ajax({
      url: "http://127.0.0.1:5000/compile",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({ code: editor.getValue() }),
      success: function (response) {
        // Handle successful response
        console.log("Compilation successful:", response);
        // output = response.json();
        writeToHTML(response);
      },
      error: function (xhr, status, error) {
        // Handle error
        console.error("Error:", status, error);
      },
    });
  });
});

function writeToHTML(output) {
  // Update console output
  var consoleLines = output.console;
  var consoleHTML = "";
  for (var i = 0; i < consoleLines.length; i++) {
    consoleHTML += consoleLines[i] + "<br>";
  }
  document.getElementById("console-output").innerHTML = consoleHTML;

  // Update quadruples output
  var quadruplesLines = output.quadruples;
  var quadruplesHTML = "";
  for (var j = 0; j < quadruplesLines.length; j++) {
    quadruplesHTML += quadruplesLines[j] + "<br>";
  }
  document.getElementById("quadruples-output").innerHTML = quadruplesHTML;

  // Update symbol table
  var symbolTable = output.symbol_table;
  var symbolTableHTML =
    "<table><tr><th>Name</th><th>Type</th><th>Value</th><th>Declared</th><th>Initialized</th><th>Used</th><th>Scope</th></tr>";
  for (var key in symbolTable) {
    if (symbolTable.hasOwnProperty(key)) {
      var symbol = symbolTable[key];
      symbolTableHTML += "<tr>";
      symbolTableHTML += "<td>" + symbol.Name + "</td>";
      symbolTableHTML += "<td>" + symbol.Type + "</td>";
      symbolTableHTML += "<td>" + symbol.Value + "</td>";
      symbolTableHTML += "<td>" + symbol.Declared + "</td>";
      symbolTableHTML += "<td>" + symbol.Initialized + "</td>";
      symbolTableHTML += "<td>" + symbol.Used + "</td>";
      symbolTableHTML += "<td>" + symbol.Scope + "</td>";
      symbolTableHTML += "</tr>";
    }
  }
  symbolTableHTML += "</table>";
  document.getElementById("symbol-table").innerHTML = symbolTableHTML;
}
