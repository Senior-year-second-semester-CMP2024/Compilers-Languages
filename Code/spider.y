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

    // ----- Quadruples ------



    // ----- Semantic Erros ------
    #define SHOW_SEMANTIC_ERROR_MESSAGES 1
    #define SEMANTIC_ERROR_TYPE_MISMATCH 1
    #define SEMANTIC_ERROR_UNDECLARED 2
    #define SEMANTIC_ERROR_UNINITIALIZED 3
    #define SEMANTIC_ERROR_UNUSED 4
    #define SEMANTIC_ERROR_REDECLARED 5
    #define SEMANTIC_ERROR_CONSTANT 6
    #define SEMANTIC_ERROR_OUT_OF_SCOPE 7
    #define SEMANTIC_WARNING_CONSTANT_IF 8

    void log_semantic_error( int error_code, char variable) {
        int error_line = nline;

        if ( SHOW_SEMANTIC_ERROR_MESSAGES ) {
            
            switch( error_code ) {
                case SEMANTIC_ERROR_TYPE_MISMATCH:
                    printf("Semantic error (%d): Type mismatch error\n", error_line);
                    break;
                case SEMANTIC_ERROR_UNDECLARED:
                    printf("Semantic error (%d): Undeclared variable '%c'\n", error_line, variable);
                    break;
                case SEMANTIC_ERROR_UNINITIALIZED:
                    printf("Semantic error (%d): Uninitialized variable '%c'\n", error_line, variable);
                    break;
                case SEMANTIC_ERROR_UNUSED:
                    printf("Semantic error (%d): Unused variable '%c'\n", error_line, variable);
                    break;
                case SEMANTIC_ERROR_REDECLARED:
                    printf("Semantic error (%d): Redeclared variable '%c'\n", error_line, variable);
                    break;
                case SEMANTIC_ERROR_CONSTANT:
                    printf("Semantic error (%d): Constant variable '%c'\n", error_line, variable);
                    break;
                case SEMANTIC_ERROR_OUT_OF_SCOPE:
                    printf("Semantic error (%d): Variable '%c' out of scope\n", error_line, variable);
                    exit(EXIT_FAILURE);
                    break;
                case SEMANTIC_WARNING_CONSTANT_IF:
                    printf("Semantic warning (%d): If statement is always %s\n", error_line, (variable ? "True" : "False"));
                    break;
                default:
                    printf("Semantic error (%d): Unknown error\n", error_line);
                    break;
            }
            write_symbol_table_to_file(); // Assuming you have a function named printSymbolTable to print the symbol table
        }
    }


    // --------- Operators Functions ----------------
    struct NodeType* perform_arithmetic(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_bitwise_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_logical_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_comparison(struct NodeType* first_operand, struct NodeType* second_operand, char* operator);
    struct NodeType* perform_conversion(struct NodeType* term, char *target_type);


    // ----- Symbol Table Variables ------
    int symbol_table_index = 0;

    int scope_index = 1;
    int scopes[100];

    // --------- Types -------------
    struct NodeType {
        char *type;
        union {
                int integer_value;
                float float_value;
                char* string_value;
                int bool_value;
        }value;

        // check if the expression is a constant ==> helps in if statements with constant expressions
        int isConstant; 
    };

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
        int declared_flag, constant_flag, initialized_flag, used_flag, scope;
    };

    // ----- Symbol Table Functions ------
    struct symbol symbol_table [100]; // 26 for lower case, 26 for upper case
    struct NodeType* get_symbol_value(char symbol); // returns the value of a given symbol
    void add_symbol(char name, char* type, int constant_flag, int initialized_flag, int used_flag, int scope);
    void change_symbol_name(char symbol, char new_name);
    void modify_symbol_value(char symbol, struct NodeType* new_value);
    void modify_symbol_parameter(char symbol, int new_parameter);

    int retrieve_symbol_index(char symbol_name);

%}

/*
%union {
    char *str;  // Assuming yylval holds a pointer to a string
}

%token <str> IDENTIFIER
*/

// -----Tokens-----
%token PRINT CONSTANT 
%token BOOL_DATA_TYPE STRING_DATA_TYPE INT_DATA_TYPE FLOAT_DATA_TYPE VOID_DATA_TYPE 
%token IF ELSE ELSE_IF 
%token FOR WHILE REPEAT UNTIL 
%token SWITCH CASE DEFAULT CONTINUE BREAK RETURN 
%token SHIFT_LEFT SHIFT_RIGHT AND OR NOT 
%token TRUE_VALUE FALSE_VALUE INTEGER FLOAT STRING ENUM IDENTIFIER

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

int find_symbol_index(char symbol) {
    
    // Initialize the index to -1 if symbol is not found
    int symbol_index = -1; 
    
    // Iterate through the symbol table in reverse order
    for (int i = symbol_table_index - 1; i >= 0; i--) {
        
        // Check if the symbol name matches the given symbol
        if (symbol_table[i].name == symbol) {

            // Get the scope of the symbol            
            int symbol_scope = symbol_table[i].scope; 
            
            // Iterate through the scopes array in reverse order
            for (int j = scope_index - 1; j >= 0; j--) {

                // Check if the symbol scope matches any of the scopes in the array
                if (symbol_scope == scopes[j]) {
                    // If a match is found, return the index of the symbol in the symbol table
                    return i;
                }
            }
        }
    }
    // If the symbol is not found, return -1
    return symbol_index;
}

/* --------------------------------------------------------------------------------------------------------*/

/* ----------------------------
Parameters:
- name: the name of the symbol to be inserted.
- type: the type of the symbol
- scope:the scope level of the symbol
---------------------------- */

void add_symbol(char symbol_name, char* symbol_type, int constant_flag, int initialized_flag, int used_flag, int symbol_scope) {
    // Add a symbol to the symbol table
    symbol_table[symbol_table_index].name = symbol_name; 
    symbol_table[symbol_table_index].type = symbol_type; 
    symbol_table[symbol_table_index].declared_flag = 1; 
    symbol_table[symbol_table_index].constant_flag = constant_flag; 
    symbol_table[symbol_table_index].initialized_flag = initialized_flag; 
    symbol_table[symbol_table_index].used_flag = used_flag;
    symbol_table[symbol_table_index].scope = symbol_scope; 
    symbol_table_index++; 
}

/* ------------------------------------------------------------------------*/

/* ----------------------------
retrieves the value of a given symbol from a symbol table
computes index of `symbol` in the symbol table by calling the `find_symbol_index` 
The result is stored in the variable `bucket`
---------------------------- */

struct NodeType* get_symbol_value(char symbol) {

    // Find the index of the symbol    
    int bucket = find_symbol_index(symbol); 

    struct NodeType* ptr = malloc(sizeof(struct NodeType)); 
    ptr->type = symbol_table[bucket].type; 
    
    // Check the type of the symbol and assign its value to the node
    if (strcmp(symbol_table[bucket].type, "int") == 0)
        ptr->value.integer_value = symbol_table[bucket].value.integer_value;
    
    else if (strcmp(symbol_table[bucket].type, "float") == 0)
        ptr->value.float_value = symbol_table[bucket].value.float_value;
    
    else if (strcmp(symbol_table[bucket].type, "bool") == 0)
        ptr->value.bool_value = symbol_table[bucket].value.bool_value;
    
    else if (strcmp(symbol_table[bucket].type, "string") == 0)
        ptr->value.string_value = symbol_table[bucket].value.string_value;
    
    return ptr;
}


/* ------------------------------------------------------------------------*/

/* ----------------------------
1. Parameters:
- name: Represents the name of the symbol whose index is to be retrieved.
---------------------------- */

int retrieve_symbol_index(char symbol_name) {
    int bucket = find_symbol_index(symbol_name);
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = bucket;
    return bucket;
}

/* ------------------------------------------------------------------------*/

void change_symbol_name(char old_symbol, char new_symbol_name){
    int bucket = find_symbol_index(old_symbol);
    symbol_table [bucket].name = new_symbol_name;
}

/* ------------------------------------------------------------------------*/

/* ----------------------------
Parameters:
- symbol: the symbol whose value is to be updated.
- value: the new value to be assigned to the symbol.
---------------------------- */

void modify_symbol_value(char symbol, struct NodeType* new_value){
	// Find the index of the symbol
    int bucket = find_symbol_index(symbol);
    
    if( strcmp(symbol_table[bucket].type, "int") == 0)
        symbol_table [bucket].value.integer_value = new_value->value.integer_value;
    
    else if( strcmp(symbol_table[bucket].type, "float") == 0)
        symbol_table[bucket].value.float_value = new_value->value.float_value;
    
    else if( strcmp(symbol_table[bucket].type, "bool") == 0)
        symbol_table[bucket].value.bool_value = new_value->value.bool_value;
    
    else if( strcmp(symbol_table[bucket].type, "string") == 0)
        symbol_table[bucket].value.string_value = new_value->value.string_value;
}

/* ------------------------------------------------------------------------*/

/* ----------------------------
Parameters:
- symbol: the symbol whose value is to be updated
- param: the new parameter value to be assigned to the symbol

Usage: in function definition (later)
---------------------------- */

void modify_symbol_parameter(char symbol, int new_parameter){
    int bucket = find_symbol_index(symbol);
    symbol_table [bucket].value.integer_value = new_parameter;
}


/* ------------------------------------------------------------------------*/

void display_node_value(struct NodeType* node)
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

void write_symbol_table_to_file(){

    FILE *filePointer = fopen("symbol_table.txt", "w");
    if (filePointer == NULL)
    {
        printf("Error opening file!\n");
        exit(EXIT_FAILURE);
    }

    fprintf(filePointer, "Symbol Table:\n");

    // Iterate through the symbol table and write each entry to the file
    for( int i=0 ; i < symbol_table_index ; i++ ){
        
        if( strcmp(symbol_table[i].type, "int") == 0 ){
            fprintf(filePointer, "Name:%c, Type:%s, Value:%d, Declared:%d, Initialized:%d, Used:%d, Constant:%d, Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.integer_value, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
        }
        
        else if( strcmp(symbol_table[i].type, "float" ) == 0){
            fprintf(filePointer, "Name:%c,Type:%s,Value:%f,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.float_value, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
        }
        
        else if( strcmp(symbol_table[i].type, "bool" ) == 0){
            fprintf(filePointer, "Name:%c,Type:%s,Value:%d,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.bool_value, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
        }
        
        else if( strcmp(symbol_table[i].type, "string" ) == 0){
            fprintf(filePointer, "Name:%c,Type:%s,Value:%s,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value.string_value, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
        }
    }

    fclose(filePointer); 
}

/* ------------------------------------------------------------------------*/

/* -------------------------Operators Functions-----------------------------*/


/* ------------------------- 1-Arithmetic Operations -----------------------------*/

struct NodeType* perform_arithmetic(struct NodeType* first_operand, struct NodeType* second_operand, char operator) {

    struct NodeType* result_node = malloc(sizeof(struct NodeType));

    if ( strcmp(first_operand->type, "int") == 0 && strcmp(second_operand->type, "int") == 0 ) {

        result_node->type = "int";

        switch (operator) {
            case '+':
                result_node->value.integer_value = first_operand->value.integer_value + second_operand->value.integer_value;
                break;
            case '-':
                result_node->value.integer_value = first_operand->value.integer_value - second_operand->value.integer_value;
                break;
            case '*':
                result_node->value.integer_value = first_operand->value.integer_value * second_operand->value.integer_value;
                break;
            case '/':
                result_node->value.integer_value = first_operand->value.integer_value / second_operand->value.integer_value;
                break;
            case '%':
                result_node->value.integer_value = first_operand->value.integer_value % second_operand->value.integer_value;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } else if ( strcmp(first_operand->type, "float") == 0 && strcmp(second_operand->type, "float") == 0 ) {

        result_node->type = "float";

        switch (operator) {
            case '+':
                result_node->value.float_value = first_operand->value.float_value + second_operand->value.float_value;
                break;
            case '-':
                result_node->value.float_value = first_operand->value.float_value - second_operand->value.float_value;
                break;
            case '*':
                result_node->value.float_value = first_operand->value.float_value * second_operand->value.float_value;
                break;
            case '/':
                result_node->value.float_value = first_operand->value.float_value / second_operand->value.float_value;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } else if ( strcmp(first_operand->type, "int") == 0 && strcmp(second_operand->type, "float") == 0 ) {

        result_node->type = "float";

        switch (operator) {
            case '+':
                result_node->value.float_value = first_operand->value.integer_value + second_operand->value.float_value;
                break;
            case '-':
                result_node->value.float_value = first_operand->value.integer_value - second_operand->value.float_value;
                break;
            case '*':
                result_node->value.float_value = first_operand->value.integer_value * second_operand->value.float_value;
                break;
            case '/':
                result_node->value.float_value = first_operand->value.integer_value / second_operand->value.float_value;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } else if (strcmp(first_operand->type, "float") == 0 && strcmp(second_operand->type, "int") == 0) {
        
        result_node->type = "float";
        
        switch (operator) {
            case '+':
                result_node->value.float_value = first_operand->value.float_value + second_operand->value.integer_value;
                break;
            case '-':
                result_node->value.float_value = first_operand->value.float_value - second_operand->value.integer_value;
                break;
            case '*':
                result_node->value.float_value = first_operand->value.float_value * second_operand->value.integer_value;
                break;
            case '/':
                result_node->value.float_value = first_operand->value.float_value / second_operand->value.integer_value;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } else {
        log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
    }

    return result_node;
}

/* ------------------------- 2- Bitwise Operations -----------------------------*/

struct NodeType* perform_bitwise_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator) {
    
    struct NodeType* result_node = malloc(sizeof(struct NodeType));
    
    if ( strcmp(first_operand->type, "int") == 0 && strcmp(second_operand->type, "int") == 0 ) {

        result_node->type = "int";

        switch (operator) {
            case '|':
                result_node->value.integer_value = first_operand->value.integer_value | second_operand->value.integer_value;
                break;
            case '&':
                result_node->value.integer_value = first_operand->value.integer_value & second_operand->value.integer_value;
                break;
            case '^':
                result_node->value.integer_value = first_operand->value.integer_value ^ second_operand->value.integer_value;
                break;
            case '<':
                result_node->value.integer_value = first_operand->value.integer_value << second_operand->value.integer_value;
                break;
            case '>':
                result_node->value.integer_value = first_operand->value.integer_value >> second_operand->value.integer_value;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, operator);
        }
    } else {
        log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, operator);
    }
    
    return result_node;
}

/* ------------------------- 3- Logical Operations -----------------------------*/

struct NodeType* perform_logical_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator) {

    struct NodeType* result_node = malloc(sizeof(struct NodeType));
    
    if ( strcmp(first_operand->type, "bool") == 0 && strcmp(second_operand->type, "bool") == 0 ) {

        result_node->type = "bool";

        switch (operator) {
            case '&':
                result_node->value.bool_value = first_operand->value.bool_value && second_operand->value.bool_value;
                break;
            case '|':
                result_node->value.bool_value = first_operand->value.bool_value || second_operand->value.bool_value;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, operator);
        }
    } else {
        log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, operator);
    }
    
    return result_node;
}

/* ------------------------- 4- Comparison Operations -----------------------------*/

struct NodeType* perform_comparison(struct NodeType* first_operand, struct NodeType* second_operand, char* operator) {

    struct NodeType* result_node = malloc(sizeof(struct NodeType));
    result_node->type = "bool";
    
    if ( strcmp(first_operand->type, second_operand->type) != 0 ) {
        log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
    }

    if (strcmp(first_operand->type, "float") == 0) {
        
        // ----------- float values -----------
        if (strcmp(operator, "==") == 0) {
            result_node->value.bool_value = first_operand->value.float_value == second_operand->value.float_value;
        } 
        else if (strcmp(operator, "!=") == 0) {
            result_node->value.bool_value = first_operand->value.float_value != second_operand->value.float_value;
        } 
        else if (strcmp(operator, ">") == 0) {
            result_node->value.bool_value = first_operand->value.float_value > second_operand->value.float_value;
        } 
        else if (strcmp(operator, ">=") == 0) {
            result_node->value.bool_value = first_operand->value.float_value >= second_operand->value.float_value;
        } 
        else if (strcmp(operator, "<") == 0) {
            result_node->value.bool_value = first_operand->value.float_value < second_operand->value.float_value;
        } 
        else if (strcmp(operator, "<=") == 0) {
            result_node->value.bool_value = first_operand->value.float_value <= second_operand->value.float_value;
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } 
    // ----------- integer values -----------
    else {
        if (strcmp(operator, "==") == 0) {
            result_node->value.bool_value = first_operand->value.integer_value == second_operand->value.integer_value;
        } 
        else if (strcmp(operator, "!=") == 0) {
            result_node->value.bool_value = first_operand->value.integer_value != second_operand->value.integer_value;
        } 
        else if (strcmp(operator, ">") == 0) {
            result_node->value.bool_value = first_operand->value.integer_value > second_operand->value.integer_value;
        } 
        else if (strcmp(operator, ">=") == 0) {
            result_node->value.bool_value = first_operand->value.integer_value >= second_operand->value.integer_value;
        } 
        else if (strcmp(operator, "<") == 0) {
            result_node->value.bool_value = first_operand->value.integer_value < second_operand->value.integer_value;
        } 
        else if (strcmp(operator, "<=") == 0) {
            result_node->value.bool_value = first_operand->value.integer_value <= second_operand->value.integer_value;
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    }
    
    return result_node;
}

/* ------------------------- 5- Conversion Operations -----------------------------*/

struct NodeType* perform_conversion(struct NodeType* term, char *target_type) {

    struct NodeType* converted_node = malloc(sizeof(struct NodeType));

    /* ------------------------- Convert to Integer -----------------------------*/
    if(strcmp(target_type, "int") == 0) {

        converted_node->type = "int";
        /* ------------------------- Float to Integer -----------------------------*/        
        if( strcmp(term->type, "float") == 0 ) {
            converted_node->value.integer_value = (int)term->value.float_value;
        } 
        /* ------------------------- Bool to Integer -----------------------------*/        
        else if(strcmp(term->type, "bool") == 0) {
            converted_node->value.integer_value = (int)term->value.bool_value;
        } 
        /* ------------------------- String to Integer -----------------------------*/        
        else if(strcmp(term->type, "string") == 0) {
            char *str = strdup(term->value.string_value);
            str++;
            str[strlen(str)-1] = '\0';
            converted_node->value.integer_value = atoi(str);
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, term->type);
        }
    } 
    /* ------------------------- Convert to Float -----------------------------*/
    else if( strcmp(target_type, "float") == 0 ) {

        converted_node->type = "float";

        /* ------------------------- Integer to Float -----------------------------*/        
        if( strcmp(term->type, "int") == 0 ) {
            converted_node->value.float_value = (float)term->value.integer_value;
        } 
        /* ------------------------- Bool to Float -----------------------------*/        
        else if(strcmp(term->type, "bool") == 0) {
            converted_node->value.float_value = (float)term->value.bool_value;
        }
        /* ------------------------- String to Float -----------------------------*/         
        else if(strcmp(term->type, "string") == 0) {
            char *str = strdup(term->value.string_value);
            str++;
            str[strlen(str)-1] = '\0';
            converted_node->value.float_value = atof(str);
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, term->type);
        }
    }
    /* ------------------------- Convert to Bool -----------------------------*/
    else if(strcmp(target_type, "bool") == 0) {

        converted_node->type = "bool";

        /* ------------------------- Bool to Integer -----------------------------*/         
        if(strcmp(term->type, "int") == 0) {
            converted_node->value.bool_value = (int)term->value.integer_value!=0;
        } 
        /* ------------------------- Bool to Float -----------------------------*/         
        else if(strcmp(term->type, "float") == 0) {
            converted_node->value.bool_value = (int)term->value.float_value!=0;
        } 
        /* ------------------------- Bool to String -----------------------------*/         
        else if(strcmp(term->type, "string") == 0) {
            char *str = strdup(term->value.string_value);
            str++;
            str[strlen(str)-1] = '\0';
            converted_node->value.bool_value = str[0] != '\0';
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, term->type);
        }
    } 
    /* ------------------------- Convert to String -----------------------------*/
    else if( strcmp(target_type, "string") == 0 ) {
        converted_node->type = "string";

        /* ------------------------- String to Integer -----------------------------*/         
        if(strcmp(term->type, "int") == 0) {
            char temp[100];
            sprintf(temp, "%d", term->value.integer_value);
            converted_node->value.string_value = strdup(temp);
        } 
        /* ------------------------- String to Float -----------------------------*/         
        else if(strcmp(term->type, "float") == 0) {
            char temp[100];
            sprintf(temp, "%f", term->value.float_value);
            converted_node->value.string_value = strdup(temp);
        } 
        /* ------------------------- String to Bool -----------------------------*/         
        else if(strcmp(term->type, "bool") == 0) {
            char temp[100];
            sprintf(temp, "%d", term->value.bool_value);
            converted_node->value.string_value = strdup(temp);
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, term->type);
        }
    } 

    return converted_node;
}





/* ------------------------------------------------------------------------*/

void yyerror(char *s) {
     fprintf(stderr, "Error: %s at line %d\n", s, nline);
     write_symbol_table_to_file();
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
        write_symbol_table_to_file();
        return 0;
    }
}
