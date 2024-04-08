%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    void yyerror(char *);
    int yylex();
    void yyerror (char *s); 
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

%nonassoc LESS_THAN GREATER_THAN LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL EQUAL NOT_EQUAL

%%

program : statement_list
        | /* empty */
        ;

statement_list : statement
               | statement_list statement
               ;

statement : PRINT expression ';'
          | PRINT '(' STRING ')' 	                {printf("%s\n", $3);}
          | declaration ';'
          | selection_statement
          | iteration_statement
          | jump_statement ';'
          ;

declaration : CONSTANT data_type IDENTIFIER '=' expression
            | data_type IDENTIFIER '=' expression
            | data_type IDENTIFIER '=' STRING
            | data_type IDENTIFIER
            | enum_declaration
            | enum_def
            ;

data_type : BOOL_DATA_TYPE          {$$ = $1;}
          | STRING_DATA_TYPE        {$$ = $1;}
          | INT_DATA_TYPE           {$$ = $1;}
          | FLOAT_DATA_TYPE         {$$ = $1;}
          | VOID_DATA_TYPE          {$$ = $1;}
          ;

selection_statement : IF '(' expression ')' statement
                    | IF '(' expression ')' statement ELSE statement
                    | IF '(' expression ')' statement ELSE_IF '(' expression ')' statement
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

function_definition : data_type IDENTIFIER '(' function_arguments ')' code_block        {;}
                    | data_type IDENTIFIER '(' ')' code_block                           {printf("function_definition\n");}
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
    fprintf(stderr, "%s\n", s);
}


int main(void) {
    yyparse();
}