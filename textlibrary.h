int verification_variable (char str[], char name_archv[]); 
void create_archv (char name[]);
void write_incode_archv(char name[], int numcode, char str[]);
char *define_array (char type[], char var[], char list[]);
char *define_escalar_op_array (char *variable, char *escalar, char* op, int forma);
char *define_lenght_array(char *var, int cant);
//Crear un archivo inicio
void create_archv (char name[]){
    FILE *traduccion; 
    traduccion= fopen(name, "w"); 
    fputs("#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <math.h>\n\n", traduccion);
    fputs("int main()\n{\n\n return 0;\n}\n ", traduccion);  
    fclose(traduccion);
}

//Escribir en la línea de código numcode el string str en el archivo name.
void write_incode_archv(char name[], int numcode, char str[]){
    FILE *archv; 
    char line[100];
    int linecode = 1;
    archv = fopen(name, "r+"); 
    while (fgets(line, 100, archv) != NULL)
    {
        linecode++;
        if(linecode == numcode){
            fputs(str,archv); 
        }
    }
    fputs(" return 0;\n}\n", archv);
    fclose(archv);

}

//Verificar si un str en el archivo name_archv
int verification_variable(char str[], char name_archv[])
{
    FILE *archv;
    char *word = NULL;
    char c[1]; 
    int found, max = 1; 
    word = (char*)calloc(max, sizeof(char)); 
    archv = fopen(name_archv, "r");
    while ((c[0] = getc(archv)) != EOF){
        if(c[0] != ' '){
            max++;
            word = (char*)realloc(word,max);
            strcat(word,c);
        }
        else
        {
            if (strcmp(str,word)==0){
                free(word);
                fclose(archv);
                return 1; 
            }
            else {
                max=1;
                free(word);
                word = (char*)calloc(max, sizeof(char));
            }
            
        }
        
    }
    free(word);
    fclose(archv);
    return 0; 
}

//Definir en c un arreglo de type con nombre var y contenido list
char *define_array (char *type, char *var, char *list){
    char *define = (char*)calloc(strlen(type) + strlen(var) + strlen(list) + 14, sizeof(char));
    strcat(define, type);
    strcat(define, " ");
    strcat(define, var);
    strcat(define, "[] = ");
    strcat(define, list);
    strcat(define, "\n");  

    return define; 
}

char *define_escalar_op_array (char *variable, char *escalar, char* op, int forma)
{
    char *define = (char*)calloc(strlen(variable) + strlen(escalar) + strlen(op) + 50, sizeof(char));
    strcat(define, " for (int i = 0; i<=size_");
    strcat(define, variable);
    strcat(define, "; i++){\n\t");
    strcat(define, variable);
    strcat(define, "[i] = ");
    if (forma == 1)
    {
        strcat(define, escalar);
        strcat(define, " ");
        strcat(define, op);
        strcat(define, " ");
        strcat(define, variable);
        strcat(define, "[i];\n }");
    }
    else {
        strcat(define, variable);
        strcat(define, "[i] ");
        strcat(define, op);
        strcat(define, " ");
        strcat(define, escalar);
        strcat(define, ";\n }");
    }
    strcat(define, "\n"); 
    return define; 
}

char *define_lenght_array(char *var, int cant)
{   
    int length = snprintf( NULL, 0, "%d", cant );
    char* number = calloc( length + 1 ,sizeof(char));
    snprintf( number, length + 1, "%d", cant );
    char *define = (char*)calloc(strlen(var) + 19 , sizeof(char));
    strcat(define, " int size_");
    strcat(define, var);
    strcat(define," = ");
    strcat(define, number);
    strcat(define, ";\n");
    free(number);
    return define; 
}