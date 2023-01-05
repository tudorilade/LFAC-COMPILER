%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "anaconda.h"

extern FILE* yyin;
extern FILE* yyout;
extern int yylineno;
extern char* yytext;
extern int yylex();
extern int yyerror();

void insertSymbolInt(char *name, int valueInt);
void insertSymbolFloat(char *name, double valueFloat);
void insertSymbolString(char *name, char *valueString);
void insertSymbolBool(char *name, char *valueBool);
void insertSymbolChar(char *name, char *valueChar);
void insertSymbolArray(char *name, char *type, int arraySize);
void insertSymbolFunction(char *name, char *type, int numberOfParameters);
void insertSymbolObject(char *names);
struct symbol *updateSymbol(char *name, int valueInt, double valueFloat, char *valueString);

struct symbol *lookup_symbol(char *name);
void initSymbolTable();
void print_symbol_table(FILE *file);

void notDefinedErr(char *name);             //function that prints an error message when a symbol is not defined
void prevDefinedErr(char *name);            //function that prints an error message when a symbol is already defined
void notVarErr(char *name);                 //function that prints an error message when a symbol is not a variable
void notIntErr(char *name);                 //function that prints an error message when a symbol is not an integer
void notArrErr(char *name);                 //function that prints an error message when a symbol is not an array
void notFuncErr(char *name);                //function that prints an error message when a symbol is not a function
void notObjErr(char *name);                 //function that prints an error message when a symbol is not an object
void typeErr(char *t1, char *t2);           //function that prints an error message when a symbol has a different type
void divByZeroErr();                        //function that prints an error message when a division by zero is attempted

int countpf;
char const_type[100];
struct symbol *sym;
%}

%union {
    int int_val; 
    double float_val;
    char *bool_val;
    char char_val;
    char *str_val;
    struct symbol *s;
}

%token <str_val> ID
%token <int_val> INT 
%token <float_val> FLOAT
%token <bool_val> BOOL
%token <char_val> CHAR
%token <str_val> STRING
%token ARRAY
%token <str_val> TIP 
%token BGIN END ASSIGN DECLAR
%token GLOBAL ENDGLOBAL 
%token <s> OBJECT ENDOBJECT DECLATTR DECLMETHOD DECLOBJECT
%token <s> FUNC 
%token ENDFUNC RTRNARROW FUNCDEF 
%token IMPL OF INHERIT
%token IFCLAUSE ELSECLAUSE ELIFCLAUSE WHILECLAUSE FORCLAUSE
%token LESSOP LESSEQOP GREATEROP GREATEREQ NEQOP EQOP OROP
%token <str_val> ANDOP DIFFOP TRUEP FALSEP COMMENT

%type <s> param body_func object primitives var assigments arg expr

%left '+' '-'
%left '*' '/'
%right DIFFOP
%left LESSOP LESSEQOP GREATEROP GREATEREQ EQOP OROP ANDOP NEQOP
%start progr 
%%
progr: global func object_declar bloc_prog  { printf("Syntactically correct program!\n"); }
     ;

/* GLOBAL VAR SECTION */
global : GLOBAL global_declar ENDGLOBAL
       ;
     
global_declar : declaratie ';'
	         | global_declar declaratie ';'
	         ;

declaratie : DECLAR params 
           ;

params : param
       | params ',' param
       ;

param : ID ':' TIP              { 
                                    if (lookup_symbol($1) != NULL) {
                                        prevDefinedErr($1);
                                    } else {
                                        if (strcmp($3, "int") == 0) {
                                            insertSymbolInt($1, 0);
                                        } else if (strcmp($3, "float") == 0) {
                                            insertSymbolFloat($1, 0.0);
                                        } else if (strcmp($3, "char") == 0) {
                                            insertSymbolChar($1, "");
                                        } else if (strcmp($3, "string") == 0) {
                                            insertSymbolString($1, "");
                                        } else if (strcmp($3, "bool") == 0) {
                                            insertSymbolBool($1, "");
                                        }
                                    }
                                }
      | ID '[' INT ']' ':' TIP  { 
                                    if (lookup_symbol($1) != NULL) {
                                        prevDefinedErr($1);
                                    } else {
                                        insertSymbolArray($1, $6, $3);
                                    }
                                }
      ;

/* FUNC SECTION */
func : FUNC func_declar ENDFUNC
     ;

func_declar : fun ';'
            | func_declar fun ';'
            ;

fun : FUNCDEF body_func
    ;

body_func : ID '(' func_params ')' RTRNARROW TIP body_instr {   
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insertSymbolFunction($1, $6, countpf);
                                                                }
                                                                countpf = 0;
                                                            }
          | ID '(' ')' RTRNARROW TIP body_instr             {              
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insertSymbolFunction($1, $5, 0);
                                                                }
                                                            }
          ;

func_params : func_param                                    { countpf++; }
            | func_params ',' func_param                    { countpf++; }
            ;

func_param : ID ':' TIP                                     {   // daca exista simbolul in tabel, ii putem face atribuiri, nu e o DECLAR deci nu ne intereseaza sa zicem ca a fost deja definit
                                                                if (lookup_symbol($1) != NULL) {
                                                                    if (strcmp($3, "int") == 0) {
                                                                        insertSymbolInt($1, 0);
                                                                    } else if (strcmp($3, "float") == 0) {
                                                                        insertSymbolFloat($1, 0.0);
                                                                    } else if (strcmp($3, "char") == 0) {
                                                                        insertSymbolChar($1, "");
                                                                    } else if (strcmp($3, "string") == 0) {
                                                                        insertSymbolString($1, "");
                                                                    } else if (strcmp($3, "bool") == 0) {
                                                                        insertSymbolBool($1, "");
                                                                    }
                                                                }
                                                            }
           ;

body_instr : body_if
           | '{' '}'
           ;

/* OBJECT SECTION */
object_declar : OBJECT declar_objects ENDOBJECT 
              ;

declar_objects : 
               | objects impl_methods declar_objects
               ;

objects : object ';'
        | objects object ';'
        ;

object : DECLOBJECT ID '[' inside_obj ']'                   {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insertSymbolObject($2);
                                                                }   
                                                            }
       | DECLOBJECT ID '[' ']'                              {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insertSymbolObject($2);
                                                                }   
                                                            }
       | DECLOBJECT ID ':' INHERIT ID '[' inside_obj ']'    {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insertSymbolObject($2);
                                                                }   

                                                                if (lookup_symbol($5) == NULL) {
                                                                    notDefinedErr($5);
                                                                } else {
                                                                    if (lookup_symbol($5)->dataType != 3) {
                                                                        notObjErr($5);
                                                                    } else {
                                                                        insertSymbolObject($5);
                                                                    }
                                                                }
                                                            }
       | DECLOBJECT ID ':' INHERIT ID  '[' ']'              {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insertSymbolObject($2);
                                                                }   

                                                                if (lookup_symbol($5) == NULL) {
                                                                    notDefinedErr($5);
                                                                } else {
                                                                    if (lookup_symbol($5)->dataType != 3) {
                                                                        notObjErr($5);
                                                                    } else {
                                                                        insertSymbolObject($5);
                                                                    }
                                                                }  
                                                            }
       ;

/* OBJECT STRUCTURE */
inside_obj : more_attributes
           | more_methods
           | more_attributes more_methods
           ;

/* ATTRIBUTES DECLARATION */
more_attributes : attributes
                | more_attributes attributes
                ;

attributes : attribute
           | attributes ',' attribute 
           ;

attribute : DECLATTR object_attributes ';'
          ;

object_attributes : params
                  ;

/* METHODS DECLARATION*/

more_methods : method ';'
             | more_methods method ';'
             ;

method : DECLMETHOD body_method
       ;

body_method : ID '(' func_params ')' RTRNARROW TIP          {
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insertSymbolFunction($1, $6, countpf);
                                                                }
                                                                countpf = 0;
                                                            }
            | ID '(' ')' RTRNARROW TIP                      {
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insertSymbolFunction($1, $5, 0);
                                                                }
                                                            }
            ;

/* METHODS INITIALIZATION */
impl_methods : impl_method ';'
             | impl_methods impl_method
             ;

impl_method : IMPL body_method OF ID body_instr
            ;

/* OBJECT INITIALIZATION */
obj_init : DECLAR some_objects
         ;

some_objects : obj 
             | some_objects ',' obj
             ;

obj : ID ':' ID '{' lista_apel '}'                          {
                                                                if (lookup_symbol($1) == NULL) {
                                                                    notDefinedErr($1);
                                                                } else {
                                                                    if (lookup_symbol($1)->dataType != 3) {
                                                                        notObjErr($1);
                                                                    }
                                                                }

                                                                if (lookup_symbol($3) == NULL) {
                                                                    notDefinedErr($3);
                                                                } else {
                                                                    if (lookup_symbol($3)->dataType != 3) {
                                                                        notObjErr($3);
                                                                    }
                                                                }
                                                            }
    | ID ':' ID '{' '}'                                     {
                                                                if (lookup_symbol($1) == NULL) {
                                                                    notDefinedErr($1);
                                                                } else {
                                                                    if (lookup_symbol($1)->dataType != 3) {
                                                                        notObjErr($1);
                                                                    }
                                                                }

                                                                if (lookup_symbol($3) == NULL) {
                                                                    notDefinedErr($3);
                                                                } else {
                                                                    if (lookup_symbol($3)->dataType != 3) {
                                                                        notObjErr($3);
                                                                    }
                                                                }
                                                            }
    ;
      
/* program main */
bloc_prog : BGIN instructions END  
          ;
     
/* instructions */
instructions : instruction ';' 
             | instructions instruction ';'
             ;

/* instruction */
instruction: assigments
           | obj_init
           | clauses
           ;

clauses : IFCLAUSE expr body_if 
        | IFCLAUSE expr body_if  ELIFCLAUSE expr body_if  ELSECLAUSE body_if 
        | IFCLAUSE expr body_if  ELIFCLAUSE expr body_if
        | IFCLAUSE expr body_if ELSECLAUSE body_if
        | WHILECLAUSE expr body_if
        | FORCLAUSE assigments ';' expr ';' assigments body_if
        ;

body_if : '{' instructions '}'
        ;

assigments : var ASSIGN INT                         {
                                                        sym = lookup_symbol($1->name);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym->type[0] != 'i') {
                                                                typeErr(sym->type, "int");
                                                            } else {
                                                                $1 = updateSymbol($1->name, $3, 0.0, "");
                                                                //printf("value: %d at line %d\n", $3, yylineno);
                                                            }
                                                        }
                                                    }
           | var ASSIGN FLOAT                       {
                                                          sym = lookup_symbol($1->name);
                                                          if (sym == NULL) {
                                                                notDefinedErr($1->name);
                                                          } else {
                                                                if (sym->type[0] != 'f') {
                                                                 typeErr(sym->type, "float");
                                                                } else {
                                                                    $1 = updateSymbol($1->name, 0, $3, "");
                                                                    //printf("value: %f at line %d\n", $3, yylineno);
                                                                }
                                                          }
                                                    }
           | var ASSIGN STRING                      {
                                                          sym = lookup_symbol($1->name);
                                                          if (sym == NULL) {
                                                                notDefinedErr($1->name);
                                                          } else {
                                                                if (sym->type[0] != 's' && sym->type[0] != 'c' && sym->type[0] != 'b') {
                                                                 typeErr(sym->type, "string");
                                                                } else {
                                                                    $1 = updateSymbol($1->name, 0, 0.0, $3);
                                                                    //printf("value: %s at line %d\n", $1->name, yylineno);
                                                                }
                                                          }
                                                    }
           | var ASSIGN arg                         {
                                                        sym = lookup_symbol($1->name);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (strcmp(sym->type, $3->type) == 0) {
                                                                typeErr(sym->type, $3->type);
                                                            } else {
                                                                if (strcmp(sym->type, "int") == 0) {
                                                                    sym->valueInt = $3->valueInt;
                                                                } else if (strcmp(sym->type , "float") == 0) {
                                                                    sym->valueFloat = $3->valueFloat;
                                                                } else {
                                                                    strcpy(sym->valueString, $3->valueString);
                                                                }
                                                            }
                                                        }
                                                    }
           
           | ID '(' lista_apel ')'                  {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 2) {
                                                                notFuncErr($1);
                                                            }
                                                        }
                                                    }
           | ID RTRNARROW ID '(' lista_apel ')'     {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 3) {
                                                                notObjErr($1);
                                                            }
                                                        }

                                                        sym = lookup_symbol($3);
                                                        if (sym == NULL) {
                                                            notDefinedErr($3);
                                                        } else {
                                                            if (sym->dataType != 2) {
                                                                notFuncErr($3);
                                                            }
                                                        }
                                                    }
           | DECLAR ID '[' INT ']' ':' TIP          {
                                                        if (lookup_symbol($2) != NULL) { 
                                                            prevDefinedErr($2);
                                                        } else {
                                                            insertSymbolArray($2, $7, $4);
                                                        }
                                                    }
           | ID '[' INT ']'                         {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 1) {
                                                                notArrErr($1);
                                                            }
                                                        }
                                                    }
var : ID                                            { 
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType == 1) {
                                                                notVarErr($1);
                                                            } else {
                                                                $$->valueInt = sym->valueInt;
                                                                $$->valueFloat = sym->valueFloat;
                                                                strcpy($$->valueString, sym->valueString);
                                                                strcpy($$->type, sym->type);
                                                            }
                                                        }
                                                    }
    | DECLAR ID ':' TIP                             {
                                                        if (lookup_symbol($2) != NULL) {
                                                            prevDefinedErr($2);
                                                        } else {
                                                            if (strcmp($4, "int") == 0) {
                                                                insertSymbolInt($2, 0);
                                                            } else if (strcmp($4, "float") == 0) {
                                                                insertSymbolFloat($2, 0.0);
                                                            } else if (strcmp($4, "char") == 0) {
                                                                insertSymbolChar($2, "");
                                                            } else if (strcmp($4, "string") == 0) {
                                                                insertSymbolString($2, "");
                                                            } else if (strcmp($4, "bool") == 0) {
                                                                insertSymbolBool($2, "");
                                                            }
                                                        }
                                                    }
    | ID RTRNARROW ID                               {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 3) {
                                                                notObjErr($1);
                                                            }
                                                        }

                                                        sym = lookup_symbol($3);
                                                        if (sym == NULL) {
                                                            notDefinedErr($3);
                                                        } else {
                                                            if (sym->dataType != 3) {
                                                                notObjErr($3);
                                                            }
                                                        }
                                                    }                      
    | ID '[' INT ']'                                {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 1) {
                                                                notArrErr($1);
                                                            }
                                                        }
                                                    }      
    | DECLAR ID '[' INT ']' ':' TIP                 {
                                                        if (lookup_symbol($2) != NULL) {
                                                            prevDefinedErr($2);
                                                        } else {
                                                            insertSymbolArray($2, $7, $4);
                                                        }
                                                    }
    ;

lista_apel : arg
           | lista_apel ',' arg
           | '{' lista_apel '}'
           ;

arg : expr
    | '[' expr ']'
    ;

expr : expr '+' expr                                {   
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                $$->valueInt = sym1->valueInt + sym2->valueInt;
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                $$->valueFloat = sym1->valueFloat + sym2->valueFloat;
                                                            } else if (strcmp(sym1->type, "string") == 0) {
                                                                strcpy($$->valueString, sym1->valueString);
                                                                strcat($$->valueString, sym2->valueString);
                                                            }
                                                        }
                                                    }
     | expr '-' expr                                {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                $$->valueInt = sym1->valueInt - sym2->valueInt;
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                $$->valueFloat = sym1->valueFloat - sym2->valueFloat;
                                                            }
                                                        }  
                                                    }
     | expr '*' expr                                {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                $$->valueInt = sym1->valueInt * sym2->valueInt;
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                $$->valueFloat = sym1->valueFloat * sym2->valueFloat;
                                                            }
                                                        }     
                                                    }   
     | expr '/' expr                                {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                if (sym2->valueInt == 0) {
                                                                    divByZeroErr();
                                                                } else {
                                                                    $$->valueInt = sym1->valueInt / sym2->valueInt;
                                                                }
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                if (sym2->valueFloat == 0) {
                                                                    divByZeroErr();
                                                                } else {
                                                                    $$->valueFloat = sym1->valueFloat / sym2->valueFloat;
                                                                }
                                                            }
                                                        }       
                                                    }
     | expr LESSEQOP expr                           {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                               
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                if (sym1->valueInt <= sym2->valueInt)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                if (sym1->valueFloat <= sym2->valueFloat)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        }  
                                                    }
     | expr GREATEREQ expr                          {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                if (sym1->valueInt >= sym2->valueInt)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                if (sym1->valueFloat >= sym2->valueFloat)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        }    
                                                    }
     | expr LESSOP expr                             {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                if (sym1->valueInt < sym2->valueInt)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                if (sym1->valueFloat < sym2->valueFloat)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        } 
                                                    }
     | expr GREATEROP expr                          {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "int") == 0) {
                                                                if (sym1->valueInt > sym2->valueInt)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                if (sym1->valueFloat > sym2->valueFloat)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        }   
                                                    }
     | expr ANDOP expr                              {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "bool") == 0) {
                                                                
                                                                if (strcmp(sym1->valueString, "true") == 0 && strcmp(sym2->valueString, "true") == 0)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        }
                                                    }
     | expr OROP expr                               {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "bool") == 0) {
                                                                
                                                                if (strcmp(sym1->valueString, "true") == 0 || strcmp(sym2->valueString, "true") == 0)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        }
                                                    }
     | expr NEQOP expr                              {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "bool") == 0) {
                                                                
                                                                if (strcmp(sym1->valueString, "true") == 0 && strcmp(sym2->valueString, "false") == 0)
                                                                    strcpy($$->valueString, "true");
                                                                else if (strcmp(sym1->valueString, "false") == 0 && strcmp(sym2->valueString, "true") == 0)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "int") == 0) {
                                                                if (sym1->valueInt != sym2->valueInt)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                if (sym1->valueFloat != sym2->valueFloat)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "string") == 0 || strcmp(sym1->type, "char") == 0) {
                                                                if (strcmp(sym1->valueString, sym2->valueString) != 0)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        }
                                                    }
     | expr EQOP expr                               {
                                                        struct symbol *sym1 = lookup_symbol($1->name);
                                                        struct symbol *sym2 = lookup_symbol($3->name);

                                                        if (sym1 == NULL) {
                                                            notDefinedErr($1->name);
                                                        } else {
                                                            if (sym1->dataType == 1) {
                                                                notVarErr($1->name);
                                                            }
                                                        }

                                                        if (strcmp(sym1->type, sym2->type) != 0) {
                                                            typeErr(sym1->name, sym2->name);
                                                        } else {
                                                            if (strcmp(sym1->type, "bool") == 0) {
                                                                
                                                                if (strcmp(sym1->valueString, sym2->valueString) == 0)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "int") == 0) {
                                                                if (sym1->valueInt == sym2->valueInt)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "float") == 0) {
                                                                if (sym1->valueFloat == sym2->valueFloat)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            } else if (strcmp(sym1->type, "string") == 0 || strcmp(sym1->type, "char") == 0) {
                                                                if (strcmp(sym1->valueString, sym2->valueString) == 0)
                                                                    strcpy($$->valueString, "true");
                                                                else
                                                                    strcpy($$->valueString, "false");
                                                            }
                                                        }
                                                    }
     | DIFFOP expr                                  
     | '-' expr
     | primitives
     ;

primitives : ID RTRNARROW ID                        {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 2) {
                                                                notFuncErr($1);
                                                            } else {
                                                                if (sym == NULL) {
                                                                    notDefinedErr($3);
                                                                } else {
                                                                    if (sym->type != "int") {
                                                                        notIntErr($3);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
           | ID RTRNARROW ID '(' lista_apel ')'     {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 2) {
                                                                notFuncErr($1);
                                                            } else {
                                                                if (sym == NULL) {
                                                                    notDefinedErr($3);
                                                                } else {
                                                                    if (sym->type != "int") {
                                                                        notIntErr($3);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
           | ID RTRNARROW ID '(' ')'                {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 2) {
                                                                notFuncErr($1);
                                                            } else {
                                                                if (sym == NULL) {
                                                                    notDefinedErr($3);
                                                                } else {
                                                                    if (sym->type != "int") {
                                                                        notIntErr($3);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
           | ID '(' lista_apel ')'                  {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 2) {
                                                                notFuncErr($1);
                                                            }
                                                        }
                                                    }
           | ID '(' ')'                             {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 2) {
                                                                notFuncErr($1);
                                                            }
                                                        }
                                                    }
           | ID '[' INT ']'                         {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->dataType != 1) {
                                                                notArrErr($1);
                                                            } else {
                                                                sym->arraySize = $3;
                                                            }
                                                        }
                                                    }
           | ID                                     {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                                strcpy($$->name, $1);
                                                                
                                                                if (sym->type == "int") {
                                                                    $$->valueInt = sym->valueInt;
                                                                } else if (sym->type == "float") {
                                                                    $$->valueFloat = sym->valueFloat;
                                                                } else if (sym->type == "char") {
                                                                    strcpy($$->valueString, sym->valueString);
                                                                } else if (sym->type == "string") {
                                                                    strcpy($$->valueString, sym->valueString);
                                                                }
                                                        }
                                                    }
            ;

%%

int yyerror(char * s)
{
    printf("Error: %s at line: %d\n!", s, yylineno);
    exit(1);
}

void notDefinedErr(char *s)
{
    printf("Error: %s is not defined at line: %d!\n", s, yylineno);
    exit(1);
}

void prevDefinedErr(char *s)
{
    printf("Error: %s is already defined at line: %d!\n", s, yylineno);
    exit(1);
}

void notVarErr(char *s)
{
    printf("Error: %s is not a variable at line: %d!\n", s, yylineno);
    exit(1);
}

void notIntErr(char *s)
{
    printf("Error: %s is not an integer at line: %d!\n", s, yylineno);
    exit(1);
}

void notArrErr(char *s)
{
    printf("Error: %s is not an array at line: %d!\n", s, yylineno);
    exit(1);
}

void notFuncErr(char *s)
{
    printf("Error: %s is not a function at line: %d!\n", s, yylineno);
    exit(1);
}

void notObjErr(char *s)
{
    printf("Error: %s is not an object at line: %d!\n", s, yylineno);
    exit(1);
}

void typeErr(char *t1, char *t2)
{
    printf("Error: %s and %s are not of the same type at line: %d!\n", t1, t2, yylineno);
    exit(1);
}

void divByZeroErr()
{
    printf("Error: Division by zero at line: %d!\n", yylineno);
    exit(1);
}

int main(int argc, char *argv[])
{
    initSymbolTable();

    if (argc)
    {
        yyin = fopen(argv[1], "r");
        if (yyin == NULL)
        {
            printf("Cannot open file %s!", argv[1]);
            return 1;
        }
    }
    else
    {
        printf("No input file!");
        return 1;
    }

    yyparse();

    fclose(yyin);

    yyout = fopen("symbol_table.txt", "w");
    print_symbol_table(yyout);
    fclose(yyout);

    return 0;
}