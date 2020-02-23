start "/*"
end "*/"
%x comment
%x is_multi
%x in_str
%x in_literal
%x backslash
%x backslash_forchar
%option yylineno
%{
	int err=0;
%}
%%
   int start_line= 0;
   int l=0;



{start}		{ start_line=yylineno;
			BEGIN(comment);
		}

\" {fprintf(yyout,"%s",yytext);
	BEGIN(in_str);}
\n {fprintf(yyout,"\n");
		l++;}
\' {fprintf(yyout,"%s",yytext);
	BEGIN(in_literal);}


<comment>[^*\n] ;
<comment>"*" ;
<comment>\n {fprintf(yyout," \n");
				BEGIN(is_multi);}
<comment>{end} {fprintf(yyout," ");
				BEGIN(INITIAL);}
<comment><<EOF>> {
			err=1;
			fprintf(stderr,"Error: line %d: unterminated comment\n",start_line);
			yyterminate();
}



<is_multi>[^*\n] ;
<is_multi>"*" ;
<is_multi>\n fprintf(yyout,"\n");
<is_multi><<EOF>> {
			err=1;
			fprintf(stderr,"Error: line %d: unterminated comment\n",start_line);
			yyterminate();}
<is_multi>{end} BEGIN(INITIAL);


<in_str>[^\\\" ] fprintf(yyout,"%s",yytext);
<in_str>\\ {fprintf(yyout,"%s",yytext); 
			BEGIN(backslash);}
<in_str>\" {fprintf(yyout,"%s",yytext);
		BEGIN(INITIAL);}


<backslash>.|\n  {fprintf(yyout,"%s",yytext);
				BEGIN(in_str);}


<in_literal>[^\\\'] fprintf(yyout,"%s",yytext);
<in_literal>\\ {fprintf(yyout,"%s",yytext); 
			BEGIN(backslash_forchar);}
<in_literal>\' {fprintf(yyout,"%s",yytext);
		BEGIN(INITIAL);}

<backslash_forchar>.|\n  {fprintf(yyout,"%s",yytext);
				BEGIN(in_literal);}


%%
int main(int k,char **argvc){
	yyin = fopen(argvc[1],"r");
	yyout = fopen("out.c","w");
	yylex();
	if(err=1){
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}

