%{
#include "y.tab.h"      //generated by yacc
%}
%%


[+\-]?(0|([1-9][0-9]*))("."[0-9]*[1-9])?       {yylval.txtval=strdup(yytext);return number;}
[+\-*/\n]                                      {return yytext[0];}
.                                              ;
<<EOF>>                                        { static int once = 0; return once++ ? 0 : '\n' ;}   

%%

int yywrap (void) {return 1;}