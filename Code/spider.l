%{

#include "spider.tab.h"
#include <stdio.h>
#include <string.h> // For strdup
#include <stdarg.h>
#include <stdlib.h> // For atoi, atof
// called by the parser in case of a syntax error. 
void yyerror (char *s);

// called by the parser whenever it needs a token. 
// This is where the lexical analyzer is called. 
int yylex();


int nword=0;
extern int nline=1;
#define SHOW_LOGS 0
void Log(const char* type, const char* value)
{
    if(SHOW_LOGS)
    {
        if (type == "int value")
        {
            printf("Lex(%d) %s: %d\n", nline, type, atoi(value));
        }
        else if (type == "float value")
        {
            printf("Lex(%d) %s: %f\n", nline, type, atof(value));
        }
        else{
            printf("Lex(%d) %s: %s\n", nline, type, value);
        }

    }
}

%}


%%
"print"				{ Log("Command", yytext); return PRINT; }            /* yytext => matched string */ 
"const"				{ Log("Data Modifier", yytext); return CONSTANT; }

"bool"				{ Log("Data Type", yytext); return BOOL_DATA_TYPE; }
"string"			{ Log("Data Type", yytext); return STRING_DATA_TYPE; }
"int"				{ Log("Data Type", yytext); return INTEGER_DATA_TYPE; }
"float"				{ Log("Data Type", yytext); return FLOAT_DATA_TYPE; }
"void"				{ Log("Data Type", yytext); return VOID_DATA_TYPE; }

"if"				{ Log("Control Flow", yytext); return IF; }
"else"				{ Log("Control Flow", yytext); return ELSE; }
"elif"				{ Log("Control Flow", yytext); return ELSE_IF; }

"for"				{ Log("Control Flow", yytext); return FOR; }
"while"				{ Log("Control Flow", yytext); return WHILE; }
"repeat"			{ Log("Control Flow", yytext); return REPEAT; }
"until"				{ Log("Control Flow", yytext); return UNTIL; }

"switch"			{ Log("Control Flow", yytext); return SWITCH; }
"case"				{ Log("Control Flow", yytext); return CASE; }
"default"			{ Log("Control Flow", yytext); return DEFAULT; }
"continue"			{ Log("Control Flow", yytext); return CONTINUE; }
"break"				{ Log("Control Flow", yytext); return BREAK; }
"return"			{ Log("Control Flow", yytext); return RETURN; }

"enum"              {Log("enum", yytext);return ENUM;}

"<<"				{ Log("BitWise Operator", yytext); return SHIFT_LEFT; }
">>"				{ Log("BitWise Operator", yytext); return SHIFT_RIGHT; }

"<"				    { Log("Comparison Operator", yytext); return LT; }
">"				    { Log("Comparison Operator", yytext); return GT; }
"<="				{ Log("Comparison Operator", yytext); return LEQ; }
">="				{ Log("Comparison Operator", yytext); return GEQ; }
"=="				{ Log("Comparison Operator", yytext); return EQ; }
"!="				{ Log("Comparison Operator", yytext); return NEQ; }

"&&"				{ Log("Logical Operator", yytext); return AND; }
"||"				{ Log("Logical Operator", yytext); return OR; }
"!"				    { Log("Logical Operator", yytext); return NOT; }

[&^~|]              {Log("Bitwise Operator", yytext);return yytext[0];}
           
[;]                 {Log("End Of Statement", "; \n"); return yytext[0];}

[-+*%/]			    { Log("Arithmetic Operator", yytext); return yytext[0]; }

[()={}:,]			{ Log("Punctuators", yytext); return yytext[0]; }

"true"				{ Log("Value", "true"); yylval.BOOL_TYPE = 1; return TRUE_VALUE; }
"false"		        { Log("value", "false"); yylval.BOOL_TYPE = 0; return FALSE_VALUE; }


[_a-zA-Z][_a-zA-Z0-9]*		                    { Log("Identifier", yytext); yylval.INTEGER_TYPE = yytext[0]; return IDENTIFIER; } 

-?[0-9]+			                            { Log("Integer Value", yytext); yylval.INTEGER_TYPE = atoi(yytext); return INTEGER; }
-?[0-9]*[.][0-9]+		                        { Log("Float Value", yytext); yylval.FLOAT_TYPE = atof(yytext); return FLOAT; }
\"(\\.|[^\\"])*\"		                        { Log("String Value", yytext); yylval.STRING_TYPE = strdup(yytext); return STRING;}

\n	    			                            nline++;

[ \r\t] 			                            ;                                /* Ignore White Spaces */

\/\/.*			                                { Log("InLine Comment", yytext); }          /* Ignore Inline Comment */

\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*\/	    { Log("MultiLine Comment", yytext); }       /* Ignore MultiLine Comment */

.                                               {Log("UnExpected Token", yytext); yyerror ("UnExpected Token");} /* Otherwise, Error Message */

%%

// SubRoutines
// called by lex when input is exhausted. Return 1 if you are done
int yywrap (void) {
    return 1;
}
