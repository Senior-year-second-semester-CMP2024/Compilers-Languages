%{

#include "spider.tab.h"
#include <stdio.h>
#include <string.h> // For strdup
#include <stdarg.h>

// called by the parser in case of a syntax error. 
void yyerror (char *s);

// called by the parser whenever it needs a token. 
// This is where the lexical analyzer is called. 
int yylex();


int nword=0;
extern int nline=1;
#define SHOW_LOGS 1
void Log(const char* type, const char* value)
{
    if(SHOW_LOGS)
    {
        if (type == "int value")
        {
            printf("Lex(%d) %s: %d\n", nline, type, atoi(value));
            // printf("\033[1;30mLex(%d) %s: %d\033[0m\n", nline, type, atoi(value));
        }
        else if (type == "float value")
        {
            printf("Lex(%d) %s: %f\n", nline, type, atof(value));
            // printf("\033[1;30mLex(%d) %s: %f\033[0m\n", nline, type, atof(value));
        }
        else{
            printf("Lex(%d) %s: %s\n", nline, type, value);
            // printf("\033[1;30mLex(%d) %s: %s\033[0m\n", nline, type, value);

        }

    }
}

%}

%%
"print"				{ return PRINT; }
"const"				{ return CONSTANT; }

"bool"				{ return BOOL_DATA_TYPE; }
"string"			{ return STRING_DATA_TYPE; }
"int"				{ return INT_DATA_TYPE; }
"float"				{ return FLOAT_DATA_TYPE; }
"void"				{ return VOID_DATA_TYPE; }

"if"				{ return IF; }
"else"				{ return ELSE; }
"elif"				{ return ELSE_IF; }

"for"				{ return FOR; }
"while"				{ return WHILE; }
"repeat"			{ return REPEAT; }
"until"				{ return UNTIL; }

"switch"			{ return SWITCH; }
"case"				{ return CASE; }
"default"			{ return DEFAULT; }
"continue"			{ return CONTINUE; }
"break"				{ return BREAK; }
"return"			{ return RETURN; }


"<<"				{ return SHIFT_LEFT; }
">>"				{ return SHIFT_RIGHT; }
"<"				{ return LESS_THAN; }
">"				{ return GREATER_THAN; }
"<="				{ return LESS_THAN_OR_EQUAL; }
">="				{ return GREATER_THAN_OR_EQUAL; }
"=="				{ return EQUAL; }
"!="				{ return NOT_EQUAL; }
"&&"				{ return AND; }
"||"				{ return OR; }
"!"				{ return NOT; }


[;]                 {return yytext[0];} /*Return the character*/

[-+*%&^|~/]			{ return yytext[0]; }  /*mod and division  not working*/

[()={}:,]			{ return yytext[0]; }

true				{ yylval=1; return TRUE_VALUE; }

false		{ yylval=0; return FALSE_VALUE; }

[_a-zA-Z][_a-zA-Z0-9]*		{ yylval = strdup(yytext); return IDENTIFIER; } 

-?[0-9]+			{ yylval = atoi(yytext); return INTEGER; }

-?[0-9]*[.][0-9]+		{ yylval = atof(yytext); return FLOAT; }

\"(\\.|[^\\"])*\"		{ yylval = strdup(yytext); return STRING; }


(\n)+				{nline += yyleng ; nword++; }

[ \r\t]+			{ nword++; /* Ignore whitespace */ }

\/\/.*			{ /* Ignore inline comments "//comment" */ }

\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*\/	{ /* Ignore multiline comments */ }

.				{ yyerror("unexpected character"); }

%%  

//SubRoutines
// called by lex when input is exhausted. Return 1 if you are done
int yywrap (void) {
    printf("#words = %d\t #lines= %d\n", nword, nline-1);
    return 1;
}
