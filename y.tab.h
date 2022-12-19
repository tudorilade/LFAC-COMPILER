/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    INT = 259,
    NR = 260,
    FLOAT = 261,
    BOOL = 262,
    CHAR = 263,
    STRING = 264,
    ARRAY = 265,
    TIP = 266,
    BGIN = 267,
    END = 268,
    ASSIGN = 269,
    DECLAR = 270,
    GLOBAL = 271,
    ENDGLOBAL = 272,
    OBJECT = 273,
    ENDOBJECT = 274,
    DECLATTR = 275,
    DECLMETHOD = 276,
    DECLOBJECT = 277,
    FUNC = 278,
    ENDFUNC = 279,
    RTRNARROW = 280,
    FUNCDEF = 281,
    IMPL = 282,
    OF = 283,
    INHERIT = 284,
    IFCLAUSE = 285,
    ELSECLAUSE = 286,
    ELIFCLAUSE = 287,
    WHILECLAUSE = 288,
    FORCLAUSE = 289,
    LESSOP = 290,
    LESSEQOP = 291,
    GREATEROP = 292,
    GREATEREQ = 293,
    NEQOP = 294,
    EQOP = 295,
    OROP = 296,
    ANDOP = 297,
    DIFFOP = 298,
    TRUEP = 299,
    FALSEP = 300,
    COMMENT = 301
  };
#endif
/* Tokens.  */
#define ID 258
#define INT 259
#define NR 260
#define FLOAT 261
#define BOOL 262
#define CHAR 263
#define STRING 264
#define ARRAY 265
#define TIP 266
#define BGIN 267
#define END 268
#define ASSIGN 269
#define DECLAR 270
#define GLOBAL 271
#define ENDGLOBAL 272
#define OBJECT 273
#define ENDOBJECT 274
#define DECLATTR 275
#define DECLMETHOD 276
#define DECLOBJECT 277
#define FUNC 278
#define ENDFUNC 279
#define RTRNARROW 280
#define FUNCDEF 281
#define IMPL 282
#define OF 283
#define INHERIT 284
#define IFCLAUSE 285
#define ELSECLAUSE 286
#define ELIFCLAUSE 287
#define WHILECLAUSE 288
#define FORCLAUSE 289
#define LESSOP 290
#define LESSEQOP 291
#define GREATEROP 292
#define GREATEREQ 293
#define NEQOP 294
#define EQOP 295
#define OROP 296
#define ANDOP 297
#define DIFFOP 298
#define TRUEP 299
#define FALSEP 300
#define COMMENT 301

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 20 "anaconda.y"

    int int_val;
    double float_val;
    char *bool_val;
    char char_val;
    char *str_val;
    struct symbol_table *s;

#line 158 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
