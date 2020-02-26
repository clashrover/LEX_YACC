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

\" {printf("%s",yytext);
	BEGIN(in_str);}
\n {printf("\n");
		l++;}
\' {printf("%s",yytext);
	BEGIN(in_literal);}


<comment>[^*\n] ;
<comment>"*" ;
<comment>\n {printf(" \n");
				BEGIN(is_multi);}
<comment>{end} {printf(" ");
				BEGIN(INITIAL);}
<comment><<EOF>> {
			err=1;
			fprintf(stderr,"Error: line %d: unterminated comment\n",start_line);
			yyterminate();
}



<is_multi>[^*\n] ;
<is_multi>"*" ;
<is_multi>\n printf("\n");
<is_multi><<EOF>> {
			err=1;
			fprintf(stderr,"Error: line %d: unterminated comment\n",start_line);
			yyterminate();}
<is_multi>{end} BEGIN(INITIAL);


<in_str>[^\\\" ] printf("%s",yytext);
<in_str>\\ {printf("%s",yytext); 
			BEGIN(backslash);}
<in_str>\" {printf("%s",yytext);
		BEGIN(INITIAL);}


<backslash>.|\n  {printf("%s",yytext);
				BEGIN(in_str);}


<in_literal>[^\\\'] printf("%s",yytext);
<in_literal>\\ {printf("%s",yytext); 
			BEGIN(backslash_forchar);}
<in_literal>\' {printf("%s",yytext);
		BEGIN(INITIAL);}

<backslash_forchar>.|\n  {printf("%s",yytext);
				BEGIN(in_literal);}


%%
int main(int k,char **argvc){
	yylex();
	if(err==1){
		return EXIT_FAILURE;
	}
	return 0;
}

