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
    int scope_count = 1;
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

    // --------- Types Functions -------------
    struct NodeType* create_int_node();
    struct NodeType* create_float_node();
    struct NodeType* create_bool_node();
    struct NodeType* create_string_node();
    struct NodeType* create_enum_node();

    void check_type(struct NodeType* first_type, struct NodeType* second_type);
    void check_type_2(char symbol, struct NodeType* second_type);
    void check_type_3(char* first_type, char* second_type);

    int check_variable_declaration(char variable_name);
    void check_same_scope_redeclaration(char variable_name);
    void check_out_of_scope_declaration(char variable_name);
    void check_initialization(char variable_name);
    void check_using_variables();
    void check_reassignment_constant_variable(char variable_name);
    void check_constant_expression_if_statement(struct NodeType* expression);
    int check_variable_declaration_as_constant_same_scope(char variable_name);

    /* ------------------------------------------------------------------------*/

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


    // ----------------------------------
    void set_variable_constant_in_symbol_table(char variable_name);
    void set_variable_initialized_in_symbol_table(char variable_name);
    void mark_variable_used_in_symbol_table(char variable_name);
    void mark_variable_declared_in_symbol_table(char variable_name);
    

    // -------------- Scope Functions --------------------
    void enter_scope();
    void exit_scope();

    // -------------- Quadruples --------------------
    #define show_quadruples 1
    #define MAX_STACK_SIZE 100
    void print_function_start(const char* function_name);


    int end_label_stack[MAX_STACK_SIZE];
    int end_label_stack_ptr = -1;
    int end_label_number = 0;

    int label_stack[MAX_STACK_SIZE];
    int label_stack_ptr = -1;
    int label_number = 0;

    char last_identifier_stack[MAX_STACK_SIZE];
    int last_identifier_stack_ptr = -1;

    int start_label_stack[MAX_STACK_SIZE];
    int start_label_stack_ptr = -1;
    int start_label_number = 0;

    // ---------Functions --------------
    void print_function_start(const char* function_name);
    void print_function_end(const char* function_name);
    void print_function_call(const char* function_name);
    void print_function_return();
    void print_instruction(const char* instruction);
    void print_push_integer(int value);
    void print_push_float(float value);
    void print_push_identifier(char symbol);
    void print_push_string(char* str);
    void print_pop_identifier(char symbol);
    void print_push_end_label(int end_label_number);
    void print_jump_end_label();
    void print_pop_end_label();
    void print_jump_false_label(int label_number);
    void print_pop_label();
    void print_push_last_identifier_stack(char identifier);
    void print_peak_last_identifier_stack();
    void print_pop_last_identifier_stack();
    void print_push_start_label(int start_label_number);
    void print_jump_start_label();
    void print_pop_start_label();
    void print_start_enum(char enum_name);
    void print_end_enum(char enum_name);


%}

/* --------------- Yacc definitions ---------------*/

/* --------------- Starting Symbol ---------------*/
%start program

// %union is used to define the types of the tokens that can be returned
// Here, we define the types where the 2nd term is associated with the type of the 1st term.
%union {
    int INTEGER_TYPE;
    float FLOAT_TYPE;
    int BOOL_TYPE;
    char* STRING_TYPE;
    void* VOID_TYPE;
    char* DATA_TYPE;
    char* DATA_MODIFIER;
    struct NodeType* NODE_TYPE;
}

// -----Tokens-----
%token PRINT  
%token IF ELSE ELSE_IF 
%token FOR WHILE REPEAT UNTIL 
%token SWITCH CASE DEFAULT CONTINUE BREAK RETURN 
%token SHIFT_LEFT SHIFT_RIGHT AND OR NOT 
%token ENUM

// -----Operators-----
%right '=' 
%left AND OR
%left  '|' '^' '&' 
%left EQUAL NOT_EQUAL 
%left GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL 
%left SHIFT_LEFT SHIFT_RIGHT
%left '+' '-'
%right NOT
%left '*' '/' '%'

// ----- Declarations -----
%token <DATA_MODIFIER> CONSTANT
%token <DATA_TYPE> INTEGER_DATA_TYPE FLOAT_DATA_TYPE BOOL_DATA_TYPE STRING_DATA_TYPE VOID_DATA_TYPE
%token <NODE_TYPE> IDENTIFIER // this is a token IDENTIFIER returned by the lexical analyzer with as NODE_TYPE


// ----- Data Types -----
%token <INTEGER_DATA_TYPE> INTEGER
%token <FLOAT_DATA_TYPE> FLOAT
%token <STRING_DATA_TYPE> STRING
%token <BOOL_DATA_TYPE> TRUE_VALUE FALSE_VALUE

// ----- Return Types (NON TERMINALS) -----
%type <VOID_TYPE> program statement_list control_statement statement
%type <VOID_TYPE> if_condition while_loop for_loop repeat_until_loop switch_Case case_list case
%type <VOID_TYPE> function_arguments function_parameters

%type <DATA_MODIFIER> data_modifier


%type <NODE_TYPE> literal
%type <NODE_TYPE> expression assignment data_type declaration function_call

%%

/* ----------------------------DONE---------------------------------*/
program : statement_list                            {;}
        | function_definition                       {;} 
        | statement_list program                    {;}  
        | function_definition program               {;}
        ;
/* ----------------------------DONE---------------------------------*/
statement_list  : statement ';'                          {;}
                | '{' {enter_scope();} statement_list '}' {exit_scope();}
                | control_statement                      {;}
                | statement_list '{' {enter_scope();} statement_list '}' {exit_scope();}  {;}        
                | statement_list statement ';'           {;} 
                | statement_list control_statement       {;}
                ;
/* -----------------------------DONE--------------------------------*/
control_statement   :  {print_push_end_label(++end_label_number);} if_condition {print_pop_end_label();}
                    |  {print_push_end_label(++end_label_number);} switch_Case {print_pop_end_label();}
                    |  {print_push_start_label(++start_label_number);} while_loop {print_pop_start_label();}
                    |  {print_push_start_label(++start_label_number);} repeat_until_loop {print_pop_start_label();}
                    |  for_loop {print_pop_start_label();}
                    ;   
/* ----------------------------DONE---------------------------------*/
statement : assignment                   {;}
          | expression                   {;}
          | declaration                  {;}
          | PRINT '(' expression ')'     {display_node_value($3);}
          | PRINT '(' IDENTIFIER ')'     {display_node_value(get_symbol_value($3)); mark_variable_used_in_symbol_table($3);}
          | jump_statement               {;}
          ;
/* ----------------------------DONE---------------------------------*/
declaration : data_modifier data_type IDENTIFIER    {check_same_scope_redeclaration($3);} '=' expression { check_Type_3($2, $6); add_symbol($3, $2->type, 1, 0, 0, scopes[scope_index-1]); modify_symbol_value($3, $6); set_variable_initialized_in_symbol_table($3); print_pop_identifier($3);} 
            | data_type IDENTIFIER                  { check_same_scope_redeclaration($2); add_symbol($2, $1->type, 0, 0, 0, scopes[scope_index-1]); print_pop_identifier($2); }
            | data_type IDENTIFIER                  { check_same_scope_redeclaration($2);} '=' expression {check_Type_3($1, $5); add_symbol($2, $1->type, 0, 0, 0, scopes[scope_index-1]); modify_symbol_value($2,$5); set_variable_initialized_in_symbol_table($2); print_pop_identifier($2);}
            ;
/* --------------------------DONE-----------------------------------*/
data_modifier : CONSTANT
              ;
/* ---------------------------DONE----------------------------------*/
assignment : IDENTIFIER '=' expression              {check_out_of_scope_declaration($1); check_reassignment_constant_variable(); check_type_2($1,$3); mark_variable_used_in_symbol_table($1); modify_symbol_value($1, $3); $$ = $3; set_variable_initialized_in_symbol_table($3); print_pop_identifier($1);}
           | enum_definition                        {;} 
           | data_type enum_declaration             {/*check if redeclared*/;}
           ;
/* ----------------------------DONE---------------------------------*/
expression : function_call                                      {$$->isConstant=0;}
           
           | '-' literal                                        {print_instruction("Negative or Negation"); if($2->type == "int") {$$ = create_int_node(); $$->value.integer_value = -$2->value.integer_value;} else if ($2->type == "float") { $$ = create_float_node(); $$->value.float_value = -$2->value.float_value;} $$->isConstant = $2->isConstant;}
           | NOT literal                                        {print_instruction("Negation or NOT"); if($2->type == "bool") {$$ = create_bool_node(); $$->value.bool_value = !$2->value.bool_value;} else if ($2->value.integer_value) {$$ = create_bool_node(); $$->value.bool_value = 0;} else {$$ = create_bool_node(); $$->value.bool_value = 1;} $$->isConstant = $2->isConstant;}
           
           | expression '|' expression                          {print_instruction("Bitwise OR"); $$ = perform_bitwise_operation($1, $3, '|'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression '&' expression                          {print_instruction("Bitwise AND"); $$ = perform_bitwise_operation($1, $3, '&'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression '^' expression                          {print_instruction("Bitwise XOR"); $$ = perform_bitwise_operation($1, $3, '^'); $$->isConstant = $1->isConstant && $3->isConstant;}
           
           | expression '+' expression                          {print_instruction("Addition"); $$ = perform_arithmetic($1, $3, '+'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression '-' expression                          {print_instruction("Subtraction"); $$ = perform_arithmetic($1, $3, '-'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression '*' expression                          {print_instruction("Multiplication"); $$ = perform_arithmetic($1, $3, '*'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression '/' expression                          {print_instruction("Division"); $$ = perform_arithmetic($1, $3, '/'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression '%' expression                          {print_instruction("Modulus"); $$ = perform_arithmetic($1, $3, '%'); $$->isConstant = $1->isConstant && $3->isConstant;}
           
           | expression AND expression                          {print_instruction("Logical AND"); $$ = perform_logical_operation($1, $3, '&'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression OR expression                           {print_instruction("Logical OR"); $$ = perform_logical_operation($1, $3, '|'); $$->isConstant = $1->isConstant && $3->isConstant;}

           | expression SHIFT_LEFT expression                   {print_instruction("Shift Left"); perform_bitwise_operation($1, $3, '<'); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression SHIFT_RIGHT expression                  {print_instruction("Shift Right"); perform_bitwise_operation($1, $3, '>'); $$->isConstant = $1->isConstant && $3->isConstant;}

           | expression LESS_THAN expression                    {print_instruction("Less Than"); $$ = perform_comparison($1, $3, "<"); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression GREATER_THAN expression                 {print_instruction("Greater Than"); $$ = perform_comparison($1, $3, ">"); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression LESS_THAN_OR_EQUAL expression           {print_instruction("Less Than or Equal"); $$ = perform_comparison($1, $3, "<="); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression GREATER_THAN_OR_EQUAL expression        {print_instruction("Greater Than or Equal"); $$ = perform_comparison($1, $3, ">="); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression EQUAL expression                        {print_instruction("Equal"); $$ = perform_comparison($1, $3, "=="); $$->isConstant = $1->isConstant && $3->isConstant;}
           | expression NOT_EQUAL expression                    {print_instruction("Not Equal"); $$ = perform_comparison($1, $3, "!="); $$->isConstant = $1->isConstant && $3->isConstant;}
           
           | literal                                            {$$ = $1;}
           | '(' data_type ')' literal                          {print_instruction("Casting or Conversion"); $$ = perform_conversion($4, $2->type); $$->isConstant = $4->isConstant;}
           ;
/* -------------------------------------------------------------*/

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
               | BREAK                          {print_jump_end_label();}
               | RETURN                         {print_function_return();}
               | RETURN expression              {print_function_return();}
               ;

// ------------ Data Types DONE------------------
data_type : BOOL_DATA_TYPE              {$$ = create_bool_node();}
          | STRING_DATA_TYPE            {$$ = create_string_node();}
          | INTEGER_DATA_TYPE           {$$ = create_int_node();}
          | FLOAT_DATA_TYPE             {$$ = create_float_node();}
          | VOID_DATA_TYPE              {;}
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
enum_definition : ENUM IDENTIFIER '{' enum_body '}'         {;}
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

/* ------------------------- Type Checking -----------------------------*/

/* -------------------------
a new node of 'int' &&  initial value = 0 && Returns: A pointer to the node
------------------------- */
struct NodeType* create_int_node() {
    struct NodeType* new_node = malloc(sizeof(struct NodeType));
    new_node->type = "int";
    new_node->value.integer_value = 0;
    return new_node;
}

struct NodeType* create_float_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "float";
    ptr->value.integer_value = 0;
    return ptr;
}

struct NodeType* create_bool_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "bool";
    ptr->value.integer_value = 0;
    return ptr;
}

struct NodeType* create_string_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "string";
    ptr->value.integer_value = 0;
    return ptr;
}

struct NodeType* create_enum_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "enum";
    ptr->value.integer_value = 0;
    return ptr;
}


/* ------------------------- Compares the types of two node -----------------------------*/
void check_type(struct NodeType* first_type, struct NodeType* second_type) {
    if( strcmp(first_type->type, second_type->type) != 0 ) {
        log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_type->type); 
    }
    return;
}

/* ------------------------- Checks the type of a symbol against a given node type -----------------------------*/
void check_type_2(char symbol, struct NodeType* second_type) {
    for( int i=symbol_table_index-1 ; i>=0 ; i-- ) 
    {
        if( symbol_table[i].name == symbol ) 
        {
            for( int j=scope_index-1 ; j>=0 ; j--) 
            {
                if(symbol_table[i].scope == scopes[j]) 
                {
                    if(strcmp(symbol_table[i].type, second_type->type) != 0) 
                    {
                        log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, symbol_table[i].name);
                    }
                    else{
                        return;
                    }
                }
            }
        }
    }
    return;
}

/* ------------------------- Compares two types specified as strings -----------------------------*/
void check_type_3(char* first_type, char* second_type){
    if( strcmp(first_type, second_type) != 0 ) {
        log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_type);
    }
    return;
}

/* ------------------------------------------------------------------------*/

/* ------------------------- General Checking Functions -----------------------------*/
/* -------------------------
Checks if a variable is declared in the symbol table.
------------------------- */
int check_variable_declaration(char variable_name) {
    int found = 0;
    for( int i = 0; i < symbol_table_index; ++i ) {
        if( symbol_table[i].name == variable_name) {
            found = 1;
            break;
        }
    }    
    return found;
}

/* -------------------------
Checks if a variable is already declared in the current scope.
------------------------- */
void check_same_scope_redeclaration(char variable_name) {
    int level;
    for(int i = 0; i < symbol_table_index; ++i) 
    {
        if( symbol_table[i].name == variable_name ) 
        {
            level = symbol_table[i].scope;
            if( level == scopes[scope_index - 1] ) {
                log_semantic_error(SEMANTIC_ERROR_REDECLARED, variable_name);
            }
        }
    }
}

/* -------------------------
Checks if a variable is out of scope (undeclared or removed).
------------------------- */
void check_out_of_scope_declaration(char variable_name) {
    int level;
    for( int i = symbol_table_index - 1; i >= 0; --i ) 
    {
        if(symbol_table[i].name == variable_name) 
        {
            level = symbol_table[i].scope;
            for( int j = scope_index - 1; j >= 0; --j) {
                if(level == scopes[j]) {
                    return;
                }
            }
        }
    }
    log_semantic_error(SEMANTIC_ERROR_OUT_OF_SCOPE, variable_name);
}

/* -------------------------
Checks if a variable is initialized before use
------------------------- */
void check_initialization(char variable_name) {
    for(int i = symbol_table_index - 1; i >= 0; --i) 
    {
        if(symbol_table[i].name == variable_name) 
        {
            if(symbol_table[i].initialized_flag == 0) 
            {
                log_semantic_error(SEMANTIC_ERROR_UNINITIALIZED, variable_name);
                return;
            }
        }
    }
}

/* -------------------------
Checks that all variables are used
------------------------- */
void check_using_variables() {
    for(int i = 0; i < symbol_table_index; ++i) 
    {
        if(symbol_table[i].used_flag == 0) 
        {
            log_semantic_error(SEMANTIC_ERROR_UNUSED, symbol_table[i].name);
        }
    }
}

/* -------------------------
Checks if a constant variable is re-assigned a value
------------------------- */
void check_reassignment_constant_variable(char variable_name) {
    for(int i = symbol_table_index - 1 ; i >= 0; --i) 
    {
        if(symbol_table[i].name == variable_name) 
        {
            for(int j = scope_index - 1; j >= 0; --j) 
            {
                if(symbol_table[i].scope == scopes[j]) 
                {
                    if(symbol_table[i].constant_flag == 1) 
                    {
                        log_semantic_error(SEMANTIC_ERROR_CONSTANT, variable_name);
                        return;
                    } else {
                        return;
                    }
                }
            }
        }
    }
}

/* -------------------------
Checks if a conditional expression in an if statement is constant
------------------------- */
void check_constant_expression_if_statement(struct NodeType* expression) {
    if(expression->isConstant == 1) {
        log_semantic_error(SEMANTIC_WARNING_CONSTANT_IF, expression->value.bool_value != 0);
    }
}

/* -------------------------
Checks if a variable is declared as a constant within the current scope
------------------------- */
int check_variable_declaration_as_constant_same_scope(char variable_name) {
    for(int i = symbol_table_index - 1; i >= 0; --i) 
    {
        if(symbol_table[i].name == variable_name) 
        {
            for(int j = scope_index - 1; j >= 0; --j) 
            {
                if(symbol_table[i].scope == scopes[j]) 
                {
                    if(symbol_table[i].constant_flag == 1) 
                    {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            }
        }
    }
    return 0;
}

/* ------------------------------------------------------------------------*/

/* --------------------------------- Setter functions ---------------------------------------*/

/* -------------------------
Sets a variable as a constant within the symbol table
------------------------- */
void set_variable_constant_in_symbol_table(char variable_name) {
    for(int i = symbol_table_index - 1; i >= 0; --i) 
    {
        if(symbol_table[i].name == variable_name) 
        {
            symbol_table[i].constant_flag = 1;
            return;
        }
    }
}

/* -------------------------
Sets a variable as initialized within the symbol table
------------------------- */
void set_variable_initialized_in_symbol_table(char variable_name) {
    for(int i = symbol_table_index - 1; i >= 0; --i) 
    {
        if(symbol_table[i].name == variable_name) 
        {
            symbol_table[i].initialized_flag = 1;
            return;
        }
    }
}

/* -------------------------
Marks a variable as used within the symbol table
------------------------- */
void mark_variable_used_in_symbol_table(char variable_name) {
    for(int i = symbol_table_index - 1; i >= 0; --i) 
    {
        if(symbol_table[i].name == variable_name) 
        {
            symbol_table[i].used_flag = 1;
            return;
        }
    }
}


/* -------------------------
Marks a variable as declared within the symbol table
------------------------- */
void mark_variable_declared_in_symbol_table(char variable_name) {
    for(int i = symbol_table_index - 1; i >= 0; --i) {
        if(symbol_table[i].name == variable_name) { 
            symbol_table[i].declared_flag = 1;
            return;
        }
    }
}

/* ------------------------------------------------------------------------*/


/* --------------------------------- Setter functions ---------------------------------------*/
/* -------------------------
Enters a new scope by updating the scope array and index
------------------------- */
void enter_scope() {
    scopes[scope_index] = scope_count;
    scope_index++;
    scope_count++;
}

/* -------------------------
Exits the current scope by decrementing the scope index
------------------------- */
void exit_scope() {
    scope_index--;
}
/* ------------------------------------------------------------------------*/

/* --------------------------------- Quadruples functions ---------------------------------------*/

/* -------------------------
Prints the start of a function with its name if the show_quadruples flag is enabled
------------------------- */
void print_function_start(const char* function_name)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tPROC %s\n", nline, function_name); 
    }
}


/* -------------------------
Prints the end of a function along with its name if the show_quadruples flag is enabled.
------------------------- */
void print_function_end(const char* function_name)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tENDPROC %s\n", nline, function_name); 
    }
}

/* -------------------------
Prints the call of a function with its name if the show_quadruples flag is enabled.
------------------------- */
void print_function_call(const char* function_name)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tCALL %s\n", nline, function_name);
    }
}

/* -------------------------
Prints the return from a function if the show_quadruples flag is enabled.
------------------------- */
void print_function_return()
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tRET\n", nline);
    }
}

/* -------------------------
Prints a quadruple instruction if the show_quadruples flag is enabled.
------------------------- */
void print_instruction(const char* instruction)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \t%s\n", nline, instruction);
    }
}

void print_push_integer(int value)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tPUSH %d\n", nline, value);
    }
}

void print_push_float(float value)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tPUSH %f\n", nline, value);
    }
}

void print_push_identifier(char symbol)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tPUSH %c\n", nline, symbol);
    }
}

void print_push_string(char* str)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tPUSH %s\n", nline, str);
    }
}

void print_pop_identifier(char symbol)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tPOP %c\n", nline, symbol);
    }
}

void print_push_end_label(int end_label_number)
{
    if (show_quadruples) {
        /* Push the end label number to the stack */
        end_label_stack[++end_label_stack_ptr] = end_label_number;
    }
}

void print_jump_end_label()
{
    if (show_quadruples) {
        /* Get the last end label number from the stack */
        int end_label_number = end_label_stack[end_label_stack_ptr];
        printf("Quadruple(%d) \tJMP EndLabel_%d\n", nline, end_label_number);
    }
}

void print_pop_end_label()
{
    if (end_label_stack_ptr < 0) {
        printf("Quadruple(%d) Error: No end label to add. Segmentation Fault\n", nline);
        return;
    }
    /* Get the last end label number from the stack */
    int end_label_number = end_label_stack[end_label_stack_ptr--];
    if (show_quadruples) {
        printf("Quadruple(%d) EndLabel_%d:\n", nline, end_label_number);
    }
}

void print_jump_false_label(int label_number)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tJF Label_%d\n", nline, label_number);
        /* Push the label number to the stack */
        label_stack[label_stack_ptr++] = label_number;
    }
}

void print_pop_label()
{
    if (label_stack_ptr < 0) {
        printf("Quadruple(%d) Error: No end label to add. Segmentation Fault\n", nline);
        return;
    }
    /* Get the last label number from the stack */
    int label_number = label_stack[--label_stack_ptr];
    if (show_quadruples) {
        printf("Quadruple(%d) Label_%d:\n", nline, label_number);
    }
}

void print_push_last_identifier_stack(char identifier)
{
    if (show_quadruples) {
        /* Add the identifier to the stack */
        last_identifier_stack[++last_identifier_stack_ptr] = identifier;
    }
}

void print_peak_last_identifier_stack()
{
    if (last_identifier_stack_ptr < 0) {
        printf("Quadruple(%d) Error: No last identifier to peak. Segmentation Fault\n", nline);
        return;
    }
    /* Get the last identifier from the stack */
    char identifier = last_identifier_stack[last_identifier_stack_ptr];
    if (show_quadruples) {
        printf("Quadruple(%d) \tPUSH %c\n", nline, identifier);
    }
}

void print_pop_last_identifier_stack()
{
    if (last_identifier_stack_ptr < 0) {
        printf("Quadruple(%d) Error: No last identifier to pop. Segmentation Fault\n", nline);
        return;
    }
    /* Get the last identifier from the stack */
    char identifier = last_identifier_stack[last_identifier_stack_ptr--];
}

void print_push_start_label(int start_label_number)
{
    if (show_quadruples) {
        /* Push the start label number to the stack */
        start_label_stack[++start_label_stack_ptr] = start_label_number;
        printf("Quadruple(%d) StartLabel_%d:\n", nline, start_label_number);
    }
}

void print_jump_start_label()
{
    if (show_quadruples) {
        /* Get the last start label number from the stack */
        int start_label_number = start_label_stack[start_label_stack_ptr];
        printf("Quadruple(%d) \tJMP StartLabel_%d\n", nline, start_label_number);
    }
}

void print_pop_start_label()
{
    if (start_label_stack_ptr < 0) {
        printf("Quadruple(%d) Error: No start label to pop. Segmentation Fault\n", nline);
        return;
    }
    /* Get the last start label number from the stack */
    int start_label_number = start_label_stack[start_label_stack_ptr--];
}

void print_start_enum(char enum_name)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tENUM %c\n", nline, enum_name);
    }
}

void print_end_enum(char enum_name)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tENDENUM %c\n", nline, enum_name);
    }
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
        check_using_variables();

        fclose(yyin);
        write_symbol_table_to_file();
        return 0;
    }
}
