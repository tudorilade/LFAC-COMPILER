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

"int"|"float"|"char"|"string"|"bool"    {
                                            yylval.str_val = (char*)malloc(strlen(yytext) + 1); 
                                            strcpy(yylval.str_val, yytext);  
                                            return TIP;
                                        }

[_a-zA-Z][_a-zA-Z0-9]*                  { 
                                            yylval.str_val = strdup(yytext); 
                                            return ID;
                                        }

[1-9][0-9]*|0                           { 
                                            yylval.int_val = atoi(yytext); 
                                            return INT; 
                                        }

[1-9][0-9]*\.[0-9]+|0*\.[0-9]+          { 
                                            yylval.float_val = atof(yytext); 
                                            return FLOAT; 
                                        }

\".\"                                   { 
                                            yylval.str_val = (char*)malloc(strlen(yytext) + 1); 
                                            strcpy(yylval.str_val, yytext); 
                                            return STRING; 
                                        }

\".*\"                                  { 
                                            yylval.str_val = (char*)malloc(strlen(yytext) + 1); 
                                            strcpy(yylval.str_val, yytext); 
                                            return STRING; 
                                        }

":="                                    { return ASSIGN; }
[ \t] ;
\n                                      { yylineno++; }

.                                       { return yytext[0]; }
%%