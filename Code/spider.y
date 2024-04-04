%{
    #include <stdio.h>
    void yyerror(char *);
    int yylex(void);

    int sym[26];
%}
%token PRINT CONSTANT BOOL_DATA_TYPE INT_DATA_TYPE STRING_DATA_TYPE FLOAT_DATA_TYPE VOID_DATA_TYPE
%token IF ELSE ELSE_IF 
%token WHILE FOR REPEAT UNTIL SWITCH CASE DEFAULT BREAK CONTINUE RETURN
%token ENUM
%token SHIFT_LEFT SHIFT_RIGHT
%token EQUAL NOT_EQUAL GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL
%token AND OR NOT
%token TRUE_VALUE FALSE_VALUE
%token IDENTIFIER INTEGER FLOAT STRING 
%token INLINE_COMMENT

%%

// ===========================================================================

program: declaration_list
    ;

declaration_list: declaration_list declaration
    | declaration
    ;

declaration: data_type IDENTIFIER ';'
    | data_type IDENTIFIER '=' expression ';'
    ;

data_type: INT_DATA_TYPE
    | FLOAT_DATA_TYPE
    | STRING_DATA_TYPE
    | BOOL_DATA_TYPE
    | VOID_DATA_TYPE
    ;

expression: expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    | expression SHIFT_LEFT expression
    | expression SHIFT_RIGHT expression
    | expression EQUAL expression
    | expression NOT_EQUAL expression
    | expression GREATER_THAN expression
    | expression GREATER_THAN_OR_EQUAL expression
    | expression LESS_THAN expression
    | expression LESS_THAN_OR_EQUAL expression
    | expression AND expression
    | expression OR expression
    | expression NOT expression
    | '(' expression ')'
    | IDENTIFIER
    | INTEGER
    | FLOAT
    | STRING
    ;



// ===========================================================================
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}


int main(void) {
    yyparse();
}