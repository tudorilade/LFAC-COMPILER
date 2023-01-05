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

struct symbol *updateSymbol(char *name, int valueInt, double valueFloat, char *valueString);

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
%token LESSOP LESSEQOP GREATEROP GREATEREQ NEQOP EQOP OROP ANDOP DIFFOP
%token <str_val> TRUEP FALSEP COMMENT

%type <s> param object 


%left '+' '-'
%left '*' '/'
%right DIFFOP
%left LESSOP LESSEQOP GREATEROP GREATEREQ EQOP OROP ANDOP NEQOP
%start progr 
%%
progr: global func object_declar bloc_prog {printf("program corect sintactic\n");}
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

param : ID ':' TIP  { 
                        if(lookup_symbol($1) == NULL){
                            if(strcmp($3, "float") == 0)
                                insertSymbolFloat($1, 0.0);
                            else if(strcmp($3, "int") == 0)
                                insertSymbolInt($3, 0);
                            else if(strcmp($3, "bool") == 0)
                                insertSymbolBool($3, "");
                            else if(strcmp($3, "string") == 0)
                                insertSymbolString($3, "");
                        }else
                        {
                            prevDefinedErr($1);
                        }
                    }
      | ID '[' INT ']' ':' TIP {}
      ;

/* FUNC SECTION */
func : FUNC func_declar ENDFUNC
     ;

func_declar : fun ';'
            | func_declar fun ';'
            ;

fun : FUNCDEF body_func
    ;

body_func : ID '(' func_params ')' RTRNARROW TIP body_instr
          | ID '(' ')' RTRNARROW TIP body_instr
          ;

func_params : func_param
            | func_params ',' func_param 
            ;

func_param : ID ':' TIP
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
    printf("eroare: %s la linia: %d\n", s, yylineno);
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