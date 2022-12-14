// symbol table for variables and functions

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef YYSTYPE;
#define MAX_SYMBOLS 100
extern char *yytext;
int count = 0;

#define INT_TO_PTR(i) ((void *)(long)(i))       //cast integer to pointer
#define PTR_TO_INT(p) ((int)(long)(p))          //cast pointer to integer

struct symbol
{
    char *name;          // name of the variable
    int dataType;        // 0 - variable, 1 - vector (array), 2 - function, 3 - structure, 4 - class
    char *type;          // int, char, float
    int value;           // value of the variable
    int inDataType;      // 0 - in main, 1 - in function, 2 - in structure, 3 - in class         /* inca nu sunt sigura daca e nevoie de asta, mai mult pentru a tine evidenta ca */
    struct symbol *next; // pointer to the next symbol in the list                               /* o variabila cu numele 'a' poate exista in toate 4 locuri fara sa imi spuna ca daca e in main, nu poate fi in functie */
};

struct symbol *sym_table = NULL;

int lookup(YYSTYPE name, int inDataType)
{
    struct symbol *s;
    for (s = sym_table; s != NULL; s = s->next)
        if (strcmp(s->name, INT_TO_PTR(name)) == 0 && s->inDataType == inDataType) // if the symbol exists in the table and is in the same scope
        {
            printf("Symbol %s exists in the table.\n", s->name);
            return 1;
        }

    return 0;
}

void insert(YYSTYPE name, int dataType, YYSTYPE type, int value, int inDataType)
{
    struct symbol *s;
    s = (struct symbol *)malloc(sizeof(struct symbol));

    if (count == MAX_SYMBOLS)
    {
        printf("Symbol table is full!\n");
    }
    else
    {
        count++;
        s->name = INT_TO_PTR(name);
        s->dataType = dataType;
        s->value = value;
        s->type = INT_TO_PTR(type);
        s->next = sym_table;
        sym_table = s;

        printf("Symbol %s inserted in the table.\n", name);

        //print the symbol table in a file

        char dataT[20];
        switch (dataType)
        {   
            case 0:
                strcpy(dataT, "variable");
                break;
            case 1:
                strcpy(dataT, "vector");
                break;
            case 2:
                strcpy(dataT, "function");
                break;
            case 3:
                strcpy(dataT, "structure");
                break;
            case 4:
                strcpy(dataT, "class");
                break;
        }
            

        FILE *f = fopen("symbol_table.txt", "w");
        fprintf(f, "%s %s %s %d %d\n", s->name, dataT, s->type, s->value, s->inDataType);
        fclose(f);

        //print the functions in a file
        if (dataType == 1)
        {
            FILE *g = fopen("symbol_table_functions.txt", "w");
            fprintf(g, "%s %s %s %d %d\n", s->name, dataT, s->type, s->value, s->inDataType);
            fclose(g);
        }
    }
}
