%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    #define YY_USER_ACTION yylineno += yyleng;
    #define YYSTYPE int

    void yyerror (char *s); 
    int yyparse();
    int yywrap();
    int yylex();
    extern FILE *yyin;
    extern int nline;

%}

// -----Tokens-----
%token PRINT CONSTANT 
%token BOOL_DATA_TYPE STRING_DATA_TYPE INT_DATA_TYPE FLOAT_DATA_TYPE VOID_DATA_TYPE 
%token IF ELSE ELSE_IF 
%token FOR WHILE REPEAT UNTIL 
%token SWITCH CASE DEFAULT CONTINUE BREAK RETURN 
%token SHIFT_LEFT SHIFT_RIGHT AND OR NOT 
%token TRUE_VALUE FALSE_VALUE IDENTIFIER INTEGER FLOAT STRING ENUM

// -----Operators-----
%left '+' '-'
%left '*' '/' '%'
%left  '|' '^' '&' 
%left AND OR
%left SHIFT_LEFT SHIFT_RIGHT
%left EQUAL NOT_EQUAL 
%left GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL 

%right '=' 
%right NOT
//%nonassoc LESS_THAN GREATER_THAN LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL EQUAL NOT_EQUAL

%%

program : statement_list
        | '\n'
        | /*empty*/
        ;

statement_list : statement ';'
               | statement ';' '\n'
               | statement ';' statement_list
               | statement ';' '\n' statement_list
               ;

statement : PRINT expression
          | declaration
          | selection_statement
          | iteration_statement
          | jump_statement
          | assignment
          ;

declaration : CONSTANT data_type assignment
            | data_type assignment
            | data_type IDENTIFIER
            ;

assignment : IDENTIFIER '=' expression

data_type : BOOL_DATA_TYPE          {$$ = $1;}
          | STRING_DATA_TYPE        {$$ = $1;}
          | INT_DATA_TYPE           {$$ = $1;}
          | FLOAT_DATA_TYPE         {$$ = $1;}
          | VOID_DATA_TYPE          {$$ = $1;}
          ;

selection_statement : IF '(' expression ')' statement_list
                    | IF '(' expression ')' statement_list ELSE statement_list
                    | IF '(' expression ')' statement_list ELSE_IF '(' expression ')' statement_list
                    | IF '(' expression ')' statement_list ELSE statement_list ELSE_IF '(' expression ')' statement_list
                    | SWITCH '(' expression ')' '{' case_list '}'
                    ;

case_list : case_list case
          | case
          ;

case : CASE INTEGER ':' statement_list
     | DEFAULT ':' statement_list
     ;

iteration_statement : WHILE '(' expression ')' statement                                {;}
                    | FOR '(' declaration ';' expression ';' expression ')' statement   {;}
                    | REPEAT statement UNTIL '(' expression ')' ';'                     {;}
                    ;

jump_statement : CONTINUE                       {;}
               | BREAK                          {;}
               | RETURN expression              {;}
               | RETURN                         {;}
               ;

expression : function_call                                      {;}
           | '-' literal                                        {$$ = -$2;}
           | NOT literal                                        {$$ = !$2;}
           | expression '|' expression                          {$$ = $1 | $3;}
           | expression '&' expression                          {$$ = $1 & $3;}
           | expression '^' expression                          {$$ = $1 ^ $3;}
           | expression '+' expression                          {$$ = $1 + $3;}
           | expression '-' expression                          {$$ = $1 - $3;}
           | expression '*' expression                          {$$ = $1 * $3;}
           | expression '/' expression                          {$$ = $1 / $3;}
           | expression '%' expression                          {$$ = $1 % $3;}
           | expression AND expression                          {$$ = $1 && $3;}
           | expression OR expression                           {$$ = $1 || $3;}
           | NOT expression                                     {$$ = !$2;}
           | expression SHIFT_LEFT expression                   {$$ = $1 << $3;}
           | expression SHIFT_RIGHT expression                  {$$ = $1 >> $3;}
           | expression LESS_THAN expression                    {$$ = $1 < $3;}
           | expression GREATER_THAN expression                 {$$ = $1 > $3;}
           | expression LESS_THAN_OR_EQUAL expression           {$$ = $1 <= $3;}
           | expression GREATER_THAN_OR_EQUAL expression        {$$ = $1 >= $3;}
           | expression EQUAL expression                        {$$ = $1 == $3;}
           | expression NOT_EQUAL expression                    {$$ = $1 != $3;}
           | '(' expression ')'                                 {$$ = $2;}
           | literal                                            {$$ = $1;}
           | IDENTIFIER                                         /* Need to put into thy Symbol Table*/
           ;


literal : INTEGER               {$$ = $1;}
        | FLOAT                 {$$ = $1;}
        | STRING                {$$ = $1;}
        | TRUE_VALUE            {$$ = 1;}
        | FALSE_VALUE           {$$ = 0;}
        ;


// ------------ Function ------------------
function_arguments : data_type IDENTIFIER                                 {;}
                   | data_type IDENTIFIER ',' function_arguments          {;}
                   ;

function_parameters : literal                                          {;}
                    | literal ',' function_parameters                  {;}
                    ;

function_definition : data_type IDENTIFIER '(' function_arguments ')' statement_list        {;}
                    | data_type IDENTIFIER '(' ')' statement_list                           {printf("function_definition\n");}
                    ;

function_call : IDENTIFIER '(' function_parameters ')'        {;}
              | IDENTIFIER '(' ')'                            {;}
              ;


// ------------ Enum ------------------
enum_def : ENUM IDENTIFIER '{' enum_body '}'         {;}
         ;

enum_body : IDENTIFIER                                      {;}
          | IDENTIFIER '=' expression                       {;}
          | enum_body ',' IDENTIFIER                        {;}
          | enum_body ',' IDENTIFIER  '=' expression        {;}
          ;

enum_declaration : IDENTIFIER IDENTIFIER                         {;}
                 | IDENTIFIER IDENTIFIER '=' expression          {;}
                 ;

// --------------------------------------------------------------------

%%

void yyerror(char *s) {
     fprintf(stderr, "Error: %s at line %d\n", s, nline);
}

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        printf("File not found, Interpreter mode..\n");
        
        yyparse();
    }
    else{
        yyparse();

        fclose(yyin);

        return 0;
    }
}
