%{
#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
#include "textlibrary.h"

int yylex();
int yylineno;
void yyerror(const char*);
int yywrap();
int linecode = 8, cantlist = 1;
char namearch[]= "traducctionR.c";

%}


%union { char* val; }
%token VARIABLE PIZQ PDER COMA CARR ASIGNIZQ ASIGNDER OP
%token NUM
%type <val> NUM LISTA ARR
%type <val> VARIABLE OP S
%start program
%left '\n'

%%                  

program : S program
        | S
        ;
S	      : S '\n' {printf("\n");}
        | VARIABLE ASIGNIZQ ARR {
          char *line = define_array(" double", $1, $3);
          write_incode_archv(namearch, linecode, line);
          linecode++; 
          char *line2 = define_lenght_array($3, cantlist);
          write_incode_archv(namearch, linecode, line2);
          linecode++;
          free($1); free($3);
          free(line);
          free(line2);
          }
        | ARR ASIGNDER VARIABLE {
          char *line = define_array(" double", $3, $1);
          write_incode_archv(namearch, linecode, line);
          linecode++;
          char *line2 = define_lenght_array($3, cantlist);
          write_incode_archv(namearch, linecode, line2);
          linecode++;
          free($1); free($3);
          free(line);
          free(line2);
          }
        | NUM OP VARIABLE { 
          char *var = (char*)calloc(strlen($3)+5, sizeof(char));
          strcpy(var, $3);
          strcat(var, "[]");
          if((verification_variable(var, namearch)) == 1)
          {
            char *line = define_escalar_op_array($3, $1, $2, 1);
            write_incode_archv(namearch, linecode, line);
            linecode++;
            free(line);
          }
          else
            printf("%s doesn't exist.", $3);
          free(var);
        }
        | VARIABLE OP NUM {
          char *var = (char*)calloc(strlen($1)+5, sizeof(char));
          strcpy(var, $1);
          strcat(var, "[]");
          if((verification_variable(var, namearch)) == 1)
          {
            char *line = define_escalar_op_array($1, $3, $2, 2);
            write_incode_archv(namearch, linecode, line);
            linecode++;
            free(line);
          }
          else{
            printf("%s doesn't exist.", $1);
          }
          free(var);
        } 
        | S error '\n' {yyerrok;}		
	      ;
ARR 	  :CARR PIZQ LISTA PDER {
                                char *function = malloc(strlen($3) + 3);
                                strcat(function, "{");
                                strcat(function, $3);
                                strcat(function, "}");
                                $$=function;
                              }
		    ;
LISTA   : NUM COMA LISTA      {  char *list = malloc(strlen($1) + strlen($3) + 3);
                                 strcat(list, $1);
                                 strcat(list, ", ");
                                 strcat(list, $3);
                                 cantlist++;
                                 $$=list;
                              }
        | NUM                 {$$=$1;}
        ;
%%

int main()
{
	printf("\n\t\t\t\t\t Traductor de R a C \n");
	printf("Traduce un arreglo de R a un arreglo de double en C\n");
  create_archv(namearch);
	yyparse();
	return 0;
}

void yyerror(const char* s)
{
  fprintf(stderr, "line %d: %s\n",yylineno, s);
}

int yywrap()
{
  return(1);
}
