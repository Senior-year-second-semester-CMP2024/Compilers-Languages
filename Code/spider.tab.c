
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 1 "./spider.y"

    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    #define YY_USER_ACTION yylineno += yyleng;
    #define YYSTYPE int

    void yyerror (char *s); 
    int yylex();
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


    // ----- Symbol Table Variables ------
    int symbol_table_index = 0;

    int scope_index = 1;
    int scope_count = 1;
    int scopes[100];

    // --------- Types -------------
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

    // --------- Operators Functions ----------------
    struct NodeType* perform_arithmetic(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_bitwise_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_logical_operation(struct NodeType* first_operand, struct NodeType* second_operand, char operator);
    struct NodeType* perform_comparison(struct NodeType* first_operand, struct NodeType* second_operand, char* operator);
    struct NodeType* perform_conversion(struct NodeType* term, char *target_type);


    // --------- Types Functions -------------
    struct NodeType* create_int_node();
    struct NodeType* create_float_node();
    struct NodeType* create_bool_node();
    struct NodeType* create_string_node();
    struct NodeType* create_enum_node();

    void check_type(struct NodeType* first_type, struct NodeType* second_type);
    void check_type_3(char* first_type, char* second_type);

    void check_reassignment_constant_variable(char variable_name);
    void check_initialization(char variable_name);
    int check_variable_declaration(char variable_name);
    void check_using_variables();
    void check_constant_expression_if_statement(struct NodeType* expression);
    int check_variable_declaration_as_constant_same_scope(char variable_name);
    void check_same_scope_redeclaration(char variable_name);
    void check_out_of_scope_declaration(char variable_name);

    /* ------------------------------------------------------------------------*/

    // ----- Symbol Table Data Structure ------
    struct symbol {
        char name;
        char *type;
        union {
                int integer_value_symbol;
                float float_value_symbol;
                char* string_value_symbol;
                int bool_value_symbol;
        }value_symbol;
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


    // ---------------
    int counter_arguments = 0;
    int function_pointer = -1;
    int counter_parameters = 0;
    int counter_enum = 0;


    //------------
    struct NodeType* fill_enum_values;

    //------------------
    void display_node_value(struct NodeType* node);



/* Line 189 of yacc.c  */
#line 284 "spider.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


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

/* Line 214 of yacc.c  */
#line 218 "./spider.y"

    int INTEGER_TYPE;
    float FLOAT_TYPE;
    int BOOL_TYPE;
    char* STRING_TYPE;
    void* VOID_TYPE;
    char* DATA_TYPE;

    char* DATA_MODIFIER;
    struct NodeType* NODE_TYPE;



/* Line 214 of yacc.c  */
#line 374 "spider.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 386 "spider.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  55
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1053

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  57
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  61
/* YYNRULES -- Number of rules.  */
#define YYNRULES  128
/* YYNRULES -- Number of states.  */
#define YYNSTATES  253

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   295

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,    37,    23,     2,
      53,    54,    35,    32,    56,    33,     2,    36,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    55,    50,
       2,    18,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    22,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    51,    21,    52,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    19,    20,    24,    25,    26,    27,    28,
      29,    30,    31,    34,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     7,    10,    13,    16,    17,    22,
      24,    25,    26,    33,    37,    40,    41,    44,    45,    48,
      49,    52,    53,    56,    58,    60,    62,    64,    66,    68,
      70,    73,    78,    83,    84,    91,    94,    95,   101,   103,
     107,   109,   112,   114,   117,   120,   124,   128,   132,   136,
     140,   144,   148,   152,   156,   160,   164,   168,   172,   176,
     180,   184,   188,   192,   194,   199,   200,   201,   202,   214,
     215,   216,   220,   221,   222,   229,   230,   231,   232,   244,
     245,   251,   255,   258,   260,   261,   262,   272,   273,   274,
     284,   285,   286,   287,   302,   303,   304,   315,   317,   319,
     321,   323,   325,   327,   329,   331,   333,   335,   337,   341,
     342,   346,   347,   348,   355,   356,   357,   358,   370,   378,
     379,   384,   385,   392,   394,   398,   402,   408,   411
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      58,     0,    -1,    59,    -1,   108,    -1,    59,    58,    -1,
     108,    58,    -1,    68,    50,    -1,    -1,    51,    60,    59,
      52,    -1,    63,    -1,    -1,    -1,    59,    51,    61,    59,
      52,    62,    -1,    59,    68,    50,    -1,    59,    63,    -1,
      -1,    64,    75,    -1,    -1,    65,    89,    -1,    -1,    66,
      92,    -1,    -1,    67,    99,    -1,    95,    -1,    73,    -1,
      74,    -1,    69,    -1,    15,    -1,    14,    -1,    16,    -1,
      16,    74,    -1,     3,    53,    44,    54,    -1,     3,    53,
      74,    54,    -1,    -1,    72,   102,    44,    70,    18,    74,
      -1,   102,    44,    -1,    -1,   102,    44,    71,    18,    74,
      -1,    38,    -1,    44,    18,    74,    -1,   114,    -1,   102,
     117,    -1,   112,    -1,    33,   103,    -1,    34,   103,    -1,
      74,    21,    74,    -1,    74,    23,    74,    -1,    74,    22,
      74,    -1,    74,    32,    74,    -1,    74,    33,    74,    -1,
      74,    35,    74,    -1,    74,    36,    74,    -1,    74,    37,
      74,    -1,    74,    20,    74,    -1,    74,    19,    74,    -1,
      74,    31,    74,    -1,    74,    30,    74,    -1,    74,    27,
      74,    -1,    74,    29,    74,    -1,    74,    26,    74,    -1,
      74,    28,    74,    -1,    74,    25,    74,    -1,    74,    24,
      74,    -1,   103,    -1,    53,   102,    54,   103,    -1,    -1,
      -1,    -1,     4,    53,    74,    76,    54,    51,    77,    59,
      52,    78,    79,    -1,    -1,    -1,     5,    80,    75,    -1,
      -1,    -1,     5,    81,    51,    82,    59,    52,    -1,    -1,
      -1,    -1,     6,    53,    74,    83,    54,    51,    84,    59,
      52,    85,    79,    -1,    -1,    12,    74,    87,    55,    59,
      -1,    13,    55,    59,    -1,    88,    86,    -1,    86,    -1,
      -1,    -1,    11,    53,    44,    54,    90,    51,    91,    88,
      52,    -1,    -1,    -1,     8,    53,    74,    54,    93,    51,
      94,    59,    52,    -1,    -1,    -1,    -1,     7,    53,    73,
      50,    96,    74,    50,    97,    73,    54,    51,    98,    59,
      52,    -1,    -1,    -1,     9,    51,   100,    59,    52,   101,
      10,    53,    74,    54,    -1,    41,    -1,    42,    -1,    39,
      -1,    40,    -1,    43,    -1,    45,    -1,    46,    -1,    47,
      -1,    48,    -1,    49,    -1,    44,    -1,    53,    74,    54,
      -1,    -1,   102,    44,   105,    -1,    -1,    -1,   102,    44,
     106,   107,    56,   104,    -1,    -1,    -1,    -1,   102,    44,
     109,   110,   111,    53,   104,    54,    51,    59,    52,    -1,
     102,    44,    53,    54,    51,    59,    52,    -1,    -1,    44,
     113,    53,    54,    -1,    -1,    17,    44,   115,    51,   116,
      52,    -1,    44,    -1,    44,    18,    74,    -1,   116,    56,
      44,    -1,   116,    56,    44,    18,    74,    -1,    44,    44,
      -1,    44,    44,    18,    74,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   272,   272,   273,   274,   275,   278,   279,   279,   280,
     281,   281,   281,   282,   283,   286,   286,   287,   287,   288,
     288,   289,   289,   290,   293,   294,   295,   296,   297,   298,
     299,   300,   301,   304,   304,   305,   306,   306,   309,   312,
     313,   314,   317,   319,   320,   322,   323,   324,   326,   327,
     328,   329,   330,   332,   333,   335,   336,   338,   339,   340,
     341,   342,   343,   345,   346,   351,   351,   351,   351,   354,
     355,   355,   356,   356,   356,   357,   357,   357,   357,   360,
     360,   361,   364,   365,   368,   368,   368,   372,   372,   372,
     375,   375,   375,   375,   378,   378,   378,   382,   383,   384,
     385,   386,   389,   390,   391,   392,   393,   394,   395,   398,
     398,   399,   399,   399,   406,   406,   406,   406,   407,   410,
     410,   415,   415,   418,   419,   420,   421,   424,   425
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "PRINT", "IF", "ELSE", "ELSE_IF", "FOR",
  "WHILE", "REPEAT", "UNTIL", "SWITCH", "CASE", "DEFAULT", "CONTINUE",
  "BREAK", "RETURN", "ENUM", "'='", "OR", "AND", "'|'", "'^'", "'&'",
  "NOT_EQUAL", "EQUAL", "LESS_THAN_OR_EQUAL", "LESS_THAN",
  "GREATER_THAN_OR_EQUAL", "GREATER_THAN", "SHIFT_RIGHT", "SHIFT_LEFT",
  "'+'", "'-'", "NOT", "'*'", "'/'", "'%'", "CONSTANT",
  "INTEGER_DATA_TYPE", "FLOAT_DATA_TYPE", "BOOL_DATA_TYPE",
  "STRING_DATA_TYPE", "VOID_DATA_TYPE", "IDENTIFIER", "INTEGER", "FLOAT",
  "STRING", "TRUE_VALUE", "FALSE_VALUE", "';'", "'{'", "'}'", "'('", "')'",
  "':'", "','", "$accept", "program", "statement_list", "$@1", "$@2",
  "$@3", "control_statement", "$@4", "$@5", "$@6", "$@7", "statement",
  "declaration", "$@8", "$@9", "data_modifier", "assignment", "expression",
  "if_condition", "$@10", "$@11", "$@12", "else_condition", "$@13", "$@14",
  "$@15", "$@16", "$@17", "$@18", "case", "$@19", "case_list",
  "switch_Case", "$@20", "$@21", "while_loop", "$@22", "$@23", "for_loop",
  "$@24", "$@25", "$@26", "repeat_until_loop", "$@27", "$@28", "data_type",
  "literal", "function_arguments", "$@29", "$@30", "$@31",
  "function_definition", "$@33", "$@34", "$@35", "function_call", "$@36",
  "enum_definition", "$@37", "enum_body", "enum_declaration", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,    61,   273,
     274,   124,    94,    38,   275,   276,   277,   278,   279,   280,
     281,   282,    43,    45,   283,    42,    47,    37,   284,   285,
     286,   287,   288,   289,   290,   291,   292,   293,   294,   295,
      59,   123,   125,    40,    41,    58,    44
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    57,    58,    58,    58,    58,    59,    60,    59,    59,
      61,    62,    59,    59,    59,    64,    63,    65,    63,    66,
      63,    67,    63,    63,    68,    68,    68,    68,    68,    68,
      68,    68,    68,    70,    69,    69,    71,    69,    72,    73,
      73,    73,    74,    74,    74,    74,    74,    74,    74,    74,
      74,    74,    74,    74,    74,    74,    74,    74,    74,    74,
      74,    74,    74,    74,    74,    76,    77,    78,    75,    79,
      80,    79,    81,    82,    79,    83,    84,    85,    79,    87,
      86,    86,    88,    88,    90,    91,    89,    93,    94,    92,
      96,    97,    98,    95,   100,   101,    99,   102,   102,   102,
     102,   102,   103,   103,   103,   103,   103,   103,   103,   105,
     104,   106,   107,   104,   109,   110,   111,   108,   108,   113,
     112,   115,   114,   116,   116,   116,   116,   117,   117
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     1,     2,     2,     2,     0,     4,     1,
       0,     0,     6,     3,     2,     0,     2,     0,     2,     0,
       2,     0,     2,     1,     1,     1,     1,     1,     1,     1,
       2,     4,     4,     0,     6,     2,     0,     5,     1,     3,
       1,     2,     1,     2,     2,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     1,     4,     0,     0,     0,    11,     0,
       0,     3,     0,     0,     6,     0,     0,     0,    11,     0,
       5,     3,     2,     1,     0,     0,     9,     0,     0,     9,
       0,     0,     0,    14,     0,     0,    10,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     3,     0,
       3,     0,     0,     6,     0,     0,     0,    11,     7,     0,
       4,     0,     6,     1,     3,     3,     5,     2,     4
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
      15,     0,     0,    28,    27,    29,     0,     0,     0,    38,
      99,   100,    97,    98,   101,   107,   102,   103,   104,   105,
     106,     7,     0,     0,     2,     9,     0,     0,     0,     0,
       0,    26,     0,    24,    25,    23,     0,    63,     3,    42,
      40,     0,     0,   107,    30,   121,   107,     0,    43,    44,
       0,     0,    15,     0,     0,     1,     7,     4,     9,     0,
       0,    16,     0,    18,     0,    20,     0,    22,     6,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    35,    41,
       5,   107,     0,     0,     0,     0,     0,    39,     0,    15,
       0,   108,     0,    15,     6,     0,     0,     0,    94,    33,
      54,    53,    45,    47,    46,    62,    61,    59,    57,    60,
      58,    56,    55,    48,    49,    50,    51,    52,   127,     0,
       0,   115,    31,    32,    90,     0,     0,   120,    10,     8,
      14,     0,    35,    64,    15,    65,     0,     0,    15,     0,
       0,     0,     0,   116,     0,   123,     0,    13,    11,     0,
      84,    87,    15,     0,   128,    15,    37,     0,     0,     0,
     122,     0,    12,     0,     0,     0,    95,    34,    15,     0,
      91,   124,   125,    66,    85,    88,     0,   118,     0,     0,
       0,     0,    15,     0,    15,     0,   109,     0,     0,   126,
      15,     0,     0,    83,     0,    15,     0,   110,   112,    15,
       0,    67,    79,    15,    86,    82,    89,     0,     0,    15,
      92,    69,     0,    81,    96,     0,   117,    15,    70,     0,
      68,    15,   113,    15,     0,     0,     0,    80,    93,    71,
      73,    75,    15,     0,    15,     0,    74,    76,    15,    15,
      77,    69,    78
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    23,    24,    52,   103,   172,    25,    26,    27,    28,
      29,    30,    31,   149,   130,    32,    33,    34,    61,   159,
     192,   221,   230,   234,   235,   242,   243,   248,   251,   203,
     222,   204,    63,   174,   193,    65,   175,   194,    35,   154,
     190,   227,    67,   148,   186,   100,    37,   189,   207,   208,
     218,    38,   131,   153,   167,    39,    51,    40,    96,   156,
      89
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -51
static const yytype_int16 yypact[] =
{
     852,   -38,   -22,   -51,   -51,    59,     5,   125,   125,   -51,
     -51,   -51,   -51,   -51,   -51,    -2,   -51,   -51,   -51,   -51,
     -51,   -51,    77,    34,   233,   -51,    46,    27,    44,    51,
      11,   -51,   -21,   -51,   999,   -51,    18,   -51,   284,   -51,
     -51,   212,    15,    10,   999,   -51,   -51,    59,   -51,   -51,
      59,    31,   852,   887,    32,   -51,   -51,   -51,   -51,    14,
      35,   -51,    37,   -51,    38,   -51,    36,   -51,   -51,    41,
      59,    59,    59,    59,    59,    59,    59,    59,    59,    59,
      59,    59,    59,    59,    59,    59,    59,    59,    -9,   -51,
     -51,   -41,   907,    76,    45,    52,    50,   999,    43,   331,
      65,   -51,   125,   852,   -51,    59,    69,    59,   -51,   -51,
    1016,  1016,   278,   278,   278,   323,   323,   366,   366,   366,
     366,   100,   100,    -8,    -8,   -51,   -51,   -51,    96,    73,
     111,   -51,   -51,   -51,   -51,    87,    94,   -51,   -51,   -51,
     -51,    89,    -7,   -51,   378,   999,    86,   927,   852,   123,
      59,    92,    59,   -51,    59,   130,   -26,   -51,   -51,    99,
     -51,   -51,   425,    59,   999,   852,   999,    97,   967,    59,
     -51,   110,   -51,   104,   105,   106,   -51,   999,   472,   -21,
     -51,   999,   142,   -51,   -51,   -51,   151,   -51,   121,   112,
      15,    59,   852,    28,   852,   114,   119,   128,   122,   999,
     519,    59,   127,   -51,    -6,   566,    59,   -51,   -51,   852,
     132,   -51,   999,   852,   -51,   -51,   -51,   947,   129,   613,
     -51,    42,   133,   664,   -51,   -21,   -51,   852,   136,   140,
     -51,   852,   -51,   711,    46,   143,    59,   664,   -51,   -51,
     -51,   999,   852,   145,   758,   146,   -51,   -51,   852,   805,
     -51,    42,   -51
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -51,   -14,   -50,   -51,   -51,   -51,   -16,   -51,   -51,   -51,
     -51,   -10,   -51,   -51,   -51,   -51,   -39,    -5,   -34,   -51,
     -51,   -51,   -49,   -51,   -51,   -51,   -51,   -51,   -51,     0,
     -51,   -51,   -51,   -51,   -51,   -51,   -51,   -51,   -51,   -51,
     -51,   -51,   -51,   -51,   -51,     1,    -3,   -20,   -51,   -51,
     -51,   -51,   -51,   -51,   -51,   -51,   -51,   -51,   -51,   -51,
     -51
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -120
static const yytype_int16 yytable[] =
{
      44,    36,    99,    94,    48,    49,   201,   202,    58,   -36,
      57,   -36,  -119,   132,    59,    41,    50,    53,    10,    11,
      12,    13,    14,    54,    90,    36,   170,    85,    86,    87,
     171,    42,     6,    69,    55,   128,    92,   128,    62,    36,
     201,   202,    53,    95,   129,    97,   214,   228,   229,    45,
      60,  -119,    64,   144,    10,    11,    12,    13,    14,    93,
      66,    68,    88,  -119,   104,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   140,    98,   109,   102,   108,   105,   141,
     106,   107,     7,     8,    50,   134,   135,   137,   162,   143,
     145,   136,   147,    43,    16,    17,    18,    19,    20,   142,
       7,     8,    22,   146,   150,   178,    10,    11,    12,    13,
      14,    43,    16,    17,    18,    19,    20,   151,   140,   152,
      22,   128,    83,    84,   141,    85,    86,    87,   155,   157,
     160,   163,   200,   165,   205,   164,   140,   166,   169,   168,
     179,   198,   141,   173,   182,   183,   184,   185,   177,   219,
     191,   195,   140,   223,   181,   196,   197,   206,   141,    46,
      16,    17,    18,    19,    20,  -111,   210,   233,    47,   209,
     188,   237,   213,   220,   140,   225,   199,   -72,   231,   140,
     141,    95,   244,   236,   240,   141,   212,   247,   249,   245,
     239,   217,   252,   140,   215,   232,     0,   140,     0,   141,
       0,     0,     0,   141,     0,     0,     0,   140,     0,     0,
       0,   140,     0,   141,     0,     0,   188,   141,   140,     0,
       0,   241,     0,   140,   141,     0,     1,   -15,     0,   141,
       2,   -19,   -21,     0,   -17,     7,     8,     3,     4,     5,
       6,     0,     0,     0,     0,     0,    91,    16,    17,    18,
      19,    20,     0,     0,     0,    22,     7,     8,     0,     0,
       0,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,     0,    56,     0,    22,     1,   -15,     0,
       0,     2,   -19,   -21,     0,   -17,     0,     0,     3,     4,
       5,     6,    75,    76,    77,    78,    79,    80,    81,    82,
      83,    84,     0,    85,    86,    87,     0,     7,     8,     0,
       0,     0,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,     1,    21,     0,    22,     2,   -19,
     -21,     0,   -17,     0,     0,     3,     4,     5,     6,    77,
      78,    79,    80,    81,    82,    83,    84,     0,    85,    86,
      87,     0,     0,     0,     7,     8,     0,     0,     0,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,     1,   138,   139,    22,     2,   -19,   -21,     0,   -17,
       0,     0,     3,     4,     5,     6,    81,    82,    83,    84,
       0,    85,    86,    87,     0,     0,     0,     0,     0,     0,
       0,     7,     8,     0,     0,     0,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     1,   138,
     158,    22,     2,   -19,   -21,     0,   -17,     0,     0,     3,
       4,     5,     6,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     7,     8,
       0,     0,     0,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     1,   138,   176,    22,     2,
     -19,   -21,     0,   -17,     0,     0,     3,     4,     5,     6,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     7,     8,     0,     0,     0,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     1,   138,   187,    22,     2,   -19,   -21,     0,
     -17,     0,     0,     3,     4,     5,     6,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     7,     8,     0,     0,     0,     9,    10,    11,
      12,    13,    14,    15,    16,    17,    18,    19,    20,     1,
     138,   211,    22,     2,   -19,   -21,     0,   -17,     0,     0,
       3,     4,     5,     6,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     7,
       8,     0,     0,     0,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,     1,   138,   216,    22,
       2,   -19,   -21,     0,   -17,     0,     0,     3,     4,     5,
       6,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     7,     8,     0,     0,
       0,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,     0,   138,   226,    22,     1,   -15,     0,
       0,     2,   -19,   -21,     0,   -17,     0,     0,     3,     4,
       5,     6,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     7,     8,     0,
       0,     0,     9,    10,    11,    12,    13,    14,    15,    16,
      17,    18,    19,    20,     1,   138,     0,    22,     2,   -19,
     -21,     0,   -17,     0,     0,     3,     4,     5,     6,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     7,     8,     0,     0,     0,     9,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
      20,     1,   138,   238,    22,     2,   -19,   -21,     0,   -17,
       0,     0,     3,     4,     5,     6,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     7,     8,     0,     0,     0,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,     1,   138,
     246,    22,     2,   -19,   -21,     0,   -17,     0,     0,     3,
       4,     5,     6,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     7,     8,
       0,     0,     0,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,    20,     1,   138,   250,    22,     2,
     -19,   -21,     0,   -17,     0,     0,     3,     4,     5,     6,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     7,     8,     0,     0,     0,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,     0,    21,     0,    22,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,     0,    85,    86,    87,     0,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,   101,    85,    86,    87,     0,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,   133,    85,    86,    87,     0,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,   161,    85,    86,    87,     0,    70,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      84,   224,    85,    86,    87,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   180,    70,    71,
      72,    73,    74,    75,    76,    77,    78,    79,    80,    81,
      82,    83,    84,     0,    85,    86,    87,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
       0,    85,    86,    87
};

static const yytype_int16 yycheck[] =
{
       5,     0,    52,    42,     7,     8,    12,    13,    24,    18,
      24,    18,    53,    54,    24,    53,    18,    22,    39,    40,
      41,    42,    43,    22,    38,    24,    52,    35,    36,    37,
      56,    53,    17,    32,     0,    44,    41,    44,    11,    38,
      12,    13,    47,    42,    53,    50,    52,     5,     6,    44,
       4,    53,     8,   103,    39,    40,    41,    42,    43,    44,
       9,    50,    44,    53,    50,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    99,    53,    44,    54,    51,    53,    99,
      53,    53,    33,    34,    18,    50,    44,    54,   148,   102,
     105,    51,   107,    44,    45,    46,    47,    48,    49,    44,
      33,    34,    53,    44,    18,   165,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    54,   144,    18,
      53,    44,    32,    33,   144,    35,    36,    37,    44,    50,
      54,    18,   192,    51,   194,   150,   162,   152,    18,   154,
      53,   190,   162,    54,    44,    51,    51,    51,   163,   209,
      18,    10,   178,   213,   169,    44,    54,    53,   178,    44,
      45,    46,    47,    48,    49,    56,    54,   227,    53,    51,
     179,   231,    55,    51,   200,    56,   191,    51,    55,   205,
     200,   190,   242,    53,    51,   205,   201,    51,   248,    54,
     234,   206,   251,   219,   204,   225,    -1,   223,    -1,   219,
      -1,    -1,    -1,   223,    -1,    -1,    -1,   233,    -1,    -1,
      -1,   237,    -1,   233,    -1,    -1,   225,   237,   244,    -1,
      -1,   236,    -1,   249,   244,    -1,     3,     4,    -1,   249,
       7,     8,     9,    -1,    11,    33,    34,    14,    15,    16,
      17,    -1,    -1,    -1,    -1,    -1,    44,    45,    46,    47,
      48,    49,    -1,    -1,    -1,    53,    33,    34,    -1,    -1,
      -1,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    -1,    51,    -1,    53,     3,     4,    -1,
      -1,     7,     8,     9,    -1,    11,    -1,    -1,    14,    15,
      16,    17,    24,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    -1,    35,    36,    37,    -1,    33,    34,    -1,
      -1,    -1,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,     3,    51,    -1,    53,     7,     8,
       9,    -1,    11,    -1,    -1,    14,    15,    16,    17,    26,
      27,    28,    29,    30,    31,    32,    33,    -1,    35,    36,
      37,    -1,    -1,    -1,    33,    34,    -1,    -1,    -1,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,     3,    51,    52,    53,     7,     8,     9,    -1,    11,
      -1,    -1,    14,    15,    16,    17,    30,    31,    32,    33,
      -1,    35,    36,    37,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    33,    34,    -1,    -1,    -1,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,     3,    51,
      52,    53,     7,     8,     9,    -1,    11,    -1,    -1,    14,
      15,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    33,    34,
      -1,    -1,    -1,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,     3,    51,    52,    53,     7,
       8,     9,    -1,    11,    -1,    -1,    14,    15,    16,    17,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    33,    34,    -1,    -1,    -1,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,     3,    51,    52,    53,     7,     8,     9,    -1,
      11,    -1,    -1,    14,    15,    16,    17,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    33,    34,    -1,    -1,    -1,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,     3,
      51,    52,    53,     7,     8,     9,    -1,    11,    -1,    -1,
      14,    15,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    33,
      34,    -1,    -1,    -1,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,     3,    51,    52,    53,
       7,     8,     9,    -1,    11,    -1,    -1,    14,    15,    16,
      17,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    33,    34,    -1,    -1,
      -1,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    -1,    51,    52,    53,     3,     4,    -1,
      -1,     7,     8,     9,    -1,    11,    -1,    -1,    14,    15,
      16,    17,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    33,    34,    -1,
      -1,    -1,    38,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,     3,    51,    -1,    53,     7,     8,
       9,    -1,    11,    -1,    -1,    14,    15,    16,    17,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    33,    34,    -1,    -1,    -1,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,     3,    51,    52,    53,     7,     8,     9,    -1,    11,
      -1,    -1,    14,    15,    16,    17,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    33,    34,    -1,    -1,    -1,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,     3,    51,
      52,    53,     7,     8,     9,    -1,    11,    -1,    -1,    14,
      15,    16,    17,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    33,    34,
      -1,    -1,    -1,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,     3,    51,    52,    53,     7,
       8,     9,    -1,    11,    -1,    -1,    14,    15,    16,    17,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    33,    34,    -1,    -1,    -1,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    -1,    51,    -1,    53,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    -1,    35,    36,    37,    -1,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    54,    35,    36,    37,    -1,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    54,    35,    36,    37,    -1,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    54,    35,    36,    37,    -1,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    54,    35,    36,    37,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    50,    19,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    -1,    35,    36,    37,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      -1,    35,    36,    37
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     7,    14,    15,    16,    17,    33,    34,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    51,    53,    58,    59,    63,    64,    65,    66,    67,
      68,    69,    72,    73,    74,    95,   102,   103,   108,   112,
     114,    53,    53,    44,    74,    44,    44,    53,   103,   103,
      18,   113,    60,    74,   102,     0,    51,    58,    63,    68,
       4,    75,    11,    89,     8,    92,     9,    99,    50,   102,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    35,    36,    37,    44,   117,
      58,    44,    74,    44,    73,   102,   115,    74,    53,    59,
     102,    54,    54,    61,    50,    53,    53,    53,    51,    44,
      74,    74,    74,    74,    74,    74,    74,    74,    74,    74,
      74,    74,    74,    74,    74,    74,    74,    74,    44,    53,
      71,   109,    54,    54,    50,    44,    51,    54,    51,    52,
      63,    68,    44,   103,    59,    74,    44,    74,   100,    70,
      18,    54,    18,   110,    96,    44,   116,    50,    52,    76,
      54,    54,    59,    18,    74,    51,    74,   111,    74,    18,
      52,    56,    62,    54,    90,    93,    52,    74,    59,    53,
      50,    74,    44,    51,    51,    51,   101,    52,   102,   104,
      97,    18,    77,    91,    94,    10,    44,    54,    73,    74,
      59,    12,    13,    86,    88,    59,    53,   105,   106,    51,
      54,    52,    74,    55,    52,    86,    52,    74,   107,    59,
      51,    78,    87,    59,    54,    56,    52,    98,     5,     6,
      79,    55,   104,    59,    80,    81,    53,    59,    52,    75,
      51,    74,    82,    83,    59,    54,    52,    51,    84,    59,
      52,    85,    79
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1455 of yacc.c  */
#line 272 "./spider.y"
    {;;}
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 273 "./spider.y"
    {;;}
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 274 "./spider.y"
    {;;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 275 "./spider.y"
    {;;}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 278 "./spider.y"
    {;;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 279 "./spider.y"
    {enter_scope();;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 279 "./spider.y"
    {exit_scope();;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 280 "./spider.y"
    {;;}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 281 "./spider.y"
    {enter_scope();;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 281 "./spider.y"
    {exit_scope();;}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 281 "./spider.y"
    {;;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 282 "./spider.y"
    {;;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 283 "./spider.y"
    {;;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 286 "./spider.y"
    {print_push_end_label(++end_label_number);;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 286 "./spider.y"
    {print_pop_end_label();;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 287 "./spider.y"
    {print_push_end_label(++end_label_number);;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 287 "./spider.y"
    {print_pop_end_label();;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 288 "./spider.y"
    {print_push_start_label(++start_label_number);;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 288 "./spider.y"
    {print_pop_start_label();;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 289 "./spider.y"
    {print_push_start_label(++start_label_number);;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 289 "./spider.y"
    {print_pop_start_label();;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 290 "./spider.y"
    {print_pop_start_label();;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 293 "./spider.y"
    {;;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 294 "./spider.y"
    {;;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 295 "./spider.y"
    {;;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 296 "./spider.y"
    {print_jump_end_label();;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 297 "./spider.y"
    {;;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 298 "./spider.y"
    {print_function_return();;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 299 "./spider.y"
    {print_function_return();;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 300 "./spider.y"
    {display_node_value(get_symbol_value((yyvsp[(3) - (4)].NODE_TYPE))); mark_variable_used_in_symbol_table((yyvsp[(3) - (4)].NODE_TYPE));;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 301 "./spider.y"
    {display_node_value((yyvsp[(3) - (4)].NODE_TYPE));;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 304 "./spider.y"
    {check_same_scope_redeclaration((yyvsp[(3) - (3)].NODE_TYPE));;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 304 "./spider.y"
    { check_type((yyvsp[(2) - (6)].NODE_TYPE), (yyvsp[(6) - (6)].NODE_TYPE)); add_symbol((yyvsp[(3) - (6)].NODE_TYPE), (yyvsp[(2) - (6)].NODE_TYPE)->type, 1, 0, 0, scopes[scope_index-1]); modify_symbol_value((yyvsp[(3) - (6)].NODE_TYPE), (yyvsp[(6) - (6)].NODE_TYPE)); set_variable_initialized_in_symbol_table((yyvsp[(3) - (6)].NODE_TYPE)); print_pop_identifier((yyvsp[(3) - (6)].NODE_TYPE));;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 305 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(2) - (2)].NODE_TYPE)); add_symbol((yyvsp[(2) - (2)].NODE_TYPE), (yyvsp[(1) - (2)].NODE_TYPE)->type, 0, 0, 0, scopes[scope_index-1]); print_pop_identifier((yyvsp[(2) - (2)].NODE_TYPE)); ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 306 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(2) - (2)].NODE_TYPE));;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 306 "./spider.y"
    {check_type((yyvsp[(1) - (5)].NODE_TYPE), (yyvsp[(5) - (5)].NODE_TYPE)); add_symbol((yyvsp[(2) - (5)].NODE_TYPE), (yyvsp[(1) - (5)].NODE_TYPE)->type, 0, 0, 0, scopes[scope_index-1]); modify_symbol_value((yyvsp[(2) - (5)].NODE_TYPE),(yyvsp[(5) - (5)].NODE_TYPE)); set_variable_initialized_in_symbol_table((yyvsp[(2) - (5)].NODE_TYPE)); print_pop_identifier((yyvsp[(2) - (5)].NODE_TYPE));;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 312 "./spider.y"
    {check_out_of_scope_declaration((yyvsp[(1) - (3)].NODE_TYPE)); check_reassignment_constant_variable((yyvsp[(1) - (3)].NODE_TYPE)); check_type_2((yyvsp[(1) - (3)].NODE_TYPE),(yyvsp[(3) - (3)].NODE_TYPE)); mark_variable_used_in_symbol_table((yyvsp[(1) - (3)].NODE_TYPE)); modify_symbol_value((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE)); (yyval.NODE_TYPE) = (yyvsp[(3) - (3)].NODE_TYPE); set_variable_initialized_in_symbol_table((yyvsp[(1) - (3)].NODE_TYPE)); print_pop_identifier((yyvsp[(1) - (3)].NODE_TYPE));;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 313 "./spider.y"
    {;;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 314 "./spider.y"
    {/*check if redeclared*/;;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 317 "./spider.y"
    {(yyval.NODE_TYPE)->isConstant=0;;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 319 "./spider.y"
    {print_instruction("Negative or Negation"); if((yyvsp[(2) - (2)].NODE_TYPE)->type == "int") {(yyval.NODE_TYPE) = create_int_node(); (yyval.NODE_TYPE)->value_node.integer_value_node = -(yyvsp[(2) - (2)].NODE_TYPE)->value_node.integer_value_node;} else { (yyval.NODE_TYPE) = create_float_node(); (yyval.NODE_TYPE)->value_node.float_value_node = -(yyvsp[(2) - (2)].NODE_TYPE)->value_node.float_value_node;} (yyval.NODE_TYPE)->isConstant = (yyvsp[(2) - (2)].NODE_TYPE)->isConstant;;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 320 "./spider.y"
    {print_instruction("Negation or NOT"); if((yyvsp[(2) - (2)].NODE_TYPE)->type == "bool") {(yyval.NODE_TYPE) = create_bool_node(); (yyval.NODE_TYPE)->value_node.bool_value_node = !(yyvsp[(2) - (2)].NODE_TYPE)->value_node.bool_value_node;} else { if ((yyvsp[(2) - (2)].NODE_TYPE)->value_node.integer_value_node) {(yyval.NODE_TYPE) = create_bool_node(); (yyval.NODE_TYPE)->value_node.bool_value_node = 0;} else {(yyval.NODE_TYPE) = create_bool_node(); (yyval.NODE_TYPE)->value_node.bool_value_node = 1;}} (yyval.NODE_TYPE)->isConstant = (yyvsp[(2) - (2)].NODE_TYPE)->isConstant;;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 322 "./spider.y"
    {print_instruction("Bitwise OR"); (yyval.NODE_TYPE) = perform_bitwise_operation((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '|'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 323 "./spider.y"
    {print_instruction("Bitwise AND"); (yyval.NODE_TYPE) = perform_bitwise_operation((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '&'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 324 "./spider.y"
    {print_instruction("Bitwise XOR"); (yyval.NODE_TYPE) = perform_bitwise_operation((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '^'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 326 "./spider.y"
    {print_instruction("Addition"); (yyval.NODE_TYPE) = perform_arithmetic((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '+'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 327 "./spider.y"
    {print_instruction("Subtraction"); (yyval.NODE_TYPE) = perform_arithmetic((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '-'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 328 "./spider.y"
    {print_instruction("Multiplication"); (yyval.NODE_TYPE) = perform_arithmetic((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '*'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 329 "./spider.y"
    {print_instruction("Division"); (yyval.NODE_TYPE) = perform_arithmetic((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '/'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 330 "./spider.y"
    {print_instruction("Modulus"); (yyval.NODE_TYPE) = perform_arithmetic((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '%'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 332 "./spider.y"
    {print_instruction("Logical AND"); (yyval.NODE_TYPE) = perform_logical_operation((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '&'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 333 "./spider.y"
    {print_instruction("Logical OR"); (yyval.NODE_TYPE) = perform_logical_operation((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '|'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 335 "./spider.y"
    {print_instruction("Shift Left"); perform_bitwise_operation((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '<'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 336 "./spider.y"
    {print_instruction("Shift Right"); perform_bitwise_operation((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), '>'); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 338 "./spider.y"
    {print_instruction("Less Than"); (yyval.NODE_TYPE) = perform_comparison((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), "<"); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 339 "./spider.y"
    {print_instruction("Greater Than"); (yyval.NODE_TYPE) = perform_comparison((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), ">"); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 340 "./spider.y"
    {print_instruction("Less Than or Equal"); (yyval.NODE_TYPE) = perform_comparison((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), "<="); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 341 "./spider.y"
    {print_instruction("Greater Than or Equal"); (yyval.NODE_TYPE) = perform_comparison((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), ">="); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 342 "./spider.y"
    {print_instruction("Equal"); (yyval.NODE_TYPE) = perform_comparison((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), "=="); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 343 "./spider.y"
    {print_instruction("Not Equal"); (yyval.NODE_TYPE) = perform_comparison((yyvsp[(1) - (3)].NODE_TYPE), (yyvsp[(3) - (3)].NODE_TYPE), "!="); (yyval.NODE_TYPE)->isConstant = (((yyvsp[(1) - (3)].NODE_TYPE)->isConstant) && ((yyvsp[(3) - (3)].NODE_TYPE)->isConstant));;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 345 "./spider.y"
    {(yyval.NODE_TYPE) = (yyvsp[(1) - (1)].NODE_TYPE);;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 346 "./spider.y"
    {print_instruction("Casting or Conversion"); (yyval.NODE_TYPE) = perform_conversion((yyvsp[(4) - (4)].NODE_TYPE), (yyvsp[(2) - (4)].NODE_TYPE)->type); (yyval.NODE_TYPE)->isConstant = (yyvsp[(4) - (4)].NODE_TYPE)->isConstant;;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 351 "./spider.y"
    { check_constant_expression_if_statement((yyvsp[(3) - (3)].NODE_TYPE)); print_jump_false_label(++label_number); ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 351 "./spider.y"
    {enter_scope();;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 351 "./spider.y"
    {print_jump_end_label(); print_pop_label(); exit_scope();;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 351 "./spider.y"
    {;;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 354 "./spider.y"
    {;;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 355 "./spider.y"
    {;;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 355 "./spider.y"
    {;;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 356 "./spider.y"
    {;;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 356 "./spider.y"
    {enter_scope();;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 356 "./spider.y"
    {exit_scope();;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 357 "./spider.y"
    { check_constant_expression_if_statement((yyvsp[(3) - (3)].NODE_TYPE)); print_jump_false_label(++label_number); ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 357 "./spider.y"
    {enter_scope();;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 357 "./spider.y"
    {print_jump_end_label(); print_pop_label(); exit_scope();;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 357 "./spider.y"
    {;;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 360 "./spider.y"
    {print_peak_last_identifier_stack(); print_jump_false_label(++label_number); ;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 360 "./spider.y"
    {print_pop_label();;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 361 "./spider.y"
    {;;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 364 "./spider.y"
    {;;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 365 "./spider.y"
    {;;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 368 "./spider.y"
    {print_push_last_identifier_stack((yyvsp[(3) - (4)].NODE_TYPE)); set_variable_initialized_in_symbol_table((yyvsp[(3) - (4)].NODE_TYPE));;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 368 "./spider.y"
    {enter_scope();;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 368 "./spider.y"
    {print_pop_last_identifier_stack(); exit_scope();;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 372 "./spider.y"
    {print_jump_false_label(++label_number);;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 372 "./spider.y"
    {enter_scope();;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 372 "./spider.y"
    {print_jump_start_label(); print_pop_label(); exit_scope();;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 375 "./spider.y"
    {print_push_start_label(++start_label_number);;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 375 "./spider.y"
    {print_jump_false_label(++label_number);;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 375 "./spider.y"
    {enter_scope();;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 375 "./spider.y"
    {print_jump_start_label(); print_pop_label(); print_pop_start_label(); exit_scope();;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 378 "./spider.y"
    {enter_scope();;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 378 "./spider.y"
    {exit_scope();;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 378 "./spider.y"
    {print_jump_false_label(++label_number); print_pop_label();;}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 382 "./spider.y"
    {(yyval.NODE_TYPE) = create_bool_node();;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 383 "./spider.y"
    {(yyval.NODE_TYPE) = create_string_node();;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 384 "./spider.y"
    {(yyval.NODE_TYPE) = create_int_node();;}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 385 "./spider.y"
    {(yyval.NODE_TYPE) = create_float_node();;}
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 386 "./spider.y"
    {;;}
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 389 "./spider.y"
    {print_push_integer((yyvsp[(1) - (1)].INTEGER_TYPE)); (yyval.NODE_TYPE) = create_int_node(); (yyval.NODE_TYPE)->value_node.integer_value_node = (yyvsp[(1) - (1)].INTEGER_TYPE); (yyval.NODE_TYPE)->isConstant = 1;;}
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 390 "./spider.y"
    {print_push_float((yyvsp[(1) - (1)].FLOAT_TYPE)); (yyval.NODE_TYPE) = create_float_node(); (yyval.NODE_TYPE)->value_node.float_value_node = (yyvsp[(1) - (1)].FLOAT_TYPE); (yyval.NODE_TYPE)->isConstant = 1;;}
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 391 "./spider.y"
    {print_push_string((yyvsp[(1) - (1)].STRING_TYPE)); (yyval.NODE_TYPE) = create_string_node(); (yyval.NODE_TYPE)->value_node.string_value_node = strdup((yyvsp[(1) - (1)].STRING_TYPE)); (yyval.NODE_TYPE)->isConstant = 1;;}
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 392 "./spider.y"
    {print_push_integer(1); (yyval.NODE_TYPE) = create_bool_node(); (yyval.NODE_TYPE)->value_node.bool_value_node = 1; (yyval.NODE_TYPE)->isConstant = 1;;}
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 393 "./spider.y"
    {print_push_integer(0); (yyval.NODE_TYPE) = create_bool_node(); (yyval.NODE_TYPE)->value_node.bool_value_node = 0; (yyval.NODE_TYPE)->isConstant = 1;;}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 394 "./spider.y"
    {print_push_identifier((yyvsp[(1) - (1)].NODE_TYPE)); check_out_of_scope_declaration((yyvsp[(1) - (1)].NODE_TYPE)); (yyval.NODE_TYPE) = get_symbol_value((yyvsp[(1) - (1)].NODE_TYPE)); check_initialization((yyvsp[(1) - (1)].NODE_TYPE)); (yyval.NODE_TYPE)->isConstant = check_variable_declaration_as_constant_same_scope((yyvsp[(1) - (1)].NODE_TYPE)); mark_variable_used_in_symbol_table((yyvsp[(1) - (1)].NODE_TYPE));;}
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 395 "./spider.y"
    {(yyval.NODE_TYPE) = (yyvsp[(2) - (3)].NODE_TYPE);;}
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 398 "./spider.y"
    {print_pop_identifier((yyvsp[(2) - (2)].NODE_TYPE));;}
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 398 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(2) - (3)].NODE_TYPE)); add_symbol((yyvsp[(2) - (3)].NODE_TYPE), (yyvsp[(1) - (3)].NODE_TYPE)->type, 0, 0, 0, scopes[scope_index-1]); counter_arguments = symbol_table_index - counter_arguments;;}
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 399 "./spider.y"
    {print_pop_identifier((yyvsp[(2) - (2)].NODE_TYPE));;}
    break;

  case 112:

/* Line 1455 of yacc.c  */
#line 399 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(2) - (3)].NODE_TYPE)); add_symbol((yyvsp[(2) - (3)].NODE_TYPE), (yyvsp[(1) - (3)].NODE_TYPE)->type, 0, 0, 0, scopes[scope_index-1]); ;}
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 406 "./spider.y"
    {print_function_start((yyvsp[(2) - (2)].NODE_TYPE));;}
    break;

  case 115:

/* Line 1455 of yacc.c  */
#line 406 "./spider.y"
    {check_same_scope_redeclaration((yyvsp[(2) - (3)].NODE_TYPE)); add_symbol((yyvsp[(2) - (3)].NODE_TYPE), (yyvsp[(1) - (3)].NODE_TYPE)->type, 0, 0, 0, scopes[scope_index-1]); counter_arguments = symbol_table_index;;}
    break;

  case 116:

/* Line 1455 of yacc.c  */
#line 406 "./spider.y"
    {enter_scope();;}
    break;

  case 117:

/* Line 1455 of yacc.c  */
#line 406 "./spider.y"
    {exit_scope(); print_function_end((yyvsp[(2) - (11)].NODE_TYPE)); modify_symbol_parameter((yyvsp[(2) - (11)].NODE_TYPE), counter_arguments);;}
    break;

  case 118:

/* Line 1455 of yacc.c  */
#line 407 "./spider.y"
    {;;}
    break;

  case 119:

/* Line 1455 of yacc.c  */
#line 410 "./spider.y"
    {counter_parameters = get_symbol_value((yyvsp[(1) - (1)].NODE_TYPE))->value_node.integer_value_node; function_pointer = retrieve_symbol_index((yyvsp[(1) - (1)].NODE_TYPE));;}
    break;

  case 120:

/* Line 1455 of yacc.c  */
#line 410 "./spider.y"
    { check_out_of_scope_declaration((yyvsp[(1) - (4)].NODE_TYPE)); (yyval.NODE_TYPE) = get_symbol_value((yyvsp[(1) - (4)].NODE_TYPE)); print_function_call((yyvsp[(1) - (4)].NODE_TYPE)); if( counter_parameters != 0 ) {log_semantic_error(SEMANTIC_ERROR_TYPE_MISMATCH, (yyvsp[(1) - (4)].NODE_TYPE)); };}
    break;

  case 121:

/* Line 1455 of yacc.c  */
#line 415 "./spider.y"
    {print_start_enum((yyvsp[(2) - (2)].NODE_TYPE)); check_same_scope_redeclaration((yyvsp[(2) - (2)].NODE_TYPE)); add_symbol((yyvsp[(2) - (2)].NODE_TYPE), "enum", 1, 1, 0, scopes[scope_index-1]);;}
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 415 "./spider.y"
    {print_end_enum((yyvsp[(2) - (6)].NODE_TYPE)); counter_enum = 0;;}
    break;

  case 123:

/* Line 1455 of yacc.c  */
#line 418 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(1) - (1)].NODE_TYPE)); add_symbol((yyvsp[(1) - (1)].NODE_TYPE), "int", 1, 1, 0, scopes[scope_index-1]); fill_enum_values->value_node.integer_value_node = 0; modify_symbol_value((yyvsp[(1) - (1)].NODE_TYPE), fill_enum_values); print_push_integer(++counter_enum); print_pop_identifier((yyvsp[(1) - (1)].NODE_TYPE)); ;}
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 419 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(1) - (3)].NODE_TYPE)); check_type(fill_enum_values, (yyvsp[(3) - (3)].NODE_TYPE)); add_symbol((yyvsp[(1) - (3)].NODE_TYPE), "int", 1, 1, 0, scopes[scope_index-1]); fill_enum_values->value_node.integer_value_node = (yyvsp[(3) - (3)].NODE_TYPE)->value_node.integer_value_node; modify_symbol_value((yyvsp[(1) - (3)].NODE_TYPE), fill_enum_values); print_pop_identifier((yyvsp[(1) - (3)].NODE_TYPE)); ;}
    break;

  case 125:

/* Line 1455 of yacc.c  */
#line 420 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(3) - (3)].NODE_TYPE)); add_symbol((yyvsp[(3) - (3)].NODE_TYPE), "int", 1, 1, 0, scopes[scope_index-1]); fill_enum_values->value_node.integer_value_node++; modify_symbol_value((yyvsp[(3) - (3)].NODE_TYPE), fill_enum_values); print_push_integer(++counter_enum); print_pop_identifier((yyvsp[(3) - (3)].NODE_TYPE)); ;}
    break;

  case 126:

/* Line 1455 of yacc.c  */
#line 421 "./spider.y"
    { check_same_scope_redeclaration((yyvsp[(3) - (5)].NODE_TYPE)); check_type(fill_enum_values, (yyvsp[(5) - (5)].NODE_TYPE)); add_symbol((yyvsp[(3) - (5)].NODE_TYPE), "int", 1, 1, 0, scopes[scope_index-1]); fill_enum_values->value_node.integer_value_node = (yyvsp[(5) - (5)].NODE_TYPE)->value_node.integer_value_node; modify_symbol_value((yyvsp[(3) - (5)].NODE_TYPE), fill_enum_values); print_pop_identifier((yyvsp[(3) - (5)].NODE_TYPE)); ;}
    break;

  case 127:

/* Line 1455 of yacc.c  */
#line 424 "./spider.y"
    { check_out_of_scope_declaration((yyvsp[(1) - (2)].NODE_TYPE)); check_type_2((yyvsp[(1) - (2)].NODE_TYPE), create_enum_node()); check_same_scope_redeclaration((yyvsp[(2) - (2)].NODE_TYPE)); add_symbol((yyvsp[(2) - (2)].NODE_TYPE), "int", 0, 0, 0, scopes[scope_index-1]); ;}
    break;

  case 128:

/* Line 1455 of yacc.c  */
#line 425 "./spider.y"
    { check_out_of_scope_declaration((yyvsp[(1) - (4)].NODE_TYPE)); check_type_2((yyvsp[(1) - (4)].NODE_TYPE), create_enum_node()); check_same_scope_redeclaration((yyvsp[(2) - (4)].NODE_TYPE)); add_symbol((yyvsp[(2) - (4)].NODE_TYPE), "int", 0, 1, 0, scopes[scope_index-1]); check_type((yyvsp[(4) - (4)].NODE_TYPE), create_int_node()); modify_symbol_value((yyvsp[(2) - (4)].NODE_TYPE), (yyvsp[(4) - (4)].NODE_TYPE)); print_pop_identifier((yyvsp[(2) - (4)].NODE_TYPE)); ;}
    break;



/* Line 1455 of yacc.c  */
#line 2850 "spider.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 430 "./spider.y"


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
    ptr->type = symbol_table[bucket].type; 
    
    // Check the type of the symbol and assign its value to the node
    if (strcmp(symbol_table[bucket].type, "int") == 0)
        ptr->value_node.integer_value_node = symbol_table[bucket].value_symbol.integer_value_symbol;
    
    else if (strcmp(symbol_table[bucket].type, "float") == 0)
        ptr->value_node.float_value_node = symbol_table[bucket].value_symbol.float_value_symbol;
    
    else if (strcmp(symbol_table[bucket].type, "bool") == 0)
        ptr->value_node.bool_value_node = symbol_table[bucket].value_symbol.bool_value_symbol;
    
    else if (strcmp(symbol_table[bucket].type, "string") == 0)
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
    
    if( strcmp(symbol_table[bucket].type, "int") == 0)
        symbol_table [bucket].value_symbol.integer_value_symbol = new_value->value_node.integer_value_node;
    
    else if( strcmp(symbol_table[bucket].type, "float") == 0)
        symbol_table[bucket].value_symbol.float_value_symbol = new_value->value_node.float_value_node;
    
    else if( strcmp(symbol_table[bucket].type, "bool") == 0)
        symbol_table[bucket].value_symbol.bool_value_symbol = new_value->value_node.bool_value_node;
    
    else if( strcmp(symbol_table[bucket].type, "string") == 0)
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
        printf("%d\n", node->value_node.integer_value_node);
    else if( strcmp(node->type, "float") == 0 )
        printf("%f\n", node->value_node.float_value_node);
    else if( strcmp(node->type, "bool") == 0 )
        printf("%d\n", node->value_node.bool_value_node);
    else if(strcmp( node->type, "string" ) == 0)
        printf("%s\n", node->value_node.string_value_node);
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
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value_node.integer_value_node, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
        }
        
        else if( strcmp(symbol_table[i].type, "float" ) == 0){
            fprintf(filePointer, "Name:%c,Type:%s,Value:%f,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value_node.float_value_node, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
        }
        
        else if( strcmp(symbol_table[i].type, "bool" ) == 0){
            fprintf(filePointer, "Name:%c,Type:%s,Value:%d,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value_node.bool_value_node, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
        }
        
        else if( strcmp(symbol_table[i].type, "string" ) == 0){
            fprintf(filePointer, "Name:%c,Type:%s,Value:%s,Declared:%d,Initialized:%d,Used:%d,Const:%d,Scope:%d\n", 
                        symbol_table[i].name, symbol_table[i].type, symbol_table[i].value_node.string_value_node, symbol_table[i].declared_flag, symbol_table[i].initialized_flag, symbol_table[i].used_flag, symbol_table[i].constant_flag, symbol_table[i].scope);
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


/* ------------------------------------------------------------------------*/

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
void print_function_start(char function_name)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tPROC %s\n", nline, function_name); 
    }
}


/* -------------------------
Prints the end of a function along with its name if the show_quadruples flag is enabled.
------------------------- */
void print_function_end(char function_name)
{
    if (show_quadruples) {
        printf("Quadruple(%d) \tENDPROC %s\n", nline, function_name); 
    }
}

/* -------------------------
Prints the call of a function with its name if the show_quadruples flag is enabled.
------------------------- */
void print_function_call(char function_name)
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


int main( void ) {

    fill_enum_values = create_int_node();
    yyparse();
    check_using_variables();
    print_symbol_table();
    return 0;
}


void yyerror(char *s) {
    printf("Syntax error (%d) Near line %d: %s\n", nline, nline, s);
    fprintf(stderr, "Syntax error (%d) Near line %d: %s\n", nline, nline, s);
    printSymbolTable();
}

