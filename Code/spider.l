%{

#include "spider.tab.h"
#include <stdio.h>
#include <string.h> // For strdup

// called by the parser in case of a syntax error. 
void yyerror (char *s);

// called by the parser whenever it needs a token. 
// This is where the lexical analyzer is called. 
int yylex();


int line=1;
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

"enum"				{ return ENUM; }

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


[-+*/%&^|~]			{ return yytext[0]; }

[()={}:,;]			{ return yytext[0]; }

True				{ yylval=1; return TRUE_VALUE; }

False				{ yylval=0; return FALSE_VALUE; }


-?[0-9]+			{ yylval = atoi(yytext); return INTEGER; }

-?[0-9]*"."[0-9]+		{ yylval = atof(yytext); return FLOAT; }

[_a-zA-Z][_a-zA-Z0-9]*		{ yylval = strdup(yytext); return IDENTIFIER; } 

\"(\\.|[^\\"])*\"		{ yylval = strdup(yytext); return STRING; }

\n				{ line++; }

[ \r\t]+			{ /* Ignore whitespace */ }

\/\/[^\n]*			{ /* Ignore inline comments "//comment" */ }

\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*\/	{ /* Ignore multiline comments */ }

.				{ yyerror("unexpected character"); }

%%

//SubRoutines
// called by lex when input is exhausted. Return 1 if you are done

int yywrap (void) {
    return 1;
}