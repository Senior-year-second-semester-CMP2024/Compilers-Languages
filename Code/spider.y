%{
    /* ------------------------- Header Files -----------------------------*/
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    /* ------------------------------------------------------*/
    void yyerror (char *s); 
    int yylex();
    extern int nline;

    /* ------------------------- Semantic Erros -----------------------------*/
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
            write_symbol_table_to_file();
        }
    }

    /* ------------------------- Types Definitions -----------------------------*/
    struct NodeType {
        char *type;
        union {
                int integer_value_node;
                float float_value_node;
                char* string_value_node;
                int bool_value_node;
        }value_node;

        // check if the expression is a constant ==> helps in if statements with constant expressions
        int isConstant; 
    };

    struct symbol {
        char name;
        char *symbol_type;
        union {
                int integer_value_symbol;
                float float_value_symbol;
                char* string_value_symbol;
                int bool_value_symbol;
        }value_symbol;
        int declared_flag, constant_flag, initialized_flag, used_flag, scope;
    };

    /* ------------------------- Display Functions -----------------------------*/
    void display_node_value(struct NodeType* node);

    /* ------------------------- Scope Functions -----------------------------*/
    void enter_scope();
    void exit_scope();

    /* ------------------------- Semantic Functions -----------------------------*/
    void check_using_variables();
    struct NodeType* create_int_node();
    struct NodeType* create_float_node();
    struct NodeType* create_bool_node();
    struct NodeType* create_string_node();
    struct NodeType* create_enum_node();
    void check_initialization(char variable_name);
    int check_variable_declaration(char variable_name);
    void check_type_3(char* first_type, char* second_type);
    void check_same_scope_redeclaration(char variable_name);
    void check_out_of_scope_declaration(char variable_name);
    void check_reassignment_constant_variable(char variable_name);
    void check_constant_expression_if_statement(struct NodeType* expression);
    int check_variable_declaration_as_constant_same_scope(char variable_name);
    void check_type(struct NodeType* first_type, struct NodeType* second_type);

    /* ------------------------- Symbol Table Functions -----------------------------*/
    struct symbol symbol_table [100];
    int retrieve_symbol_index(char symbol_name);
    struct NodeType* get_symbol_value(char symbol); 
    void change_symbol_name(char symbol, char new_name);
    void mark_variable_used_in_symbol_table(char variable_name);
    void modify_symbol_parameter(char symbol, int new_parameter);
    void set_variable_constant_in_symbol_table(char variable_name);
    void mark_variable_declared_in_symbol_table(char variable_name);
    void set_variable_initialized_in_symbol_table(char variable_name);
    void modify_symbol_value(char symbol, struct NodeType* new_value);
    void add_symbol(char name, char* type, int constant_flag, int initialized_flag, int used_flag, int scope);


    /* ------------------------- Code Generation ( Quad ruples ) -----------------------------*/
    #define show_quadruples 1
    #define MAX_STACK_SIZE 100

    void print_function_start(char function_name);
    void print_function_end(char function_name);
    void print_function_call(char function_name);
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

    /* ------------------------- 2-Bitwise Operations -----------------------------*/
    struct NodeType* perform_arithmetic(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_bitwise_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_logical_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_comparison(struct NodeType* first_operand, struct NodeType* second_operand, char* operator);
    struct NodeType* perform_conversion(struct NodeType* term, char *target_type);


    /* ----------------------------------------------------------------------------*/
    int symbol_table_index = 0;

    int scope_index = 1;
    int scope_count = 1;
    int scopes[100];

    int start_label_stack[MAX_STACK_SIZE];
    int start_label_stack_ptr = -1;
    int start_label_number = 0;

    int end_label_stack[MAX_STACK_SIZE];
    int end_label_stack_ptr = -1;
    int end_label_number = 0;

    int label_stack[MAX_STACK_SIZE];
    int label_stack_ptr = -1;
    int label_number = 0;

    char last_identifier_stack[MAX_STACK_SIZE];
    int last_identifier_stack_ptr = -1;

    int counter_arguments = 0;
    int function_pointer = -1;
    int counter_parameters = 0;
    int counter_enum = 0;

    struct NodeType* fill_enum_values;

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
%token EXIT
%token IF ELSE 
%token FOR WHILE REPEAT UNTIL 
%token SWITCH CASE DEFAULT CONTINUE BREAK RETURN 
%token ENUM

// -----Operators-----
%right '=' 
%left AND OR
%left  '|'
%left '^'
%left '&' 
%left EQ NEQ 
%left GT GEQ LT LEQ
%left SHIFT_RIGHT SHIFT_LEFT
%left '+' '-'
%right NOT
%left '*' '/' '%'

// ----- Declarations -----
%token <DATA_MODIFIER> CONSTANT
%token <DATA_TYPE> INTEGER_DATA_TYPE FLOAT_DATA_TYPE BOOL_DATA_TYPE STRING_DATA_TYPE VOID_DATA_TYPE
%token <NODE_TYPE> IDENTIFIER // this is a token IDENTIFIER returned by the lexical analyzer with as NODE_TYPE


// ----- Data Types -----
%token <INTEGER_TYPE> INTEGER
%token <FLOAT_TYPE> FLOAT
%token <STRING_TYPE> STRING
%token <BOOL_TYPE> TRUE_VALUE 
%token <BOOL_TYPE> FALSE_VALUE

// ----- Return Types (NON TERMINALS) -----
%type <VOID_TYPE> program statement_list control_statement statement
%type <VOID_TYPE> if_condition while_loop for_loop repeat_until_loop switch_Case case_list case
%type <VOID_TYPE> code_block function_arguments function_parameters

%type <DATA_MODIFIER> data_modifier
%type <NODE_TYPE> literal expression assignment data_type declaration 
%type <NODE_TYPE> function_call

%%

/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
program : statement_list                            {;}
        | function_definition                       {;} 
        | statement_list program                    {;}  
        | function_definition program               {;}
        ;
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
statement_list  : statement ';'                                                         {;}
                | '{' {enter_scope();} code_block '}' {exit_scope();}
                | control_statement                                                     {;}
                | statement_list '{' {enter_scope();} code_block '}' {exit_scope();}    {;}        
                | statement_list statement ';'                                          {;} 
                | statement_list control_statement                                      {;}
                ;
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
code_block      : statement_list                         {;}
                ;
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
control_statement   :  { print_push_end_label(++end_label_number);}     if_condition        {print_pop_end_label();}
                    |  { print_push_end_label(++end_label_number);}     switch_Case         {print_pop_end_label();}
                    |  { print_push_start_label(++start_label_number);} while_loop          {print_pop_start_label();}
                    |  { print_push_start_label(++start_label_number);} repeat_until_loop   {print_pop_start_label();}
                    |  for_loop {print_pop_start_label();}
                    ;   
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
statement : assignment                   {;}
          | expression                   {;}
          | declaration                  {;}
          | EXIT                         {print_instruction("Exit"); exit(EXIT_SUCCESS);}
          | BREAK                        {print_jump_end_label();}
          | CONTINUE                     {;}
          | RETURN                       {print_function_return();}
          | RETURN expression            {print_function_return();}
          | PRINT '(' IDENTIFIER ')'     {display_node_value(get_symbol_value($3)); mark_variable_used_in_symbol_table($3);}
          | PRINT '(' expression ')'     {display_node_value($3);}
          ;

/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
data_modifier : CONSTANT        {;}
              ;

/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
data_type : BOOL_DATA_TYPE              {$$ = create_bool_node();}
          | STRING_DATA_TYPE            {$$ = create_string_node();}
          | INTEGER_DATA_TYPE           {$$ = create_int_node();}
          | FLOAT_DATA_TYPE             {$$ = create_float_node();}
          | VOID_DATA_TYPE              {;}
          ;

/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
declaration : data_modifier data_type IDENTIFIER    {   check_same_scope_redeclaration($3);} 
                                                        '=' expression 
                                                    {   check_type($2, $6); add_symbol($3, $2->type, 1, 0, 0, scopes[scope_index-1]); modify_symbol_value($3, $6); 
                                                        set_variable_initialized_in_symbol_table($3); print_pop_identifier($3);} 

            | data_type IDENTIFIER                  {   check_same_scope_redeclaration($2); 
                                                        add_symbol($2, $1->type, 0, 0, 0, scopes[scope_index-1]); 
                                                        print_pop_identifier($2); }

            | data_type IDENTIFIER                  {   check_same_scope_redeclaration($2);} 
                                                        '=' expression 
                                                    {   check_type($1, $5); add_symbol($2, $1->type, 0, 0, 0, scopes[scope_index-1]); modify_symbol_value($2,$5); 
                                                        set_variable_initialized_in_symbol_table($2); print_pop_identifier($2);}
            ;
            
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
assignment : IDENTIFIER '=' expression              {   check_out_of_scope_declaration($1); 
                                                        check_reassignment_constant_variable($1); 
                                                        check_type_2($1,$3); /* Checks the type of a symbol against a given node type */
                                                        mark_variable_used_in_symbol_table($1); 
                                                        modify_symbol_value($1, $3); 
                                                        $$ = $3; 
                                                        set_variable_initialized_in_symbol_table($1); 
                                                        print_pop_identifier($1);}


           | enum_definition                        {;} 
           | data_type enum_declaration             {;}
           ;
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
expression : literal                                            {$$ = $1;}
           | function_call                                      {$$->isConstant=0;}
           
           | '-' literal                                        {   print_instruction("Negative or Negation"); 
                                                                    if($2->type == "int") {$$ = create_int_node(); $$->value_node.integer_value_node = -$2->value_node.integer_value_node;} 
                                                                    else if ( $2->type == "float" ) {$$ = create_float_node(); $$->value_node.float_value_node = -$2->value_node.float_value_node;} 
                                                                    else exit(EXIT_FAILURE); $$->isConstant = $2->isConstant; }

           | NOT literal                                        {   print_instruction("Negation or NOT"); 
                                                                    if($2->type == "bool") {$$ = create_bool_node(); $$->value_node.bool_value_node = !$2->value_node.bool_value_node;} 
                                                                    else { if ($2->value_node.integer_value_node) {$$ = create_bool_node(); $$->value_node.bool_value_node = 0;} 
                                                                    else {$$ = create_bool_node(); $$->value_node.bool_value_node = 1;}} $$->isConstant = $2->isConstant;}
           
           | expression '|' expression                          {   print_instruction("Bitwise OR"); 
                                                                    $$ = perform_bitwise_operation($1, $3, '|'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression '&' expression                          {   print_instruction("Bitwise AND"); 
                                                                    $$ = perform_bitwise_operation($1, $3, '&'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression '^' expression                          {   print_instruction("Bitwise XOR"); 
                                                                    $$ = perform_bitwise_operation($1, $3, '^'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}
           
           | expression '+' expression                          {   print_instruction("Addition"); 
                                                                    $$ = perform_arithmetic($1, $3, '+'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression '-' expression                          {   print_instruction("Subtraction"); 
                                                                    $$ = perform_arithmetic($1, $3, '-'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression '*' expression                          {   print_instruction("Multiplication"); 
                                                                    $$ = perform_arithmetic($1, $3, '*'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression '/' expression                          {   print_instruction("Division"); 
                                                                    $$ = perform_arithmetic($1, $3, '/'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression '%' expression                          {   print_instruction("Modulus"); 
                                                                    $$ = perform_arithmetic($1, $3, '%'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}
           
           | expression AND expression                          {   print_instruction("Logical AND"); 
                                                                    $$ = perform_logical_operation($1, $3, '&'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression OR expression                           {   print_instruction("Logical OR"); 
                                                                    $$ = perform_logical_operation($1, $3, '|'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression SHIFT_LEFT expression                   {   print_instruction("Shift Left"); 
                                                                    $$ = perform_bitwise_operation($1, $3, '<'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression SHIFT_RIGHT expression                  {   print_instruction("Shift Right"); 
                                                                    $$ = perform_bitwise_operation($1, $3, '>'); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression EQ expression                           {   print_instruction("EQ");   
                                                                    $$ = perform_comparison($1, $3, "==");  
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression NEQ expression                          {   print_instruction("NEQ");  
                                                                    $$ = perform_comparison($1, $3, "!="); 
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression GT expression                           {   print_instruction("GT");   
                                                                    $$ = perform_comparison($1, $3, ">");   
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression GEQ expression                          {   print_instruction("GEQ");  
                                                                    $$ = perform_comparison($1, $3, ">=");  
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression LT expression                           {   print_instruction("LT");   
                                                                    $$ = perform_comparison($1, $3, "<");   
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}

           | expression LEQ expression                          {   print_instruction("LEQ");  
                                                                    $$ = perform_comparison($1, $3, "<=");  
                                                                    $$->isConstant = (($1->isConstant) && ($3->isConstant));}
           
           | '(' data_type ')' literal                          {   print_instruction("Casting or Conversion"); 
                                                                    $$ = perform_conversion($4, $2->type); 
                                                                    $$->isConstant = $4->isConstant;}
           ;
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
literal : INTEGER               {   print_push_integer($1); 
                                    $$ = create_int_node(); 
                                    $$->value_node.integer_value_node = $1; 
                                    $$->isConstant = 1;}

        | FLOAT                 {   print_push_float($1); 
                                    $$ = create_float_node(); 
                                    $$->value_node.float_value_node = $1; 
                                    $$->isConstant = 1;}

        | STRING                {   print_push_string($1); 
                                    $$ = create_string_node(); 
                                    $$->value_node.string_value_node = strdup($1); 
                                    $$->isConstant = 1;}

        | TRUE_VALUE            {   print_push_integer(1); 
                                    $$ = create_bool_node(); 
                                    $$->value_node.bool_value_node = 1; 
                                    $$->isConstant = 1;}

        | FALSE_VALUE           {   print_push_integer(0); 
                                    $$ = create_bool_node(); 
                                    $$->value_node.bool_value_node = 0; 
                                    $$->isConstant = 1;}

        | IDENTIFIER            {   print_push_identifier($1); 
                                    check_out_of_scope_declaration($1); 
                                    $$ = get_symbol_value($1); 
                                    check_initialization($1); 
                                    $$->isConstant = check_variable_declaration_as_constant_same_scope($1); 
                                    mark_variable_used_in_symbol_table($1);}

        | '(' expression ')'    {$$ = $2;}
        ;

/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
if_condition             :  IF '(' expression { check_constant_expression_if_statement($3); print_jump_false_label(++label_number); } ')' 
                            '{' {enter_scope();} code_block '}' 
                            {print_jump_end_label(); exit_scope(); print_pop_label();} 
                            else_condition {;}
                         ;

else_condition          :                       {;}
                        |   ELSE {;} if_condition {;}
                        |   ELSE {;} 
                            '{' {enter_scope();} code_block '}' {exit_scope();} 
                        ;

case                    :   CASE expression {print_peak_last_identifier_stack(); print_jump_false_label(++label_number); } 
                            ':' statement_list {print_pop_label();}
                        
                        |   DEFAULT ':' statement_list                        {;}
                        ;

case_list               :   case_list case            {;}
                        |   case                      {;}
                        ;

switch_Case          :  SWITCH '(' IDENTIFIER ')' 
                        {print_push_last_identifier_stack($3); set_variable_initialized_in_symbol_table($3);} 
                        '{' {enter_scope();} case_list '}' 
                        {print_pop_last_identifier_stack(); exit_scope();}
                     ;

/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
while_loop               :  WHILE '(' expression ')'  
                            {print_jump_false_label(++label_number);} 
                            '{' {enter_scope();} code_block '}' 
                            {exit_scope(); print_jump_start_label(); print_pop_label();} {;}
                        ;

for_loop                 :  FOR '(' assignment ';' 
                            {print_push_start_label(++start_label_number);} expression ';' {print_jump_false_label(++label_number);} assignment ')' 
                            '{' {enter_scope();} code_block '}' 
                            {print_jump_start_label(); print_pop_label(); exit_scope();}
                        ;

repeat_until_loop        :  REPEAT '{' {enter_scope();} code_block '}' 
                            {exit_scope();} UNTIL '(' expression ')' ';' 
                            {print_jump_false_label(++label_number); print_jump_start_label(); print_pop_label();}
                        ;


/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function_parameters : literal                   {   check_type_3($1->type, symbol_table[++function_pointer].symbol_type); /* Compares two types specified as strings */
                                                    counter_parameters--; };

                    | literal                   {   check_type_3($1->type, symbol_table[++function_pointer].symbol_type); 
                                                    counter_parameters--; } ',' function_parameters
                    ;

function_arguments : data_type IDENTIFIER       {   print_pop_identifier($2);} 
                                                {   check_same_scope_redeclaration($2); 
                                                    add_symbol($2, $1->type, 0, 0, 0, scopes[scope_index-1]); 
                                                    counter_arguments = symbol_table_index - counter_arguments;}

                   | data_type IDENTIFIER       {   print_pop_identifier($2);} 
                                                {   check_same_scope_redeclaration($2); 
                                                    add_symbol($2, $1->type, 0, 0, 0, scopes[scope_index-1]); } ',' function_arguments
                   ;

function_definition : data_type IDENTIFIER      { print_function_start($2);   } 
                                                {   check_same_scope_redeclaration($2); 
                                                    add_symbol($2, $1->type, 0, 0, 0, scopes[scope_index-1]); 
                                                    counter_arguments = symbol_table_index;} 
                                                {enter_scope();} 
                                                function_definition_res '{' code_block '}' 
                                                {exit_scope(); print_function_end($2); modify_symbol_parameter($2, counter_arguments);}
                    ;

function_definition_res : '(' function_arguments ')' 
                        | '('              ')' 
                        ;
                        
function_call : IDENTIFIER                      {   counter_parameters = get_symbol_value($1)->value_node.integer_value_node; function_pointer = retrieve_symbol_index($1);} 
                                                function_call_res 
                                                {   check_out_of_scope_declaration($1); $$ = get_symbol_value($1); print_function_call($1); 
                                                    // if( counter_parameters != 0 ) {log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, $1); }
                                                    }
              ;

function_call_res       : '(' function_parameters ')'               {;}
                        | '('              ')'                      {;}
                        ;
/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
enum_definition :       ENUM IDENTIFIER 
                        {print_start_enum($2); check_same_scope_redeclaration($2); add_symbol($2, "enum", 1, 1, 0, scopes[scope_index-1]);} 
                        '{' enum_body '}' 
                        {print_end_enum($2); counter_enum = 0;}
                ;

enum_body : IDENTIFIER                                      {   check_same_scope_redeclaration($1); 
                                                                add_symbol($1, "int", 1, 1, 0, scopes[scope_index-1]); 
                                                                fill_enum_values->value_node.integer_value_node = 0; 
                                                                modify_symbol_value($1, fill_enum_values); 
                                                                print_push_integer(++counter_enum); 
                                                                print_pop_identifier($1); }

          | IDENTIFIER '=' expression                       {   check_same_scope_redeclaration($1); 
                                                                check_type(fill_enum_values, $3); 
                                                                add_symbol($1, "int", 1, 1, 0, scopes[scope_index-1]); 
                                                                fill_enum_values->value_node.integer_value_node = $3->value_node.integer_value_node; 
                                                                modify_symbol_value($1, fill_enum_values); 
                                                                print_pop_identifier($1); }

          | enum_body ',' IDENTIFIER                        {   check_same_scope_redeclaration($3); 
                                                                add_symbol($3, "int", 1, 1, 0, scopes[scope_index-1]); 
                                                                fill_enum_values->value_node.integer_value_node++; 
                                                                modify_symbol_value($3, fill_enum_values); 
                                                                print_push_integer(++counter_enum); 
                                                                print_pop_identifier($3); }

          | enum_body ',' IDENTIFIER  '=' expression        {   check_same_scope_redeclaration($3); 
                                                                check_type(fill_enum_values, $5); 
                                                                add_symbol($3, "int", 1, 1, 0, scopes[scope_index-1]); 
                                                                fill_enum_values->value_node.integer_value_node = $5->value_node.integer_value_node; 
                                                                modify_symbol_value($3, fill_enum_values); 
                                                                print_pop_identifier($3); }
          ;

enum_declaration : IDENTIFIER IDENTIFIER                    {   check_out_of_scope_declaration($1); 
                                                                check_type_2($1, create_enum_node());   /* Checks the type of a symbol against a given node type */
                                                                check_same_scope_redeclaration($2); 
                                                                add_symbol($2, "int", 0, 0, 0, scopes[scope_index-1]); }

                 | IDENTIFIER IDENTIFIER '=' expression     {   check_out_of_scope_declaration($1); 
                                                                check_type_2($1, create_enum_node()); 
                                                                check_same_scope_redeclaration($2); 
                                                                add_symbol($2, "int", 0, 1, 0, scopes[scope_index-1]); 
                                                                check_type($4, create_int_node()); 
                                                                modify_symbol_value($2, $4); 
                                                                print_pop_identifier($2); }
                 ;
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
    symbol_table[symbol_table_index].symbol_type = symbol_type; 
    symbol_table[symbol_table_index].declared_flag = 1; 
    symbol_table[symbol_table_index].constant_flag = constant_flag; 
    symbol_table[symbol_table_index].initialized_flag = initialized_flag; 
    symbol_table[symbol_table_index].used_flag = used_flag;
    symbol_table[symbol_table_index].scope = symbol_scope; 
    ++symbol_table_index; 
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
    char* sym_type = symbol_table[bucket].symbol_type;
    ptr->type = sym_type; 
    
    // Check the type of the symbol and assign its value to the node
    if (strcmp(sym_type, "int") == 0)
        ptr->value_node.integer_value_node = symbol_table[bucket].value_symbol.integer_value_symbol;
    
    else if (strcmp(sym_type, "float") == 0)
        ptr->value_node.float_value_node = symbol_table[bucket].value_symbol.float_value_symbol;
    
    else if (strcmp(sym_type, "bool") == 0)
        ptr->value_node.bool_value_node = symbol_table[bucket].value_symbol.bool_value_symbol;
    
    else if (strcmp(sym_type, "string") == 0)
        ptr->value_node.string_value_node = symbol_table[bucket].value_symbol.string_value_symbol;
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
    char* sym_type = symbol_table[bucket].symbol_type;
    if( strcmp(sym_type, "int") == 0)
        symbol_table [bucket].value_symbol.integer_value_symbol = new_value->value_node.integer_value_node;
    
    else if( strcmp(sym_type, "float") == 0)
        symbol_table[bucket].value_symbol.float_value_symbol = new_value->value_node.float_value_node;
    
    else if( strcmp(sym_type, "bool") == 0)
        symbol_table[bucket].value_symbol.bool_value_symbol = new_value->value_node.bool_value_node;
    
    else if( strcmp(sym_type, "string") == 0)
        symbol_table[bucket].value_symbol.string_value_symbol = new_value->value_node.string_value_node;
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
    symbol_table [bucket].value_symbol.integer_value_symbol = new_parameter;
}


/* ------------------------------------------------------------------------*/

void display_node_value(struct NodeType* node)
{
    if( strcmp(node->type, "int") == 0 )
        printf("Value: %d\n", node->value_node.integer_value_node);
    else if( strcmp(node->type, "float") == 0 )
        printf("Value: %f\n", node->value_node.float_value_node);
    else if( strcmp(node->type, "bool") == 0 )
        printf("Value: %d\n", node->value_node.bool_value_node);
    else if(strcmp( node->type, "string" ) == 0)
        printf("Value: %s\n", node->value_node.string_value_node);
}

/* ------------------------------------------------------------------------*/

void write_symbol_table_to_file(){

    FILE *filePointer = fopen("output/symbol_table.txt", "w");
    if (filePointer == NULL)
    {
        printf("Error opening file!\n");
        exit(EXIT_FAILURE);
    }

    fprintf(filePointer, "Symbol Table:\n");

    // Iterate through the symbol table and write each entry to the file
    for( int i=0 ; i < symbol_table_index ; i++ ){
        
        switch (symbol_table[i].symbol_type[0]) 
        {
            case 'i':
                fprintf(filePointer, "Name:%c,Type:%s,Value:%d,Declared:%d,Initialized:%d,Used:%d,Constant:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].symbol_type, symbol_table[i].value_symbol.integer_value_symbol, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
                break;
            case 'f':
                fprintf(filePointer, "Name:%c,Type:%s,Value:%f,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].symbol_type, symbol_table[i].value_symbol.float_value_symbol, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
                break;
            case 'b':
                fprintf(filePointer, "Name:%c,Type:%s,Value:%d,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].symbol_type, symbol_table[i].value_symbol.bool_value_symbol, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
                break;
            case 's':
                fprintf(filePointer, "Name:%c,Type:%s,Value:%s,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].symbol_type, symbol_table[i].value_symbol.string_value_symbol, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
                break;
            default:
                fprintf(filePointer, "Error: Invalid type\n");
                break;
        }
    }

    fclose(filePointer); 
}

/* -------------------------Operators Functions-----------------------------*/


/* ------------------------- 1-Arithmetic Operations -----------------------------*/

struct NodeType* perform_arithmetic(struct NodeType* first_operand, struct NodeType* second_operand, char operator) {

    struct NodeType* result_node = malloc(sizeof(struct NodeType));

    if ( strcmp(first_operand->type, "int") == 0 && strcmp(second_operand->type, "int") == 0 ) {

        result_node->type = "int";

        switch (operator) {
            case '+':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node + second_operand->value_node.integer_value_node;
                break;
            case '-':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node - second_operand->value_node.integer_value_node;
                break;
            case '*':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node * second_operand->value_node.integer_value_node;
                break;
            case '/':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node / second_operand->value_node.integer_value_node;
                break;
            case '%':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node % second_operand->value_node.integer_value_node;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } else if ( strcmp(first_operand->type, "float") == 0 && strcmp(second_operand->type, "float") == 0 ) {

        result_node->type = "float";

        switch (operator) {
            case '+':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node + second_operand->value_node.float_value_node;
                break;
            case '-':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node - second_operand->value_node.float_value_node;
                break;
            case '*':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node * second_operand->value_node.float_value_node;
                break;
            case '/':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node / second_operand->value_node.float_value_node;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } else if ( strcmp(first_operand->type, "int") == 0 && strcmp(second_operand->type, "float") == 0 ) {

        result_node->type = "float";

        switch (operator) {
            case '+':
                result_node->value_node.float_value_node = first_operand->value_node.integer_value_node + second_operand->value_node.float_value_node;
                break;
            case '-':
                result_node->value_node.float_value_node = first_operand->value_node.integer_value_node - second_operand->value_node.float_value_node;
                break;
            case '*':
                result_node->value_node.float_value_node = first_operand->value_node.integer_value_node * second_operand->value_node.float_value_node;
                break;
            case '/':
                result_node->value_node.float_value_node = first_operand->value_node.integer_value_node / second_operand->value_node.float_value_node;
                break;
            default:
                log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } else if (strcmp(first_operand->type, "float") == 0 && strcmp(second_operand->type, "int") == 0) {
        
        result_node->type = "float";
        
        switch (operator) {
            case '+':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node + second_operand->value_node.integer_value_node;
                break;
            case '-':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node - second_operand->value_node.integer_value_node;
                break;
            case '*':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node * second_operand->value_node.integer_value_node;
                break;
            case '/':
                result_node->value_node.float_value_node = first_operand->value_node.float_value_node / second_operand->value_node.integer_value_node;
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
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node | second_operand->value_node.integer_value_node;
                break;
            case '&':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node & second_operand->value_node.integer_value_node;
                break;
            case '^':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node ^ second_operand->value_node.integer_value_node;
                break;
            case '<':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node << second_operand->value_node.integer_value_node;
                break;
            case '>':
                result_node->value_node.integer_value_node = first_operand->value_node.integer_value_node >> second_operand->value_node.integer_value_node;
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
                result_node->value_node.bool_value_node = first_operand->value_node.bool_value_node && second_operand->value_node.bool_value_node;
                break;
            case '|':
                result_node->value_node.bool_value_node = first_operand->value_node.bool_value_node || second_operand->value_node.bool_value_node;
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
            result_node->value_node.bool_value_node = first_operand->value_node.float_value_node == second_operand->value_node.float_value_node;
        } 
        else if (strcmp(operator, "!=") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.float_value_node != second_operand->value_node.float_value_node;
        } 
        else if (strcmp(operator, ">") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.float_value_node > second_operand->value_node.float_value_node;
        } 
        else if (strcmp(operator, ">=") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.float_value_node >= second_operand->value_node.float_value_node;
        } 
        else if (strcmp(operator, "<") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.float_value_node < second_operand->value_node.float_value_node;
        } 
        else if (strcmp(operator, "<=") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.float_value_node <= second_operand->value_node.float_value_node;
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, second_operand->type);
        }
    } 
    // ----------- integer values -----------
    else {
        if (strcmp(operator, "==") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.integer_value_node == second_operand->value_node.integer_value_node;
        } 
        else if (strcmp(operator, "!=") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.integer_value_node != second_operand->value_node.integer_value_node;
        } 
        else if (strcmp(operator, ">") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.integer_value_node > second_operand->value_node.integer_value_node;
        } 
        else if (strcmp(operator, ">=") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.integer_value_node >= second_operand->value_node.integer_value_node;
        } 
        else if (strcmp(operator, "<") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.integer_value_node < second_operand->value_node.integer_value_node;
        } 
        else if (strcmp(operator, "<=") == 0) {
            result_node->value_node.bool_value_node = first_operand->value_node.integer_value_node <= second_operand->value_node.integer_value_node;
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
            converted_node->value_node.integer_value_node = (int)term->value_node.float_value_node;
        } 
        /* ------------------------- Bool to Integer -----------------------------*/        
        else if(strcmp(term->type, "bool") == 0) {
            converted_node->value_node.integer_value_node = (int)term->value_node.bool_value_node;
        } 
        /* ------------------------- String to Integer -----------------------------*/        
        else if(strcmp(term->type, "string") == 0) {
            char *str = strdup(term->value_node.string_value_node);
            str++;
            str[strlen(str)-1] = '\0';
            converted_node->value_node.integer_value_node = atoi(str);
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
            converted_node->value_node.float_value_node = (float)term->value_node.integer_value_node;
        } 
        /* ------------------------- Bool to Float -----------------------------*/        
        else if(strcmp(term->type, "bool") == 0) {
            converted_node->value_node.float_value_node = (float)term->value_node.bool_value_node;
        }
        /* ------------------------- String to Float -----------------------------*/         
        else if(strcmp(term->type, "string") == 0) {
            char *str = strdup(term->value_node.string_value_node);
            str++;
            str[strlen(str)-1] = '\0';
            converted_node->value_node.float_value_node = atof(str);
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
            converted_node->value_node.bool_value_node = (int)term->value_node.integer_value_node!=0;
        } 
        /* ------------------------- Bool to Float -----------------------------*/         
        else if(strcmp(term->type, "float") == 0) {
            converted_node->value_node.bool_value_node = (int)term->value_node.float_value_node!=0;
        } 
        /* ------------------------- Bool to String -----------------------------*/         
        else if(strcmp(term->type, "string") == 0) {
            char *str = strdup(term->value_node.string_value_node);
            str++;
            str[strlen(str)-1] = '\0';
            converted_node->value_node.bool_value_node = str[0] != '\0';
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
            sprintf(temp, "%d", term->value_node.integer_value_node);
            converted_node->value_node.string_value_node = strdup(temp);
        } 
        /* ------------------------- String to Float -----------------------------*/         
        else if(strcmp(term->type, "float") == 0) {
            char temp[100];
            sprintf(temp, "%f", term->value_node.float_value_node);
            converted_node->value_node.string_value_node = strdup(temp);
        } 
        /* ------------------------- String to Bool -----------------------------*/         
        else if(strcmp(term->type, "bool") == 0) {
            char temp[100];
            sprintf(temp, "%d", term->value_node.bool_value_node);
            converted_node->value_node.string_value_node = strdup(temp);
        } 
        else {
            log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, term->type);
        }
    } 

    return converted_node;
}


/* ------------------------- Type Checking -----------------------------*/

/* -------------------------
a new node of 'int' &&  initial value = 0 && Returns: A pointer to the node
------------------------- */
struct NodeType* create_int_node() {
    struct NodeType* new_node = malloc(sizeof(struct NodeType));
    new_node->type = "int";
    new_node->value_node.integer_value_node = 0;
    return new_node;
}

struct NodeType* create_float_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "float";
    ptr->value_node.integer_value_node = 0;
    return ptr;
}

struct NodeType* create_bool_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "bool";
    ptr->value_node.integer_value_node = 0;
    return ptr;
}

struct NodeType* create_string_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "string";
    ptr->value_node.integer_value_node = 0;
    return ptr;
}

struct NodeType* create_enum_node() {
    struct NodeType* ptr = malloc(sizeof(struct NodeType));
    ptr->type = "enum";
    ptr->value_node.integer_value_node = 0;
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
                    if(strcmp(symbol_table[i].symbol_type, second_type->type) != 0) 
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
        log_semantic_error(SEMANTIC_WARNING_CONSTANT_IF, expression->value_node.bool_value_node != 0);
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

/* --------------------------------- Quadruples functions ---------------------------------------*/

void print_function_start(char function_name)
{
    if (show_quadruples) {
        printf("Quad(%d)\tPROC %c\n", nline, function_name); 
    }
}

void print_function_end(char function_name)
{
    if (show_quadruples) {
        printf("Quad(%d)\tENDPROC %c\n", nline, function_name); 
    }
}

void print_function_call(char function_name)
{
    if (show_quadruples) {
        printf("Quad(%d)\tCALL %c\n", nline, function_name);
    }
}

void print_function_return()
{
    if (show_quadruples) {
        printf("Quad(%d)\tRET\n",nline);
    }
}

void print_instruction(const char* instruction)
{
    if (show_quadruples) {
        printf("Quad(%d)\t%s\n", nline, instruction);
    }
}

void print_push_integer(int value)
{
    if (show_quadruples) {
        printf("Quad(%d)\tPUSH %d\n", nline, value);
    }
}

void print_push_float(float value)
{
    if (show_quadruples) {
        printf("Quad(%d)\tPUSH %f\n", nline, value);
    }
}

void print_push_identifier(char symbol)
{
    if (show_quadruples) {
        printf("Quad(%d)\tPUSH %c\n", nline, symbol);
    }
}

void print_push_string(char* str)
{
    if (show_quadruples) {
        printf("Quad(%d)\tPUSH %s\n", nline, str);
    }
}

void print_pop_identifier(char symbol)
{
    if (show_quadruples) {
        printf("Quad(%d)\tPOP %c\n", nline, symbol);
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
        printf("Quad(%d)\tJMP EndLabel_%d\n", nline, end_label_number);
    }
}

void print_pop_end_label()
{
    if (end_label_stack_ptr < 0) {
        printf("Error: No end label to add. Segmentation Fault\n");
        return;
    }
    /* Get the last end label number from the stack */
    int end_label_number = end_label_stack[end_label_stack_ptr--];
    if (show_quadruples) {
        printf("Quad(%d) EndLabel_%d:\n", nline, end_label_number);
    }
}

void print_jump_false_label(int label_number)
{
    if (show_quadruples) {
        printf("Quad(%d)\tJF Label_%d\n", nline, label_number);
        /* Push the label number to the stack */
        label_stack[label_stack_ptr++] = label_number;
    }
}

void print_pop_label()
{
    if (label_stack_ptr < 0) {
        printf("Error: No end label to add. Segmentation Fault\n");
        return;
    }
    /* Get the last label number from the stack */
    int label_number = label_stack[--label_stack_ptr];
    if (show_quadruples) {
        printf("Quad(%d) Label_%d:\n", nline, label_number);
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
        printf("Error: No last identifier to peak. Segmentation Fault\n");
        return;
    }
    /* Get the last identifier from the stack */
    char identifier = last_identifier_stack[last_identifier_stack_ptr];
    if (show_quadruples) {
        printf("Quad(%d)\tPUSH %c\n", nline, identifier);
    }
}

void print_pop_last_identifier_stack()
{
    if (last_identifier_stack_ptr < 0) {
        printf("Error: No last identifier to pop. Segmentation Fault\n");
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
        printf("Quad(%d) StartLabel_%d:\n", nline, start_label_number);
    }
}

void print_jump_start_label()
{
    if (show_quadruples) {
        /* Get the last start label number from the stack */
        int start_label_number = start_label_stack[start_label_stack_ptr];
        printf("Quad(%d)\tJMP StartLabel_%d\n", nline, start_label_number);
    }
}

void print_pop_start_label()
{
    if (start_label_stack_ptr < 0) {
        printf("Error: No start label to pop. Segmentation Fault\n");
        return;
    }
    /* Get the last start label number from the stack */
    int start_label_number = start_label_stack[start_label_stack_ptr--];
}

void print_start_enum(char enum_name)
{
    if (show_quadruples) {
        printf("Quad(%d)\tENUM %c\n", nline, enum_name);
    }
}

void print_end_enum(char enum_name)
{
    if (show_quadruples) {
        printf("Quad(%d)\tENDENUM %c\n", nline, enum_name);
    }
}

/* ------------------------------------------------------------------------*/

int main( void ) {

    fill_enum_values = create_int_node();
    yyparse();
    check_using_variables();
    write_symbol_table_to_file();
    return 0;
}

// Declare the file pointer for the error file
FILE *errorFile;
    
void yyerror(char *s) {
    printf("Syntax error (%d) Near line %d: %s\n", nline, nline, s);
    fprintf(stderr, "Syntax error (%d) Near line %d: %s\n", nline, nline, s);
    write_symbol_table_to_file();
    exit(EXIT_FAILURE);
}
