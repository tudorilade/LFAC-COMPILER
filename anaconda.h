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
    fprintf(file, "Name      \tDataType  \tType      \tNrOfParams\n");
    fprintf(file, "----------------------------------------------\n");
    fclose(file);
}

void add_constants(char* name, char* datatype, char* type, char* value, char* arraySize, int nrParams)
{

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

struct symbol *updateSymbol(char *name, char* value)
{
    struct symbol *s = lookup_symbol(name);
    s->name = strdup(name);
    s->value = strdup(value);

    //printf("values: %d, %f, %s of symbol %s\n", s->valueInt, s->valueFloat, s->valueString, s->name);

    return s;
} 

void print_symbol_table(FILE *file)
{
    struct symbol *s;

    fprintf(file, "Name      \tDataType  \tType      \tValue      \tArraySize\tNrOfParams\n");
    fprintf(file, "----------------------------------------------------------------------\n");

    for (s = sym_table; s != NULL; s = s->next)
    {
        fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d\n", s->name, s->dataType, s->type, s->value, s->arraySize, s->numberOfParameters);

        if (strcmp(s->dataType, "Function") == 0)
        {
            //write in symbol_table_functions.txt
            FILE *file2 = fopen("symbol_table_functions.txt", "a");
            fprintf(file2, "%-10s\t%-10s\t%-10s\t%-10d\n", s->name, s->dataType, s->type, s->numberOfParameters);
            fclose(file2);
        }
    }
}

void print_symbol_table_functions(FILE *file)
{
    struct symbol *s;

    fprintf(file, "Name      \tDataType  \tType      \tValue      \tArraySize\tNrOfParams");
    fprintf(file, "----------------------------------------------------------------------");

    if (strcmp(s->dataType, "Function") == 0)
    {
        fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d", s->name, "Function", s->type, "N\\A", "N\\A", s->numberOfParameters);
    }
}