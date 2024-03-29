%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

extern FILE *yyin;
extern FILE *yyout;

void pprint(char *token_type);
%}

%option noyywrap

%%
"be"            { return DECLAR; }
"of"            { return OF; }
"impl"          { return IMPL; }
"eval"          { return EVAL; }
"typeof"        { return TYPEOF;} 

"GLOBAL"        { return GLOBAL; }
"END_GLOBAL"    { return ENDGLOBAL; }

"FUNC"          { return FUNC; } 
"END_FUNC"      { return ENDFUNC; }
"def"           { return FUNCDEF; }
"->"            { return RTRNARROW; }

"OBJECT"        { return OBJECT; }
"END_OBJECT"    { return ENDOBJECT; }

"attr"          { return DECLATTR; }
"method"        { return DECLMETHOD; }
"object"        { return DECLOBJECT; }
"inherit"       { return INHERIT; }

"if"            { return IFCLAUSE; }
"else"          { return ELSECLAUSE; }
"elif"          { return ELIFCLAUSE; }
"while"         { return WHILECLAUSE; }
"for"           { return FORCLAUSE; }

"<"             { return LESSOP; }
"<="            { return LESSEQOP; }
">"             { return GREATEROP; }
">="            { return GREATEREQ; }
"!="            { return NEQOP; }
"=="            { return EQOP; }
"or"            { return OROP; }
"and"           { return ANDOP; }
"not"           { return DIFFOP; }
"true"          { return TRUEP; }
"false"         { return FALSEP; }

"BEGIN_PROGRAM" { return BGIN; }
"END_PROGRAM"   { return END; }

"int"|"float"|"string"|"bool"    {
                                            yylval.str_val = strdup(yytext); 
                                            return TIP;
                                        }

[_a-zA-Z][_a-zA-Z0-9]*                  { 
                                            yylval.str_val = strdup(yytext); 
                                            return ID;
                                        }

\".*\"|\".\"|\"[0-9]\"                  { 
                                            yylval.str_val = strdup(yytext); 
                                            return STRING; 
                                        }

(-)?[1-9][0-9]*|0                       { 
                                            yylval.str_val = strdup(yytext); 
                                            return INT; 
                                        }

(-)?[1-9][0-9]*\.[0-9]+|(-)?0*\.[0-9]+  { 
                                            yylval.str_val = strdup(yytext);                                             
                                            return FLOAT; 
                                        }

":="                                    { return ASSIGN; }
[ \t] ;
\n                                      { yylineno++; }

.                                       { return yytext[0]; }
%%