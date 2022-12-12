%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%

"be" {return DECLAR;}
"of" {return OF;}
"impl" {return IMPL;}

"GLOBAL" {return GLOBAL;}
"END_GLOBAL" {return ENDGLOBAL;}

"FUNC" {return FUNC;}
"END_FUNC" {return ENDFUNC;}
"def" {return FUNCDEF;}
"->" {return RTRNARROW;}

"OBJECT" {return OBJECT;}
"END_OBJECT" {return ENDOBJECT;}

"attr" {return DECLATTR;}
"method" {return DECLMETHOD;}
"object" {return DECLOBJECT;}
"inherit" {return INHERIT;}

"if" {return IFCLUASE;}
"else" {return ELSECLAUSE;}
"elif" {return ELIFCLAUSE;}
"while" {return WHILECLAUSE;}

"<" {return LESSOP;}
"=<" {return LESSEQOP;}
">" {return GREATEROP;}
">=" {return GREATEREQ;}
"!=" {return NEQOP;}
"==" {return EQOP;}
"or" {return OROP;}
"and" {return ANDOP;}
"not" {return DIFFOP;}

"BEGIN_PROGRAM" {return BGIN;}
"END_PROGRAM" {return END;}

"int"|"float"|"char"|"string" {return TIP;}

[_a-zA-Z][_a-zA-Z0-9]* {return ID;}
":=" {return ASSIGN;}
[0-9]+ {return NR;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 
