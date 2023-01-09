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
    FLOAT = 260,
    BOOL = 261,
    CHAR = 262,
    STRING = 263,
    ARRAY = 264,
    EVAL = 265,
    TYPEOF = 266,
    TIP = 267,
    BGIN = 268,
    END = 269,
    ASSIGN = 270,
    DECLAR = 271,
    GLOBAL = 272,
    ENDGLOBAL = 273,
    OBJECT = 274,
    ENDOBJECT = 275,
    DECLATTR = 276,
    DECLMETHOD = 277,
    DECLOBJECT = 278,
    FUNC = 279,
    ENDFUNC = 280,
    RTRNARROW = 281,
    FUNCDEF = 282,
    IMPL = 283,
    OF = 284,
    INHERIT = 285,
    IFCLAUSE = 286,
    ELSECLAUSE = 287,
    ELIFCLAUSE = 288,
    WHILECLAUSE = 289,
    FORCLAUSE = 290,
    LESSOP = 291,
    LESSEQOP = 292,
    GREATEROP = 293,
    GREATEREQ = 294,
    NEQOP = 295,
    EQOP = 296,
    OROP = 297,
    ANDOP = 298,
    DIFFOP = 299,
    TRUEP = 300,
    FALSEP = 301,
    COMMENT = 302
  };
#endif
/* Tokens.  */
#define ID 258
#define INT 259
#define FLOAT 260
#define BOOL 261
#define CHAR 262
#define STRING 263
#define ARRAY 264
#define EVAL 265
#define TYPEOF 266
#define TIP 267
#define BGIN 268
#define END 269
#define ASSIGN 270
#define DECLAR 271
#define GLOBAL 272
#define ENDGLOBAL 273
#define OBJECT 274
#define ENDOBJECT 275
#define DECLATTR 276
#define DECLMETHOD 277
#define DECLOBJECT 278
#define FUNC 279
#define ENDFUNC 280
#define RTRNARROW 281
#define FUNCDEF 282
#define IMPL 283
#define OF 284
#define INHERIT 285
#define IFCLAUSE 286
#define ELSECLAUSE 287
#define ELIFCLAUSE 288
#define WHILECLAUSE 289
#define FORCLAUSE 290
#define LESSOP 291
#define LESSEQOP 292
#define GREATEROP 293
#define GREATEREQ 294
#define NEQOP 295
#define EQOP 296
#define OROP 297
#define ANDOP 298
#define DIFFOP 299
#define TRUEP 300
#define FALSEP 301
#define COMMENT 302

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 50 "anaconda.y"

    char *str_val;
    struct symbol *s;
    struct exprinfo* exprinf;

#line 157 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
