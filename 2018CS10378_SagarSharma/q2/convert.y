%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror (char *s);
extern int yylex();
float stack[1000];
int b = 0;
int b1=0;
int stkptr = 0;
void push(float x);
float pop();
extern FILE *yyin;
extern FILE *yyout;
%}

%union {
    char* txtval;
}
%start line
%token <txtval> number
%token error
%type  <txtval> line exp

%%

line    : exp '\n'                {b=1;fprintf(yyout,"%s %f", $1, stack[stkptr]); free($1);}
        | line exp '\n'           {fprintf(yyout,"\n%s %f", $2, stack[stkptr]); free($2);}   
        | error  '\n'             {fprintf(yyout,"invalid_input");} 
        | line error '\n'         {fprintf(yyout,"\ninvalid_input");}                 
        ;

exp     : number          {$$=strdup($1);   push(atof($1));  free($1);}
        | exp exp '+'   {   int size = 2 + strlen($1) + strlen($2) + 2;
                            $$ = (char*)malloc(size);
                            memset($$,0,size);
                            strcat($$,"+ ");
                            strcat($$,$1);
                            strcat($$," ");
                            strcat($$,$2);
                            free($1); free($2);
                            float x = pop(); float y=pop(); x=x+y; push(x);
                        }
        | exp exp '-'   {   int size = 2 + strlen($1) + strlen($2) + 2;
                            $$ = (char*)malloc(size);
                            memset($$,0,size);
                            strcat($$,"- ");
                            strcat($$,$1);
                            strcat($$," ");
                            strcat($$,$2);
                            free($1); free($2);
                            float x = pop(); float y=pop(); x=y-x; push(x);
                        }
        | exp exp '*'   {   int size = 2 + strlen($1) + strlen($2) + 2;
                            $$ = (char*)malloc(size);
                            memset($$,0,size);
                            strcat($$,"* ");
                            strcat($$,$1);
                            strcat($$," ");
                            strcat($$,$2);
                            free($1); free($2);
                            float x = pop(); float y=pop(); x=x*y; push(x);
                        }
        | exp exp '/'   {   int size = 2 + strlen($1) + strlen($2) + 2;
                            $$ = (char*)malloc(size);
                            memset($$,0,size);
                            strcat($$,"/ ");
                            strcat($$,$1);
                            strcat($$," ");
                            strcat($$,$2);
                            free($1); free($2);
                            float x = pop(); float y=pop();  float c = y/x; push (c);
                        }

        ;

%%

void push(float x){
    stack[++stkptr]=x;
}

float pop(){
    --stkptr;
    return stack[stkptr+1];
}

void yyerror(char* s){
    
}

int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    yyout = fopen(argv[2],"w");
    int x = yyparse();
    
    fclose(yyout);
    return x;
}