%{

%}

NUM [0-9]+\.?[0-9]*
VAR [a-zA-Z]+[0-9]*
DECL "let"
SQRT "sqrt"
STR "\"".*"\""
PRINT "out"
SCAN "in"
INI "begin"
FIM "end"
%%

{DECL} {return DECL;}

{PRINT} {return PRINT;}

{INI} {return INI;}		

{STR} {
	strcpy(yylval.str,yytext);
	return STR;
	}
	
{SCAN} {
	return SCAN;
	}

{SQRT} {
	return SQRT;
	}

{FIM} {return FIM;}

{NUM} {
	yylval.flo = atof(yytext);
	return NUM;
	}
	
{VAR} {
	strcpy (yylval.str,yytext);
	return VAR;
	}

	
[-+()=/*^] {return *yytext;}
	
[\ \n\t]*	{;}

. {}
%%