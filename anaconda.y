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

body_instr : '{' list '}'
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

body_method : ID '(' method_params ')' RTRNARROW TIP
     | ID '(' ')' RTRNARROW TIP
     ;

method_params : method_param
     | method_params ',' method_param 
     ;

method_param : ID ':' TIP 
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

obj : ID ':' ID '{' init_list '}'
     | ID ':' ID '{' '}'
     ;

init_list : init_par
     | init_list ',' init_par
     ;

init_par : ID 
     | NR
     | '"'ID'"'
     | '"'NR'"'
     | ID '(' lista_apel ')'
     ;

      
/* bloc */
bloc_prog : BGIN list END  
     ;
     
/* lista instructiuni */
list :  statement ';' 
     | list statement ';'
     ;

/* instructiune */
statement: assigment
         | obj_init
         ;

assigment : ID ASSIGN ID
         | ID ASSIGN NR  
         | ID ASSIGN '"' ID '"'
         | ID ASSIGN '"' NR '"'		 
         | ID '(' lista_apel ')'
         ;


lista_apel : NR
           | lista_apel ',' NR
           ;
%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 