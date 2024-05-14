#! /usr/bin/env python3
import sys
import re
import os
from PyQt5.QtCore import Qt, QRegExp
from PyQt5.QtGui import QFont, QTextCursor, QKeySequence, QSyntaxHighlighter, QTextCharFormat, QColor, QPixmap
from PyQt5.QtWidgets import QLabel, QApplication, QHBoxLayout, QVBoxLayout, QTextEdit, QWidget, QShortcut, QFileDialog, QPushButton, QTextBrowser, QTableWidget, QTableWidgetItem, QAbstractItemView


compiler_path = './output/program.exe'
test_file_path = 'operations_TC2.txt'
output_file_path = 'output/output.txt'

# Regex patterns for output file parsing
lexer_line_pattern = r'Lex\((\d+)\).+'
quads_line_pattern = r'Quad\((\d+)\).+'
syntax_error_line_pattern = r'Syntax error \((\d+)\).+'
semantic_error_line_pattern = r'Semantic error \((\d+)\).+'
semantic_warning_line_pattern = r'Semantic warning \((\d+)\).+'


# Application customizations
TITLE_STYLE_SHEET = "font-size: 20px; font-weight: bold; color: #3366CC;"
TEXT_EDITOR_FONT_SIZE = 13
TEXT_EDITOR_WIDTH = 800
TEXT_EDITOR_HEIGHT = 550
CODE_FONT_FAMILY = "Courier New"
CODE_COLOR = "#000000"
LINE_NUMBER_COLOR = "#0000FF"
BUTTON_STYLE_SHEET = '''
    QPushButton{
        background-color: #3366CC; color: white; font-size: 20px; font-weight: bold
    }
    QPushButton:hover {
        background-color: #3366FF; 
    }
'''
BUTTON_WIDTH = 170
BUTTON_HEIGHT = 80


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()

        self.file_path = None
        self.symbol_table_headers = ['Name', 'Type', 'Value', 'Declared', 'Initialized', 'Used', 'Scope']
        self.current_line = 1

        self.style_layout()
        self.highlighter = CCodeHighlighter(self.code_text_editor.document())

        # Make the window full screen
        self.showMaximized()

        # Change the title of the window
        self.setWindowTitle("Spider Compiler")


    def style_layout(self):
        code_layout = self.create_code_area()
        error_layout = self.create_compilation_area()
        quads_layout = self.create_quads_area()
        symbol_table_layout = self.create_symbol_table_area()

        left_half_app_layout = QVBoxLayout()
        left_half_app_layout.addLayout(code_layout)
        left_half_app_layout.addLayout(error_layout, 1)

        right_half_layout = QVBoxLayout()
        right_half_layout.addLayout(quads_layout)
        right_half_layout.addLayout(symbol_table_layout, 1)


        app_layout = QHBoxLayout()
        app_layout.addLayout(left_half_app_layout)
        app_layout.addLayout(right_half_layout,1)

        self.setLayout(app_layout)

    def create_code_area(self):
        # Create title widget
        text_editor_title = QLabel("Source Code")
        text_editor_title.setStyleSheet(TITLE_STYLE_SHEET)
        text_editor_title.setContentsMargins(400, 0, 0, 0)
        # add a function that is executed each time a character is typed and pass it this character

        compile_all_button = QPushButton("Compile") 
        compile_all_button.setFixedWidth(170)
        compile_all_button.setFixedHeight(44)
        compile_all_button.setStyleSheet(BUTTON_STYLE_SHEET)
        # Add an event handler to the button
        compile_all_button.clicked.connect(self.compile_all_button_handler)

        title_layout = QHBoxLayout()
        title_layout.addWidget(text_editor_title)
        title_layout.addWidget(compile_all_button)

        # Create the text editor widget
        self.code_text_editor = CodeEditor()
        self.code_text_editor.setFont(QFont(CODE_FONT_FAMILY, TEXT_EDITOR_FONT_SIZE + 1))
        self.code_text_editor.setStyleSheet(f"color: {CODE_COLOR};")
        self.code_text_editor.textChanged.connect(self.code_text_editor_text_changed)
        
        # Change the size of the text editor
        self.code_text_editor.setFixedWidth(TEXT_EDITOR_WIDTH)
        self.code_text_editor.setFixedHeight(TEXT_EDITOR_HEIGHT)

        self.line_widget = LineNumberWidget(self.code_text_editor, number_color=LINE_NUMBER_COLOR, font_size=TEXT_EDITOR_FONT_SIZE)
        self.line_widget.setFixedHeight(TEXT_EDITOR_HEIGHT)
        self.code_text_editor.textChanged.connect(self.line_widget_line_count_changed)

        text_editor_layout = QHBoxLayout()
        text_editor_layout.addWidget(self.line_widget)
        text_editor_layout.addWidget(self.code_text_editor)
        text_editor_layout.setAlignment(self.code_text_editor, Qt.AlignTop | Qt.AlignLeft)

        code_layout = QVBoxLayout()
        code_layout.addLayout(title_layout)
        code_layout.addLayout(text_editor_layout, 1)

        return code_layout
    

    def create_compilation_area(self):
        text_editor_title = QLabel("Compilation Output")
        text_editor_title.setStyleSheet(TITLE_STYLE_SHEET)
        text_editor_title.setContentsMargins(270, 0, 0, 0)

        self.error_editor = QTextEdit()
        self.error_editor.setReadOnly(True)
        self.error_editor.setViewportMargins(20, 20, 20, 20)

        # Change the font size of the text editor
        self.error_editor.setFontPointSize(TEXT_EDITOR_FONT_SIZE)
        self.error_editor.setStyleSheet(f"color: #FFF; background-color: #000;")

        # Make the text editor scrollable
        self.error_editor.setLineWrapMode(QTextEdit.NoWrap)

        # Change the font family of the text editor to be code friendly
        self.error_editor.setFontFamily(CODE_FONT_FAMILY)
        
        # Change the size of the text editor
        self.error_editor.setFixedWidth(TEXT_EDITOR_WIDTH)
        self.error_editor.setFixedHeight(300)

        error_layout = QVBoxLayout()
        error_layout.setContentsMargins(90, 70, 0, 0)
        error_layout.addWidget(text_editor_title)
        error_layout.addWidget(self.error_editor)

        return error_layout
    

    def create_quads_area(self):
        text_editor_title = QLabel("Quadruples")
        text_editor_title.setStyleSheet(TITLE_STYLE_SHEET)
        text_editor_title.setContentsMargins(0, 0, 370, 5)

        self.quads_editor = QTextEdit()

        # Change the font size of the text editor
        self.quads_editor.setFontPointSize(TEXT_EDITOR_FONT_SIZE)
        self.quads_editor.setStyleSheet(f"color: {CODE_COLOR};")

        self.quads_editor.setReadOnly(True)

        # Make the text editor scrollable
        self.quads_editor.setLineWrapMode(QTextEdit.NoWrap)

        # Change the font family of the text editor to be code friendly
        self.quads_editor.setFontFamily(CODE_FONT_FAMILY)

        # Change the size of the text editor
        self.quads_editor.setFixedWidth(TEXT_EDITOR_WIDTH + 70)
        self.quads_editor.setFixedHeight(TEXT_EDITOR_HEIGHT)

        quads_layout = QVBoxLayout()
        quads_layout.setContentsMargins(0, 20, 50, 40)
        quads_layout.addWidget(text_editor_title)
        quads_layout.addWidget(self.quads_editor, 1)
        quads_layout.setAlignment(text_editor_title, Qt.AlignTop | Qt.AlignRight)
        quads_layout.setAlignment(self.quads_editor, Qt.AlignTop | Qt.AlignRight)

        return quads_layout
    

    def create_symbol_table_area(self):
        text_editor_title = QLabel("Symbol Table")
        text_editor_title.setStyleSheet(TITLE_STYLE_SHEET)
        text_editor_title.setContentsMargins(430, 150, 0, 0)

        self.symbol_table = QTableWidget()
        self.symbol_table.setStyleSheet(f"color: {CODE_COLOR};")
        self.symbol_table.setFont(QFont(CODE_FONT_FAMILY, TEXT_EDITOR_FONT_SIZE - 5))
        self.symbol_table.setEditTriggers(QAbstractItemView.NoEditTriggers)

        self.symbol_table.setColumnCount(7)
        self.symbol_table.setHorizontalHeaderLabels(self.symbol_table_headers)
        self.symbol_table.setColumnWidth(0, 100)
        self.symbol_table.setColumnWidth(1, 110)
        self.symbol_table.setColumnWidth(2, 110)
        self.symbol_table.setColumnWidth(3, 140)
        self.symbol_table.setColumnWidth(4, 140)
        
        # Change the size of the table
        self.symbol_table.setFixedWidth(TEXT_EDITOR_WIDTH + 70)
        self.symbol_table.setFixedHeight(400)

        # Change the font size of the headers
        self.symbol_table.horizontalHeader().setFont(QFont(CODE_FONT_FAMILY, TEXT_EDITOR_FONT_SIZE - 5))

        # Change the backgorund color of the headers 
        self.symbol_table.horizontalHeader().setStyleSheet("color: #3366CC;")


        symbol_table_layout = QVBoxLayout()
        symbol_table_layout.setContentsMargins(0, 0, 50, 0)
        symbol_table_layout.addWidget(text_editor_title)
        symbol_table_layout.addWidget(self.symbol_table, 1)
        symbol_table_layout.setAlignment(self.symbol_table, Qt.AlignTop | Qt.AlignRight)
        symbol_table_layout.setAlignment(self.symbol_table, Qt.AlignTop | Qt.AlignRight)

        return symbol_table_layout

    
    def compile_all_button_handler(self):
        self.current_line = 1
        # self.compile_step_by_step_button.setText(f"Compile Step by Step ({-1})")
        # Reset the output fields
        self.error_editor.setText("Compiling...")
        self.quads_editor.setText("")
        self.highlighter.clear_highlight()
        self.symbol_table.clearContents()
        self.symbol_table.setRowCount(0)

        # Referesh the window
        self.repaint()

        # Export the written code to a temporary file
        os.chdir('..')
        file_contents = self.code_text_editor.toPlainText()
        
        if not os.path.exists('GUI'):
            os.chdir('Code')

        with open(test_file_path, "w") as f:
            f.write(file_contents)

        # Compile the code
        os.system("program.exe < operations_TC2.txt > output/output.txt")
        
        # Parse the output files
        # chdir only if we we dont have GUI folder in the current path
        self.parse_output_file()
        self.parse_symbol_table()
        
        # Remove the temporary files (if they exist) and return to the working directory
        os.chdir('..')
        # if os.path.exists(test_file_path):
        #     os.remove(test_file_path)
        # os.remove('test/out/temp.out')
        os.chdir('GUI')

        

    def parse_output_file(self):
        # Parse the output file to produce output, highlight erros, and produce quadruples
        with open(output_file_path, "r") as f:
            output = f.read().splitlines()

        lexer_lines = []
        quads_lines = []
        console_lines = []
        for line in output:
            if re.match(lexer_line_pattern, line):
                lexer_lines.append(line)
            elif re.match(quads_line_pattern, line):
                quads_lines.append(re.sub(r'Quads\(.*\)', '', line))
            elif line != '':
                console_lines.append(line)
        
        error = False
        for console_line in console_lines:
            if re.match(syntax_error_line_pattern, console_line):
                error_line = int(re.search(syntax_error_line_pattern, console_line).group(1))
                fmt = QTextCharFormat()
                fmt.setBackground(QColor(255, 0, 0))
                self.highlighter.highlight_line(error_line - 1, fmt)
                error = True
        
        for console_line in console_lines:
            if re.match(semantic_error_line_pattern, console_line):
                error_line = int(re.search(semantic_error_line_pattern, console_line).group(1))
                if error_line - 1 not in self.highlighter.highlight_lines.keys():
                    fmt = QTextCharFormat()
                    fmt.setBackground(QColor(255, 255, 0))
                    self.highlighter.highlight_line(error_line - 1, fmt)
        
        for console_line in console_lines:
            if re.match(semantic_warning_line_pattern, console_line):
                error_line = int(re.search(semantic_warning_line_pattern, console_line).group(1))
                if error_line - 1 not in self.highlighter.highlight_lines.keys():
                    fmt = QTextCharFormat()
                    fmt.setBackground(QColor(255, 165, 0))
                    self.highlighter.highlight_line(error_line - 1, fmt)

        self.error_editor.setText('\n'.join(console_lines))
        self.quads_editor.setText('\n'.join(quads_lines))
        self.repaint()
        return error


    def parse_symbol_table(self):
        # Parse the symbol table
        symbol_table = []
        os.chdir('output')
        with open('symbol_table.txt', "r") as f:
            output = f.read().splitlines()
        for line in output:
            if line != 'Symbol Table:' and line.strip() != '':
                temp_map = {}
                elements = line.split(',')
                for element in elements:
                    key, value = element.split(':')
                    temp_map[key] = value
                symbol_table.append(temp_map)
        
        self.symbol_table.setRowCount(len(symbol_table))
        
        row_index = 0
        for row in symbol_table:
            for i, header in enumerate(self.symbol_table_headers):
                item = QTableWidgetItem(row[header])
                item.setTextAlignment(Qt.AlignCenter)
                self.symbol_table.setItem(row_index, i, item)
            row_index += 1


    def line_widget_line_count_changed(self):
        if self.line_widget:
            n = int(self.code_text_editor.document().lineCount())
            self.line_widget.changeLineCount(n)

        
    def code_text_editor_text_changed(self):
            # Get the last typed character
            cursor = self.code_text_editor.textCursor()
            cursor.movePosition(QTextCursor.PreviousCharacter, QTextCursor.KeepAnchor)
            last_char = cursor.selectedText()
            # reset the cursor position
            cursor.movePosition(QTextCursor.NextCharacter, QTextCursor.MoveAnchor)

            # Define mappings of opening characters to their corresponding closing characters
            mappings = {'(': ')', '{': '}', '[': ']'}

            # Check if the last character is an opening character
            if last_char in mappings:
                # Insert the corresponding closing character
                self.code_text_editor.insertPlainText(mappings[last_char])
                # Move the cursor back to the original position
                cursor.movePosition(QTextCursor.PreviousCharacter, QTextCursor.MoveAnchor)
                self.code_text_editor.setTextCursor(cursor)

class LineNumberWidget(QTextBrowser):
    def __init__(self, widget, number_color, font_size):
        super().__init__()
        self.__number_color = number_color
        self.__initUi(widget, font_size)

    def __initUi(self, widget, font_size):
        self.__lineCount = widget.document().lineCount()
        self.__size = font_size
        self.__styleInit()

        self.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        self.setTextInteractionFlags(Qt.NoTextInteraction)

        self.verticalScrollBar().setEnabled(False)

        widget.verticalScrollBar().valueChanged.connect(self.__changeLineWidgetScrollAsTargetedWidgetScrollChanged)

        self.__initLineCount()

    def __changeLineWidgetScrollAsTargetedWidgetScrollChanged(self, v):
        self.verticalScrollBar().setValue(v)

    def __initLineCount(self):
        for n in range(1, self.__lineCount+1):
            self.append(str(n))

    def changeLineCount(self, n):
        max_one = max(self.__lineCount, n)
        diff = n-self.__lineCount
        if max_one == self.__lineCount:
            first_v = self.verticalScrollBar().value()
            for i in range(self.__lineCount, self.__lineCount + diff, -1):
                self.moveCursor(QTextCursor.End, QTextCursor.MoveAnchor)
                self.moveCursor(QTextCursor.StartOfLine, QTextCursor.MoveAnchor)
                self.moveCursor(QTextCursor.End, QTextCursor.KeepAnchor)
                self.textCursor().removeSelectedText()
                self.textCursor().deletePreviousChar()
            last_v = self.verticalScrollBar().value()
            if abs(first_v-last_v) != 2:
                self.verticalScrollBar().setValue(first_v)
        else:
            for i in range(self.__lineCount, self.__lineCount + diff, 1):
                self.append(str(i + 1))

        self.__lineCount = n

    def setValue(self, v):
        self.verticalScrollBar().setValue(v)

    def setFontSize(self, s: float):
        self.__size = int(s)
        self.__styleInit()

    def __styleInit(self):
        self.__style = f'''
                       QTextBrowser 
                       {{ 
                       background: transparent; 
                       border: none; 
                       color: {self.__number_color}; 
                       font: {self.__size}pt;
                       }}
                       '''
        self.setStyleSheet(self.__style)
        self.setFixedWidth(self.__size*5)


class CCodeHighlighter(QSyntaxHighlighter):
    def __init__(self, parent=None):
        super(CCodeHighlighter, self).__init__(parent)
        
        # Define the C keywords
        self.keywords = [
            'auto', 'break', 'case', 'char', 'const', 'continue', 'default', 'do', 'double', 'else', 'enum', 'extern',
            'float', 'for', 'goto', 'if', 'int', 'long', 'register', 'return', 'short', 'signed', 'sizeof', 'static',
            'struct', 'switch', 'typedef', 'union', 'unsigned', 'void', 'volatile', 'while', 'print'
        ]
        
        # Define the C operators
        self.operators = [
            '+', '-', '*', '/', '%', '++', '--', '==', '!=', '>', '<', '>=', '<=', '&&', '||', '!', '&', '|', '^',
            '~', '<<', '>>', '=', '+=', '-=', '*=', '/=', '%=', '<<=', '>>=', '&=', '|=', '^=', '->', '.', '{', '}'
        ]
        
        # Define the C types
        self.types = [
            'int', 'char', 'bool', 'float', 'double', 'void', 'short', 'long', 'signed', 'unsigned', 'const'
        ]

        self.bool = [
            'true', 'false'
        ]
        # Define the text formats for syntax highlighting
        self.keywordFormat = QTextCharFormat()
        self.keywordFormat.setForeground(QColor(64, 128, 255))
        self.keywordFormat.setFontWeight(QFont.Bold)
        
        self.operatorFormat = QTextCharFormat()
        self.operatorFormat.setForeground(QColor(0, 0, 255))
        
        self.typeFormat = QTextCharFormat()
        self.typeFormat.setForeground(QColor(0, 128, 0))
        self.typeFormat.setFontWeight(QFont.Bold)
        
        self.directiveFormat = QTextCharFormat()
        self.directiveFormat.setForeground(QColor(128, 0, 128))
        
        self.stringFormat = QTextCharFormat()
        self.stringFormat.setForeground(QColor(255, 0, 0))
        
        self.commentFormat = QTextCharFormat()
        self.commentFormat.setForeground(QColor(128, 128, 128))
        
        self.boolFormat = QTextCharFormat()
        self.boolFormat.setForeground(QColor(0, 0, 128))
        self.boolFormat.setFontWeight(QFont.Bold)
        # Define the regular expressions for syntax highlighting
        self.rules = []
        
        # C keywords
        keywordPattern = '\\b(' + '|'.join(self.keywords) + ')\\b'
        self.rules.append((QRegExp(keywordPattern), self.keywordFormat))
        
        # C operators
        operatorPattern = '|'.join([QRegExp.escape(op) for op in self.operators])
        self.rules.append((QRegExp(operatorPattern), self.operatorFormat))
        
        # C types
        typePattern = '\\b(' + '|'.join(self.types) + ')\\b'
        self.rules.append((QRegExp(typePattern), self.typeFormat))

        boolPattern = '\\b(' + '|'.join(self.bool) + ')\\b'
        self.rules.append((QRegExp(boolPattern), self.boolFormat))
    
        
        # String literals
        self.rules.append((QRegExp('".*?"'), self.stringFormat))
        self.rules.append((QRegExp('\'.*?\''), self.stringFormat))
        
        
        # Single-line comments
        self.rules.append((QRegExp('//[^\n]*'), self.commentFormat))
        
        # Multi-line comments
        self.rules.append((QRegExp('/\\*'), self.commentFormat))
        self.rules.append((QRegExp('\\*/'), self.commentFormat))

        self.highlight_lines = dict()

    def highlightBlock(self, text):
        for pattern, format in self.rules:
            expression = QRegExp(pattern)
            index = expression.indexIn(text)
            while index >= 0:
                length = expression.matchedLength()
                self.setFormat(index, length, format)
                index = expression.indexIn(text, index + length)

        line = self.currentBlock().blockNumber()
        fmt = self.highlight_lines.get(line)
        if fmt is not None:
            self.setFormat(0, len(text), fmt)

    def highlight_line(self, line, fmt):
        if isinstance(line, int) and line >= 0 and isinstance(fmt, QTextCharFormat):
            self.highlight_lines[line] = fmt
            tb = self.document().findBlockByLineNumber(line)
            self.rehighlightBlock(tb)

    def clear_highlight(self):
        self.highlight_lines = dict()
        self.rehighlight()


class CodeEditor(QTextEdit):
    def __init__(self, parent=None):
        super(CodeEditor, self).__init__(parent)
        
        # Set the font and tab stop width
        font = QFont('Courier New')
        font.setFixedPitch(True)
        font.setPointSize(10)
        self.setFont(font)
        self.setTabStopWidth(20)
        
        # Enable line wrapping
        self.setLineWrapMode(QTextEdit.NoWrap)
        
        # Syntax highlighting
        self.highlighter = CCodeHighlighter(self.document())

if __name__ == "__main__":
    app = QApplication(sys.argv)
    mainWindow = MainWindow()
    mainWindow.show()
    app.exec()