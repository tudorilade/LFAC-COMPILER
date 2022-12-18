// symbol table for variables and functions

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100
#define MAXTOKENLEN 40
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
    char name[MAXTOKENLEN]; // name of the variable
    int dataType;           // 0 - variable, 1 - vector (array), 2 - function, 3 - structure, 4 - class
    int type;               // int, char, float
    int scope;              // 0 - global, 1 - in main, 2 - in function, 3 - in structure, 4 - in class
    int value;              // value of the variable, applicaple only for variables
    int arraySize;          // size of the array, applicaple only for vectors
    int numberOfParameters; // number of parameters, applicaple only for functions
    struct symbol *next;    // pointer to the next symbol in the list
};

struct symbol *sym_table = NULL;

void init_symbol_table()
{
    sym_table = NULL;
    count = 0;
    
    FILE *file = fopen("symbol_table_functions.txt", "w");
    fprintf(file, "Name      \tType      \tScope     \tValue      \tArraySize\tNrOfParams\n");
    fprintf(file, "----------------------------------------------------------------------\n");
    fclose(file);
}

void insert_symbol(char *name, int dataType, int type, int scope, int value, int arraySize, int numberOfParameters)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    strcpy(s->name, name);
    s->dataType = dataType;
    s->type = type;

    if (scope == 0)
        s->scope = 0;
    else if (scope == 1)
        s->scope = 1;
    else if (scope == 2)
        s->scope = 2;
    else if (scope == 3)
        s->scope = 3;
    else if (scope == 4)
        s->scope = 4;

    if (dataType == 0)
        s->value = value;
    else
        s->value = 0;

    if (dataType == 1)
        s->arraySize = arraySize;
    else
        s->arraySize = 0;

    if (dataType == 2)
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

struct symbol *lookup_symbol_in_scope(char *name, int scope)
{
    struct symbol *s;
    for (s = sym_table; s != NULL; s = s->next)
        if (strcmp(s->name, name) == 0 && s->scope == scope)
            return s;
    return NULL;
}

void print_symbol_table(FILE *file)
{
    struct symbol *s;

    fprintf(file, "Name      \tType      \tScope     \tValue      \tArraySize\tNrOfParams\n");
    fprintf(file, "----------------------------------------------------------------------\n");

    for (s = sym_table; s != NULL; s = s->next)
    {
        char where[10];

        if (s->scope == 0)
        {
            strcpy(where, "Global");
        }
        else if (s->scope == 1)
        {
            strcpy(where, "Main");
        }
        else if (s->scope == 2)
        {
            strcpy(where, "Function");
        }
        else if (s->scope == 3)
        {
            strcpy(where, "Structure");
        }
        else if (s->scope == 4)
        {
            strcpy(where, "Class");
        }

        if (s->dataType == 0)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10d\t%-10s\t%-10s\n", s->name, "Variable", where, s->value, "N\\A", "N\\A");
        }
        else if (s->dataType == 1)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10d\t%-10s\n", s->name, "Vector", where, "N\\A", s->arraySize, "N\\A");
        }
        else if (s->dataType == 2)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d\n", s->name, "Function", where, "N\\A", "N\\A", s->numberOfParameters);

            //write in symbol_table_functions.txt
            FILE *file2 = fopen("symbol_table_functions.txt", "a");
            fprintf(file2, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d\n", s->name, "Function", where, "N\\A", "N\\A", s->numberOfParameters);
            fclose(file2);
        }
        else if (s->dataType == 3)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Structure", where, "N\\A", "N\\A", "N\\A");
        }
        else if (s->dataType == 4)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Class", where, "N\\A", "N\\A", "N\\A");
        }
        else
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Unknown", where, "N\\A", "N\\A", "N\\A");
        }
    }
}

void print_symbol_table_functions(FILE *file)
{
    struct symbol *s;

    fprintf(file, "Name      \tType      \tScope     \tValue      \tArraySize\tNrOfParams");
    fprintf(file, "----------------------------------------------------------------------");

    char where[10];

    if (s->scope == 0)
    {
        strcpy(where, "Global");
    }
    else if (s->scope == 1)
    {
        strcpy(where, "Main");
    }
    else if (s->scope == 2)
    {
        strcpy(where, "Function");
    }
    else if (s->scope == 3)
    {
        strcpy(where, "Structure");
    }
    else if (s->scope == 4)
    {
        strcpy(where, "Class");
    }

    if (s->dataType == 2)
    {
        fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d", s->name, "Function", where, "N\\A", "N\\A", s->numberOfParameters);
    }
}