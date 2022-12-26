// symbol table for variables and functions

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100
#define MAXTOKENLEN 40
#define MAXIDLEN 20
extern char *yytext;
int count = 0;
int dataType;
char *type;
int value;
int inDataType;

#define INT_TO_PTR(i) ((void *)(long)(i)) // cast integer to pointer
#define PTR_TO_INT(p) ((int)(long)(p))    // cast pointer to integer

struct symbol
{
    char name[MAXTOKENLEN];         // name of the variable
    int dataType;                   // 0 - variable, 1 - vector (array), 2 - string/char, 3 - function, 4 - object
    char type[MAXIDLEN];            // int, char, float
    int value;                      // value of the variable, applicaple only for int/float variables
    char valueString[MAXTOKENLEN];  // value of the variable, applicaple only for char/string variables
    int arraySize;                  // size of the array, applicaple only for vectors
    int numberOfParameters;         // number of parameters, applicaple only for functions
    struct symbol *next;            // pointer to the next symbol in the list
};

struct symbol *sym_table = NULL;

void init_symbol_table()
{
    sym_table = NULL;
    count = 0;

    FILE *file = fopen("symbol_table_functions.txt", "w");
    fprintf(file, "Name      \tDataType  \tType      \tValue      \tArraySize\tNrOfParams\n");
    fprintf(file, "----------------------------------------------------------------------\n");
    fclose(file);
}

void insert_symbol(char *name, int dataType, char *type, int value, char* val, int arraySize, int numberOfParameters)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    strcpy(s->name, name);
    s->dataType = dataType;
    strcpy(s->type, type);

    if (dataType == 0)
        s->value = value;
    else
        s->value = 0;

    if (dataType == 1)
        s->arraySize = arraySize;
    else
        s->arraySize = 0;

    if (dataType == 2)
        strcpy(s->valueString, val);

    if (dataType == 3)
        s->numberOfParameters = numberOfParameters;
    else
        s->numberOfParameters = 0;

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

void print_symbol_table(FILE *file)
{
    struct symbol *s;

    fprintf(file, "Name      \tDataType  \tType      \tValue      \tArraySize\tNrOfParams\n");
    fprintf(file, "----------------------------------------------------------------------\n");

    for (s = sym_table; s != NULL; s = s->next)
    {
        if (s->dataType == 0)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10d\t%-10s\t%-10s\n", s->name, "Variable", s->type, s->value, "N\\A", "N\\A");
        }
        else if (s->dataType == 1)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10d\t%-10s\n", s->name, "Vector", s->type, "N\\A", s->arraySize, "N\\A");
        }
        else if (s->dataType == 2)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "String", s->type, s->valueString, "N\\A", "N\\A");
        }
        else if (s->dataType == 3)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d\n", s->name, "Function", s->type, "N\\A", "N\\A", s->numberOfParameters);

            //write in symbol_table_functions.txt
            FILE *file2 = fopen("symbol_table_functions.txt", "a");
            fprintf(file2, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d\n", s->name, "Function", s->type, "N\\A", "N\\A", s->numberOfParameters);
            fclose(file2);
        }
        else if (s->dataType == 4)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Object", "N\\A", "N\\A", "N\\A", "N\\A");
        }
        else
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Unknown", s->type, "N\\A", "N\\A", "N\\A");
        }
    }
}

void print_symbol_table_functions(FILE *file)
{
    struct symbol *s;

    fprintf(file, "Name      \tDataType  \tType      \tValue      \tArraySize\tNrOfParams");
    fprintf(file, "----------------------------------------------------------------------");

    if (s->dataType == 2)
    {
        fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d", s->name, "Function", s->type, "N\\A", "N\\A", s->numberOfParameters);
    }
}