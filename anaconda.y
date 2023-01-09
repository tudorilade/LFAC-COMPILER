%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "anaconda.h"

extern FILE* yyin;
extern FILE* yyout;
extern char* yytext;
extern int yylex();
extern int yyerror();
extern int yylineno;

void add_constants(char* name, char* type, char* value);
void insertSymbol(char* name, char* datatype, char* type, char* value, char* arraySize, int nrParams);
void updateSymbol(char *name, char* value, char* dataType, int type);

void notDefinedErr(char *name);             //function that prints an error message when a symbol is not defined
void prevDefinedErr(char *name);            //function that prints an error message when a symbol is already defined
void notVarErr(char *name);                 //function that prints an error message when a symbol is not a variable
void notIntErr(char *name);                 //function that prints an error message when a symbol is not an integer
void notArrErr(char *name);                 //function that prints an error message when a symbol is not an array
void notFuncErr(char *name);                //function that prints an error message when a symbol is not a function
void notObjErr(char *name);                 //function that prints an error message when a symbol is not an object
void typeErr(char *t1, char *t2);           //function that prints an error message when a symbol has a different type
void divByZeroErr();                        //function that prints an error message when a division by zero is attempted
void indexOutOfBoundErr();
void insufficentParameters(char* f, int nrParam, int nrApel);
void incorrectExpression(char* reason);
void attrNotDefinedErr(char* s);
void print_expr_type(unsigned int, char*);
char * inttostr(int n);
void updateSymbolAtr(char* name, char* value, char* dataType);



struct symbol *lookup_symbol(char *name);
void initSymbolTable();
void print_symbol_table(FILE *file);

int countpf;
int countApel;
char const_type[100];
struct symbol *sym;
struct exprinfo* expr;

%}

%union {
    char *str_val;
    struct symbol *s;
    struct exprinfo* exprinf;
}

%token <str_val> ID
%token <str_val> INT 
%token <str_val> FLOAT
%token <str_val> BOOL
%token <str_val> CHAR
%token <str_val> STRING
%token ARRAY
%token EVAL
%token TYPEOF
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

%type <s> progr more_attributes attributes attribute object_attributes params param body_func object
%type <exprinf> primitives expr

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
                                        $$ = createSymbol($1, "Variable", $3, NULL, "-1", -1);
                                    }
                                }
      | ID '[' INT ']' ':' TIP  { 
                                    if (lookup_symbol($1) != NULL) {
                                        prevDefinedErr($1);
                                    } else {
                                        insertSymbol($1, "Array", $6, NULL, $3, -1);
                                        $$ = createSymbol($1, "Array", $6, NULL, $3, -1);
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

func_param : ID ':' TIP                                     { 
                                                                if (lookup_symbol_attr_func($1, "Func Param") != NULL) {
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

object_attributes : params {
                        sym = lookup_symbol($$->name);
                        if(sym != NULL)
                        {
                            if(strcmp(sym->dataType, "Array") == 0)
                            {
                                updateSymbolAtr($$->name, NULL, "Array Attribute");
                            }
                            else
                            {
                                updateSymbolAtr($$->name, NULL, "Attribute");
                            }
                        }                
    }
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
                                                                    insertSymbol($1, "Method", $6, NULL, "-1", countpf);
                                                                }
                                                                countpf = 0;
                                                            }
            | ID '(' ')' RTRNARROW TIP                      {
                                                                if (lookup_symbol($1) != NULL) {
                                                                    prevDefinedErr($1);
                                                                } else {
                                                                    insertSymbol($1, "Method", $5, NULL, "-1", 0);
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
           | EVAL '(' expr ')' { int value = eval_AST($3->ast); printf("The evaluation of expression is: %d\n", value); }
           | TYPEOF '(' expr ')' {
             eval_AST($3->ast);
             if($3->ast->right->numbType == 3)
             {
                print_expr_type($3->ast->right->numbType, $3->ast->right->value);
             }
             else
             {
                print_expr_type($3->ast->right->numbType, NULL); 
             }
             }
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

assigments : ID ASSIGN expr {
                                if ((sym = lookup_symbol($1)) == NULL) notDefinedErr($1);
                                else{
                                    
                                    if($3->ast->left == NULL && $3->ast->right == NULL)
                                    {
                                        // no expression. just assignment
                                        updateSymbol($1, $3->ast->value, "Variable", $3->ast->numbType);
                                    }
                                    else
                                    {
                                        // expression
                                        int value = eval_AST($3->ast);
                                        updateSymbol($1, inttostr(value), "Variable", NUMBER);
                                    }
                                }
                                // int value = eval_AST($3->ast);
                                // printf("Eval de aici:  %d\n", value); 
                            }                      

           | ID RTRNARROW ID  ASSIGN expr {
                                    if ((sym = lookup_symbol($1)) == NULL) notDefinedErr($1);
                                    else{
                                        if($5->ast->left == NULL && $5->ast->right == NULL)
                                        {
                                            // no expression. just assignment
                                            updateSymbol($3, $5->ast->value, "Attribute", $5->ast->numbType);
                                        }
                                        else
                                        {
                                            // expression
                                            int value = eval_AST($5->ast);
                                            updateSymbol($3, inttostr(value), "Attribute", $5->ast->numbType);
                                        }
                                    }
                                }

         | ID RTRNARROW ID   { 
                                    sym = lookup_symbol($1);
                                    if(sym == NULL)
                                    {
                                        notDefinedErr($1);
                                    }
                                    sym = lookup_symbol($3);
                                    if(sym == NULL)
                                    {
                                        notDefinedErr($3);
                                    }
                                }                     
                                                                                       
           | ID RTRNARROW ID '(' lista_apel ')'  {
                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    
                    sym = lookup_symbol($3);

                    if(sym->numberOfParameters != countApel)
                    {
                        insufficentParameters($3, sym->numberOfParameters, countApel);
                    }
                    countApel = 0;
           }  
                                                    
           | ID RTRNARROW ID '(' ')' {
                     sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    sym = lookup_symbol($3);
                    if(sym == NULL)
                    {
                        attrNotDefinedErr($3);
                    }
           }               
                                                    
           | ID '(' lista_apel ')'   {

                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    if(sym->numberOfParameters != countApel)
                    {
                        insufficentParameters($1, sym->numberOfParameters, countApel);
                    }
                    countApel = 0;
           }               
                                                    
           | ID '(' ')' {
                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
           }                             
                                                    
           | ID '[' INT ']'  ASSIGN  expr {
                        sym = lookup_symbol($1);
                        if(sym == NULL)
                        {
                            notDefinedErr($1);
                        }
                        if(atoi($3) >= atoi(sym->arraySize))
                        {
                            indexOutOfBoundErr(yylineno);
                        }
                    }
           
           ;
  


lista_apel : expr {countApel++;}
           | lista_apel ',' expr {countApel++;}
           | '{' lista_apel '}'
           ;

expr : '[' expr ']' { $$ = $2;}
    | expr '+' expr    {
                            $$->ast = buildASTNode("+", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                        }                            
                                                    
     | expr '-' expr     {       

                            $$->ast = buildASTNode("-", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;

                        }                            
                                                    
     | expr '*' expr    {

                            $$->ast = buildASTNode("*", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                        }                               
                                                       
     | expr '/' expr    {
                            $$->ast = buildASTNode("/", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;

                        }                                 
                                                    
     | expr LESSEQOP expr   {
                            $$->ast = buildASTNode("<=", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                            }                         
                                                    
     | expr GREATEREQ expr {
                            $$->ast = buildASTNode(">=", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;

                            }                         
                                                     
     | expr LESSOP expr    {
                            $$->ast = buildASTNode("<", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                            }                         
                                                                                                   
     | expr GREATEROP expr {
                            $$->ast = buildASTNode(">", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                            }                         
                                                  
     | expr ANDOP expr      {
                            $$->ast = buildASTNode("and", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                            }                        
                                                    
     | expr OROP expr    {
                            $$->ast = buildASTNode("or", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                         }                           
                                                    
     | expr NEQOP expr  {
                            $$->ast = buildASTNode("!=", $1->ast, $3->ast,OPERATOR);
                            $$->type = OPERATOR;
                        }                            
                                                    
     | expr EQOP expr   {
                            $$->ast = buildASTNode("==", $1->ast, $3->ast, OPERATOR);
                            $$->type = OPERATOR;
                        }

                                                    
     | DIFFOP expr {
                            $$->ast = buildASTNode("and", $2->ast, NULL,OPERATOR);
                            $$->type = OPERATOR;
                    }

     | primitives
     ;

primitives : ID RTRNARROW ID   { 
                                    sym = lookup_symbol($1);
                                    if(sym == NULL)
                                    {
                                        notDefinedErr($1);
                                    }
                                    sym = lookup_symbol($3);
                                    if(sym == NULL)
                                    {
                                        notDefinedErr($3);
                                    }
                                    $$->ast = buildASTNode($1, NULL, NULL, IDENTIFICATOR); 
                                    $$->type = IDENTIFICATOR;
                                }                     
                                                                                       
           | ID RTRNARROW ID '(' lista_apel ')'  {
                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    sym = lookup_symbol($3);
                    if(sym->numberOfParameters != countApel)
                    {
                        insufficentParameters($3, sym->numberOfParameters, countApel);
                    }
                    countApel = 0;
                    $$->ast = buildASTNode($1, NULL, NULL, IDENTIFICATOR); 
                    $$->type = IDENTIFICATOR;
           }  
                                                    
           | ID RTRNARROW ID '(' ')' {
                     sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    sym = lookup_symbol($3);
                    if(sym == NULL)
                    {
                        attrNotDefinedErr($3);
                    }
                    $$->ast = buildASTNode($1, NULL, NULL, IDENTIFICATOR); 
                    $$->type = IDENTIFICATOR;
           }               
                                                    
           | ID '(' lista_apel ')'   {

                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    if(sym->numberOfParameters != countApel)
                    {
                        insufficentParameters($1, sym->numberOfParameters, countApel);
                    }
                    countApel = 0;
                    $$->ast = buildASTNode($1, NULL, NULL, IDENTIFICATOR); 
                    $$->type = IDENTIFICATOR;
           }               
                                                    
           | ID '(' ')' {
                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    $$->ast = buildASTNode($1, NULL, NULL, IDENTIFICATOR); 
                    $$->type = IDENTIFICATOR;
           }                             
                                                    
           | ID '[' INT ']'   {
                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }
                    if(atoi($3) >= atoi(sym->arraySize))
                    {
                        indexOutOfBoundErr(yylineno);
                    }
                    $$->ast = buildASTNode($1, NULL, NULL, IDENTIFICATOR); 
                    $$->type = IDENTIFICATOR;
           }                      
                                                    
           | ID  {
                    sym = lookup_symbol($1);
                    if(sym == NULL)
                    {
                        notDefinedErr($1);
                    }  
                    $$->ast = buildASTNode(sym->name, NULL, NULL, IDENTIFICATOR); 
                    $$->type = IDENTIFICATOR;
                } 

           | INT { $$->ast = buildASTNode($1, NULL, NULL, NUMBER); $$->type = NUMBER; }
           | STRING { $$->ast = buildASTNode($1, NULL, NULL, STRINGG); $$->type = STRINGG;}
           | TRUEP  { $$->ast = buildASTNode($1, NULL, NULL, BOOLL); $$->type = BOOLL;}  
           | FALSEP  { $$->ast = buildASTNode($1, NULL, NULL, BOOLL); $$->type = BOOLL;}  
           | CHAR  { $$->ast = buildASTNode($1, NULL, NULL, CHARR); $$->type = CHARR;}
           | FLOAT { $$->ast = buildASTNode($1, NULL, NULL, FLOATT); $$->type = FLOATT;}                                 
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
void attrNotDefinedErr(char* s)
{
    printf("Error: %s attribute is not defined at line: %d!\n", s, yylineno);
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

void indexOutOfBoundErr()
{
    printf("Error: Index out of bound line: %d!\n", yylineno);
    exit(1);  
};

void insufficentParameters(char* f, int nrParam, int nrApel)
{
    printf("Error: Function %s has been called with insufficient parameters. Nr of param is %d, but called with %d at line %d!\n",f, nrParam, nrApel, yylineno);
    exit(1);  
}

void incorrectExpression(char* reason)
{
    printf("Error: Incorrect expression at line %d: %s \n", yylineno, reason);
    exit(1);
}

void print_expr_type(unsigned int type, char* identifier)
{
    switch(type)
    {
        case 3:
            printf("Type of expression is %s\n", lookup_symbol(identifier)->type); break;
        case 1:
            printf("Type of expression is int\n"); break;
        case 7:
            printf("Type of expression is float\n"); break;

    }
}

char * inttostr(int n) {
    char * number_str;
    if (n >= 0)
        number_str = malloc(floor(log10(n)) + 2);
    else
        number_str = malloc(floor(log10(n)) + 3);
    sprintf(number_str, "%d", n);
    return number_str;
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