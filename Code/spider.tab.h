
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PRINT = 258,
     IF = 259,
     ELSE = 260,
     ELSE_IF = 261,
     FOR = 262,
     WHILE = 263,
     REPEAT = 264,
     UNTIL = 265,
     SWITCH = 266,
     CASE = 267,
     DEFAULT = 268,
     CONTINUE = 269,
     BREAK = 270,
     RETURN = 271,
     ENUM = 272,
     OR = 273,
     AND = 274,
     NOT_EQUAL = 275,
     EQUAL = 276,
     LESS_THAN_OR_EQUAL = 277,
     LESS_THAN = 278,
     GREATER_THAN_OR_EQUAL = 279,
     GREATER_THAN = 280,
     SHIFT_RIGHT = 281,
     SHIFT_LEFT = 282,
     NOT = 283,
     CONSTANT = 284,
     INTEGER_DATA_TYPE = 285,
     FLOAT_DATA_TYPE = 286,
     BOOL_DATA_TYPE = 287,
     STRING_DATA_TYPE = 288,
     VOID_DATA_TYPE = 289,
     IDENTIFIER = 290,
     INTEGER = 291,
     FLOAT = 292,
     STRING = 293,
     TRUE_VALUE = 294,
     FALSE_VALUE = 295
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 218 "./spider.y"

    int INTEGER_TYPE;
    float FLOAT_TYPE;
    int BOOL_TYPE;
    char* STRING_TYPE;
    void* VOID_TYPE;
    char* DATA_TYPE;

    char* DATA_MODIFIER;
    struct NodeType* NODE_TYPE;



/* Line 1676 of yacc.c  */
#line 106 "spider.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


