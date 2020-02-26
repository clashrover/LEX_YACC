%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror (char *s);
extern int yylex();
float stack[1000];
int stkptr = 0;
void push(float x);
float pop();
%}

%union {
    char* txtval;
}
%start line
%token <txtval> number
%type  <txtval> line exp

%%

line    : exp '\n'            {printf("%s %f\n", $1, stack[stkptr]);}
        | line exp '\n'       {printf("%s %f\n", $2, stack[stkptr]);}   
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
    printf("%s\n", s);
}

int main(void){
    return yyparse();
}