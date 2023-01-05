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
    TIP = 265,
    BGIN = 266,
    END = 267,
    ASSIGN = 268,
    DECLAR = 269,
    GLOBAL = 270,
    ENDGLOBAL = 271,
    OBJECT = 272,
    ENDOBJECT = 273,
    DECLATTR = 274,
    DECLMETHOD = 275,
    DECLOBJECT = 276,
    FUNC = 277,
    ENDFUNC = 278,
    RTRNARROW = 279,
    FUNCDEF = 280,
    IMPL = 281,
    OF = 282,
    INHERIT = 283,
    IFCLAUSE = 284,
    ELSECLAUSE = 285,
    ELIFCLAUSE = 286,
    WHILECLAUSE = 287,
    FORCLAUSE = 288,
    LESSOP = 289,
    LESSEQOP = 290,
    GREATEROP = 291,
    GREATEREQ = 292,
    NEQOP = 293,
    EQOP = 294,
    OROP = 295,
    ANDOP = 296,
    DIFFOP = 297,
    TRUEP = 298,
    FALSEP = 299,
    COMMENT = 300
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
#define TIP 265
#define BGIN 266
#define END 267
#define ASSIGN 268
#define DECLAR 269
#define GLOBAL 270
#define ENDGLOBAL 271
#define OBJECT 272
#define ENDOBJECT 273
#define DECLATTR 274
#define DECLMETHOD 275
#define DECLOBJECT 276
#define FUNC 277
#define ENDFUNC 278
#define RTRNARROW 279
#define FUNCDEF 280
#define IMPL 281
#define OF 282
#define INHERIT 283
#define IFCLAUSE 284
#define ELSECLAUSE 285
#define ELIFCLAUSE 286
#define WHILECLAUSE 287
#define FORCLAUSE 288
#define LESSOP 289
#define LESSEQOP 290
#define GREATEROP 291
#define GREATEREQ 292
#define NEQOP 293
#define EQOP 294
#define OROP 295
#define ANDOP 296
#define DIFFOP 297
#define TRUEP 298
#define FALSEP 299
#define COMMENT 300

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 43 "anaconda.y"

    int int_val; 
    double float_val;
    char *bool_val;
    char char_val;
    char *str_val;
    struct symbol *s;

#line 156 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
