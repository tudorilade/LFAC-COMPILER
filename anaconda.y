%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "anaconda.h"

extern FILE* yyin;
extern FILE* yyout;
extern int yylineno;
extern char* yytext;
extern int ylex();

void insert_symbol(char *name, int dataType, char *type, int value, char* val, int arraySize, int numberOfParameters);
struct symbol *lookup_symbol(char *name);
void print_symbol_table(FILE *file);

void notDefinedErr(char *name);             //function that prints an error message when a variable is not defined
void prevDefinedErr(char *name);            //function that prints an error message when a variable is already defined
void notIntErr(char *name);                 //function that prints an error message when a variable is not an integer
void notArrErr(char *name);                 //function that prints an error message when a variable is not an array
void notFuncErr(char *name);                //function that prints an error message when a variable is not a function
void notObjErr(char *name);                 //function that prints an error message when a variable is not an object
void typeErr(char *t1, char *t2);           //function that prints an error message when a variable has a different type

int countpf;
int const_num;
double const_float;
char const_char;
char const_string[100];
char const_bool[100];
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
                                        insert_symbol($1, 0, $3, 0, "", 0, 0);
                                    }
                                }
      | ID '[' INT ']' ':' TIP  { 
                                    if (lookup_symbol($1) != NULL) {
                                        prevDefinedErr($1);
                                    } else {
                                        insert_symbol($1, 1, $6, 0, "", $3, 0);
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
                                                                    insert_symbol($1, 3, $6, 0, "", 0, countpf);
                                                                }
                                                                countpf = 0;
                                                            }
          | ID '(' ')' RTRNARROW TIP body_instr             {              
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insert_symbol($1, 3, $5, 0, "", 0, 0);
                                                                }
                                                            }
          ;

func_params : func_param                                    { countpf++; }
            | func_params ',' func_param                    { countpf++; }
            ;

func_param : ID ':' TIP                                     {   
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insert_symbol($1, 0, $3, 0, "", 0, 0);
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
                                                                    insert_symbol($2, 4, "", 0, "", 0, 0);
                                                                }   
                                                            }
       | DECLOBJECT ID '[' ']'                              {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insert_symbol($2, 4, "", 0, "", 0, 0);
                                                                }   
                                                            }
       | DECLOBJECT ID ':' INHERIT ID '[' inside_obj ']'    {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insert_symbol($2, 4, "", 0, "", 0, 0);
                                                                }   
                                                            }
       | DECLOBJECT ID ':' INHERIT ID  '[' ']'              {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insert_symbol($2, 4, "", 0, 0, 0, 0);
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
                                                                    insert_symbol($1, 3, $6, 0, "", 0, countpf);
                                                                }
                                                                countpf = 0;
                                                            }
            | ID '(' ')' RTRNARROW TIP                      {
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insert_symbol($1, 3, $5, 0, "", 0, 0);
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

obj : ID ':' ID '{' lista_apel '}' 
    | ID ':' ID '{' '}'
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

assigments : var ASSIGN arg                         {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                            if (sym->type != $3->type) {
                                                                typeErr(sym->name, $3->name);
                                                            }
                                                            else {
                                                                if (sym->type == "int" || sym->type == "float") {
                                                                    sym->value = $3->value;
                                                                } else {
                                                                    strcpy(sym->valueString, $3->valueString);
                                                                }
                                                            }
                                                        }
                                                    }
           | ID '(' lista_apel ')'
           | ID RTRNARROW ID '(' lista_apel ')'
           | DECLAR ID '[' INT ']' ':' TIP
           | ID '[' INT ']'
           ;

var : ID                                            { $$ = $1; }
    | DECLAR ID ':' TIP                             {
                                                        if (lookup_symbol($2) != NULL) {
                                                            prevDefinedErr($2);
                                                        } else {
                                                            insert_symbol($2, 1, $4, 0, "", 0, 0);
                                                        }
                                                    }
    | ID RTRNARROW ID                               
    | ID '[' INT ']'                               
    | DECLAR ID '[' INT ']' ':' TIP
    ;

lista_apel : arg
           | lista_apel ',' arg
           ;

arg : '{' lista_apel '}'
    | expr
    ;

expr : '[' expr ']' 
     | expr '+' expr                                {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }
     | expr '-' expr                                {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }
     | expr '*' expr                                {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }   
     | expr '/' expr                                {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }
     | DIFFOP expr                                  
     | expr LESSEQOP expr                           {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }
     | expr GREATEREQ expr                          {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }
     | expr LESSOP expr                             {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }
     | expr GREATEROP expr                          {
                                                        if (lookup_symbol($1) != NULL) {
                                                            if (lookup_symbol($1)->type != "int") {
                                                                notIntErr($1);
                                                            }
                                                        }
                                                        if (lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($3)->type != "int") {
                                                                notIntErr($3);
                                                            }
                                                        }   
                                                    }
     | expr ANDOP expr                              {
                                                        if (lookup_symbol($1) != NULL && lookup_symbol($3) != NULL) {
                                                            if (lookup_symbol($1)->value && lookup_symbol($3)->value) {
                                                               // notBoolErr($1);
                                                            }
                                                        }   
                                                    }
     | expr OROP expr                               {
                                                        if (lookup_symbol($1) != NULL && lookup_symbol($3) != NULL) {
                                                            if (!(lookup_symbol($1)->value || lookup_symbol($3)->value)) {
                                                               // notBoolErr($1);
                                                            }
                                                        }   
                                                    }
     | expr NEQOP expr
     | expr EQOP expr
     | '-' expr
     | primitives
     ;

primitives : INT                                    { 
                                                        $$ = $1; 
                                                        strcpy($$->type, "int");
                                                    }           
           | '"' CHAR '"'                           { 
                                                        strcpy($$->valueString, $2);
                                                        strcpy($$->type, "char");
                                                    }
           | '"' STRING '"'                         {
                                                        strcpy($$->valueString, $2);
                                                        strcpy($$->type, "string");
                                                    }
           | '"' INT '"'                            {
                                                        char *aux;
                                                        sprintf(aux, "%d", $2);
                                                        strcpy($$->valueString, aux);
                                                        strcpy($$->type, "string");
                                                    }
           | FLOAT                                  { 
                                                        char *aux;
                                                        sprintf(aux, "%f", $1);
                                                        strcpy($$->valueString, aux);
                                                    }
           | '"' FLOAT '"'                          {
                                                        char *aux;
                                                        sprintf(aux, "%f", $2);
                                                        strcpy($$->valueString, aux);
                                                        strcpy($$->type, "string");
                                                    }
           | ID                                     {
                                                        sym = lookup_symbol($1);
                                                        if (sym == NULL) {
                                                            notDefinedErr($1);
                                                        } else {
                                                                $$ = $1;
                                                                strcpy($$->type, sym->type);
                                                        }
                                                    }
           | TRUEP                                  { $$ = $1; }          
           | FALSEP                                 { $$ = $1; }
           | ID RTRNARROW ID                        {
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
           ;

%%

int yyerror(char * s)
{
    printf("Error: %s at line: %d\n!", s, yylineno);
}

void notDefinedErr(char *s)
{
    printf("Error: %s is not defined at line: %d!\n", s, yylineno);
}

void prevDefinedErr(char *s)
{
    printf("Error: %s is already defined at line: %d!\n", s, yylineno);
}

void notIntErr(char *s)
{
    printf("Error: %s is not an integer at line: %d!\n", s, yylineno);
}

void notArrErr(char *s)
{
    printf("Error: %s is not an array at line: %d!\n", s, yylineno);
}

void notFuncErr(char *s)
{
    printf("Error: %s is not a function at line: %d!\n", s, yylineno);
}

void notObjErr(char *s)
{
    printf("Error: %s is not an object at line: %d!\n", s, yylineno);
}

void typeErr(char *t1, char *t2)
{
    printf("Error: %s and %s are not of the same type at line: %d!\n", t1, t2, yylineno);
}

int main(int argc, char *argv[])
{
    init_symbol_table();

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