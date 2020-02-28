RUN:
	lex scannner.l
	cc -o decomment lex.yy.c -lfl 
	./decomment < input.c > out.c 2> errorsAndWarnings