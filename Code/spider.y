%{
    #include <stdio.h>
    void yyerror(char *);
    int yylex(void);

%}

%token PRINT CONSTANT BOOL_DATA_TYPE STRING_DATA_TYPE INT_DATA_TYPE FLOAT_DATA_TYPE VOID_DATA_TYPE IF ELSE ELSE_IF FOR WHILE REPEAT UNTIL SWITCH CASE DEFAULT CONTINUE BREAK RETURN SHIFT_LEFT SHIFT_RIGHT AND OR NOT TRUE_VALUE FALSE_VALUE IDENTIFIER INTEGER FLOAT STRING ENUM
%left '+' '-'
%left '*' '/' '%'
%left AND OR
%right NOT
%left SHIFT_LEFT SHIFT_RIGHT
%nonassoc LESS_THAN GREATER_THAN LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL EQUAL NOT_EQUAL

%%

program : statement_list
        | /* empty */
        ;

statement_list : statement
               | statement_list statement
               ;

statement : PRINT expression ';'
          | declaration ';'
          | selection_statement
          | iteration_statement
          | jump_statement ';'
          ;

declaration : CONSTANT data_type IDENTIFIER '=' expression
            | data_type IDENTIFIER '=' expression
            | data_type IDENTIFIER
            ;

data_type : BOOL_DATA_TYPE
          | STRING_DATA_TYPE
          | INT_DATA_TYPE
          | FLOAT_DATA_TYPE
          | VOID_DATA_TYPE
          ;

selection_statement : IF '(' expression ')' statement
                    | IF '(' expression ')' statement ELSE statement
                    | IF '(' expression ')' statement ELSE_IF '(' expression ')' statement
                    | SWITCH '(' expression ')' '{' case_list '}'
                    ;

case_list : case_list case
          | /* empty */
          ;

case : CASE INTEGER ':' statement_list
     | DEFAULT ':' statement_list
     ;

iteration_statement : WHILE '(' expression ')' statement
                     | FOR '(' declaration ';' expression ';' expression ')' statement
                     | REPEAT statement UNTIL '(' expression ')' ';'
                     ;

jump_statement : CONTINUE
               | BREAK
               | RETURN expression
               | RETURN
               ;

expression : expression '+' expression
           | expression '-' expression
           | expression '*' expression
           | expression '/' expression
           | expression '%' expression
           | expression AND expression
           | expression OR expression
           | NOT expression
           | expression SHIFT_LEFT expression
           | expression SHIFT_RIGHT expression
           | expression LESS_THAN expression
           | expression GREATER_THAN expression
           | expression LESS_THAN_OR_EQUAL expression
           | expression GREATER_THAN_OR_EQUAL expression
           | expression EQUAL expression
           | expression NOT_EQUAL expression
           | '(' expression ')'
           | literal
           | IDENTIFIER
           ;

literal : INTEGER
        | FLOAT
        | STRING
        | TRUE_VALUE
        | FALSE_VALUE
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}


int main(void) {
    yyparse();
}