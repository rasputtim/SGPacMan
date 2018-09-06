/* This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */
 
%{ /*** C/C++ Declarations ***/

	#include <string>
	#include <iostream>
	#include <iomanip>
    #include "../../SGF_Global.h"
	#include "cmdScanner.h"
	
	/* import the parser's token type into a local typedef */
	
	typedef CmdCompiler::Parser::token token;
	typedef CmdCompiler::Parser::token_type token_type;
    /* By default yylex returns int, we use token_type. Unfortunately yyterminate
    * by default returns 0, which is not of token_type. */
    #define yyterminate() return token::END

	//To use in lexer to parse trigger redirection
	
      // used to keep track of location
   	/* The following paragraph suffices to track locations accurately. Each time
 	* yylex is invoked, the begin position is moved onto the end position. */

	#define YY_USER_ACTION yylloc->columns(yyleng);
	/* This disables inclusion of unistd.h, which is not available under Visual C++
 	* on Win32. The C++ scanner uses STL streams instead. */

	#define YY_NO_UNISTD_H


%}
/* The following paragraph suffices to track locations accurately. Each time
 * yylex is invoked, the begin position is moved onto the end position. */
%{
#define YY_USER_ACTION  yylloc->columns(yyleng);
%}
/* change the name of the scanner class. results in "ExampleFlexLexer" */
%option prefix="Cmd"
%option nodefault noyywrap yyclass="CScanner" c++


digit	[0123456789]
STR		\"[^\"]*\"
CHAR	[a-zA-z_]
FILENAME_CHAR [^\\\/,=;\n\r ]
blank   [\t]

%% /*** Regular Expressions Part ***/

 /* code to place at the beginning of yylex() */


%{
    // reset location
    yylloc->step();
%}


(F|f){digit}+ { yylval->doubleVal = toFloatX(); /* sscanf(yytext,"F%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_FX: " << yylval->doubleVal  <<endl; 
	return token::KEY_FX;}

(s|S){digit}+ { yylval->doubleVal = toFloatX(); /*sscanf(yytext,"S%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_SX: " << yylval->doubleVal  <<endl; 
	return token::KEY_SX;}


{digit}+"."{digit}+	|
"."{digit}+		|
{digit}+ 		{ yylval->doubleVal = toFloat();
				  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer NUMBER= "<< *yytext <<" lenght: "<< yyleng <<" doubleval: "<< setiosflags(ios::fixed) <<setprecision(4) << yylval->doubleVal <<endl;
				 return token::NUMBER;}
\-"."{digit}+	{ yylval->doubleVal = toFloat();
				  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer NUMBER= "<< *yytext <<" lenght: "<< yyleng <<" doubleval: "<< setiosflags(ios::fixed) <<setprecision(4) << yylval->doubleVal <<endl;
				 return token::NUMBER;}

{STR}[a-zA-Z_][a-zA-Z\-0-9_.]* { yylval->stringVal = new string(yytext, yyleng); 
SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer QUOTESTRING 3= "<<  yylval->stringVal->c_str() <<endl;
return token::QUOTESTRING; }			  

{STR}[a-zA-Z_\'][a-zA-Z\'\-0-9_.]*{STR} { yylval->stringVal = new string(yytext, yyleng); 
SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer QUOTESTRING 2= "<<  yylval->stringVal->c_str() <<endl;
return token::QUOTESTRING; }			  

{STR}		{yylval->stringVal = new string(yytext, yyleng);
			  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer QUOTESTRING= "<< yylval->stringVal->c_str() <<endl; 
			  return token::QUOTESTRING;}

         
"("		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
         return token_type (yytext[0]);}
")"		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<< yytext[0] <<endl;
         return token_type (yytext[0]);}
":"     {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  *yytext <<endl;
         return token_type (yytext[0]);}
"="      {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }
"."		 {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }
","		 {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }
\[	     {	SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
            return token_type (yytext[0]);  }
\]     {	SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
            return token_type (yytext[0]);  }
\/		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }

\~		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }
\$		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }
\+		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }  
\-		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }		 
\*		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }         
\>		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }  
\<		{SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }  
\% {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }
\! {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }    
"&" {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }  
"|" {SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer = "<<  yytext[0] <<endl;
           return token_type (yytext[0]); }      
"^" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_XOR" <<endl; 
	return token::CMD_XOR; }

 /* =============  FUNCTIONS ========================= */
 
(a|A)(c|C)(o|O)(s|S)  { yylval->stringVal = new string("acos"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(a|A)(s|S)(i|I)(n|N)  { yylval->stringVal = new string("asin"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(a|A)(t|T)(a|A)(n|N)  { yylval->stringVal = new string("atan"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
 
(a|A)(n|N)(i|I)(m|M)(e|E)(l|L)(e|E)(m|M)  { yylval->stringVal = new string("animelem"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}

(a|A)(b|B)(s|S)  { yylval->stringVal = new string("abs"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(a|A)(n|N)(i|I)(m|M)(e|E)(l|L)(e|E)(m|M)(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("animelemtime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(a|A)(n|N)(i|I)(m|M)(e|E)(l|L)(e|E)(m|M)(n|N)(o|O)  { yylval->stringVal = new string("animelemno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(a|A)(n|N)(i|I)(m|M)(e|E)(x|X)(i|I)(s|S)(t|T)  { yylval->stringVal = new string("animexist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}



(c|C)(o|O)(s|S)  { yylval->stringVal = new string("cos"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}

(c|C)(e|E)(i|I)(l|L)  { yylval->stringVal = new string("ceil"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(c|C)(o|O)(n|N)(s|S)(t|T)(2)(4)(0)(P|p)  { yylval->stringVal = new string("const240p"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_CONST: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(c|C)(o|O)(n|N)(s|S)(t|T)(4)(8)(0)(P|p)  { yylval->stringVal = new string("const480p"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_CONST: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(c|C)(o|O)(n|N)(s|S)(t|T)(7)(2)(0)(P|p)  { yylval->stringVal = new string("const720p"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_CONST: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}

(c|C)(o|O)(n|N)(s|S)(t|T)  { yylval->stringVal = new string("const"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_CONST: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_CONST;}


(e|E)(x|X)(p|P)  { yylval->stringVal = new string("exp"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}



(f|F)(l|L)(o|O)(o|O)(r|R)  { yylval->stringVal = new string("floor"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(f|F)(v|V)(a|A)(r|R)  { yylval->stringVal = new string("fvar"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_FVAR: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_FVAR;}


(g|G)(e|E)(t|T)(h|H)(i|I)(t|T)(v|V)(a|A)(r|R)  { yylval->stringVal = new string("gethitvar"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}



(i|F)(f|F)(e|E)(l|L)(s|S)(e|E)  { yylval->stringVal = new string("ifelse"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IFELSE: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IFELSE;}
(i|I)(s|S)(h|H)(e|E)(l|L)(p|P)(e|E)(r|R)  { yylval->stringVal = new string("ishelper"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str() <<endl; 
	return token::FUNC_IDENTIFIER;}


(l|L)(n|N)  { yylval->stringVal = new string("ln"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(l|O)(o|O)(g|G)  { yylval->stringVal = new string("log"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_LOG: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_LOG;}




(n|N)(u|U)(m|M)(p|P)(r|R)(o|O)(j|J)(i|I)(d|D)  { yylval->stringVal = new string("numprojid"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}
(n|N)(u|U)(m|M)(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)  { yylval->stringVal = new string("numtarget"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER; }                             
(n|N)(u|U)(m|M)(e|E)(x|X)(p|P)(l|L)(o|O)(d|D) { yylval->stringVal = new string("numexplod");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER; }                              
(n|N)(u|U)(m|M)(h|H)(e|E)(l|L)(p|P)(e|E)(r|R) { yylval->stringVal = new string("numhelper");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER; }                              


(p|P)(r|R)(o|O)(j|J)(g|G)(u|U)(a|A)(r|R)(d|D)(e|E)(d|D)(t|T)(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("projguardedtime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::FUNC_IDENTIFIER;}

(p|P)(r|R)(o|O)(j|J)(h|H)(i|I)(t|T){digit}+ { yylval->doubleVal = toFloatX(); /* sscanf(yytext,"%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_PROJHIT: " << yylval->doubleVal  <<endl; 
	return token::FUNC_PROJHIT;}
(p|P)(r|R)(o|O)(j|J)(h|H)(i|I)(t|T) { yylval->doubleVal = 0; /* sscanf(yytext,"%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_PROJHIT: " << yylval->doubleVal  <<endl; 
	return token::FUNC_PROJHIT;}
	
(p|P)(r|R)(o|O)(j|J)(g|G)(u|U)(a|A)(r|R)(d|D)(e|E)(d|D){digit}+ { yylval->doubleVal = toFloatX(); /* sscanf(yytext,"F%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_PROJGUARDED: " << yylval->doubleVal  <<endl; 
	return token::FUNC_PROJGUARDED;}
(p|P)(r|R)(o|O)(j|J)(g|G)(u|U)(a|A)(r|R)(d|D)(e|E)(d|D) { yylval->doubleVal = 0; /* sscanf(yytext,"%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_PROJGUARDED: " << yylval->doubleVal  <<endl; 
	return token::FUNC_PROJGUARDED;}
(p|P)(r|R)(o|O)(j|J)(h|H)(i|I)(t|T)(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("projhittime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}
(p|P)(r|R)(o|O)(j|J)(c|C)(o|O)(n|N)(t|T)(a|A)(c|C)(t|T){digit}+ { yylval->doubleVal = toFloatX(); /* sscanf(yytext,"%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_PROJCONTACT: " << yylval->doubleVal  <<endl; 
	return token::FUNC_PROJCONTACT;}
(p|P)(r|R)(o|O)(j|J)(c|C)(o|O)(n|N)(t|T)(a|A)(c|C)(t|T)  { yylval->doubleVal = 0; /* sscanf(yytext,"F%d",&yylval->doubleVal); */SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_PROJCONTACT: " << yylval->doubleVal  <<endl; 
	return token::FUNC_PROJCONTACT;}
(p|P)(r|R)(o|O)(j|J)(c|C)(o|O)(n|N)(t|T)(a|A)(c|C)(t|T)(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("projcontacttime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}
(p|P)(r|R)(o|O)(j|J)(c|C)(a|A)(n|N)(c|C)(e|E)(l|L)(t|T)(i|I)(m|M)(e|E)    { yylval->stringVal = new string("projcanceltime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}
(p|P)(l|L)(a|A)(y|Y)(e|E)(r|R)(i|I)(d|D)(e|E)(x|X)(i|I)(s|S)(t|T)    { yylval->stringVal = new string("playeridexist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}


(s|S)(e|E)(l|L)(f|F)(a|A)(n|N)(i|I)(m|M)(e|E)(x|X)(i|I)(s|S)(t|T)  { yylval->stringVal = new string("selfanimexist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}
(s|S)(y|Y)(s|S)(f|F)(v|V)(a|A)(r|R)  { yylval->stringVal = new string("sysfvar"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}
(s|S)(i|I)(n|N)  { yylval->stringVal = new string("sin"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}

(s|S)(y|Y)(s|S)(v|V)(a|A)(r|R)  { yylval->stringVal = new string("sysvar"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_SYSVAR" <<endl; 
	return token::FUNC_SYSVAR;}




(t|T)(a|A)(n|N)  { yylval->stringVal = new string("tan"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}

(t|T)(i|I)(m|M)(e|E)(m|M)(o|O)(d|D)  { yylval->stringVal = new string("timemod"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}

[tT][eE][aA][mM][mM][oO][dD][eE] { yylval->stringVal = new string("teammode"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_IDENTIFIER" <<endl; 
	return token::FUNC_IDENTIFIER;}   

(v|V)(a|A)(r|R) { yylval->stringVal = new string("var"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "FUNC_VAR" <<endl; 
	return token::FUNC_VAR;}

  /* =============  ESPECIAL COMMANDS ========================= */
 
(c|C)(o|O)(m|M)(m|M)(a|A)(n|N)(d|D).(b|B)(u|U)(f|F)(f|F)(e|E)(r|R).(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("command.buffer.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str() <<endl; 
	return token::KEY_IDENTIFIER;}

(c|C)(o|O)(m|M)(m|M)(a|A)(n|N)(d|D).(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("command.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str() <<endl; 
	return token::KEY_IDENTIFIER;}

(c|C)(o|O)(m|M)(m|M)(a|A)(n|N)(d|D)  { yylval->stringVal = new string("command"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str() <<endl; 
	return token::KEY_IDENTIFIER;}

(s|S)(t|T)(a|A)(t|T)(e|E)(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("statetype");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATETYPE" <<endl; 
	return token::KEY_STATETYPE; }

(p|P)(h|H)(y|Y)(s|S)(i|I)(c|C)(s|S) { yylval->stringVal = new string("physics");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_PHYSICS" <<endl; 
	return token::KEY_PHYSICS; }

		  


(S|s)(T|t)(a|A)(T|t)(e|E) { yylval->stringVal = new string("state"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: CMD_STATE" <<endl; 
	return token::CMD_STATE;}
(S|s)(T|t)(a|A)(T|t)(e|E)(D|d)(E|e)(F|f) { yylval->stringVal = new string("statedef");	SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: CMD_STATEDEF" <<endl; 
		  return token::CMD_STATEDEF;}			  
			  
 /* =============  KEY_IDENTIFIER ========================= */

(a|A)(c|C)(c|C)(e|E)(l|L)  { yylval->stringVal = new string("accel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(d|D)(d|D)  { yylval->stringVal = new string("add"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(m|M)(p|P)(l|L) { yylval->stringVal = new string("ampl"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(n|N)(i|I)(m|M) { yylval->stringVal = new string("anim"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_ANIM: "<< yylval->stringVal->c_str() <<endl; 
	return token::KEY_ANIM;}
(a|A)(t|T)(t|T)(a|A)(c|C)(k|K) { yylval->stringVal = new string("attack"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
	

(a|A)(f|F)(f|F)(e|E)(c|C)(t|T)(t|T)(e|E)(a|A)(m|M)   { yylval->stringVal = new string("affectteam"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}


(a|A)(i|I)(r|R).(b|B)(a|A)(c|C)(k|K)  { yylval->stringVal = new string("air.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(f|F)(r|R)(o|O)(n|N)(t|T) { yylval->stringVal = new string("air.front"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R) { yylval->stringVal = new string("air.gethit.groundrecover"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(m|M)(u|U)(l|L) { yylval->stringVal = new string("air.gethit.airrecover.mul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(a|A)(d|D)(d|D) { yylval->stringVal = new string("air.gethit.airrecover.add"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("air.gethit.airrecover.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(f|F)(w|W)(d|D) { yylval->stringVal = new string("air.gethit.airrecover.fwd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(u|U)(p|P) {  yylval->stringVal = new string("air.gethit.airrecover.up");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(d|D)(o|O)(w|W)(n|N) { yylval->stringVal = new string("air.gethit.airrecover.down"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("air.gethit.groundlevel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("air.gethit.groundrecover.ground.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("air.gethit.groundrecover.groundlevel");  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("air.gethit.airrecover.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(y|Y)(a|A)(c|C)(c|C)(e|E)(l|L) { yylval->stringVal = new string("air.gethit.airrecover.yaccel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(t|T)(r|R)(i|I)(p|P).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("air.gethit.trip.groundlevel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(n|N)(u|U)(m|M) { yylval->stringVal = new string("airjump.num"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(h|H)(e|E)(i|I)(g|G)(h|H)(t|T) { yylval->stringVal = new string("airjump.height"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(n|N)(e|E)(u|U) { yylval->stringVal = new string("airjump.neu"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("airjump.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(f|F)(w|W)(d|D) { yylval->stringVal = new string("airjump.fwd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
	
(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P)   { yylval->stringVal = new string("airjump"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(i|I)(r|R)(j|J)(u|U)(g|G)(g|G)(l|L)(e|E)  { yylval->stringVal = new string("airjuggle"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R)  { yylval->stringVal = new string("air"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(l|L)(i|I)(v|V)(e|E) { yylval->stringVal = new string("alive");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }

(a|A)(n|N)(i|I)(m|M)(t|T)(i|I)(m|M)(e|E)      {yylval->stringVal = new string("animtime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                          
(a|A)(t|T)(t|T)(a|A)(c|C)(k|K).(d|D)(i|I)(s|S)(t|T) {yylval->stringVal = new string("attack.dist");  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(t|T)(t|T)(r|R) { yylval->stringVal = new string("attr"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(a|A)(u|U)(t|T)(h|H)(o|O)(r|R)(n|N)(a|A)(m|M)(e|E)   {yylval->stringVal = new string("authorname"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                          

(b|B)(a|A)(c|C)(k|K)(e|E)(e|E)(d|D)(g|G)(e|E)(b|B)(o|O)(d|D)(y|Y)(d|D)(i|I)(s|S)(t|T)  { yylval->stringVal = new string("backedgebodydist");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                     
(b|B)(a|A)(c|C)(k|K)(e|E)(d|D)(g|G)(e|E)(d|D)(i|I)(s|S)(t|T)   {yylval->stringVal = new string("backedgedist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                         

(b|B)(i|I)(n|N)(d|D)(t|T)(i|I)(m|M)(e|E)   { yylval->stringVal = new string("bindtime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(b|B)(u|U)(f|F)(f|F)(e|E)(r|R).(t|T)(i|I)(m|M)(e|E)   { yylval->stringVal = new string("buffer.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
	
(b|B)(u|U)(f|F)(f|F)(e|E)(r|R)   { yylval->stringVal = new string("buffer"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}




(c|C)(o|O)(l|L)(o|O)(r|R)  { yylval->stringVal = new string("color");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               

(c|C)(t|T)(r|R)(l|L)     {yylval->stringVal = new string("ctrl"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               
(c|C)(r|R)(o|O)(u|U)(c|C)(h|H).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("crouch.friction.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER;}" <<endl; 
	return token::KEY_IDENTIFIER;}
(c|C)(r|R)(o|O)(u|U)(c|C)(h|H).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N) { yylval->stringVal = new string("crouch.friction"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER;}" <<endl; 
	return token::KEY_IDENTIFIER;}

(c|C)(r|R)(o|O)(u|U)(c|C)(h|H)  { yylval->stringVal = new string("crouch"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(c|C)(a|A)(n|N)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R)  { yylval->stringVal = new string("canrecover");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                                             
 

(d|D)(e|E)(f|F)(e|E)(n|N)(c|C)(e|E) { yylval->stringVal = new string("defence"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;} 

(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E).(o|O)(f|F)(f|F)(s|S)(e|E)(t|T) { yylval->stringVal = new string("down.bounce.offset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E).(y|Y)(a|A)(c|C)(c|C)(e|E)(l|L) { yylval->stringVal = new string("down.bounce.yaccel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("down.bounce.groundlevel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(d|D)(o|O)(w|W)(n|N).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("down.friction.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(d|D)(r|R)(a|A)(w|W)(g|G)(a|A)(m|M)(e|E) { yylval->stringVal = new string("drawgame");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; } 

(d|D)(r|R)(a|A)(w|W).(o|O)(f|F)(f|F)(s|S)(e|E)(t|T) { yylval->stringVal = new string("draw.offset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(d|D)(r|R)(a|A)(w|W) {yylval->stringVal = new string("draw"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; } 

(f|F)(a|A)(c|C)(i|I)(n|N)(g|G)  { yylval->stringVal = new string("facing");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                
(f|F)(a|A)(l|L)(l|L).(d|D)(e|E)(f|F)(e|E)(n|N)(c|C)(e|E)_(u|U)(p|P) { yylval->stringVal = new string("fall.defence_up"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;} 
(f|F)(a|A)(l|L)(l|L).(d|D)(e|E)(f|F)(e|E)(n|N)(c|C)(e|E)_(m|M)(u|U)(l|L) { yylval->stringVal = new string("fall.defence_mul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(f|F)(a|A)(l|L)(l|L).(x|X)(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("fall.xvelocity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(f|F)(a|A)(l|L)(l|L).(y|Y)(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("fall.yvelocity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L)  { yylval->stringVal = new string("fall"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(o|O)(r|R)(c|C)(e|E)(s|S)(t|T)(a|A)(n|N)(d|D) { yylval->stringVal = new string("forcestand"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(o|O)(r|R)(c|C)(e|E)(n|N)(o|O)(f|F)(a|A)(l|L)(l|L) { yylval->stringVal = new string("forcenofall"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(c|C)(e|E)(p|P)(2)  { yylval->stringVal = new string("facep2"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(l|L)(o|O)(a|A)(t|T)(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T)(i|I)(n|N)(d|D)(e|E)(x|X) { yylval->stringVal = new string("floatpersistindex"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}	
(f|F)(r|R)(o|O)(n|N)(t|T)(e|E)(d|D)(g|G)(e|E)(b|B)(o|O)(d|D)(y|Y)(d|D)(i|I)(s|S)(t|T)  {yylval->stringVal = new string("frontedgebodydist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                     
(f|F)(r|R)(o|O)(n|N)(t|T)(e|E)(d|D)(g|G)(e|E)(d|D)(i|I)(s|S)(t|T)      { yylval->stringVal = new string("frontedgedist");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                     
(f|F)(v|V)(a|A)(l|L)(u|U)(e|E) { yylval->stringVal = new string("fvalue"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(f|F)(r|R)(e|E)(q|Q)  { yylval->stringVal = new string("freq"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}



(g|G)(a|A)(m|M)(e|E)(t|T)(i|I)(m|M)(e|E)   { yylval->stringVal = new string("gametime");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }    
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(b|B)(a|A)(c|C)(k|K) {yylval->stringVal = new string("ground.back");  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(f|F)(r|R)(o|O)(n|N)(t|T)  { yylval->stringVal = new string("ground.front"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)  { yylval->stringVal = new string("ground"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(g|G)(u|U)(a|A)(r|R)(d|D).(s|S)(p|P)(a|A)(r|R)(k|K)(n|N)(o|O) { yylval->stringVal = new string("guard.sparkno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(g|G)(u|U)(a|A)(r|R)(d|D)(f|F)(l|L)(a|A)(g|G) { yylval->stringVal = new string("guardflag"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(g|G)(u|U)(a|A)(r|R)(d|D).(p|P)(a|A)(u|U)(s|S)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("guard.pausetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(u|U)(a|A)(r|R)(d|D)(s|S)(o|O)(u|U)(n|N)(d|D) { yylval->stringVal = new string("guardsound"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("ground.type"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
         
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(s|S)(l|L)(i|I)(d|D)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("ground.slidetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(g|G)(u|U)(a|A)(r|R)(d|D).(s|S)(l|L)(i|I)(d|D)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("guard.slidetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(h|H)(i|I)(t|T)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("ground.hittime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(u|U)(a|A)(r|R)(d|D).(h|H)(i|I)(t|T)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("guard.hittime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(e|E)(t|T)(p|P)(o|O)(w|W)(e|E)(r|R) { yylval->stringVal = new string("getpower "); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(g|G)(i|I)(v|V)(e|E)(p|P)(o|O)(w|W)(e|E)(r|R) { yylval->stringVal = new string("givepower"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
     
(g|G)(u|U)(a|A)(r|R)(d|D).(c|C)(t|T)(r|R)(l|L)(t|T)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("guard.ctrltime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(u|U)(a|A)(r|R)(d|D).(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("guard.dist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("ground.velocity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(u|U)(a|A)(r|R)(d|D).(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("guard.velocity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(g|G)(u|U)(a|A)(r|R)(d|D).(k|K)(i|I)(l|L)(l|L) { yylval->stringVal = new string("guard.kill"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
	
(g|G)(u|U)(a|A)(r|R)(d|D)  { yylval->stringVal = new string("guard"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

	
(h|H)(e|E)(i|I)(g|G)(h|H)(t|T)  { yylval->stringVal = new string("height"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(h|H)(e|E)(a|A)(d|D).(p|P)(o|O)(s|S) { yylval->stringVal = new string("head.pos"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

	
(h|H)(e|E)(a|A)(d|D)  { yylval->stringVal = new string("head"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(h|H)(i|I)(t|T)(o|O)(n|N)(c|C)(e|E) { yylval->stringVal = new string("hitonce"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(h|H)(i|I)(t|T)(c|C)(o|O)(u|U)(n|N)(t|T)(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T)  { yylval->stringVal = new string("hitcountpersist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(h|H)(i|I)(t|T)(d|D)(e|E)(f|F)(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T)  { yylval->stringVal = new string("hitdefpersist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(h|H)(i|I)(t|T)(c|C)(o|O)(u|U)(n|N)(t|T) {yylval->stringVal = new string("hitcount"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                
(h|H)(i|I)(t|T)(f|F)(a|A)(l|L)(l|L)  { yylval->stringVal = new string("hitfall");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               
(h|H)(i|I)(t|T)(f|F)(l|L)(a|A)(g|G) { yylval->stringVal = new string("hitflag");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }
	(h|H)(i|I)(t|T)(o|O)(v|V)(e|E)(r|R)  {yylval->stringVal = new string("hitover"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               
(h|H)(i|I)(t|T)(p|P)(a|A)(u|U)(s|S)(e|E)(t|T)(i|I)(m|M)(e|E)  {yylval->stringVal = new string("hitpausetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                          
(h|H)(i|I)(t|T)(s|S)(h|H)(a|A)(k|K)(e|E)(o|O)(v|V)(e|E)(r|R)  {yylval->stringVal = new string("hitshakeover"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                          
(h|H)(i|I)(t|T)(s|S)(o|O)(u|U)(n|N)(d|D) { yylval->stringVal = new string("hitsound"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(h|H)(i|I)(t|T)(v|V)(e|E)(l|L)  {yylval->stringVal = new string("hitvel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                          

(i|I)(d|D)  { yylval->stringVal = new string("id"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(i|I)(n|N)(g|G)(u|U)(a|A)(r|R)(d|D)(d|D)(i|I)(s|S)(t|T)  { yylval->stringVal = new string("inguarddist");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }

(i|I)(n|N)(t|T)(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T)(i|I)(n|N)(d|D)(e|E)(x|X)  { yylval->stringVal = new string("intpersistindex"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(i|I)(g|G)(n|N)(o|O)(r|R)(e|E)(h|H)(i|I)(t|T)(p|P)(a|A)(u|U)(s|S)(e|E) { yylval->stringVal = new string("ignorehitpause"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(i|I)(n|N)(t|T)(e|E)(r|R)(v|V)(a|A)(l|L)(l|L) { yylval->stringVal = new string("interval"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(i|I)(s|S)(h|H)(o|O)(m|M)(e|E)(t|T)(e|E)(a|A)(m|M)   { yylval->stringVal = new string("ishometeam");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                           


(j|J)(u|U)(g|G)(g|G)(l|L)(e|E) { yylval->stringVal = new string("juggle"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(j|J)(u|U)(m|M)(p|P).(c|C)(h|H)(a|A)(n|N)(g|G)(e|E)(a|A)(n|N)(i|I)(m|M).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("jump.changeanim.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::KEY_IDENTIFIER;}

(j|J)(u|U)(m|M)(p|P).(n|N)(e|E)(u|U) { yylval->stringVal = new string("jump.neu"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(j|J)(u|U)(m|M)(p|P).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("jump.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(j|J)(u|U)(m|M)(p|P).(f|F)(w|W)(d|D) { yylval->stringVal = new string("jump.fwd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(j|J)(u|U)(m|M)(p|P)  { yylval->stringVal = new string("jump"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(k|K)(i|I)(l|L)(l|L) { yylval->stringVal = new string("kill"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(k|K)(o|O).(e|E)(c|C)(h|H)(o|O) { yylval->stringVal = new string("KO.echo"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(k|K)(o|O)  { yylval->stringVal = new string("ko"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

	
(l|L)(i|I)(e|E)(d|D)(o|O)(w|W)(n|N).(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("liedown.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(l|L)(i|I)(e|E)(d|D)(o|O)(w|W)(n|N)  { yylval->stringVal = new string("liedown"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(l|L)(i|I)(f|F)(e|E)(m|M)(a|A)(x|X) { yylval->stringVal = new string("lifemax");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                
(l|L)(i|I)(f|F)(e|E)   {yylval->stringVal = new string("life"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                   
(l|L)(o|O)(s|S)(e|E)(k|K)(o|O)  { yylval->stringVal = new string("loseko");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               
(l|L)(o|O)(s|S)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("losetime");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               
(l|L)(o|O)(s|S)(e|E)   { yylval->stringVal = new string("lose");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                 



(m|M)(a|A)(t|T)(c|C)(h|H)(n|N)(o|O) { yylval->stringVal = new string("matchno");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                
(m|M)(a|A)(t|T)(c|C)(h|H)(o|O)(v|V)(e|E)(r|R) {yylval->stringVal = new string("matchover"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                              
(m|M)(a|A)(x|X)(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("maxdist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(m|M)(i|I)(n|N)(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("mindist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(m|M)(i|I)(d|D).(p|P)(o|O)(s|S) { yylval->stringVal = new string("mid.pos"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(m|M)(i|I)(d|D)  { yylval->stringVal = new string("mid"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(m|M)(o|O)(v|V)(e|E)(h|H)(i|I)(t|T)(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T) { yylval->stringVal = new string("movehitpersist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(m|M)(o|O)(v|V)(e|E)(g|G)(u|U)(a|A)(r|R)(d|D)(e|E)(d|D) { yylval->stringVal = new string("moveguarded");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                            
(m|M)(o|O)(v|V)(e|E)(h|H)(i|I)(t|T)    { yylval->stringVal = new string("movehit");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                             
(m|M)(o|O)(v|V)(e|E)(r|R)(e|E)(v|V)(e|E)(r|R)(s|S)(e|E)(d|D)  { yylval->stringVal = new string("movereversed");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                           
(m|M)(o|O)(v|V)(e|E)(c|C)(o|O)(n|N)(t|T)(a|A)(c|C)(t|T)  { yylval->stringVal = new string("movecontact"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(m|M)(o|O)(v|V)(e|E)(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("movetype");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }

(m|M)(u|U)(l|L)  { yylval->stringVal = new string("mul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
	

	
(n|N)(a|A)(m|M)(e|E)  { yylval->stringVal = new string("name"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(n|N)(o|O)(c|C)(h|H)(a|A)(i|I)(n|N)(i|I)(d|D) { yylval->stringVal = new string("nochainID"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(n|N)(u|U)(m|M)(e|E)(n|N)(e|E)(m|M)(y|Y) {yylval->stringVal = new string("numenemy"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               
(n|N)(u|U)(m|M)(h|H)(i|I)(t|T)(s|S) { yylval->stringVal = new string("numhits"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(n|N)(u|U)(m|M)(p|P)(a|A)(r|R)(t|T)(n|N)(e|E)(r|R) {yylval->stringVal = new string("numpartner"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                             
(n|N)(u|U)(m|M)(p|P)(r|R)(o|O)(j|J)  { yylval->stringVal = new string("numproj");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                               

(p|P)(a|A)(u|U)(s|S)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("pausetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T)(e|E)(n|N)(t|T)  { yylval->stringVal = new string("persistent"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
	
(p|P)(o|O)(s|S)(t|T)(y|Y)(p|P)(e|E)  { yylval->stringVal = new string("postype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(p|P)(o|O)(s|S)  { yylval->stringVal = new string("pos"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(p|P)(r|R)(i|I)(o|O)(r|R)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("priority"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(p|P)(r|R)(o|O)(j|J) { yylval->stringVal = new string("proj"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(p|P)(r|R)(o|O)(j|J).(a|A)(t|T)(t|T)(a|A)(c|C)(k|K).(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("proj.attack.dist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(p|P)(r|R)(o|O)(j|J).(d|D)(o|O)(s|S)(c|C)(a|A)(l|L)(e|E) { yylval->stringVal = new string("proj.doscale"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(p|P)(1)(i|I)(d|D)  { yylval->stringVal = new string("p1id"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                  
(p|P)(1)(n|N)(a|A)(m|M)(e|E) { yylval->stringVal = new string("p1name"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;} 
(p|P)(2)(b|B)(o|O)(d|D)(y|Y)(d|D)(i|I)(s|S)(t|T)   { yylval->stringVal = new string("p2bodydist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                               

(p|P)(2)(d|D)(i|I)(s|S)(t|T)   { yylval->stringVal = new string("p2dist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                               
(p|P)(2)(l|L)(i|I)(f|F)(e|E)   { yylval->stringVal = new string("p2life"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                               
(p|P)(2)(n|N)(a|A)(m|M)(e|E)  { yylval->stringVal = new string("p2name"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                
(p|P)(2)(s|S)(t|T)(a|A)(t|T)(e|E)(n|N)(o|O)  { yylval->stringVal = new string("p2stateno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                             
(p|P)(3)(n|N)(a|A)(m|M)(e|E)      { yylval->stringVal = new string("p3name"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                            
(p|P)(4)(n|N)(a|A)(m|M)(e|E)   { yylval->stringVal = new string("p4name"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                               
(p|P)(1)(s|S)(p|P)(r|R)(p|P)(r|R)(i|I)(o|O)(r|R)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("p1sprpriority"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(p|P)(2)(s|S)(p|P)(r|R)(p|P)(r|R)(i|I)(o|O)(r|R)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("p2sprpriority"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
  
(p|P)(1)(f|F)(a|A)(c|C)(i|I)(n|N)(g|G) { yylval->stringVal = new string("p1facing"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(p|P)(1)(g|G)(e|E)(t|T)(p|P)2(f|F)(a|A)(c|C)(i|I)(n|N)(g|G) { yylval->stringVal = new string("p1getp2facing"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(p|P)(2)(f|F)(a|A)(c|C)(i|I)(n|N)(g|G) { yylval->stringVal = new string("p2facing"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(p|P)(1)(s|S)(t|T)(a|A)(t|T)(e|E)(n|N)(o|O) { yylval->stringVal = new string("p1stateno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(p|P)(2)(g|G)(e|E)(t|T)(p|P)(1)(s|S)(t|T)(a|A)(t|T)(e|E) { yylval->stringVal = new string("p2getp1state"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(p|P)(a|A)(l|L)(n|N)(o|O)   { yylval->stringVal = new string("palno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                
(p|P)(i|I) { yylval->stringVal = new string("pi"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                     
(p|P)(r|R)(e|E)(v|V)(s|S)(t|T)(a|A)(t|T)(e|E)(n|N)(o|O) { yylval->stringVal = new string("prevstateno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                            
(p|P)(o|O)(w|W)(e|E)(r|R)(m|M)(a|A)(x|X) { yylval->stringVal = new string("powermax"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                               

(p|P)(o|O)(w|W)(e|E)(r|R)  {yylval->stringVal = new string("power"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }

(p|P)(2)(s|S)(t|T)(a|A)(t|T)(e|E)(t|T)(y|Y)(p|P)(e|E) {yylval->stringVal = new string("p2statetype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }
(p|P)(2)(b|B)(o|O)(d|D)(y|Y)(t|T)(y|Y)(p|P)(e|E)  {yylval->stringVal = new string("p2bodytype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(p|P)(2)(m|M)(o|O)(v|V)(e|E)(t|T)(y|Y)(p|P)(e|E)  { yylval->stringVal = new string("p2movetype");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}



(r|R)(a|A)(n|N)(d|D)(o|O)(m|M) { yylval->stringVal = new string("random");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                 

(r|R)(e|E)(m|M)(o|O)(v|V)(e|E)(t|T)(y|Y)(m|M)(e|E) {yylval->stringVal = new string("removetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                 

(r|R)(u|U)(n|N).(f|F)(w|W)(d|D) { yylval->stringVal = new string("run.fwd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(r|R)(u|U)(n|N).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("run.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(r|R)(u|U)(n|N) { yylval->stringVal = new string("run"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(r|R)(u|U)(n|N)(j|J)(u|U)(m|M)(p|P) { yylval->stringVal = new string("runjump"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(r|R)(o|O)(u|U)(n|N)(d|D)(n|N)(o|O) {yylval->stringVal = new string("roundno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                                
(r|R)(o|O)(u|U)(n|N)(d|D)(s|S)(e|E)(x|X)(i|I)(s|S)(t|T)(e|E)(d|D)  {yylval->stringVal = new string("roundsexisted"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                         
(r|R)(o|O)(u|U)(n|N)(d|D)(s|S)(t|T)(a|A)(t|T)(e|E) {yylval->stringVal = new string("roundstate"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                             

(r|R)(o|O)(o|O)(t|T)(d|D)(i|I)(s|S)(t|T) {yylval->stringVal = new string("rootdist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER; }                             

(r|R)(u|U)(n|N)(j|J)(u|U)(m|M)(p|P).(n|N)(e|E)(u|U) { yylval->stringVal = new string("runjump.neu"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(r|R)(u|U)(n|N)(j|J)(u|U)(m|M)(p|P).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("runjump.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(r|R)(u|U)(n|N)(j|J)(u|U)(m|M)(p|P).(f|F)(w|W)(d|D) { yylval->stringVal = new string("runjump.fwd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

			  

(s|S)(c|C)(e|E)(e|E)(n|N)(p|P)(o|O)(s|S) { yylval->stringVal = new string("screenpos"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(s|S)(h|H)(a|A)(d|D)(o|O)(w|W)(o|O)(f|F)(f|F)(s|S)(e|E)(t|T) { yylval->stringVal = new string("shadowoffset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(i|I)(m|M)(u|U)(l|L) { yylval->stringVal = new string("simul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(s|S)(i|I)(n|N)(a|A)(d|D)(d|D) { yylval->stringVal = new string("sinadd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(i|I)(n|N)(g|G)(l|L)(e|E) { yylval->stringVal = new string("single"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(n|N)(a|A)(p|P) { yylval->stringVal = new string("snap"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(p|P)(a|A)(r|R)(k|K)(n|N)(o|O) { yylval->stringVal = new string("sparkno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(t|T)(a|A)(t|T)(e|E)(n|N)(o|O)  { yylval->stringVal = new string("stateno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(s|S)(p|P)(a|A)(c|C)(i|I)(n|N)(g|G) { yylval->stringVal = new string("spacing"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(s|S)(p|P)(a|A)(r|R)(k|K)(x|X)(y|Y) { yylval->stringVal = new string("sparkxy"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(s|S)(t|T)(a|A)(t|T)(e|E)(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("statetime");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(t|T)(a|A)(n|N)(d|D).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N) { yylval->stringVal = new string("stand.friction"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER;}" <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(t|T)(a|A)(n|N)(d|D).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("stand.friction.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER;}" <<endl; 
	return token::KEY_IDENTIFIER;}

(s|S)(t|T)(a|A)(n|N)(d|D) { yylval->stringVal = new string("stand"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal <<endl; 
	return token::KEY_IDENTIFIER;}
	
(t|T)(i|I)(m|M)(e|E)  { yylval->stringVal = new string("time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal <<endl; 
	return token::KEY_IDENTIFIER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(1)  { yylval->stringVal = new string("trigger1"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(2)  { yylval->stringVal = new string("trigger2"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(3)  { yylval->stringVal = new string("trigger3"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(4)  { yylval->stringVal = new string("trigger4"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(5)  { yylval->stringVal = new string("trigger5"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(6)  { yylval->stringVal = new string("trigger6"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(7)  { yylval->stringVal = new string("trigger7"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(8)  { yylval->stringVal = new string("trigger8"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}
(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(9)  { yylval->stringVal = new string("trigger9"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGER: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGER;}

(t|T)(r|R)(i|I)(g|G)(g|G)(e|E)(r|R)(a|A)(l|L)(l|L)  { yylval->stringVal = new string("triggerall"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_TRIGGERALL: " << *yylval->stringVal <<endl; 
	return token::KEY_TRIGGERALL;}

(t|T)(y|Y)(p|P)(e|E)  { yylval->stringVal = new string("type"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal<<endl; 
	return token::KEY_IDENTIFIER;}
(t|T)(e|E)(a|A)(m|M)(s|S)(i|I)(d|D)(e|E)  { yylval->stringVal = new string("teamside"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal <<endl; 
	return token::KEY_IDENTIFIER;}                              
(t|T)(i|I)(c|C)(k|K)(s|S)(p|P)(e|E)(r|R)(s|S)(e|E)(c|C)(o|O)(n|N)(d|D)  { yylval->stringVal = new string("tickspersecond"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal <<endl; 
	return token::KEY_IDENTIFIER;}                        
(t|T)(i|I)(m|M)(e|E)(m|M)(o|O)(d|D)(e|E)  { yylval->stringVal = new string("timemode"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal <<endl; 
	return token::KEY_IDENTIFIER;}                              
(t|T)(u|U)(r|R)(n|N)(s|S)  { yylval->stringVal = new string("turns"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal <<endl; 
	return token::KEY_IDENTIFIER;}                              


(u|U)(n|N)(i|I)(q|Q)(h|H)(i|I)(t|T)(c|C)(o|O)(u|U)(n|N)(t|T)   { yylval->stringVal = new string("uniqhitcount"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: " << *yylval->stringVal <<endl; 
	return token::KEY_IDENTIFIER;}

(u|U)(n|N)(d|D)(e|E)(r|R) { yylval->stringVal = new string("under"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}





(v|V)(a|A)(l|L)(u|U)(e|E)(2)  { yylval->stringVal = new string("value2"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(v|V)(a|A)(l|L)(u|U)(e|E)  { yylval->stringVal = new string("value"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(v|V)(o|O)(l|L)(u|U)(m|M)(e|E) { yylval->stringVal = new string("volume"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}


(w|W)(a|A)(l|L)(k|K).(f|F)(w|W)(d|D) { yylval->stringVal = new string("walk.fwd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(w|W)(a|A)(l|L)(k|K).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("walk.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(w|W)(a|A)(l|L)(k|K) { yylval->stringVal = new string("walk"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(w|W)(a|A)(v|V)(e|E)(f|F)(o|O)(r|R)(m|M) { yylval->stringVal = new string("waveform"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(w|W)(i|I)(n|N) { yylval->stringVal = new string("win"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                    
(w|W)(i|I)(n|N)(k|K)(o|O)  { yylval->stringVal = new string("winko"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                 

(w|W)(i|I)(n|N)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("wintime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                    
(w|W)(i|I)(n|N)(k|K)(o|O)(p|P)(e|E)(r|R)(f|F)(e|E)(c|C)(t|T)  { yylval->stringVal = new string("winperfect"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}                                 


(x|X)(s|S)(c|C)(a|A)(l|L)(e|E) { yylval->stringVal = new string("xscale"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}


(y|Y)(a|A)(c|C)(c|C)(e|E)(l|L) { yylval->stringVal = new string("yaccel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(y|Y)(s|S)(c|C)(a|A)(l|L)(e|E) { yylval->stringVal = new string("yscale"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_IDENTIFIER: "<< yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;} 
 
 /* =============  KEYWORD ========================= */


(h|H)(i|I)(t|T)(v|V)(e|E)(l|L)" "(x|X)  { yylval->stringVal = new string("hitvelx");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }                               
(h|H)(i|I)(t|T)(v|V)(e|E)(l|L)" "(y|Y)  {yylval->stringVal = new string("hitvely"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }                               



(p|P)(2)(d|D)(i|I)(s|S)(t|T)" "(x|X)  { yylval->stringVal = new string("p2distx"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD;}
(p|P)(2)(d|D)(i|I)(s|S)(t|T)" "(y|Y)  { yylval->stringVal = new string("p2disty"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD;}

[pP][2][bB][oO][dD][yY][dD][iI][sS][tT][ ][yY] {yylval->stringVal = new string("p2bodydisty"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }

[pP][2][bB][oO][dD][yY][dD][iI][sS][tT][ ][xX] { yylval->stringVal = new string("p2bodydistx");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }


[pP][aA][rR][eE][nN][tT][dD][iI][sS][tT][ ][yY] {yylval->stringVal = new string("parentdisty"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }

[pP][aA][rR][eE][nN][tT][dD][iI][sS][tT][ ][xX] { yylval->stringVal = new string("parentdistx");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }


(p|P)(o|O)(s|S)" "(x|X)  { yylval->stringVal = new string("posx"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD;}
(p|P)(o|O)(s|S)" "(y|Y)  { yylval->stringVal = new string("posy"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD;}

(r|R)(o|O)(o|O)(t|T)(d|D)(i|I)(s|S)(t|T)" "(x|X)	{ yylval->stringVal = new string("rootdistx");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }
(r|R)(o|O)(o|O)(t|T)(d|D)(i|I)(s|S)(t|T)" "(y|Y)	{ yylval->stringVal = new string("rootdisty");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }



(s|S)(c|C)(r|R)(e|E)(e|E)(n|N)(p|P)(o|O)(s|S)" "(x|X) { yylval->stringVal = new string("screenposx");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }

(s|S)(c|C)(r|R)(e|E)(e|E)(n|N)(p|P)(o|O)(s|S)" "(y|Y) { yylval->stringVal = new string("screenposy");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD; }



(V|v)(E|e)(l|L)" "(x|X)  { yylval->stringVal = new string("velx"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD;}
(V|v)(E|e)(l|L)" "(y|Y)  { yylval->stringVal = new string("vely"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD;}
(V|v)(E|e)(l|L)  { yylval->stringVal = new string("vel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEYWORD" <<endl; 
	return token::KEYWORD;}			  
			 
 /* =============  CONSTPARAM ========================= */



(d|D)(a|A)(t|T)(a|A).(l|L)(i|I)(f|F)(e|E)  {yylval->stringVal = new string("data.life");  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(p|P)(o|O)(w|W)(e|E)(r|R) { yylval->stringVal = new string("data.power"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(a|A)(t|T)(t|T)(a|A)(c|C)(k|K) { yylval->stringVal = new string("data.attack"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(d|D)(e|E)(f|F)(e|E)(n|N)(c|C)(e|E) { yylval->stringVal = new string("data.defence"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;} 
(d|D)(a|A)(t|T)(a|A).(f|F)(a|A)(l|L)(l|L).(d|D)(e|E)(f|F)(e|E)(n|N)(c|C)(e|E)_(u|U)(p|P) { yylval->stringVal = new string("data.fall.defence_up"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(f|F)(a|A)(l|L)(l|L).(d|D)(e|E)(f|F)(e|E)(n|N)(c|C)(e|E)_(m|M)(u|U)(l|L) { yylval->stringVal = new string("data.fall.defence_mul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(l|L)(i|I)(e|E)(d|D)(o|O)(w|W)(n|N).(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("data.liedown.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(a|A)(i|I)(r|R)(j|J)(u|U)(g|G)(g|G)(l|L)(e|E) { yylval->stringVal = new string("data.airjuggle"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(s|S)(p|P)(a|A)(r|R)(k|K)(n|N)(o|O) { yylval->stringVal = new string("data.sparkno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(g|G)(u|U)(a|A)(r|R)(d|D).(s|S)(p|P)(a|A)(r|R)(k|K)(n|N)(o|O) { yylval->stringVal = new string("data.guard.sparkno"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(k|K)(o|O).(e|E)(c|C)(h|H)(o|O) { yylval->stringVal = new string("data.KO.echo"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(i|I)(n|N)(t|T)(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T)(i|I)(n|N)(d|D)(e|E)(x|X) { yylval->stringVal = new string("data.IntPersistIndex"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(f|F)(l|L)(o|O)(a|A)(t|T)(p|P)(e|E)(r|R)(s|S)(i|I)(s|S)(t|T)(i|I)(n|N)(d|D)(e|E)(x|X) { yylval->stringVal = new string("data.FloatPersistIndex"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(d|D)(a|A)(t|T)(a|A).(v|V)(o|O)(l|L)(u|U)(m|M)(e|E) { yylval->stringVal = new string("data.volume"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}

	
	
	
(s|S)(i|I)(z|Z)(e|E).(x|X)(s|S)(c|C)(a|A)(l|L)(e|E) { yylval->stringVal = new string("size.xscale"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(y|Y)(s|S)(c|C)(a|A)(l|L)(e|E) { yylval->stringVal = new string("size.yscale"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("size.ground.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(f|F)(r|R)(o|O)(n|N)(t|T)  { yylval->stringVal = new string("size.ground.front"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(a|A)(i|I)(r|R).(b|B)(a|A)(c|C)(k|K)  { yylval->stringVal = new string("size.air.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(a|A)(i|I)(r|R).(f|F)(r|R)(o|O)(n|N)(t|T) { yylval->stringVal = new string("size.air.front"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(h|H)(e|E)(i|I)(g|G)(h|H)(t|T) { yylval->stringVal = new string("size.height"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(a|A)(t|T)(t|T)(a|A)(c|C)(k|K).(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("size.attack.dist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(p|P)(r|R)(o|O)(j|J).(a|A)(t|T)(t|T)(a|A)(c|C)(k|K).(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("size.proj.attack.dist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(p|P)(r|R)(o|O)(j|J).(d|D)(o|O)(s|S)(c|C)(a|A)(l|L)(e|E) { yylval->stringVal = new string("size.proj.doscale"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(h|H)(e|E)(a|A)(d|D).(p|P)(o|O)(s|S).(x|X) { yylval->stringVal = new string("size.head.pos.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(h|H)(e|E)(a|A)(d|D).(p|P)(o|O)(s|S).(y|Y) { yylval->stringVal = new string("size.head.pos.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(m|M)(i|I)(d|D).(p|P)(o|O)(s|S).(x|X) { yylval->stringVal = new string("size.mid.pos.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(m|M)(i|I)(d|D).(p|P)(o|O)(s|S).(y|Y) { yylval->stringVal = new string("size.mid.pos.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(s|S)(h|H)(a|A)(d|D)(o|O)(w|W)(o|O)(f|F)(f|F)(s|S)(e|E)(t|T) { yylval->stringVal = new string("size.shadowoffset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(d|D)(r|R)(a|A)(w|W).(o|O)(f|F)(f|F)(s|S)(e|E)(t|T).(x|X) { yylval->stringVal = new string("size.draw.offset.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(s|S)(i|I)(z|Z)(e|E).(d|D)(r|R)(a|A)(w|W).(o|O)(f|F)(f|F)(s|S)(e|E)(t|T).(y|Y) { yylval->stringVal = new string("size.draw.offset.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}


(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(w|W)(a|A)(l|L)(k|K).(f|F)(w|W)(d|D).(x|X) { yylval->stringVal = new string("velocity.walk.fwd.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(w|W)(a|A)(l|L)(k|K).(b|B)(a|A)(c|C)(k|K).(x|X) { yylval->stringVal = new string("velocity.walk.back.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(r|R)(u|U)(n|N).(f|F)(w|W)(d|D).(x|X) { yylval->stringVal = new string("velocity.run.fwd.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(r|R)(u|U)(n|N).(f|F)(w|W)(d|D).(y|Y) { yylval->stringVal = new string("velocity.run.fwd.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(r|R)(u|U)(n|N).(b|B)(a|A)(c|C)(k|K).(x|X) { yylval->stringVal = new string("velocity.run.back.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(r|R)(u|U)(n|N).(b|B)(a|A)(c|C)(k|K).(y|Y) { yylval->stringVal = new string("velocity.run.back.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(j|J)(u|U)(m|M)(p|P).(y|Y) { yylval->stringVal = new string("velocity.jump.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(r|R)(u|U)(n|N)(j|J)(u|U)(m|M)(p|P).(y|Y) { yylval->stringVal = new string("velocity.runjump.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(j|J)(u|U)(m|M)(p|P).(n|N)(e|E)(u|U).(x|X) { yylval->stringVal = new string("velocity.jump.neu.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(j|J)(u|U)(m|M)(p|P).(b|B)(a|A)(c|C)(k|K).(x|X) { yylval->stringVal = new string("velocity.jump.back.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(j|J)(u|U)(m|M)(p|P).(f|F)(w|W)(d|D).(x|X) { yylval->stringVal = new string("velocity.jump.fwd.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(r|R)(u|U)(n|N)(j|J)(u|U)(m|M)(p|P).(b|B)(a|A)(c|C)(k|K).(x|X) { yylval->stringVal = new string("velocity.runjump.back.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(r|R)(u|U)(n|N)(j|J)(u|U)(m|M)(p|P).(f|F)(w|W)(d|D).(x|X) { yylval->stringVal = new string("velocity.runjump.fwd.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(y|Y) { yylval->stringVal = new string("velocity.airjump.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(n|N)(e|E)(u|U).(x|X) { yylval->stringVal = new string("velocity.airjump.neu.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(b|B)(a|A)(c|C)(k|K).(x|X) { yylval->stringVal = new string("velocity.airjump.back.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(f|F)(w|W)(d|D).(x|X) { yylval->stringVal = new string("velocity.airjump.fwd.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(x|X) { yylval->stringVal = new string("velocity.air.gethit.groundrecover.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(y|Y) { yylval->stringVal = new string("velocity.air.gethit.groundrecover.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(m|M)(u|U)(l|L).(x|X) { yylval->stringVal = new string("velocity.air.gethit.airrecover.mul.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(m|M)(u|U)(l|L).(y|Y) { yylval->stringVal = new string("velocity.air.gethit.airrecover.mul.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(a|A)(d|D)(d|D).(x|X) { yylval->stringVal = new string("velocity.air.gethit.airrecover.add.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(a|A)(d|D)(d|D).(y|Y) { yylval->stringVal = new string("velocity.air.gethit.airrecover.add.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("velocity.air.gethit.airrecover.back"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(f|F)(w|W)(d|D) { yylval->stringVal = new string("velocity.air.gethit.airrecover.fwd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(u|U)(p|P) { yylval->stringVal = new string("velocity.air.gethit.airrecover.up"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(d|D)(o|O)(w|W)(n|N) { yylval->stringVal = new string("velocity.air.gethit.airrecover.down"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}

(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(n|N)(u|U)(m|M) { yylval->stringVal = new string("movement.airjump.num"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R)(j|J)(u|U)(m|M)(p|P).(h|H)(e|E)(i|I)(g|G)(h|H)(t|T) { yylval->stringVal = new string("movement.airjump.height"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(y|Y)(a|A)(c|C)(c|C)(e|E)(l|L) { yylval->stringVal = new string("movement.yaccel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(s|S)(t|T)(a|A)(n|N)(d|D).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N) { yylval->stringVal = new string("movement.stand.friction"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(c|C)(r|R)(o|O)(u|U)(c|C)(h|H).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N) { yylval->stringVal = new string("movement.crouch.friction"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(s|S)(t|T)(a|A)(n|N)(d|D).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("movement.stand.friction.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(c|C)(r|R)(o|O)(u|U)(c|C)(h|H).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("movement.crouch.friction.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(j|J)(u|U)(m|M)(p|P).(c|C)(h|H)(a|A)(n|N)(g|G)(e|E)(a|A)(n|N)(i|I)(m|M).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("movement.jump.changeanim.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("movement.air.gethit.groundlevel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("movement.air.gethit.groundrecover.ground.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("movement.air.gethit.groundrecover.groundlevel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("movement.air.gethit.airrecover.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(a|A)(i|I)(r|R)(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R).(y|Y)(a|A)(c|C)(c|C)(e|E)(l|L) { yylval->stringVal = new string("movement.air.gethit.airrecover.yaccel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(a|A)(i|I)(r|R).(g|G)(e|E)(t|T)(h|H)(i|I)(t|T).(t|T)(r|R)(i|I)(p|P).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("movement.air.gethit.trip.groundlevel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E).(o|O)(f|F)(f|F)(s|S)(e|E)(t|T).(x|X) { yylval->stringVal = new string("movement.down.bounce.offset.x"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E).(o|O)(f|F)(f|F)(s|S)(e|E)(t|T).(y|Y) { yylval->stringVal = new string("movement.down.bounce.offset.y"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E).(y|Y)(a|A)(c|C)(c|C)(e|E)(l|L) { yylval->stringVal = new string("movement.down.bounce.yaccel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E).(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(l|L)(e|E)(v|V)(e|E)(l|L) { yylval->stringVal = new string("movement.down.bounce.groundlevel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
(m|M)(o|O)(v|V)(e|E)(m|M)(e|E)(n|N)(t|T).(d|D)(o|O)(w|W)(n|N).(f|F)(r|R)(i|I)(c|C)(t|T)(i|I)(o|O)(n|N).(t|T)(h|H)(r|R)(e|E)(s|S)(h|H)(o|O)(l|L)(d|D) { yylval->stringVal = new string("movement.down.friction.threshold"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CONST_PARAM" <<endl; 
	return token::CONST_PARAM;}
 /* =============  HITDEFATTR AND PARAMS ========================= */

(h|H)(i|I)(t|T)(d|D)(e|E)(f|F)(a|A)(t|T)(t|T)(r|R)  { yylval->stringVal = new string("hitdefattr"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_HITDEF: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_HITDEF;}


  /* =============  GETHITVAR PARAM ========================= */


(a|A)(n|N)(i|I)(m|M)(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("animtype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R)(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("airtype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(c|C)(t|T)(r|R)(l|L)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("ctrltime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(c|C)(h|H)(a|A)(i|I)(n|N)(i|I)(d|D) { yylval->stringVal = new string("chainid"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(d|D)(a|A)(m|M)(a|A)(g|G)(e|E) { yylval->stringVal = new string("damage"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L)(c|C)(o|O)(u|U)(n|N)(t|T) { yylval->stringVal = new string("fallcount"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(d|D)(a|A)(m|M)(a|A)(g|G)(e|E) { yylval->stringVal = new string("fall.damage"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(x|X)(v|V)(e|E)(l|L) { yylval->stringVal = new string("fall.xvel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(y|Y)(v|V)(e|E)(l|L) { yylval->stringVal = new string("fall.yvel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R) { yylval->stringVal = new string("fall.recover"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("fall.recovertime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("fall.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(k|K)(i|I)(l|L)(l|L) { yylval->stringVal = new string("fall.kill"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("fall.envshake.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(f|F)(r|R)(e|E)(q|Q) { yylval->stringVal = new string("fall.envshake.freq"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(a|A)(m|M)(p|P)(l|L) { yylval->stringVal = new string("fall.envshake.ampl"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(f|F)(a|A)(l|L)(l|L).(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(p|P)(h|H)(a|A)(s|S)(e|E) { yylval->stringVal = new string("fall.envshake.phase"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D)(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("groundtype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(g|G)(u|U)(a|A)(r|R)(d|D)(e|E)(d|D) { yylval->stringVal = new string("guarded"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(h|H)(i|I)(t|T)(s|S)(h|H)(a|A)(k|K)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("hitshaketime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "GETHIT_PARAM" <<endl; 
	return token::KEY_IDENTIFIER;}
(h|H)(i|I)(t|T)(i|I)(d|D) { yylval->stringVal = new string("hitid"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(h|H)(i|I)(t|T)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("hittime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(i|I)(s|S)(b|B)(o|O)(u|U)(n|N)(d|D) { yylval->stringVal = new string("isbound"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(r|R)(e|E)(c|C)(o|O)(v|V)(e|E)(r|R)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("recovertime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(s|S)(l|L)(i|I)(d|D)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("slidetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(x|X)(o|O)(f|F)(f|F) { yylval->stringVal = new string("xoff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(z|Z)(o|O)(f|F)(f|F) { yylval->stringVal = new string("zoff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(x|X)(v|V)(e|E)(l|L) { yylval->stringVal = new string("xvel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(x|X)(v|V)(e|E)(l|L)(a|A)(d|D)(d|D) { yylval->stringVal = new string("xveladd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(y|Y)(o|O)(f|F)(f|F) { yylval->stringVal = new string("yoff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(y|Y)(v|V)(e|E)(l|L) { yylval->stringVal = new string("yvel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}
(y|Y)(v|V)(e|E)(l|L)(a|A)(d|D)(d|D) { yylval->stringVal = new string("yveladd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "(KEY_IDENTIFIER do tipo GETHIT_PARAM)" <<endl; 
	return token::KEY_IDENTIFIER;}




 /* =============  STATE CONTROLLERS ========================= */
(a|A)(f|F)(t|T)(e|E)(r|R)(i|I)(m|M)(a|A)(g|G)(e|E) { yylval->stringVal = new string("afterimage"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
 
(a|A)(f|F)(t|T)(e|E)(r|R)(i|I)(m|M)(a|A)(g|G)(e|E)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("afterimagetime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

        

(a|A)(l|L)(l|L)(p|P)(a|A)(l|L)(f|F)(x|X) { yylval->stringVal = new string("allpalfx"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(a|A)(n|N)(g|G)(l|L)(e|E)(a|A)(d|D)(d|D) { yylval->stringVal = new string("angleadd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
       
(a|A)(n|N)(g|G)(l|L)(e|E)(d|D)(r|R)(a|A)(w|W) { yylval->stringVal = new string("angledraw"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(a|A)(n|N)(g|G)(l|L)(e|E)(m|M)(u|U)(l|L) { yylval->stringVal = new string("anglemul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(a|A)(n|N)(g|G)(l|L)(e|E)(s|S)(e|E)(t|T) { yylval->stringVal = new string("angleset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(a|A)(p|P)(p|P)(e|E)(n|N)(d|D)(t|T)(o|O)(c|C)(l|L)(i|I)(p|P)(b|B)(o|O)(a|A)(r|R)(d|D) { yylval->stringVal = new string("appendtoclipboard"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(a|A)(s|S)(s|S)(e|E)(r|R)(t|T)(s|S)(p|P)(e|E)(c|C)(i|I)(a|A)(l|L) { yylval->stringVal = new string("assertspecial"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(a|A)(t|T)(t|T)(a|A)(c|C)(k|K)(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("attackdist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(a|A)(t|T)(t|T)(a|A)(c|C)(k|K)(m|M)(u|U)(l|L)(s|S)(e|E)(t|T) { yylval->stringVal = new string("attackmulset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(b|B)(g|G)(p|P)(a|A)(l|L)(f|F)(x|X) { yylval->stringVal = new string("bgpalfx"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(b|B)(i|I)(n|N)(d|D)(t|T)(o|O)(p|P)(a|A)(r|R)(e|E)(n|N)(t|T) { yylval->stringVal = new string("bindtoparent"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(b|B)(i|I)(n|N)(d|D)(t|T)(o|O)(r|R)(o|O)(o|O)(t|T) { yylval->stringVal = new string("bindtoroot"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(b|B)(i|I)(n|N)(d|D)(t|T)(o|O)(t|T)(a|A)(r|R)(g|G)(e|E)(t|T) { yylval->stringVal = new string("bindtotarget"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(c|C)(h|H)(a|A)(n|N)(g|G)(e|E)(a|A)(n|N)(i|I)(m|M) { yylval->stringVal = new string("changeanim"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(c|C)(h|H)(a|A)(n|N)(g|G)(e|E)(a|A)(n|N)(i|I)(m|M)2 { yylval->stringVal = new string("changeanim2"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(c|C)(h|H)(a|A)(n|N)(g|G)(e|E)(S|s)(T|t)(a|A)(T|t)(e|E) { yylval->stringVal = new string("changestate"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(c|C)(l|L)(e|E)(a|A)(r|R)(c|C)(l|L)(i|I)(p|P)(b|B)(o|O)(a|A)(r|R)(d|D) { yylval->stringVal = new string("clearclipboard"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(c|C)(t|T)(r|R)(l|L)(s|S)(e|E)(t|T) { yylval->stringVal = new string("ctrlset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(d|D)(e|E)(f|F)(e|E)(n|N)(c|C)(e|E)(m|M)(u|U)(l|L)(s|S)(e|E)(t|T) { yylval->stringVal = new string("defencemulset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(d|D)(e|E)(s|S)(t|T)(r|R)(o|O)(y|Y)(s|S)(e|E)(l|L)(f|F) { yylval->stringVal = new string("destroyself"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(d|D)(i|I)(s|S)(p|P)(l|L)(a|A)(y|Y)(t|T)(o|O)(c|C)(l|L)(i|I)(p|P)(b|B)(o|O)(a|A)(r|R)(d|D) { yylval->stringVal = new string("displaytoclipboard"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(e|E)(n|N)(v|V)(c|C)(o|O)(l|L)(o|O)(r|R) { yylval->stringVal = new string("envcolor"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E) { yylval->stringVal = new string("envshake"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(e|E)(x|X)(p|P)(l|L)(o|O)(d|D) { yylval->stringVal = new string("explod"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(e|E)(x|X)(p|P)(l|L)(o|O)(d|D)(b|B)(i|I)(n|N)(d|D)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("explodbindtime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(f|F)(o|O)(r|R)(c|C)(e|E)(f|F)(e|E)(e|E)(d|D)(b|B)(a|A)(c|C)(k|K) { yylval->stringVal = new string("forcefeedback"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(f|F)(a|A)(l|L)(l|L)(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E) { yylval->stringVal = new string("fallenvshake"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(g|G)(a|A)(m|M)(e|E)(m|M)(a|A)(k|K)(e|E)(a|A)(n|N)(i|I)(m|M) { yylval->stringVal = new string("gamemakeanim"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(g|G)(r|R)(a|A)(v|V)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("gravity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(a|A)(d|D)(d|D) { yylval->stringVal = new string("hitadd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(b|B)(y|Y) { yylval->stringVal = new string("hitby"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(d|D)(e|E)(f|F) { yylval->stringVal = new string("hitdef"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(f|F)(a|A)(l|L)(l|L)(d|D)(a|A)(m|M)(a|A)(g|G)(e|E) { yylval->stringVal = new string("hitfalldamage"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(f|F)(a|A)(l|L)(l|L)(s|S)(e|E)(t|T) { yylval->stringVal = new string("hitfallset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(f|F)(a|A)(l|L)(l|L)(v|V)(e|E)(l|L) { yylval->stringVal = new string("hitfallvel"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(o|O)(v|V)(e|E)(r|R)(r|R)(i|I)(d|D)(e|E) { yylval->stringVal = new string("hitoverride"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(h|H)(i|I)(t|T)(v|V)(e|E)(l|L)(s|S)(e|E)(t|T) { yylval->stringVal = new string("hitvelset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(l|L)(i|I)(f|F)(e|E)(a|A)(d|D)(d|D) { yylval->stringVal = new string("lifeadd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(l|L)(i|I)(f|F)(e|E)(s|S)(e|E)(t|T) { yylval->stringVal = new string("lifeset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(m|M)(a|A)(k|K)(e|E)(d|D)(u|U)(s|S)(t|T) { yylval->stringVal = new string("makedust"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(m|M)(o|O)(d|D)(i|I)(f|F)(y|Y)(e|E)(x|X)(p|P)(l|L)(o|O)(d|D) { yylval->stringVal = new string("modifyexplod"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(m|M)(o|O)(v|V)(e|E)(h|H)(i|I)(t|T)(r|R)(e|E)(s|S)(e|E)(t|T) { yylval->stringVal = new string("movehitreset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(n|N)(o|O)(t|T)(h|H)(i|I)(t|T)(b|B)(y|Y) { yylval->stringVal = new string("nothitby"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(n|N)(u|U)(l|L)(l|L) { yylval->stringVal = new string("null"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(o|O)(f|F)(f|F)(s|S)(e|E)(t|T) { yylval->stringVal = new string("offset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(a|A)(l|L)(f|F)(x|X) { yylval->stringVal = new string("palfx"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(p|P)(a|A)(r|R)(e|E)(n|N)(t|T)(v|V)(d|D)(i|I)(s|S)(t|T) { yylval->stringVal = new string("parentdist"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(a|A)(r|R)(e|E)(n|N)(t|T)(v|V)(a|A)(r|R)(a|A)(d|D)(d|D) { yylval->stringVal = new string("parentvaradd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(a|A)(r|R)(e|E)(n|N)(t|T)(v|V)(a|A)(r|R)(s|S)(e|E)(t|T) { yylval->stringVal = new string("parentvarset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(a|A)(u|U)(s|S)(e|E) { yylval->stringVal = new string("pause"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(l|L)(a|A)(y|Y)(e|E)(r|R)(p|P)(u|U)(s|S)(h|H) { yylval->stringVal = new string("playerpush"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(l|L)(a|A)(y|Y)(s|S)(n|N)(d|D) { yylval->stringVal = new string("playsnd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(o|O)(s|S)(a|A)(d|D)(d|D) { yylval->stringVal = new string("posadd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(o|O)(s|S)(f|F)(r|R)(e|E)(e|E)(z|Z)(e|E) { yylval->stringVal = new string("posfreeze"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(o|O)(s|S)(s|S)(e|E)(t|T) { yylval->stringVal = new string("posset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(o|O)(w|W)(e|E)(r|R)(a|A)(d|D)(d|D) { yylval->stringVal = new string("poweradd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

(p|P)(o|O)(w|W)(e|E)(r|R)(s|S)(e|E)(t|T) { yylval->stringVal = new string("powerset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(p|P)(r|R)(o|O)(j|J)(e|E)(c|C)(t|T)(i|I)(l|L)(e|E) { yylval->stringVal = new string("projectile"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(r|R)(e|E)(m|M)(o|O)(v|V)(e|E)(e|E)(x|X)(p|P)(l|L)(o|O)(d|D) { yylval->stringVal = new string("removeexplod"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(r|R)(e|E)(v|V)(e|E)(r|R)(s|S)(a|A)(l|L)(d|D)(e|E)(f|F) { yylval->stringVal = new string("reversaldef"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(s|S)(c|C)(r|R)(e|E)(e|E)(n|N)(b|B)(o|O)(u|U)(n|N)(d|D) { yylval->stringVal = new string("screenbound"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(s|S)(e|E)(l|L)(f|F)(S|s)(T|t)(a|A)(T|t)(e|E) { yylval->stringVal = new string("selfstate"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(s|S)(p|P)(r|R)(p|P)(r|R)(i|I)(o|O)(r|R)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("sprpriority"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: " <<  yylval->stringVal->c_str() <<endl; 
	return token::KEY_IDENTIFIER;}

(S|s)(T|t)(a|A)(T|t)(e|E)(T|t)(y|Y)(p|P)(e|E)(s|S)(e|E)(t|T) { yylval->stringVal = new string("statetypeset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(S|s)(n|N)(d|D)(p|P)(a|A)(n|N) { yylval->stringVal = new string("sndpan"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(S|s)(T|t)(o|O)(p|P)(S|s)(n|N)(d|D) { yylval->stringVal = new string("stopsnd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(s|S)(u|U)(p|P)(e|E)(r|R)(p|P)(a|A)(u|U)(s|S)(e|E) { yylval->stringVal = new string("superpause"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(b|B)(i|I)(n|N)(d|D) { yylval->stringVal = new string("targetbind"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(d|D)(r|R)(o|O)(p|P) { yylval->stringVal = new string("targetdrop"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(f|F)(a|A)(c|C)(i|I)(n|N)(g|G) { yylval->stringVal = new string("targetfacing"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(l|L)(i|I)(f|F)(e|E)(a|A)(d|D)(d|D) { yylval->stringVal = new string("targetlifeadd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(p|P)(o|O)(w|W)(e|E)(r|R)(a|A)(d|D)(d|D) { yylval->stringVal = new string("targetpoweradd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(S|s)(T|t)(a|A)(T|t)(e|E) { yylval->stringVal = new string("targetstate"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(v|V)(e|E)(l|L)(a|A)(d|D)(d|D) { yylval->stringVal = new string("targetveladd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)(v|V)(e|E)(l|L)(s|S)(e|E)(t|T) { yylval->stringVal = new string("targetvelset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(r|R)(a|A)(n|N)(S|s) { yylval->stringVal = new string("trans"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(t|T)(u|U)(r|R)(n|N) { yylval->stringVal = new string("turn"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(v|V)(a|A)(r|R)(a|A)(d|D)(d|D) { yylval->stringVal = new string("varadd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(v|V)(a|A)(r|R)(r|R)(a|A)(n|N)(d|D)(o|O)(m|M)  { yylval->stringVal = new string("varrandom");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(v|V)(a|A)(r|R)(r|R)(a|A)(n|N)(g|G)(e|E)(s|S)(e|E)(t|T) { yylval->stringVal = new string("varrangeset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(v|V)(a|A)(r|R)(s|S)(e|E)(t|T) { yylval->stringVal = new string("varset"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(v|V)(e|E)(l|L)(a|A)(d|D)(d|D) { yylval->stringVal = new string("veladd"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(v|V)(e|E)(l|L)(m|M)(u|U)(l|L) { yylval->stringVal = new string("velmul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(v|V)(e|E)(l|L)(s|S)(e|E)(t|T) { yylval->stringVal = new string("velset");  SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: KEY_STATE_CONTROLER: " <<  yylval->stringVal->c_str()  <<endl; return token::KEY_IDENTIFIER; }
        
(w|W)(i|I)(d|D)(t|T)(h|H) { yylval->stringVal = new string("width"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(z|Z)(o|O)(o|O)(m|M) { yylval->stringVal = new string("zoom"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
        
(u|U)(n|N)(k|K)(n|N)(o|O)(w|W)(n|N) { yylval->stringVal = new string("unknown"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; return token::KEY_IDENTIFIER;}
		
(d|D)(e|E)(b|B)(u|U)(g|G) { yylval->stringVal = new string("debug"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: KEY_STATE_CONTROLER: "<<  yylval->stringVal->c_str()  <<endl; return token::KEY_IDENTIFIER;}
	
	 /* =============  STATE CONTROLLERS ========================= */

	/*================   TRIGGER REDIRECTION   ===================
The complete list of redirection keywords is the following:

-) parent
    Redirects the trigger to the player's parent. (Player must be a helper.)
-) root
    Redirects the trigger to the root.
-) helper
    Redirects the trigger to the first helper found. See the related trigger "NumHelper" in the trigger documentation.
-) helper(ID)
    ID should be a well-formed expression that evaluates to a positive integer. The trigger is then redirected to a helper with the corresponding ID number.
-) target
    Redirects the trigger to the first target found.
-) target(ID)
    ID should be a well-formed expression that evaluates to a non- negative integer. The trigger is then redirected to a target with the corresponding targetID. The targetID is specified in the "ID" parameter of a HitDef controller.
-) partner
    Redirects the trigger to the player's partner. Normal helpers and neutral players are not considered opponents. See the related trigger "numpartner" in the trigger documentation.
-) enemy
    Redirects the trigger to the first opponent found. Normal helpers and neutral players are not considered opponents. See the related trigger "numenemy" in the trigger documentation.
-) enemy(n)
    n should be a well-formed expression that evaluates to a non- negative integer. The trigger is redirected to the n'th opponent.
-) enemyNear
    Redirects the trigger to the nearest opponent.
-) enemyNear(n)
    n should be a well-formed expression that evaluates to a non- negative integer. The trigger is redirected to the n'th-nearest opponent.
-) playerID(ID)
    n should be a well-formed expression that evaluates to a non- negative integer. The trigger is redirected to the player with unique ID equal to ID. See the "ID" and "PlayerExistID" triggers in the trigger documentation.

If the trigger is redirected to an invalid destination (for instance, if it is retargeted to a helper when none exist), then an error is returned. See the section on SC values.

Note: multiple redirection (e.g., root,target,time) is not currently supported.

	*/


(e|E)(n|N)(e|E)(m|M)(y|Y)(n|N)(e|E)(a|A)(r|R)  { yylval->stringVal = new string("enemynear"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str()  <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER;}

(h|H)(e|E)(l|L)(p|P)(e|E)(r|R) {  yylval->stringVal = new string("helper"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str() <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER;}

(t|T)(a|A)(r|R)(g|G)(e|E)(t|T)  {  yylval->stringVal = new string("target"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str() <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER;}
	
(e|E)(n|N)(e|E)(m|M)(y|Y) { yylval->stringVal = new string("enemy"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str() <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER; }

[pP][aA][rR][tT][nN][eE][rR] { yylval->stringVal = new string("partner"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str() <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER; }

[pP][lL][aA][yY][eE][rR][iI][dD] {  yylval->stringVal = new string("playerid");SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str() <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER; }

[rR][oO][oO][tT] { yylval->stringVal = new string("root"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str() <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER; }

[pP][aA][rR][eE][nN][tT] { yylval->stringVal = new string("parent"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "TRIGGER_REDIRECTION_IDENTIFIER: " << yylval->stringVal->c_str() <<endl; 
	return token::TRIGGER_REDIRECTION_IDENTIFIER; }

	
[a-z\'A-Z_][\'a-zA-Z0-9_.]* { yylval->stringVal = new string(yytext, yyleng); 
SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer IDENTIFIER= "<<  yylval->stringVal->c_str() <<endl;
return token::IDENTIFIER; }



	/*  HIT DEF PARAMETERS ==================  */


 
	/*    yaccel ok  */
    
	/*     hitflag ok  */
    
	/*	  affectteam  ok  */
    
	/*    animtype ok gethitparam  */
(a|A)(i|I)(r|R).(a|A)(n|N)(i|I)(m|M)(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("air.animtype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
(f|F)(a|A)(l|L)(l|L).(a|A)(n|N)(i|I)(m|M)(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("fall.animtype"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
    
	/*    damage ok gethitparam  */
    
    
	/*    sparkno ok   */
	/*    guard.sparkno ok   */

(a|A)(i|I)(r|R).(t|T)(y|Y)(p|P)(e|E) { yylval->stringVal = new string("air.type"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(a|A)(i|I)(r|R).(h|H)(i|I)(t|T)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("air.hittime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(a|A)(i|I)(r|R).(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("air.velocity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(a|A)(i|I)(r|R)(g|G)(u|U)(a|A)(r|R)(d|D).(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("airguard.velocity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(r|R)(o|O)(u|U)(n|N)(d|D).(c|C)(o|O)(r|R)(n|N)(e|E)(r|R)(p|P)(u|U)(s|S)(h|H).(v|V)(e|E)(l|L)(o|O)(f|F)(f|F) { yylval->stringVal = new string("ground.cornerpush.veloff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(a|A)(i|I)(r|R).(c|C)(o|O)(r|R)(n|N)(e|E)(r|R)(p|P)(u|U)(s|S)(h|H).(v|V)(e|E)(l|L)(o|O)(f|F)(f|F) { yylval->stringVal = new string("air.cornerpush.veloff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(d|D)(o|O)(w|W)(n|N).(c|C)(o|O)(r|R)(n|N)(e|E)(r|R)(p|P)(u|U)(s|S)(h|H).(v|V)(e|E)(l|L)(o|O)(f|F)(f|F) { yylval->stringVal = new string("down.cornerpush.veloff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(g|G)(u|U)(a|A)(r|R)(d|D).(c|C)(o|O)(r|R)(n|N)(e|E)(r|R)(p|P)(u|U)(s|S)(h|H).(v|V)(e|E)(l|L)(o|O)(f|F)(f|F) { yylval->stringVal = new string("guard.cornerpush.veloff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(a|A)(i|I)(r|R)(g|G)(u|U)(a|A)(r|R)(d|D).(c|C)(o|O)(r|R)(n|N)(e|E)(r|R)(p|P)(u|U)(s|S)(h|H).(v|V)(e|E)(l|L)(o|O)(f|F)(f|F) { yylval->stringVal = new string("airguard.cornerpush.veloff"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
      
(a|A)(i|I)(r|R)(g|G)(u|U)(a|A)(r|R)(d|D).(c|C)(t|T)(r|R)(l|L)(t|T)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("airguard.ctrltime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(a|A)(i|I)(r|R).(j|J)(u|U)(g|G)(g|G)(l|L)(e|E) { yylval->stringVal = new string("air.juggle"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}

 	/*    p2stateno ok     */
	/*    fall ok    */
	/*    fall.recover ok gethitparam             */
	/*    fall.recovertime ok gethitparam         */
	/*    fall.damage ok gethitparam              */
(a|A)(i|I)(r|R).(f|F)(a|A)(l|L)(l|L) { yylval->stringVal = new string("air.fall"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
(d|D)(o|O)(w|W)(n|N).(v|V)(e|E)(l|L)(o|O)(c|C)(i|I)(t|T)(y|Y) { yylval->stringVal = new string("down.velocity"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(d|D)(o|O)(w|W)(n|N).(h|H)(i|I)(t|T)(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("down.hittime"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(d|D)(o|O)(w|W)(n|N).(b|B)(o|O)(u|U)(n|N)(c|C)(e|E) { yylval->stringVal = new string("down.bounce"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
	/*    id ok    */
	/*    chainID  ok gethitparam          */
	/*    fall.kill OK   */
     
(p|P)(a|A)(l|L)(f|F)(x|X).(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("palfx.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(p|P)(a|A)(l|L)(f|F)(x|X).(m|M)(u|U)(l|L) { yylval->stringVal = new string("palfx.mul"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(p|P)(a|A)(l|L)(f|F)(x|X).(a|A)(d|D)(d|D) { yylval->stringVal = new string("palfx.add"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(t|T)(i|I)(m|M)(e|E) { yylval->stringVal = new string("envshake.time"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(f|F)(r|R)(e|E)(q|Q) { yylval->stringVal = new string("envshake.freq"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(a|A)(m|M)(p|P)(l|L) { yylval->stringVal = new string("envshake.ampl"); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
     
(e|E)(n|N)(v|V)(s|S)(h|H)(a|A)(k|K)(e|E).(p|P)(h|H)(a|A)(s|S)(e|E) { yylval->stringVal = new string("envshake.phase "); SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< " ( HitDef controller identifier) KEY_IDENTIFIER: "<<  yylval->stringVal->c_str()  <<endl; 
	return token::KEY_IDENTIFIER;}
    
	/*    fall.envshake.time OK   */
	/*    fall.envshake.freq OK   */
	/*    fall.envshake.ampl OK   */
	/*    fall.envshake.phase OK   */

	/*  TRIGGERS   
	
	AILevel
Abs - done - FUNC_IDENTIFIER
Acos - done - FUNC_IDENTIFIER
Alive - done - KEY_IDENTIFIER
Anim - done - KEY_ANIM
AnimElem - done -  FUNC_IDENTIFIER
AnimElemNo - done - FUNC_IDENTIFIER
AnimElemTime - done - FUNC_IDENTIFIER
AnimExist - done - FUNC_IDENTIFIER
AnimTime - done - KEY_IDENTIFIER
Asin - done - FUNC_IDENTIFIER
Atan - done - FUNC_IDENTIFIER
AuthorName - done - KEY_IDENTIFIER

B
-----------------------
BackEdgeBodyDist - done - KEY_IDENTIFIER
BackEdgeDist - done - KEY_IDENTIFIER

C
-----------------------
CanRecover - done  - KEY_IDENTIFIER
Ceil - done - FUNC_IDENTIFIER
Command - done - KEY_IDENTIFIER
Const - done - FUNC_CONST
Const240p - FUNC_IDENTIFIER
Const480p - FUNC_IDENTIFIER
Const720p - FUNC_IDENTIFIER
Cos - done - FUNC_IDENTIFIER
Ctrl - done - KEY_IDENTIFIER

D
-----------------------
DrawGame - KEY_IDENTIFIER

E
-----------------------
E - NOT DEFINED - WILL COMPILE LIKE IDENTIFIER
Exp - done - FUNC_IDENTIFIER

F
-----------------------
FVar - done - FUNC_FVAR
Facing - done - KEY_IDENTIFIER
Floor - done - FUNC_IDENTIFIER
FrontEdgeBodyDist - done - KEY_IDENTIFIER
FrontEdgeDist - done - KEY_IDENTIFIER

G
-----------------------
GameTime - done - KEY_IDENTIFIER
GetHitVar - DONE - FUNC_GETHITVAR

H
-----------------------
HitCount - done - KEY_IDENTIFIER
HitDefAttr - DONE - KEY_HITDEF
HitFall - done - KEY_IDENTIFIER
HitOver - done - KEY_IDENTIFIER
HitPauseTime - done - KEY_IDENTIFIER
HitShakeOver - done - KEY_IDENTIFIER
HitVel - done - KEY_IDENTIFIER

I
-----------------------
ID - done - KEY_IDENTIFIER
IfElse - done - FUNC_IFELSE
InGuardDist - done - KEY_IDENTIFIER
IsHelper - done - FUNC_IDENTIFIER
IsHomeTeam - DONE - KEY_IDENTIFIER

L
-----------------------
Life - done - KEY_IDENTIFIER
LifeMax - done - KEY_IDENTIFIER
Ln - done - FUNC_IDENTIFIER
Log - done - FUNC_LOG
Lose DONE -  - KEY_IDENTIFIER

M
-----------------------
MatchNo - done - KEY_IDENTIFIER
MatchOver - done - KEY_IDENTIFIER
MoveContact - DONE - KEY_IDENTIFIER
MoveGuarded - done - KEY_IDENTIFIER
MoveHit - DONE - KEY_IDENTIFIER
MoveReversed - DONE - KEY_IDENTIFIER
MoveType - done - KEY_IDENTIFIER

N
-----------------------
Name - done - KEY_IDENTIFIER
NumEnemy - DONE - KEY_IDENTIFIER
NumExplod - done - FUNC_IDENTIFIER
NumHelper - DONE - FUNC_IDENTIFIER
NumPartner - DONE - KEY_IDENTIFIER
NumProj - DONE - KEY_IDENTIFIER
NumProjID - DONE - FUNC_IDENTIFIER
NumTarget - DONE - FUNC_IDENTIFIER

P
-----------------------
P1Name - done - KEY_IDENTIFIER
P2BodyDist - done - KEY_IDENTIFIER
P2Dist - done - KEY_IDENTIFIER
P2Life - done - KEY_IDENTIFIER
P2MoveType - done - KEY_IDENTIFIER
P2Name - done - KEY_IDENTIFIER
P2StateNo - done - KEY_IDENTIFIER
P2StateType - done - KEY_IDENTIFIER
P3Name - done - KEY_IDENTIFIER
P4Name - done - KEY_IDENTIFIER
PalNo - done - KEY_IDENTIFIER
ParentDist - done - KEY_IDENTIFIER
Pi - done - KEY_IDENTIFIER
PlayerIDExist - done - FUNC_IDENTIFIER
Pos - done - KEY_IDENTIFIER
Power - done - KEY_IDENTIFIER
PowerMax - done - KEY_IDENTIFIER
PrevStateNo - done - KEY_IDENTIFIER
ProjCancelTime - DONE - FUNC_IDENTIFIER
ProjContact - DONE - FUNC_PROJCONTACT
ProjContactTime - DONE - FUNC_IDENTIFIER
ProjGuarded - DONE - FUNC_IDENTIFIER
ProjGuardedTime - DONE - FUNC_IDENTIFIER
ProjHit - DONE -FUNC_IDENTIFIER
ProjHitTime - DONE - FUNC_IDENTIFIER

R
-----------------------
Random - done - KEY_IDENTIFIER
RootDist - done - KEY_IDENTIFIER
RoundNo - done - KEY_IDENTIFIER
RoundState - done - KEY_IDENTIFIER
RoundsExisted - done - KEY_IDENTIFIER

S
-----------------------
ScreenPos - done - KEY_IDENTIFIER
SelfAnimExist - done - FUNC_IDENTIFIER
Sin - done - FUNC_IDENTIFIER
StateNo - DONE - KEY_IDENTIFIER
StateType - done - KEY_STATETYPE
SysFVar - donE - FUNC_IDENTIFIER
SysVar - done - FUNC_SYSVAR

T
-----------------------
Tan - done - FUNC_IDENTIFIER
TeamMode - DONE - FUNC_IDENTIFIER
TeamSide - DONE - KEY_IDENTIFIER
TicksPerSecond - DONE - KEY_IDENTIFIER
Time - DONE - KEY_IDENTIFIER
TimeMod - DONE - FUNC_IDENTIFIER

U
-----------------------
UniqHitCount - DONE - KEY_IDENTIFIER

V
-----------------------
Var - done - FUNC_VAR
Vel - done - KEYWORD

W
-----------------------
Win - DONE - KEY_IDENTIFIER


Keywords

"vel" - DONE - KEYWORD
"velx" - DONE - KEYWORD
"vely" - DONE - KEYWORD
"hitvelx" - DONE - KEYWORD
"hitvely" - DONE - KEYWORD
"screenposy" - DONE - KEYWORD
"screenposx" - DONE - KEYWORD
"posy" - DONE - KEYWORD
"posx" - DONE - KEYWORD
"p2bodydistx" - DONE - KEYWORD
"p2bodydisty" - DONE - KEYWORD
"parentdistx" - DONE - KEYWORD
"parentdisty" - DONE - KEYWORD
"p2distx" - DONE - KEYWORD
"p2disty" - DONE - KEYWORD
"rootdistx" - DONE - KEYWORD
"rootdisty" - DONE - KEYWORD
	*/
			  

	/* gobble up white-spaces */
{blank}+ {
    //SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer blank= "<< *yytext <<endl;
    yylloc->step();
}

;[^\n\r]*[\n\r] {//SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "COMMENT" <<endl; 
	return token::COMMENT; }        

[\n\r]+        { yylloc->lines(yyleng); yylloc->step();
				SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer EOL= "<< "EOL" <<endl;
				return token::EOL;
				}


":=" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_ASSIGN" <<endl; 
	return token::CMD_ASSIGN; }
"!=" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_NOTEQ" <<endl; 
	return token::CMD_NOTEQ; }
">=" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_GREATERTHANEQ" <<endl; 
	return token::CMD_GREATERTHANEQ; }
"<=" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_LESSTHANEQ" <<endl; 
	return token::CMD_LESSTHANEQ; }
"&&" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_LOGAND" <<endl; 
	return token::CMD_LOGAND; }
"||" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_LOGOR" <<endl; 
	return token::CMD_LOGOR; }
"**" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_SQUARE" <<endl; 
	return token::CMD_SQUARE; }
"^^" { SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Token: "<< "CMD_LOGXOR" <<endl; 
	return token::CMD_LOGXOR; }


[ \t]* { ; }


	/* discard all other characters */
. {
    yylloc->step();
    SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer Unknow caracter= "<< *yytext <<endl;
  
}			  
%% 
	/*** END EXAMPLE - Change the example lexer rules above ***/
	/*** Additional Code bellow ***/
namespace CmdCompiler {

CScanner::CScanner(std::istream* in,
		 std::ostream* out)
    : CmdFlexLexer(in, out)
{
}

CScanner::~CScanner()
{
}

void CScanner::set_debug(bool b)
{
    yy_flex_debug = b;
}

float CScanner::toFloat() {
char *tempNumber=new char[yyleng+1];
for (int i = 0; i < yyleng ; i++)
{
//SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer number[" <<i<<"] = " << yytext[i] << endl;
tempNumber[i]=yytext[i];

}
tempNumber[yyleng]='\0';
float rez = 0, fact =1;
if (*tempNumber == '-') {
tempNumber++;
fact = -1;
}
int point_seen =0;
for (int j =0; j < yyleng; j++) {
//SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer number[" <<j<<"] = " << tempNumber[j] << endl;
	if (tempNumber[j] == '.'){
	point_seen =1;
	}else{
	int d = tempNumber[j] - '0';
	if (d >=0 && d <=9) {
		if (point_seen) fact /= 10.0f;
		rez = rez * 10.0f + (float)d;
		//SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer rez = " << rez << endl;

		}
	}
}
//delete tempNumber;
return rez * fact;
}

float CScanner::toFloatX() {
char *tempNumber=new char[yyleng+2];
for (int i = 0; i < yyleng ; i++)
{
//SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer number[" <<i<<"] = " << yytext[i] << endl;
tempNumber[i]=yytext[i];

}
tempNumber[yyleng]='\0';
float rez = 0, fact =1;
if (*tempNumber == '-') {
tempNumber++;
fact = -1;
}
int point_seen =0;
for (int j =0; j < yyleng; j++) {
//SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer number[" <<j<<"] = " << tempNumber[j] << endl;
	if (tempNumber[j] == '.'){
	point_seen =1;
	}else{
	int d = tempNumber[j] - '0';
	if (d >=0 && d <=9) {
		if (point_seen) fact /= 10.0f;
		rez = rez * 10.0f + (float)d;
		//SMF::Debug::debug(SMF::Debug::compilers,__FUNCTION__) <<"Lexer rez = " << rez << endl;

		}
	}
}
//delete tempNumber;
return rez * fact;
}

void CScanner::destroyComment()
{
char c;

   c= yyinput();
   while (c != '\n' && c != 0)
   {	
	c=yyinput();

   }
   
 
}


}

/* This implementation of ExampleFlexLexer::yylex() is required to fill the
 * vtable of the class ExampleFlexLexer. We define the scanner's main yylex
 * function via YY_DECL to reside in the Scanner class instead. */

#ifdef yylex
#undef yylex
#endif
/*
int CmdFlexLexer::yylex()
{
    std::cerr << "in CmdFlexLexer::yylex() !" << endl;
    return 0;
}  
*/
/* When the scanner receives an end-of-file indication from YY_INPUT, it then
 * checks the yywrap() function. If yywrap() returns false (zero), then it is
 * assumed that the function has gone ahead and set up `yyin' to point to
 * another input file, and scanning continues. If it returns true (non-zero),
 * then the scanner terminates, returning 0 to its caller. */
/*
int CmdFlexLexer::Cmdwrap()
{
    return 1;
}
*/