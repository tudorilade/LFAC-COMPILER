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

struct symbol
{
    char* name;         // name of the variable
    int dataType;                   // 0 - variable, 1 - array, 2 - function, 2 - object
    char* type;            // int, float, char, string, bool
    int valueInt;                   // value of the variable, applicaple only for int variables
    double valueFloat;              // value of the variable, applicaple only for float variables
    char* valueString;  // value of the variable, applicaple only for char/string/bool variables
    int arraySize;                  // size of the array, applicaple only for vectors
    int numberOfParameters;         // number of parameters, applicaple only for functions
    struct symbol *next;            // pointer to the next symbol in the list
};

extern struct symbol *sym_table = NULL;

void initSymbolTable()
{
    sym_table = NULL;
    count = 0;

    FILE *file = fopen("symbol_table_functions.txt", "w");
    fprintf(file, "Name      \tDataType  \tType      \tNrOfParams\n");
    fprintf(file, "----------------------------------------------\n");
    fclose(file);
}

void insertSymbolInt(char *name, int valueInt)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    size_t s_name = strlen(name) + 1;
    size_t s_dataType = strlen("int") + 1;
    size_t s_string = 2;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, "int", s_dataType);
    strncpy(s->valueString, "", s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = valueInt;
    s->valueFloat = 0.0;
    s->arraySize = 0;
    s->numberOfParameters = 0;
    s->next = sym_table;
    sym_table = s;
}

void insertSymbolFloat(char *name, double valueFloat)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    size_t s_name = strlen(name) + 1;
    size_t s_dataType = strlen("float") + 1;
    size_t s_string = 2;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, "float", s_dataType);
    strncpy(s->valueString, "", s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = 0;
    s->valueFloat = valueFloat;
    s->arraySize = 0;
    s->numberOfParameters = 0;
    s->next = sym_table;
    sym_table = s;
}

void insertSymbolChar(char *name, char *valueString)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    size_t s_name = strlen(name) + 1;
    size_t s_dataType = strlen("char") + 1;
    size_t s_string = strlen(valueString) + 1;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, "char", s_dataType);
    strncpy(s->valueString, valueString, s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = 0;
    s->valueFloat = 0.0;
    s->arraySize = 0;
    s->numberOfParameters = 0;
    s->next = sym_table;
    sym_table = s;
}

void insertSymbolString(char *name, char *valueString)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }
    
    size_t s_name = strlen(name) + 1;
    size_t s_dataType = strlen("string") + 1;
    size_t s_string = strlen(valueString) + 1;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, "string", s_dataType);
    strncpy(s->valueString, valueString, s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = 0;
    s->valueFloat = 0.0;
    s->arraySize = 0;
    s->numberOfParameters = 0;
    s->next = sym_table;
    sym_table = s;
}

void insertSymbolBool(char *name, char *valueString)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    size_t s_name = strlen(name) + 1;
    size_t s_dataType = strlen("bool") + 1;
    size_t s_string = strlen(valueString) + 1;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, "bool", s_dataType);
    strncpy(s->valueString, valueString, s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = 0;
    s->valueFloat = 0.0;
    s->arraySize = 0;
    s->numberOfParameters = 0;
    s->next = sym_table;
    sym_table = s;
}

void insertSymbolArray(char *name, char *type, int arraySize)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }
    size_t s_name = strlen(name) + 1;
    size_t s_dataType = strlen(type) + 1;
    size_t s_string = 2;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, type, s_dataType);
    strncpy(s->valueString, "", s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = 0;
    s->valueFloat = 0.0;
    s->arraySize = arraySize;
    s->numberOfParameters = 0;
    s->next = sym_table;
    sym_table = s;
}

void insertSymbolFunction(char *name, char *type, int numberOfParameters)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    size_t s_name = strlen(name) + 1;
    size_t s_dataType = strlen(type) + 1;
    size_t s_string = 2;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, type, s_dataType);
    strncpy(s->valueString, "", s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = 0;
    s->valueFloat = 0.0;
    s->arraySize = 0;
    s->numberOfParameters = numberOfParameters;
    s->next = sym_table;
    sym_table = s;
}

void insertSymbolObject(char *name)
{
    struct symbol *s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table full!");
        exit(1);
    }

    size_t s_name = strlen(name) + 1;
    size_t s_dataType = 2;
    size_t s_string = 2;
    s->name = (char*)malloc(s_name);
    s->type = (char*)malloc(s_dataType);
    s->valueString = (char*)malloc(s_string);

    strncpy(s->name, name, s_name);
    strncpy(s->type, "", s_dataType);
    strncpy(s->valueString, "", s_string);
    s->name[s_name] = 0;
    s->type[s_dataType] = 0;
    s->valueString[s_string] = 0;

    s->dataType = 0;
    s->valueInt = 0;
    s->valueFloat = 0.0;
    s->arraySize = 0;
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

struct symbol *updateSymbol(char *name, int valueInt, double valueFloat, char *valueString)
{
    struct symbol *s = lookup_symbol(name);
    if(strcmp(s->name, name) != 0)
    {
        free(s->name);
        size_t s_name = strlen(name) + 1;
        s->name = (char*)malloc(s_name);
        strncpy(s->name, name, s_name);
        s->name[s_name] = 0;
    }

    if(strcmp(s->valueString, valueString) != 0)
    {
        free(s->valueString);
        size_t s_string = strlen(valueString) + 1;
        s->valueString = (char*)malloc(s_string);
        strncpy(s->valueString, valueString, s_string);
        s->valueString[s_string] = 0;
    }
    s->valueInt = valueInt;
    s->valueFloat = valueFloat;
    return s;
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
            if (strcmp(s->type, "int") == 0)
            {
                fprintf(file, "%-10s\t%-10s\t%-10s\t%-10d\t%-10s\t%-10s\n", s->name, "Variable", s->type, s->valueInt, "N\\A", "N\\A");
            }
            else if (strcmp(s->type, "float") == 0)
            {
                fprintf(file, "%-10s\t%-10s\t%-10s\t%-10f\t%-10s\t%-10s\n", s->name, "Variable", s->type, s->valueFloat, "N\\A", "N\\A");
            }
            else if (strcmp(s->type, "bool") == 0)
            {
                fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Variable", s->type, s->valueString, "N\\A", "N\\A");
            }
            else if (strcmp(s->type, "string") == 0)
            {
                fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Variable", s->type, s->valueString, "N\\A", "N\\A");
            }
            else if (strcmp(s->type, "char") == 0)
            {
                fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n", s->name, "Variable", s->type, s->valueString, "N\\A", "N\\A");
            }
        }
        else if (s->dataType == 1)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10d\t%-10s\n", s->name, "Vector", s->type, "N\\A", s->arraySize, "N\\A");
        }
        else if (s->dataType == 2)
        {
            fprintf(file, "%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10d\n", s->name, "Function", s->type, "N\\A", "N\\A", s->numberOfParameters);

            //write in symbol_table_functions.txt
            FILE *file2 = fopen("symbol_table_functions.txt", "a");
            fprintf(file2, "%-10s\t%-10s\t%-10s\t%-10d\n", s->name, "Function", s->type, s->numberOfParameters);
            fclose(file2);
        }
        else if (s->dataType == 3)
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