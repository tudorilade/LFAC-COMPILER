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
    INTTYPE = 264,
    FLOATTYPE = 265,
    BOOLTYPE = 266,
    CHARTYPE = 267,
    STRINGTYPE = 268,
    BGIN = 269,
    END = 270,
    ASSIGN = 271,
    NR = 272,
    DECLAR = 273,
    GLOBAL = 274,
    ENDGLOBAL = 275,
    OBJECT = 276,
    ENDOBJECT = 277,
    DECLATTR = 278,
    DECLMETHOD = 279,
    DECLOBJECT = 280,
    FUNC = 281,
    ENDFUNC = 282,
    RTRNARROW = 283,
    FUNCDEF = 284,
    IMPL = 285,
    OF = 286,
    INHERIT = 287,
    IFCLAUSE = 288,
    ELSECLAUSE = 289,
    ELIFCLAUSE = 290,
    WHILECLAUSE = 291,
    FORCLAUSE = 292,
    LESSOP = 293,
    LESSEQOP = 294,
    GREATEROP = 295,
    GREATEREQ = 296,
    NEQOP = 297,
    EQOP = 298,
    OROP = 299,
    ANDOP = 300,
    DIFFOP = 301,
    TRUEP = 302,
    FALSEP = 303,
    COMMENT = 304
  };
#endif
/* Tokens.  */
#define ID 258
#define INT 259
#define FLOAT 260
#define BOOL 261
#define CHAR 262
#define STRING 263
#define INTTYPE 264
#define FLOATTYPE 265
#define BOOLTYPE 266
#define CHARTYPE 267
#define STRINGTYPE 268
#define BGIN 269
#define END 270
#define ASSIGN 271
#define NR 272
#define DECLAR 273
#define GLOBAL 274
#define ENDGLOBAL 275
#define OBJECT 276
#define ENDOBJECT 277
#define DECLATTR 278
#define DECLMETHOD 279
#define DECLOBJECT 280
#define FUNC 281
#define ENDFUNC 282
#define RTRNARROW 283
#define FUNCDEF 284
#define IMPL 285
#define OF 286
#define INHERIT 287
#define IFCLAUSE 288
#define ELSECLAUSE 289
#define ELIFCLAUSE 290
#define WHILECLAUSE 291
#define FORCLAUSE 292
#define LESSOP 293
#define LESSEQOP 294
#define GREATEROP 295
#define GREATEREQ 296
#define NEQOP 297
#define EQOP 298
#define OROP 299
#define ANDOP 300
#define DIFFOP 301
#define TRUEP 302
#define FALSEP 303
#define COMMENT 304

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 14 "anaconda.y"

    int int_val;
    double float_val;
    char bool_val[6];
    char char_val;
    char *str_val;
    struct symbol_table *symbol;

#line 164 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
