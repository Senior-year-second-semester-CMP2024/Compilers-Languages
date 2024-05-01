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
    

    // ----- Operations -----
    struct NodeType* arithmatic(struct NodeType* op1, struct NodeType*op2, char op);
    struct NodeType* comparison(struct NodeType* op1, struct NodeType*op2, char op);
    struct NodeType* logical(struct NodeType* op1, struct NodeType*op2, char op);
    struct NodeType* bitwise(struct NodeType* op1, struct NodeType*op2, char op);
    // ----- Scope -----
    int scope_id = 1;
    int scopes_count = 1;
    int scopes[100];
    void enter_scope();
    void exit_scope();

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
    // type functions
    struct NodeType* int_node();
    struct NodeType* float_node();
    struct NodeType* bool_node();
    struct NodeType* string_node();
    struct NodeType* enum_node();

    // used to fill enum values
    struct NodeType* enumValue;

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
                | statement_list '{'  statement_list '}'  {;}        
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

declaration : CONSTANT data_type assignment {;}
            | data_type assignment       {;}
            | data_type IDENTIFIER       {;}
            ;

assignment : IDENTIFIER '=' expression {modify_symbol_value($1, $3); $$ = $3;}
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
           | IDENTIFIER                                         {$$ = get_symbol_value($1);}
           ;


// ------------ Conditions ------------------
if_condition             : IF '(' expression  ')' '{'  statement_list '}' else_condition {;}
                        ;
else_condition           : {;}
                        | ELSE_IF '(' expression  ')' '{'  statement_list '}' else_condition {;}
                        | ELSE {;}'{'  statement_list '}'     {;}
                        ;
case                    : CASE expression ':' statement_list                {;}
                        | DEFAULT ':' statement_list                        {;}
                        ;
caseList                : caseList case
                        | case 
                        ;
switch_Case          : SWITCH '(' IDENTIFIER ')' '{'  caseList '}'        {;}
                        ;

case_list : case_list case
          | case
          ;

// ------------ Loops ------------------
while_loop               : WHILE '(' expression ')'  '{'  statement_list '}'                 {;}
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
data_type : BOOL_DATA_TYPE          {;}
          | STRING_DATA_TYPE        {;}
          | INT_DATA_TYPE           {;}
          | FLOAT_DATA_TYPE         {;}
          | VOID_DATA_TYPE          {;}
          ;

literal : INTEGER               {;}
        | FLOAT                 {;}
        | STRING                {;}
        | TRUE_VALUE            {;}
        | FALSE_VALUE           {;}
        ;
// ------------ Function ------------------
function_arguments : data_type IDENTIFIER                                 {;}
                   | data_type IDENTIFIER ',' function_arguments          {;}
                   ;

function_parameters : literal                                          {;}
                    | literal ',' function_parameters                  {;}
                    ;

function_definition : data_type IDENTIFIER '(' function_arguments ')' '{'  statement_list '}'          {;}
                    | data_type IDENTIFIER '(' ')' '{'  statement_list '}'                             {;}
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

// -------------------------------------------------------------
// -------------------- Operation Functions --------------------
// -------------------------------------------------------------
struct NodeType* arithmatic(struct NodeType* op1, struct NodeType*op2, char op){
    struct NodeType* p = malloc(sizeof(struct NodeType));
    if(strcmp(op1->type, "int") == 0 && strcmp(op2->type, "int") == 0){
        p->type = "int";
        switch(op){
            case '+':
                p->value.integer_value = op1->value.integer_value + op2->value.integer_value;
                break;
            case '-':
                p->value.integer_value = op1->value.integer_value - op2->value.integer_value;
                break;
            case '*':
                p->value.integer_value = op1->value.integer_value * op2->value.integer_value;
                break;
            case '/':
                p->value.integer_value = op1->value.integer_value / op2->value.integer_value;
                break;
            case '%':
                p->value.integer_value = op1->value.integer_value % op2->value.integer_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else if(strcmp(op1->type, "float") == 0 && strcmp(op2->type, "float") == 0){
        p->type = "float";
        switch(op){
            case '+':
                p->value.float_value = op1->value.float_value + op2->value.float_value;
                break;
            case '-':
                p->value.float_value = op1->value.float_value - op2->value.float_value;
                break;
            case '*':
                p->value.float_value = op1->value.float_value * op2->value.float_value;
                break;
            case '/':
                p->value.float_value = op1->value.float_value / op2->value.float_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else if (strcmp(op1->type, "int") == 0 && strcmp(op2->type, "float") == 0){
        p->type = "float";
        switch(op){
            case '+':
                p->value.float_value = op1->value.integer_value + op2->value.float_value;
                break;
            case '-':
                p->value.float_value = op1->value.integer_value - op2->value.float_value;
                break;
            case '*':
                p->value.float_value = op1->value.integer_value * op2->value.float_value;
                break;
            case '/':
                p->value.float_value = op1->value.integer_value / op2->value.float_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else if (strcmp(op1->type, "float") == 0 && strcmp(op2->type, "int") == 0){
        p->type = "float";
        switch(op){
            case '+':
                p->value.float_value = op1->value.float_value + op2->value.integer_value;
                break;
            case '-':
                p->value.float_value = op1->value.float_value - op2->value.integer_value;
                break;
            case '*':
                p->value.float_value = op1->value.float_value * op2->value.integer_value;
                break;
            case '/':
                p->value.float_value = op1->value.float_value / op2->value.integer_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else{
        /* printf("Type Error\n"); */ 
    }
    return p;
} 
struct NodeType* comparison(struct NodeType* op1, struct NodeType*op2, char op){
    struct NodeType* p = malloc(sizeof(struct NodeType)); 
    if(strcmp(op1->type, "int") == 0 && strcmp(op2->type, "int") == 0){
        p->type = "bool";
        switch(op){
            case '<':
                p->value.bool_value = op1->value.integer_value < op2->value.integer_value;
                break;
            case '>':
                p->value.bool_value = op1->value.integer_value > op2->value.integer_value;
                break;
            case '<=':
                p->value.bool_value = op1->value.integer_value <= op2->value.integer_value;
                break;
            case '>=':
                p->value.bool_value = op1->value.integer_value >= op2->value.integer_value;
                break;
            case '==':
                p->value.bool_value = op1->value.integer_value == op2->value.integer_value;
                break;
            case '!=':
                p->value.bool_value = op1->value.integer_value != op2->value.integer_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else if(strcmp(op1->type, "float") == 0 && strcmp(op2->type, "float") == 0){
        p->type = "bool";
        switch(op){
            case '<':
                p->value.bool_value = op1->value.float_value < op2->value.float_value;
                break;
            case '>':
                p->value.bool_value = op1->value.float_value > op2->value.float_value;
                break;
            case '<=':
                p->value.bool_value = op1->value.float_value <= op2->value.float_value;
                break;
            case '>=':
                p->value.bool_value = op1->value.float_value >= op2->value.float_value;
                break;
            case '==':
                p->value.bool_value = op1->value.float_value == op2->value.float_value;
                break;
            case '!=':
                p->value.bool_value = op1->value.float_value != op2->value.float_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else{
        /* printf("Type Error\n"); */
    }
    return p;
}




struct NodeType* logical(struct NodeType* op1, struct NodeType*op2, char op){
    struct NodeType* p = malloc(sizeof(struct NodeType));
    if(strcmp(op1->type, "bool") == 0 && strcmp(op2->type, "bool") == 0){
        p->type = "bool";
        switch(op){
            case '|':
                p->value.bool_value = op1->value.bool_value || op2->value.bool_value;
                break;
            case '&':
                p->value.bool_value = op1->value.bool_value && op2->value.bool_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else{
        /* printf("Type Error\n"); */
    }
    return p;
}

struct NodeType* bitwise(struct NodeType* op1, struct NodeType*op2, char op){
    struct NodeType* p = malloc(sizeof(struct NodeType));
    if(strcmp(op1->type, "int") == 0 && strcmp(op2->type, "int") == 0){
        p->type = "int";
        switch(op){
            case '|':
                p->value.integer_value = op1->value.integer_value | op2->value.integer_value;
                break;
            case '&':
                p->value.integer_value = op1->value.integer_value & op2->value.integer_value;
                break;
            case '^':
                p->value.integer_value = op1->value.integer_value ^ op2->value.integer_value;
                break;
            default:
                /* printf("Invalid operator\n"); */
        }
    }
    else{
        /* printf("Type Error\n"); */
    }
    return p;
}
 
// Scope functions
void enter_scope(){
    scopes[scope_index] = scope_id;
    scope_id++;
    scope_index++;
}
void exit_scope(){
    scope_index--;
}
// Type functions
struct NodeType* int_node(){
    struct NodeType* p = malloc(sizeof(struct NodeType));
    p->type = "int";
    return p;
}

struct NodeType* float_node(){
    struct NodeType* p = malloc(sizeof(struct NodeType));
    p->type = "float";
    return p;
}

struct NodeType* bool_node(){
    struct NodeType* p = malloc(sizeof(struct NodeType));
    p->type = "bool";
    return p;
}

struct NodeType* string_node(){
    struct NodeType* p = malloc(sizeof(struct NodeType));
    p->type = "string";
    return p;
}

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
