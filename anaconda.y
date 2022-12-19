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

void insert_symbol(char *name, int dataType, char *type, int value, int arraySize, int numberOfParameters);
struct symbol *lookup_symbol(char *name);
void print_symbol_table(FILE *file);
void prevDefinedErr(char *name);
int countpf;
%}

%union {
    int int_val;
    double float_val;
    char *bool_val;
    char char_val;
    char *str_val;
    struct symbol_table *s;
}

%token <str_val> ID
%token <int_val> INT NR
%token <float_val> FLOAT
%token <bool_val> BOOL
%token <char_val> CHAR
%token <str_val> STRING
%token ARRAY
%token <str_val> TIP 
%token BGIN END ASSIGN DECLAR
%token GLOBAL ENDGLOBAL 
%token OBJECT ENDOBJECT DECLATTR DECLMETHOD DECLOBJECT
%token <s> FUNC 
%token ENDFUNC RTRNARROW FUNCDEF 
%token IMPL OF INHERIT
%token IFCLAUSE ELSECLAUSE ELIFCLAUSE WHILECLAUSE FORCLAUSE
%token LESSOP LESSEQOP GREATEROP GREATEREQ NEQOP EQOP OROP
%token ANDOP DIFFOP TRUEP FALSEP COMMENT

%type <s> param body_func

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
                                        insert_symbol($1, 0, $3, 0, 0, 0);
                                    }
                                }
      | ID '[' NR ']' ':' TIP   { 
                                    if (lookup_symbol($1) != NULL) {
                                        prevDefinedErr($1);
                                    } else {
                                        insert_symbol($1, 1, $6, 0, 0, $3);
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
                                                                    insert_symbol($1, 2, $6, 0, 0, countpf);
                                                                }
                                                                countpf = 0;
                                                            }
          | ID '(' ')' RTRNARROW TIP body_instr             {              
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insert_symbol($1, 2, $5, 0, 0, 0);
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
                                                                    insert_symbol($1, 0, $3, 0, 0, 0);
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

object : DECLOBJECT ID '[' inside_obj ']'
       | DECLOBJECT ID '[' ']'
       | DECLOBJECT ID ':' INHERIT ID '[' inside_obj ']'
       | DECLOBJECT ID ':' INHERIT ID  '[' ']'
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

body_method : ID '(' func_params ')' RTRNARROW TIP
            | ID '(' ')' RTRNARROW TIP
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

assigments : var ASSIGN arg
           | ID '(' lista_apel ')'
           | ID RTRNARROW ID '(' lista_apel ')'
           | DECLAR ID '[' INT ']' ':' TIP
           | ID '[' INT ']'
           ;

var : ID
    | DECLAR ID ':' TIP
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
     | expr '+' expr
     | expr '-' expr
     | expr '*' expr
     | expr '/' expr
     | DIFFOP expr
     | expr LESSEQOP expr
     | expr GREATEREQ expr
     | expr LESSOP expr
     | expr GREATEROP expr
     | expr ANDOP expr
     | expr OROP expr
     | expr NEQOP expr
     | expr EQOP expr
     | '-' expr
     | primitives
     ;

primitives : INT
           | '"' ID '"'
           | '"' INT '"'
           | FLOAT
           | '"' FLOAT '"'
           | ID
           | TRUEP
           | FALSEP
           | ID RTRNARROW ID
           | ID RTRNARROW ID '(' lista_apel ')'
           | ID RTRNARROW ID '(' ')'
           | ID '(' lista_apel ')'
           | ID '(' ')'
           | ID '[' INT ']'
           ;

%%
int yyerror(char * s)
{
    printf("Error: %s at line: %d\n!", s, yylineno);
}

void prevDefinedErr(char *s)
{
    printf("Error: %s is already defined at line: %d!\n", s, yylineno);
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