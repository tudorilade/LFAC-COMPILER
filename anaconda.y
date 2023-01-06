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

void add_constants(char* name, char* datatype, char* type, char* value, char* arraySize, int nrParams);
void insertSymbol(char* name, char* datatype, char* type, char* value, char* arraySize, int nrParams);
struct symbol *updateSymbol(char *name, char* value);

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
    char *str_val;
    struct symbol *s;
}

%token <str_val> ID
%token <str_val> INT 
%token <str_val> FLOAT
%token <str_val> BOOL
%token <str_val> CHAR
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

%type <s> param body_func object  

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
                                    if (lookup_symbol($1) != NULL)
                                    {
                                        prevDefinedErr($1);
                                    }
                                    else
                                    {
                                        insertSymbol($1, "Variable", $3, NULL, "-1", -1);
                                    }
                                }
      | ID '[' INT ']' ':' TIP  { 
                                    if (lookup_symbol($1) != NULL) {
                                        prevDefinedErr($1);
                                    } else {
                                        insertSymbol($1, "Array", $6, NULL, $3, -1);
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
                                                                    insertSymbol($1,"Function", $6, NULL, "-1", countpf);
                                                                }
                                                                countpf = 0;
                                                            }
          | ID '(' ')' RTRNARROW TIP body_instr             {              
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insertSymbol($1,"Function", $5, NULL, "-1", 0);
                                                                }
                                                            }
          ;

func_params : func_param                                    { countpf++; }
            | func_params ',' func_param                    { countpf++; }
            ;

func_param : ID ':' TIP                                     {   // ar trebui sa permite duplicat aici. cautam lookup, sa facem match nu doar pe name, dar si pe dataType.
                                                                //TODO
                                                                if (lookup_symbol($1) != NULL) {
                                                                    insertSymbol($1, "Func Param", $3, NULL, "-1", -1);
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
                                                                    insertSymbol($2, "Object", NULL, NULL, "-1", -1);
                                                                }   
                                                            }
       | DECLOBJECT ID '[' ']'                              {
                                                                if (lookup_symbol($2) != NULL) {
                                                                    prevDefinedErr($2);
                                                                } else {
                                                                    insertSymbol($2, "Object", NULL, NULL, "-1", -1);
                                                                }   
                                                            }
       | DECLOBJECT ID ':' INHERIT ID '[' inside_obj ']'    {
                                                                if (lookup_symbol($5) == NULL)
                                                                {
                                                                    notDefinedErr($5);
                                                                } 
                                                                else if (strcmp(lookup_symbol($5)->dataType, "Object") != 0)
                                                                {
                                                                    notObjErr($5);
                                                                }
                                                                else if(lookup_symbol($2) != NULL)
                                                                {
                                                                    prevDefinedErr($2);
                                                                } 
                                                                else 
                                                                {
                                                                    insertSymbol($2, "Object", NULL, NULL, "-1", -1);
                                                                }   

                                                            }
       | DECLOBJECT ID ':' INHERIT ID  '[' ']'              {
                                                                if (lookup_symbol($5) == NULL)
                                                                {
                                                                    notDefinedErr($5);
                                                                } 
                                                                else if (strcmp(lookup_symbol($5)->dataType, "Object") != 0)
                                                                {
                                                                    notObjErr($5);
                                                                }
                                                                else if(lookup_symbol($2) != NULL)
                                                                {
                                                                    prevDefinedErr($2);
                                                                } 
                                                                else 
                                                                {
                                                                    insertSymbol($2, "Object", NULL, NULL, "-1", -1);
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
                                                                    insertSymbol($1, "Function", $6, NULL, "-1", countpf);
                                                                }
                                                                countpf = 0;
                                                            }
            | ID '(' ')' RTRNARROW TIP                      {
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insertSymbol($1, "Function", $5, NULL, "-1", 0);
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
                                                                if (lookup_symbol($3) == NULL) 
                                                                {
                                                                        notDefinedErr($3);
                                                                } else if (strcmp(lookup_symbol($3)->dataType, "Object") != 0) 
                                                                {
                                                                        notObjErr($3);
                                                                }
                                                                else if (lookup_symbol($1) == NULL) 
                                                                {
                                                                    notDefinedErr($1);
                                                                } else if(strcmp(lookup_symbol($1)->dataType, "Object") != 0) 
                                                                {
                                                                        notObjErr($1);
                                                                }
                                                                
                                                            }
    | ID ':' ID '{' '}'                                     {
                                                                if (lookup_symbol($3) == NULL) 
                                                                {
                                                                    notDefinedErr($3);
                                                                } else if (strcmp(lookup_symbol($3)->dataType, "Object") != 0) 
                                                                {
                                                                    notObjErr($3);
                                                                }
                                                                else if (lookup_symbol($1) == NULL) 
                                                                {
                                                                    notDefinedErr($1);
                                                                } else if(strcmp(lookup_symbol($1)->dataType, "Object") != 0) 
                                                                {
                                                                        notObjErr($1);
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

assigments :
            var ASSIGN expr                         
                                                   
           
           | ID '(' lista_apel ')'                  

                                                   
           | ID RTRNARROW ID '(' lista_apel ')'     

                                                   
           | DECLAR ID '[' INT ']' ':' TIP          

                                                   
           | ID '[' INT ']'                         

                                                   
var : ID                                             

                                                   
    | DECLAR ID ':' TIP                             

                                                   
    | ID RTRNARROW ID                               
                                                                         
    | ID '[' INT ']'                                
                                                         
    | DECLAR ID '[' INT ']' ':' TIP                 
                                                   
    ;

lista_apel : expr
           | '[' expr ']'
           | lista_apel ',' expr
           | lista_apel ',' '[' expr ']'
           | '{' lista_apel '}'
           ;

expr : expr '+' expr                                   
                                                    
     | expr '-' expr                                 
                                                    
     | expr '*' expr                                   
                                                       
     | expr '/' expr                                     
                                                    
     | expr LESSEQOP expr                            
                                                    
     | expr GREATEREQ expr                          
   
                                                    
     | expr LESSOP expr                             
                                                    
                                                    
     | expr GREATEROP expr                          
  
                                                    
     | expr ANDOP expr                              
                                                    
     | expr OROP expr                               
                                                    
     | expr NEQOP expr                              
                                                    
     | expr EQOP expr                               
                                                    
     | DIFFOP expr                                  
     | '-' expr
     | primitives
     ;

primitives : ID RTRNARROW ID                        
                                                        
                                                    
           | ID RTRNARROW ID '(' lista_apel ')'     
                                                    
           | ID RTRNARROW ID '(' ')'                
                                                    
           | ID '(' lista_apel ')'                  
                                                    
           | ID '(' ')'                             
                                                    
           | ID '[' INT ']'                         
                                                    
           | ID                                     
            | INT
            | STRING
            | BOOL    
            | CHAR  
            | FLOAT                                 
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