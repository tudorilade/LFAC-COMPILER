%{
#include <stdio.h>
#include "y.tab.h"
#include "anaconda.h"

extern FILE *yyin;
extern FILE *yyout;

void pprint(char *token_type);
void yyerror(char *s);
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

"if" {return IFCLAUSE;}
"else" {return ELSECLAUSE;}
"elif" {return ELIFCLAUSE;}
"while" {return WHILECLAUSE;}
"for" {return FORCLAUSE;}

"<" {return LESSOP;}
"<=" {return LESSEQOP;}
">" {return GREATEROP;}
">=" {return GREATEREQ;}
"!=" {return NEQOP;}
"==" {return EQOP;}
"or" {return OROP;}
"and" {return ANDOP;}
"not" {return DIFFOP;}
"true" {return TRUEP;}
"false" {return FALSEP;}

"BEGIN_PROGRAM" {return BGIN;}
"END_PROGRAM" {return END;}

"int"|"float"|"char"|"string"|"bool" {return TIP;}

[_a-zA-Z][_a-zA-Z0-9]* { 
                            if (lookup_symbol(yytext) == NULL && lookup_symbol_in_scope(yytext, -1) == NULL) 
                                insert_symbol(yytext, 2, -1, -1, -1, -1, -1);
                            yylval.s = lookup_symbol(yytext);
                                
                            return ID;
                        }
":=" {return ASSIGN;}
[1-9][0-9]*|0 { return INT; }
[1-9][0-9]*\.[0-9]+|0*\.[0-9]+ { return FLOAT; }
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
%%
