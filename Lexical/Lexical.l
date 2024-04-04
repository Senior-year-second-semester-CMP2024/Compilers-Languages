// Definitions
%{

// "y.tab.h" is automatically generated from the .y file.  
// definitions for tokens are in y.tab.h
#include "y.tab.h"

// called by the parser in case of a syntax error. 
void yyerror (char *s);

// called by the parser whenever it needs a token. 
// This is where the lexical analyzer is called. 
int yylex();

#include <stdio.h>

int line=1;
%}

// ===========================================================================

%%
// Rules
//NOTE: Order is important as if a string matches more than 1 Regular Expression ==> select first one

"print"				               {return PRINT;}

"const"                            {return CONSTANT;}

"bool"                             {return BOOL_DATA_TYPE;} 
"string"                           {return STRING_DATA_TYPE;}
"int"                              {return INT_DATA_TYPE;}
"float"                            {return FLOAT_DATA_TYPE;}
"void"                             {return VOID_DATA_TYPE;}

"if"				               {return IF;} 
"else"				               {return ELSE;}
"elif"				               {return ELSE_IF;}

"for"				               {return FOR;}
"while"				               {return WHILE;}
"repeat"				           {return REPEAT;}
"until"				               {return UNTIL;}
"switch"				           {return SWITCH;}
"case"				               {return CASE;}
"default"				           {return DEFAULT;}

"continue"				           {return CONTINUE;}
"break"				               {return BREAK;}

"return"				           {return RETURN;}

"enum"                             {return ENUM;}

"<<"                               {return SHIFT_LEFT;} 
">>"                               {return SHIFT_RIGHT;}

"<"                                {return LESS_THAN;}
">"                                {return GREATER_THAN;}
"<="                               {return LESS_THAN_OR_EQUAL;}
">="                               {return GREATER_THAN_OR_EQUAL;}
"=="                               {return EQUAL;}
"!="                               {return NOT_EQUAL;}

// bitwise Operations
[&^~|]                             {return yytext[0];}


"&&"                               {return AND;}
"||"                               {return OR;}
"!"                                {return NOT;}

// Arithmtic Operations
[/+*%-]                            {return yytext[0];}

// punctuators
[()={}:,]                          {return yytext[0];}

// End of statment
[;]                                {return yytext[0];}

// Boolean Values
True                               {yylval=1; return TRUE_VALUE;}
False                              {yylval=0; return FALSE_VALUE;}


[_a-zA-Z][_a-zA-Z0-9]*             {yylval = yytext[0]; return IDENTIFIER;}

\-?[0-9]+                           {yylval = atoi(yytext); return INTEGER;}
\-?[0-9]*"."[0-9]+                  {yylval = atof(yytext); return FLOAT;}

\"[^\"]*\" 			                {yylval = strdup(yytext); return STRING; }


// Ignore the new line
{\n}                                line++; 

// Ignore white space
[ \r\t]                             ;

// Ignore Comment
{INLINE_COMMENT}                    ; 

// Ignore Multiple Comments
\/\*.*\*\/                          ;

// Anything else is error
.                                   {yyerror ("unexpected character");}

// ===========================================================================
%%

//SubRoutines
// called by lex when input is exhausted. Return 1 if you are done

int yywrap (void) {
    return 1;
}