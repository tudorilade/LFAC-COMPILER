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
    TIP = 259,
    BGIN = 260,
    END = 261,
    ASSIGN = 262,
    NR = 263,
    DECLAR = 264,
    GLOBAL = 265,
    ENDGLOBAL = 266,
    OBJECT = 267,
    ENDOBJECT = 268,
    DECLATTR = 269,
    DECLMETHOD = 270,
    DECLOBJECT = 271,
    FUNC = 272,
    ENDFUNC = 273,
    RTRNARROW = 274,
    FUNCDEF = 275,
    IMPL = 276,
    OF = 277,
    INHERIT = 278,
    IFCLAUSE = 279,
    ELSECLAUSE = 280,
    ELIFCLAUSE = 281,
    WHILECLAUSE = 282,
    FORCLAUSE = 283,
    LESSOP = 284,
    LESSEQOP = 285,
    GREATEROP = 286,
    GREATEREQ = 287,
    NEQOP = 288,
    EQOP = 289,
    OROP = 290,
    ANDOP = 291,
    DIFFOP = 292,
    TRUEP = 293,
    FALSEP = 294,
    COMMENT = 295
  };
#endif
/* Tokens.  */
#define ID 258
#define TIP 259
#define BGIN 260
#define END 261
#define ASSIGN 262
#define NR 263
#define DECLAR 264
#define GLOBAL 265
#define ENDGLOBAL 266
#define OBJECT 267
#define ENDOBJECT 268
#define DECLATTR 269
#define DECLMETHOD 270
#define DECLOBJECT 271
#define FUNC 272
#define ENDFUNC 273
#define RTRNARROW 274
#define FUNCDEF 275
#define IMPL 276
#define OF 277
#define INHERIT 278
#define IFCLAUSE 279
#define ELSECLAUSE 280
#define ELIFCLAUSE 281
#define WHILECLAUSE 282
#define FORCLAUSE 283
#define LESSOP 284
#define LESSEQOP 285
#define GREATEROP 286
#define GREATEREQ 287
#define NEQOP 288
#define EQOP 289
#define OROP 290
#define ANDOP 291
#define DIFFOP 292
#define TRUEP 293
#define FALSEP 294
#define COMMENT 295

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
