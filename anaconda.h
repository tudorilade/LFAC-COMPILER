// symbol table for variables and functions

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define MAX_SYMBOLS 100
#define MAXTOKENLEN 40
#define MAXIDLEN 20
#define DATATYPESIZE 15
#define NOTDEFINED "N\\A"
extern char *yytext;
int count = 0;
int dataType;
char *type;
int value;
int inDataType;


typedef enum {
    NUMBER = 1,
    OPERATOR = 2,
    IDENTIFICATOR = 3,
    STRINGG = 4,
    BOOLL = 5,
    CHARR = 6,
    FLOATT = 7

} DATATYPE ;

typedef struct exprinfo
 {
    struct AST* ast;
    DATATYPE type;
 } exprf;

struct symbol
{
    char* name;         // name of the variable
    char* dataType;                   // 0 - variable, 1 - array, 2 - function, 2 - object
    char* type;            // int, float, char, string, bool
    char* value;                   // length
    char* arraySize;                 // size of the array, applicaple only for vectors
    int numberOfParameters;         // number of parameters, applicaple only for functions
    struct symbol *next;            // pointer to the next symbol in the list
};

struct symbol *sym_table = NULL;

void initSymbolTable()
{
    sym_table = NULL;
    count = 0;

    FILE *file = fopen("symbol_table_functions.txt", "w");

    fprintf(file, "%-15s\t%-15s\t%-15s\t%-15s\n", "Name", "DataType", "Type", "NrOfParams");
    for(int i = 0; i < 60; i++)
        fprintf(file, "-");
    fprintf(file, "\n");
    fclose(file);
}


struct symbol* createSymbol(char* name, char* datatype, char* type, char* value, char* arraySize, int nrParams)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));
    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    s->name = strdup(name);
    s->dataType = strdup(datatype);

    if(type == NULL)
    {
        s->type = strdup(NOTDEFINED);
    }
    else
    {
        s->type = strdup(type);
    }


    if(value == NULL)
    {
        s->value = strdup(NOTDEFINED);
    }
    else
    {
        s->value = strdup(value);
    }

    s->arraySize = strdup(arraySize);
    s->numberOfParameters = nrParams;
    return s;
}

void add_constants(char* name, char* type, char* value)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));
    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    s->name = strdup(name);
    s->dataType = strdup("Constants");

    if(type == NULL)
    {
        s->type = strdup(NOTDEFINED);
    }
    else
    {
        s->type = strdup(type);
    }


    if(value == NULL)
    {
        s->value = strdup(NOTDEFINED);
    }
    else
    {
        s->value = strdup(value);
    }

    s->next = sym_table;
    sym_table = s;

}

void insertSymbol(char* name, char* datatype, char* type, char* value, char* arraySize, int nrParams)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));
    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    s->name = strdup(name);
    s->dataType = strdup(datatype);

    if(type == NULL)
    {
        s->type = strdup(NOTDEFINED);
    }
    else
    {
        s->type = strdup(type);
    }


    if(value == NULL)
    {
        s->value = strdup(NOTDEFINED);
    }
    else
    {
        s->value = strdup(value);
    }

    s->arraySize = strdup(arraySize);
    s->numberOfParameters = nrParams;
    s->next = sym_table;
    sym_table = s;
}


struct symbol *lookup_symbol(char *name)
{
    struct symbol *s;
    for (s = sym_table; s != NULL; s = s->next)
        if (strcmp(s->name, name) == 0)
            return s;
    return NULL;
}

struct symbol *lookup_symbol_attr_func(char *name, char* dataType)
{
    struct symbol *s;
    for (s = sym_table; s != NULL; s = s->next)
        if (strcmp(s->name, name) == 0 && strcmp(s->dataType, dataType) == 0)
            return s;
    return NULL;
}

void updateSymbolAtr(char* name, char* value, char* dataType)
{
        struct symbol *s;
        for (s = sym_table; s != NULL; s = s->next)
            if (strcmp(s->name, name) == 0)
            {
                s->dataType = strdup(dataType);
                return;
            }
}

void updateSymbol(char *name, char* value, char* dataType, int type)
{
    /* 
    NUMBER = 1,
    OPERATOR = 2,
    IDENTIFICATOR = 3,
    STRINGG = 4,
    BOOLL = 5,
    CHARR = 6,
    FLOATT = 7
    */
    struct symbol *s;
    for (s = sym_table; s != NULL; s = s->next)
        if (strcmp(s->name, name) == 0)
            {
                if(dataType != NULL)
                {
                    if(strcmp(dataType, s->dataType) == 0)
                    {
                        char* typed;
                        switch(type)
                        {
                            case 1:
                                typed = strdup("int");
                                break;
                            case 4:
                                typed = strdup("string"); break;
                             case 5:
                                typed = strdup("bool"); break;
                            case 7:
                                typed = strdup("float"); break;
                            case 6:
                                typed = strdup("char"); break;
                            case 3:
                                typed = strdup(s->type); break;
                        }
                        if(strcmp(s->type, typed) != 0)
                        {
                            printf("Cannot assign %s to %s. Different types declaration: %s instead of %s\n", value, s->name, typed, s->type);
                            exit(1);
                        }
                        s->value = strdup(value);
                    }
                }
            }

    //printf("values: %d, %f, %s of symbol %s\n", s->valueInt, s->valueFloat, s->valueString, s->name);
} 

void print_symbol_table(FILE *file)
{
    struct symbol *s;

    fprintf(file, "%-15s\t%-15s\t%-15s\t%-15s\t%-15s\t%-15s\n", "Name", "DataType", "Type",  "Value", "ArraySize" , "NrOfParams");
    for(int i = 0; i < 90; i++)
        fprintf(file, "-");
    fprintf(file, "\n");

    for (s = sym_table; s != NULL; s = s->next)
    {
        fprintf(file, "%-15s\t%-15s\t%-15s\t%-15s\t%-15s\t%-15d\n", s->name, s->dataType, s->type, s->value, s->arraySize, s->numberOfParameters);

        if (strcmp(s->dataType, "Function") == 0)
        {
            //write in symbol_table_functions.txt
            FILE *file2 = fopen("symbol_table_functions.txt", "a");
            fprintf(file2, "%-15s\t%-15s\t%-15s\t%-15d\n", s->name, s->dataType, s->type, s->numberOfParameters);
            fclose(file2);
        }
    }
}

void print_symbol_table_functions(FILE *file)
{
    struct symbol *s;
    fprintf(file, "%-15s\t%-15s\t%-15s\t%-15s\t%-15s\t%-15s\n", "Name", "DataType", "Type",  "Value", "ArraySize" , "NrOfParams");
    for(int i = 0; i < 90; i++)
        fprintf(file, "-");
    fprintf(file, "\n");

    if (strcmp(s->dataType, "Function") == 0)
    {
        fprintf(file, "%-15s\t%-15s\t%-15s\t%-15s\t%-15s\t%-15d", s->name, "Function", s->type, "N\\A", "N\\A", s->numberOfParameters);
    }
}

struct AST {
    char* value;
    int numbType;
    struct AST *left;
    struct AST *right;
};


struct AST* buildASTNode(char* value, struct AST* left, struct AST* right, int num)
{    
    struct AST *node = (struct AST*)malloc(sizeof(struct AST));
    switch(num)
    {
        case 1:
            node->value = strdup(value);
            node->numbType = num;
            node->left = left;
            node->right = right;
            break;
        case 2:
            switch(left->numbType)
            {
                case 4:
                    printf("Arithmetic operands should be only int. Found STRING type!\n");
                    exit(1);
                case 5:
                    printf("Arithmetic operands should be only int. Found BOOL type\n");
                    exit(1);
                case 6:
                    printf("Arithmetic operands should be only int. Found CHAR type\n");
                    exit(1);
                case 7:
                    node->value = strdup(value);
                    node->numbType = num;
                    node->left = left;
                    node->right = right;
                    // printf("Arithmetic operands should be only int. Found FLOAT type\n");
                    // exit(1);
            }
            switch(right->numbType)
            {
                case 4:
                    printf("Arithmetic operands should be only int. Found STRING type!\n");
                    exit(1);
                case 5:
                    printf("Arithmetic operands should be only int. Found BOOL type\n");
                    exit(1);
                case 6:
                    printf("Arithmetic operands should be only int. Found CHAR type\n");
                    exit(1);
                case 7:
                    node->value = strdup(value);
                    node->numbType = num;
                    node->left = left;
                    node->right = right;
                    // printf("Arithmetic operands should be only int. Found FLOAT type\n");
                    // exit(1);
            }
            node->value = strdup(value);
            node->left = left;
            node->numbType = num;
            node->right = right;
            break;
        case 3:
            if(lookup_symbol(value) == NULL){
            
                printf("Error: Identifier %s has not beend found\n", (value));
                exit(1);
            }
            node->value = lookup_symbol(value)->name;
            node->left = left;
            node->right = right;
            node->numbType = num;
            break;
        default:
            node->value = strdup(value);
            node->numbType = num;
            node->left = left;
            node->right = right;
            break;
        }
    return node;
}


void free_AST(struct AST *node) {
  if (node == NULL) return;
  if (node->value != NULL) free(node->value);
  if (node->left != NULL) free_AST(node->left);
  if (node->right != NULL) free_AST(node->right);
  free(node);
}

int eval_AST(struct AST *root) {
    if(root == NULL) return 0;

    if(root->numbType == 2)
    {
        if(strcmp(root->value, "+") == 0)
        {
            return eval_AST(root->left) + eval_AST(root->right);
        }
        else if(strcmp(root->value, "-") == 0)
        {
            return eval_AST(root->left) - eval_AST(root->right);
    
        }
        else if(strcmp(root->value, "*") == 0)
        {
            return eval_AST(root->left) * eval_AST(root->right);

        }
        else if(strcmp(root->value, "/") == 0)
        {
            if(eval_AST(root->right) == 0)
            {
                printf("DIV BY 0 during evaluation\n");
                exit(1);
            }
            return eval_AST(root->left) / eval_AST(root->right);

        }
        else
        {
            printf("error aici\n");
            exit(1);
        }
    }

    if(root->numbType == 3)
    {
        struct symbol *s = lookup_symbol(root->value);
        if(s == NULL)
        {
            printf("Identifider %s not found during evaluation! \n", root->value);
            exit(1); 
        }
        if(strcmp(s->type, "int") == 0)
        {
            return atoi(s->value);
        }
        else if(strcmp(s->type, "float") == 0)
        {
            return (int)atof(s->value);
        }
        else
        {
            printf("Arithmetic operands should be only int. Found %s type\n", s->type);
            exit(1);
        }
    }
    if(root->numbType == 1)
    {
        return atoi(root->value);
    }
}


void exprError(char* inc, char* datatype1, char* datatype2)
{
    inc = strdup("Data types are incompatible. ");
    strncat(inc, datatype1, strlen(datatype1));
    strncat(inc, "and", strlen(" and "));
    strncat(inc, datatype2, strlen(datatype2));
}



/* 
var : ID { if ((sym = lookup_symbol($1)) == NULL) notDefinedErr($1);
            else $$ = sym;
          }                          
                                                   
    | ID RTRNARROW ID   {
                         if (lookup_symbol($1) == NULL) notDefinedErr($1);
                         else if ((sym = lookup_symbol_attr_func($3, "Attribute")) == NULL) notDefinedErr($3);
                         else $$ = sym;
                         }                           
                                                                         
    | ID '[' INT ']'  { if ((sym = lookup_symbol($1)) == NULL) prevDefinedErr($1);
                        else $$ = sym;
                      }
    ;


*/