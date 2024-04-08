%{
    #include <stdio.h>
    void yyerror(char *);
    int yylex(void);

    int sym[26];
%}

%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/'

%%

program:
        program statement '\n'
        | /* NULL */
        ;

statement:
        expression                      { printf("%d\n", $1); }
        | VARIABLE '=' expression       { sym[$1] = $3; }
        ;

expression:
        INTEGER
        | VARIABLE                      { $$ = sym[$1]; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     { $$ = $1 / $3; }
        | '(' expression ')'            { $$ = $2; }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}


int main(void) {
    yyparse();
}

// extern FILE *yyin; // Declare yyin to be an external variable defined in the generated parser file

// int main(int argc, char *argv[]) {
//     if (argc != 2) {
//         fprintf(stderr, "Usage: %s input_file\n", argv[0]);
//         return 1;
//     }

//     // Open the input file
//     FILE *input_file = fopen(argv[1], "r");
//     if (input_file == NULL) {
//         perror("Error opening input file");
//         return 1;
//     }

//     // Set yyin to point to the input file
//     yyin = input_file;

//     // Call the parser
//     yyparse();

//     // Close the input file
//     fclose(input_file);

//     // Signal that parsing is complete
//     YYACCEPT;

//     return 0;
// }
