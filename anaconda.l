%{
#include <stdio.h>
#include "y.tab.h"
//#include "anaconda.h"

extern FILE *yyin;
extern FILE *yyout;
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

"int" {return INTTYPE;}
"float" {return FLOATTYPE;}
"char" {return CHARTYPE;}
"string" {return STRINGTYPE;}
"bool" {return BOOLTYPE;}

[_a-zA-Z][_a-zA-Z0-9]* { 
                            if (lookup_symbol(yytext) == NULL && lookup_symbol_in_scope(yytext, -1) == NULL) 
                                insert_symbol(yytext, 2, -1, -1, -1, -1, -1);
                            yylval.symbol = lookup_symbol(yytext);
                                                    
                            return ID;
                        }
[1-9][0-9]*|0 { yylval.int_val = atoi(yytext); return INT; }
[1-9][0-9]*|0*\.[0-9]+ { yylval.float_val = atof(yytext); return FLOAT; }
\".\" { yylval.char_val = yytext[0]; return CHAR; }
\".*\" { 
            yylval.str_val = malloc(strlen(yytext) + 1); 
            strcpy(yylval.str_val, yytext); 
            return STRING; 
        }
":=" {return ASSIGN;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

%%
