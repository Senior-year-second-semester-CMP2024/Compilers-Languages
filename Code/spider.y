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
    extern int yyleng;

    // ----- Symbol Table Variables ------
    int symbol_table_index = 0;


    // ----- Symbol Table Data Structure ------
    struct symbol {
        char name;
        char *type;
        union {
                int integer_value;
                float float_value;
                char* string_value;
                int bool_value;
        }value;
        int isDeclared, isConstant, isInitialized, isUsed, scope;
    };

    // ----- Symbol Table Functions ------
    struct symbol symbol_table [100]; // 26 for lower case, 26 for upper case
    struct nodeType* symbolValue(char symbol); // returns the value of a given symbol
    
    int getSymbolIndex(char name);

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

program : statement_list                            {;}
        | function_definition                       {;} 
        | statement_list program                    {;}  
        | function_definition program               {;}
        ;

statement_list  : statement ';'                          {;}
                | statement_list statement ';'           {;} 
                | control_statement                      {;}
                | statement_list control_statement       {;}
                | '{' statement_list '}'
                | statement_list '{' statement_list '}'  {;}        
                ;

control_statement   :  if_condition 
                    |  while_loop 
                    |  for_loop 
                    |  repeat_until_loop 
                    |  switch_Case 
                    ;   

statement : assignment                   {;}
          | declaration                  {;}
          | jump_statement               {;}
          | expression                   {;}
          | PRINT '(' expression ')'     {;}
          ;

declaration : CONSTANT data_type assignment
            | data_type assignment
            | data_type IDENTIFIER
            ;

assignment : IDENTIFIER '=' expression
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


// ------------ Conditions ------------------
if_condition             : IF '(' expression  ')' '{' statement_list '}' else_condition {;}
                        ;
else_condition           : {;}
                        | ELSE_IF '(' expression  ')' '{' statement_list '}' else_condition {;}
                        | ELSE {;}'{' statement_list '}'     {;}
                        ;
case                    : CASE expression ':' statement_list                {;}
                        | DEFAULT ':' statement_list                        {;}
                        ;
caseList                : caseList case
                        | case 
                        ;
switch_Case          : SWITCH '(' IDENTIFIER ')' '{' caseList '}'        {;}
                        ;

case_list : case_list case
          | case
          ;

// ------------ Loops ------------------
while_loop               : WHILE '(' expression ')'  '{' statement_list '}'                              {;}
                        ;
for_loop                 : FOR '(' assignment ';'  expression ';'  assignment ')' '{' statement_list '}' {;}
                        ;
repeat_until_loop         : REPEAT '{' statement_list '}' UNTIL '(' expression ')' ';'                    {;}
                        ;

jump_statement : CONTINUE                       {;}
               | BREAK                          {;}
               | RETURN expression              {;}
               | RETURN                         {;}
               ;

// ------------ Data Types ------------------
data_type : BOOL_DATA_TYPE          {$$ = $1;}
          | STRING_DATA_TYPE        {$$ = $1;}
          | INT_DATA_TYPE           {$$ = $1;}
          | FLOAT_DATA_TYPE         {$$ = $1;}
          | VOID_DATA_TYPE          {$$ = $1;}
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

function_definition : data_type IDENTIFIER '(' function_arguments ')' '{' statement_list '}'         {;}
                    | data_type IDENTIFIER '(' ')' '{' statement_list '}'                            {;}
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

// -------------------- Symbol Table Functions --------------------

/* ----------------------------
- `level` ==> store the scope level of the symbol found in the symbol table.
- iterates backward through the symbol tables starting from the current table (bottom up).
- check if name of it == input `token` 
- Then, iterates backward through the table to find the token
- it returns the index `i`, which represents the index of the symbol in the symbol table.
---------------------------- */

int computeSymbolIndex(char token){
    int level = -1;
    for(int i=symbol_table_index - 1 ; i >= 0 ; i--) {
        if(symbol_table[i].name == token) {
            level = symbol_table[i].scope;
            for(int j = scope_index - 1 ; j >= 0 ; j--) {
                if(level == scopes[j]) {
                    return i;
                }
            }
        }
    }
    return -1;
} 

/* ------------------------------------------------------------------------*/

/* ----------------------------
Parameters:
- name: the name of the symbol to be inserted.
- type: the type of the symbol
- scope:the scope level of the symbol
---------------------------- */
void insert(char name, char* type, int isConstant, int isInitialized, int isUsed, int scope){

    symbol_table [symbol_table_index].name = name;
    symbol_table [symbol_table_index].type = type;
    symbol_table [symbol_table_index].isDeclared = 1;
    symbol_table [symbol_table_index].isConstant = isConstant;

    symbol_table [symbol_table_index].isInitialized = isInitialized;
    symbol_table [symbol_table_index].isUsed = isUsed;
    symbol_table [symbol_table_index].scope = scope;
    ++symbol_table_index;
}

/* ------------------------------------------------------------------------*/

/* ----------------------------
retrieves the value of a given symbol from a symbol table
computes index of `symbol` in the symbol table by calling the `computeSymbolIndex` 
The result is stored in the variable `bucket`
---------------------------- */
struct nodeType* symbolValue(char symbol){

    int bucket = computeSymbolIndex(symbol);
    struct nodeType* ptr = malloc(sizeof(struct nodeType));;
    ptr->type = symbol_table[bucket].type;

    if( strcmp(symbol_table[bucket].type, "int") == 0 )
        ptr->value.integer_value = symbol_table[bucket].value.integer_value;
    else if( strcmp(symbol_table[bucket].type, "float") == 0)
        ptr->value.float_value = symbol_table[bucket].value.float_value;
    else if( strcmp(symbol_table[bucket].type, "bool") == 0)
        ptr->value.bool_value = symbol_table[bucket].value.bool_value;
    else if( strcmp(symbol_table[bucket].type, "string") == 0)
        ptr->value.string_value = symbol_table[bucket].value.string_value;

    return ptr;
}

/* ------------------------------------------------------------------------*/

/* ----------------------------
1. Parameters:
- name: Represents the name of the symbol whose index is to be retrieved.
---------------------------- */

int getSymbolIndex(char name) {
    int bucket = computeSymbolIndex(name);
    struct nodeType* ptr = malloc(sizeof(struct nodeType));;
    ptr->type = bucket;
    return bucket;
}

/* ------------------------------------------------------------------------*/

/* ----------------------------

---------------------------- */

void updateSymbolName(char symbol, char new_name){
    int bucket = computeSymbolIndex(symbol);
    symbol_table [bucket].name = new_name;
}

/* ------------------------------------------------------------------------*/

/* ----------------------------
Parameters:
- symbol: the symbol whose value is to be updated.
- value: the new value to be assigned to the symbol.
---------------------------- */

void updateSymbolValue(char symbol, struct nodeType* value){
	int bucket = computeSymbolIndex(symbol);
    
    if( strcmp(symbol_table[bucket].type, "int") == 0)
        symbol_table [bucket].value.integer_value = val->value.integer_value;
    else if( strcmp(symbol_table[bucket].type, "float") == 0)
        symbol_table[bucket].value.float_value = val->value.float_value;
    else if( strcmp(symbol_table[bucket].type, "bool") == 0)
        symbol_table[bucket].value.bool_value = val->value.bool_value;
    else if( strcmp(symbol_table[bucket].type, "string") == 0)
        symbol_table[bucket].value.string_value = val->value.string_value;
}

/* ------------------------------------------------------------------------*/

/* ----------------------------
Parameters:
- symbol: the symbol whose value is to be updated
- param: the new parameter value to be assigned to the symbol

Usage: in function definition (later)
---------------------------- */

void updateSymbolParameter(char symbol, int parameter){
    int bucket = computeSymbolIndex(symbol);
    symbol_table [bucket].value.integer_value = parameter;
}


/* ------------------------------------------------------------------------*/

void printNode(struct nodeType* node)
{
    if( strcmp(node->type, "int") == 0 )
        printf("%d\n", node->value.integer_value);
    else if( strcmp(node->type, "float") == 0 )
        printf("%f\n", node->value.float_value);
    else if( strcmp(node->type, "bool") == 0 )
        printf("%d\n", node->value.bool_value);
    else if(strcmp( node->type, "string" ) == 0)
        printf("%s\n", node->value.string_value);
}

/* ------------------------------------------------------------------------*/

void printSymbolTable(){

    FILE *f = fopen("symbol_table.txt", "w");
    if (f == NULL)
    {
        printf("Error opening file!\n");
        exit(EXIT_FAILURE);
    }

    fprintf(f, "Symbol Table:\n");
    for( int i=0 ; i < symbol_table_index ; i++ ){
        if( strcmp(symbol_table[i].type, "int") == 0 ){
            fprintf(f, "Name:%c, Type:%s, Value:%d, Declared:%d, Initialized:%d, Used:%d, Const:%d, Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.integer_value, symbol_table[i].isDeclared, symbol_table[i].isInitialized, symbol_table[i].isUsed, symbol_table[i].isConstant, symbol_table[i].scope);
        }
        else if( strcmp(symbol_table[i].type, "float" ) == 0){
            fprintf(f, "Name:%c,Type:%s,Value:%f,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.float_value, symbol_table[i].isDeclared, symbol_table[i].isInitialized, symbol_table[i].isUsed, symbol_table[i].isConstant, symbol_table[i].scope);
        }
        else if( strcmp(symbol_table[i].type, "bool" ) == 0){
            fprintf(f, "Name:%c,Type:%s,Value:%d,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.bool_value, symbol_table[i].isDeclared, symbol_table[i].isInitialized, symbol_table[i].isUsed, symbol_table[i].isConstant, symbol_table[i].scope);
        }
        else if( strcmp(symbol_table[i].type, "string" ) == 0){
            fprintf(f, "Name:%c,Type:%s,Value:%s,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.string_value, symbol_table[i].isDeclared, symbol_table[i].isInitialized, symbol_table[i].isUsed, symbol_table[i].isConstant, symbol_table[i].scope);
        }
    }
}

/* ------------------------------------------------------------------------*/

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
