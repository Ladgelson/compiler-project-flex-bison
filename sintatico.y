%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

	typedef struct vars{
		char name[50];
		float value;
		struct vars * prox;
	}VARS;
	
	//insere uma nova variável na lista de variáveis
	VARS * ins(VARS*l,char n[]){
		VARS*new =(VARS*)malloc(sizeof(VARS));
		strcpy(new->name,n);
		new->prox = l;
		return new;
	}
	
	//busca uma variável na lista de variáveis
	VARS *srch(VARS*l,char n[]){
		VARS*aux = l;
		while(aux != NULL){
			if(strcmp(n,aux->name)==0){
				return aux;
			}
			aux = aux->prox;
		}
		return aux;
	}
	
	VARS *l1;
%}

%union{
	float flo;
	char str[50];
	}

%token <flo>NUM
%token <str>VAR
%token <str>STR
%token DECL
%token PRINT
%token SCAN
%token FIM
%token INI
%token SQRT
%left '+' '-'
%left '*' '/'
%right '^' SQRT
%right NEG
%type <flo> exp
%type <flo> valor


%%



prog: INI cod FIM
	;

cod: cod cmdos
	|
	;

cmdos: DECL VAR {
					VARS * aux = srch(l1,$2);
					if (aux == NULL)
						l1 = ins(l1,$2);
					else
						printf ("Redeclaração de variável: %s\n",$2);
				 	 }
	|
	
		PRINT '(' exp ')' {
						printf ("%.2f \n",$3);
						}

	|

		PRINT '(' STR ')' {
						int i;
						for(i=0; $3[i] != '\0'; ++i){
							if($3[i] != '\"') {
								printf("%c",$3[i]);
							}
						}
						printf ("\n");
						}
	| 	
		SCAN '(' VAR ')' {
						VARS * aux = srch(l1,$3);
						if (aux == NULL){
							printf ("Variável não declarada: %s\n",$3);
						} else{
							float f;
							printf("> ");
							scanf("%f", &f);
							aux->value = f;
						}
					}
		
	|
		VAR '=' exp {
					VARS * aux = srch(l1,$1);
					if (aux == NULL)
						printf ("Variável não declarada: %s\n",$1);
					else
						aux -> value = $3;
		}
	;

exp: exp '+' exp {$$ = $1 + $3;}
	|exp '-' exp {$$ = $1 - $3;}
	|exp '*' exp {$$ = $1 * $3;}
	|exp '/' exp {$$ = $1 / $3;}
	|'(' exp ')' {$$ = $2;}
	|exp '^' exp {$$ = pow($1,$3);}
	|SQRT '(' exp ')' {$$ = sqrt($3);}
	|'-' exp %prec NEG {$$ = -$2;}
	|valor {$$ = $1;}
	|VAR {
			VARS * aux = srch (l1,$1);
			if (aux == NULL)
				printf ("Variável não declarada: %s\n",$1);
			else
				$$ = aux->value;
			}
	;

valor: NUM {$$ = $1;}
	;

%%

#include "lex.yy.c"

int main(){
	l1 = NULL;
	yyin=fopen("entrada.txt","r");
	yyparse();
	yylex();
	fclose(yyin);
return 0;
}
