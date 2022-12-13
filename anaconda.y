%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token ID TIP BGIN END ASSIGN NR  DECLAR
%token GLOBAL ENDGLOBAL 
%token OBJECT ENDOBJECT DECLATTR DECLMETHOD DECLOBJECT
%token FUNC ENDFUNC RTRNARROW FUNCDEF 
%token IMPL OF INHERIT
%token IFCLAUSE ELSECLAUSE ELIFCLAUSE WHILECLAUSE FORCLAUSE
%token LESSOP LESSEQOP GREATEROP GREATEREQ NEQOP EQOP OROP
%token ANDOP DIFFOP TRUEP FALSEP 
%left '+' '-'
%left '*' '/'
%right DIFFOP
%left LESSOP LESSEQOP GREATEROP GREATEREQ EQOP OROP ANDOP NEQOP
%start progr 
%%
progr: global func object_declar bloc_prog {printf("program corect sintactic\n");}
     ;

/* GLOBAL VAR SECTION */
global : GLOBAL global_declar  ENDGLOBAL
     ;
     
global_declar : declaratie ';'
	   | global_declar declaratie ';'
	   ;

declaratie : DECLAR params 
           ;

params : param
      | params ',' param
      ;

param : ID ':' TIP
     | ID '[' NR ']' ':' TIP
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

object_attributes : params ;

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
instructions :  instruction ';' 
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
         | DECLAR ID '[' NR ']' ':' TIP
         | ID '[' NR ']'
         ;

var : ID
     | ID '(' lista_apel ')' 
     | DECLAR ID ':' TIP
     | ID RTRNARROW ID
     | ID '[' NR ']'
     | DECLAR ID '[' NR ']' ':' TIP
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


primitives : NR
     | '"' ID '"'
     | '"' NR '"'
     | ID
     | TRUEP
     | FALSEP
     | ID RTRNARROW ID
     | ID RTRNARROW ID '(' lista_apel ')'
     | ID RTRNARROW ID '(' ')'
     | ID '(' lista_apel ')'
     | ID '(' ')'
     ;

%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 