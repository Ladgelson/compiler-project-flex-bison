all : lexico.l sintatico.y
	flex -i lexico.l
	bison sintatico.y
	gcc sintatico.tab.c -o analisador -lfl -lm
	clear
	./analisador