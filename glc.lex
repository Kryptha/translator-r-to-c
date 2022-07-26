%{
	#include <stdio.h>
	#include "y.tab.h"
%}
%%
"c"                             { yylval.val = strdup(yytext); return(CARR);}
[A-Za-z_]+([A-Za-z0-9_])?    	{ yylval.val = strdup(yytext); return(VARIABLE); }
"("                             { yylval.val = strdup(yytext); return(PIZQ);}
")"                             { yylval.val = strdup(yytext); return(PDER);}
","                             { yylval.val = strdup(yytext); return(COMA);}
"<-"                            { yylval.val = strdup(yytext); return(ASIGNIZQ);}
"->"                            { yylval.val = strdup(yytext); return(ASIGNDER);}
[0-9]+(\.[0-9]+)?               { yylval.val = strdup(yytext); return(NUM);}
[\*\-\/\+]						{ yylval.val = strdup(yytext); return(OP);}
\n								return(yytext[0]);
[\t ]							;
.								;
%%