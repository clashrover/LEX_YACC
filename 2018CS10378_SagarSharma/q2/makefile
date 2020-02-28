RUN:
	yacc -d convert.y
	lex convert.l
	gcc lex.yy.c y.tab.c -o convert
	./convert postfix.txt result.txt