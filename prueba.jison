%{

    //codigo en JS
    //importaciones y declaraciones
    const {Declaracion} = require('./instrucciones/declaracion.js');
    const {Asignacion} = require('./instrucciones/asignar.js');
    const {Literal} = require('./expresiones/literal.js')
    const {Type} = require('./symbols/type.js');
    const {Arithmetic} = require('./expresiones/aritmeticas.js');
    const {Acceso} = require('./expresiones/Acceso.js');
    const {AritmeticOption} = require('./expresiones/aritmeticOption.js');
    //const {Bloque} = require('./instrucciones/Env')
    //const {Imprimir} = require('./instrucciones/imprimir')
   //const {Sentencia_if} = require('./instrucciones/condicionIf')
    //const {metodo} = require('./instrucciones/metodo')
    //const {llamada} = require('./instrucciones/llamada')
    const { RelacionalOption } = require("./expresiones/relacionalOptions.js");
    const { Relacional } = require("./expresiones/relacional.js");
    const {DeclaracionARRAY} = require('./instrucciones/declaracionarray.js');
    const {imprimir} = require('./instrucciones/imprimir.js');
    var array_erroresLexicos;
   
%}

%lex
%options case-insensitive

number "-"?[0-9]+
cadena "\"" [^\"]* "\""
bool    "true"|"false"   

%%

\s+                   /* skip whitespace */
"//".*                // comentario simple línea
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] // comentario multiple líneas












//expresiones regulare


{number}    return 'expreR_numero'
{cadena}    return 'expreR_cadena'
{bool}      return 'expreR_bool'




//palabras reservadas

"var"   return 'pr_var'
"let"   return 'pr_let'
"const" return 'pr_const'

"int" return 'pr_numero'
"string" return 'pr_string'
"bool" return 'pr_bool'
"print" return 'pr_print'
"println" return 'pr_println'
"return" return 'pr_return'
"while" return 'pr_while'
"switch" return 'pr_switch'
"for" return 'pr_for'
"do" return 'pr_do'
"if" return 'pr_if'
"else" return 'pr_else'
"break" return 'pr_break'
"void" return 'pr_void'
"call" return 'pr_call'
"typeof" return 'pr_typeof'
"new" return 'pr_new'




//simbolos

";" return ';' 
"=" return '='
":" return ':' 
"+" return '+' 
"-" return '-' 
"*" return '*' 
"/" return '/' 
"," return ','
"{" return '{' 
"}" return '}' 
")" return ')' 
"(" return '(' 
"<" return '<'
">" return '>'
"||" return '||'
"&&" return '&&'
"^" return '^'
"!" return '!'
"%" return '%'
"<=" return '<='
">=" return '>='
"==" return '=='
"!=" return '!='
"[" return '['
"]" return ']'





[a-zA-ZñÑ][a-zA-Z0-9_ñÑ]*	return 'id';


<<EOF>>		            return 'EOF'

.   { 
        console.log("error lexico :"+yytext)
        //push para array errores
    }

/lex 

%right   '!'
%left '*' '/' '%'
%left '+' '-'
%left  '<' '>' '<=' '>=' '==' '!='
%left '^'

%start INIT


%%

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 
 
//GENERAL INSTRUCCIONES 
INIT: INSTRUCCIONES    EOF {return $1} ;


INSTRUCCIONES :   INSTRUCCIONES INSTRUCCION { $1.push($2); $$=$1; console.log("s ")}
              |   INSTRUCCION               {$$ = [$1]; console.log("s ") }
              ;


INSTRUCCION : DECLARACION   { $$=$1;console.log("reconocio declaracion ") } 
            | BLOQUE        { console.log("reconocio bloque") } 
            | IMPRIMIR      { $$=$1;console.log("reconocio PRINT ") } 
            | IMPRIMIRLN    { console.log("reconocio PRINTLN ") } 
            | ASIGNACION    { $$=$1;console.log("reconocio asignacion ") }
            | METODO        {  console.log("reconocio metodo")}
            | FUNCION       { console.log("reconocio funcion") }
            | METODOsp        {  console.log("reconocio metodo sin parametros")}
            | FUNCIONsp       { console.log("reconocio funcion sin parametros") }
            | CONDICIONIF   { console.log("reconocio condicion if") } 
            | CICLO         {console.log("reconocio  ciclo")}
            | RETURN   {console.log("reconocio  RETURN")}
            | CALL      {console.log("reconocio  LLAMADA")}
            |DECLARACION_ARRAY {$$=$1;console.log("reconocio delcaracion array")}
            |E ';'{console.log("reconocio instruccion expresion")}
            | error    ';'  { console.log("Error sintactico en la linea "+(yylineno+1)); }
;
//INSTRUCCIONES CICLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOS
CICLO: 'pr_for'  '(' DECLARACION_INTERNA ',' COMPARACIONES ',' AUMENTO ')' BLOQUE {console.log("reconocio CICLO FOR ") }
    | 'pr_while' '(' COND_WHILE ')' BLOQUE {console.log("reconocio CICLO WHILE ")}
    | 'pr_do' BLOQUE 'pr_while' '(' COND_WHILE ')' ';' {console.log("reconocio CICLO DO-WHILE ")}
    ;
COND_WHILE: 'expreR_bool'
          |  COMPARACIONES
;

AUMENTO: ASIGNACION {}
        | E {}
;




//CONDICION IF
CONDICIONIF: 'pr_if' '(' COMPARACIONES ')' BLOQUE 'pr_else' BLOQUE  { console.log("reconoci una sentencia if");
                                                       }
| 'pr_if' '(' COMPARACIONES ')' BLOQUE

;






//FUNCIONES Y METODOS CON PARAMETROS
FUNCION: TIPODATO_DECLARACION 'id' PARAMETROS BLOQUE
;
METODO : 'pr_void' 'id' PARAMETROS BLOQUE 
;
PARAMETROS : '(' PARS ')' 
;
PARS : PARS ',' PAR 
     | PAR          
;
PAR : TIPODATO_DECLARACION 'id'
;
PARAMETROSLL : '(' PARSLL ')' 
;
PARSLL : PARSLL ',' E
     | E 
;

//sin parametros

FUNCIONsp: TIPODATO_DECLARACION 'id' '(' ')'BLOQUE
;
METODOsp : 'pr_void' 'id' '(' ')' BLOQUE 
;
//EL RETURN

RETURN : 'pr_return' E ';'
        | 'pr_return' ';'
;

//LLAMADA DE FUNCION O METODOS
CALL: 'pr_call' 'id' PARAMETROSLL ';'
    | 'pr_call' 'id' '('')'';'

;




//INSTRUCCION IMPRIMIR UNA Y VARIAS LINEAS

IMPRIMIR : 'pr_print' '(' E ')' ';' {$$ = new imprimir($3,@1.first_line, @1.first_column );}
;
IMPRIMIRLN : 'pr_println' '(' E ')' ';'
;

//BLOQUE DE INSTRUCCIONES
BLOQUE: '{' INSTRUCCIONES  '}' {console.log("reconocio BLOQUE DE INSTRUCCIONES ") }
;
//ASIGNACION DE VARIABLES YA DECLARADAS (CAMBIO DE VALOR)
ASIGNACION : 'id' '=' 'E' ';' {$$= new Asignacion($1,$3, @1.first_line, @1.first_column);} 
            | 'id' '=' 'id' ';'{$$= new Asignacion($1,$3, @1.first_line, @1.first_column);} 
            ;

//DECLARACION DE VARIABLES NO DECLARADAS SINGULAR O EN CONJUNTO, FINALES O NO FINALES, INCLUYE EXPRESIONES
ES : ES ',' E {$1.push($3); $$=$1;}
    | E {$$ = [$1]}
    ;
LISTA_ARRAY : '[' ES ']' {$$ = $2}
;

LISTA_LISTAS_ARRAY : '[' LSS ']' {$$ = $2}
;
LSS : LSS ',' LISTA_ARRAY {$1.push($3); $$=$1;}
    |  LISTA_ARRAY {$$ = [$1]}
    ;

DECLARACION_ARRAY : TIPODATO_DECLARACION IDS '['  ']' '=' 'pr_new' TIPODATO_DECLARACION '[' E ']' ';' {$$= new DeclaracionARRAY(false, $1,$2,null, $9,null,false,@1.first_line, @1.first_column)}
                  | TIPODATO_DECLARACION IDS '[' ']' '='  LISTA_ARRAY ';' {$$= new DeclaracionARRAY(false, $1,$2,$6,null,null,false,@1.first_line, @1.first_column)}
                  |   TIPODATO_DECLARACION IDS '['  ']''[' ']' '=' 'pr_new' TIPODATO_DECLARACION '[' E ']''[' E ']' ';' {$$= new DeclaracionARRAY(false, $1,$2,null, $11,$14,true,@1.first_line, @1.first_column)}
                  | TIPODATO_DECLARACION IDS '['  ']''['  ']' '=' LISTA_LISTAS_ARRAY  ';' {$$= new DeclaracionARRAY(false, $1,$2,$8,null,null,true,@1.first_line, @1.first_column)}
;

TIPO_DECLARACION_CONST: 'pr_const'; 
TIPODATO_DECLARACION  :  'pr_numero' {$$=Type.NUMBER}
                       | 'pr_bool'    {$$=Type.BOOLEAN}
                       | 'pr_string' {$$=Type.STRING}
                       ; 

DECLARACION : TIPO_DECLARACION_CONST  TIPODATO_DECLARACION IDS '=' E ';' {$$=new Declaracion(true,$2, $3,$5, @1.first_line, @1.first_column)}
            |
            TIPODATO_DECLARACION IDS '=' E ';'  {$$=new Declaracion(false,$1, $2,$4, @1.first_line, @1.first_column)}
            ;
DECLARACION_INTERNA : TIPODATO_DECLARACION IDS '=' E {}
            ;

IDS : IDS ',' 'id'{$1.push($3); $$=$1;}
    | 'id' {$$ = [$1]}
    ;
COMPARACIONES: '!' COMPARACIONES  {$$= new Relacional(null,$2,RelacionalOption.NEGACION, @1.first_line, @1.first_column);}
            |  COMPARACIONES '&&' COMP {$$= new Relacional($1,$3,RelacionalOption.AND, @1.first_line, @1.first_column);}
            |  COMPARACIONES '||' COMP {$$= new Relacional($1,$3,RelacionalOption.OR, @1.first_line, @1.first_column);}
            |   COMP  {$$=$1;} 
;
COMP:  E '<' E {$$= new Relacional($1,$3,RelacionalOption.MENOR, @1.first_line, @1.first_column);}
    |  E '>''=' E  {$$= new Relacional($1,$3,RelacionalOption.MAYORIGUAL, @1.first_line, @1.first_column);}
    |  E '<''=' E  {$$= new Relacional($1,$3,RelacionalOption.MENORIGUAL, @1.first_line, @1.first_column);}
    |  E '>' E     {$$= new Relacional($1,$3,RelacionalOption.MAYOR, @1.first_line, @1.first_column);}
    |  E '!''=' E   {$$= new Relacional($1,$3,RelacionalOption.NOIGUAL, @1.first_line, @1.first_column);}
    |  E '=''=' E   {$$= new Relacional($1,$3,RelacionalOption.IGUAL, @1.first_line, @1.first_column);}
;
E: E '+' E  {$$= new Arithmetic($1,$3,AritmeticOption.MAS, @1.first_line, @1.first_column);}
    |  E '-' E  {$$= new Arithmetic($1,$3,AritmeticOption.MENOS, @1.first_line, @1.first_column);}  
    |  E '*' E  {$$= new Arithmetic($1,$3,AritmeticOption.MULTIPLICACION, @1.first_line, @1.first_column);}
    |  E '/' E  {$$= new Arithmetic($1,$3,AritmeticOption.DIVISION, @1.first_line, @1.first_column);}
    |  E '%' E  {$$= new Arithmetic($1,$3,AritmeticOption.MODULO, @1.first_line, @1.first_column);}
    |  E '+''+' {$$= new Arithmetic($1,null,AritmeticOption.SOBRESUMA, @1.first_line, @1.first_column);}
    |  E '-''-' {$$= new Arithmetic($1,null,AritmeticOption.SOBRERESTA, @1.first_line, @1.first_column);}
    |  F   {$$=$1;} 
;

F: expreR_numero {$$=new Literal($1,Type.NUMBER , @1.first_line, @1.first_column)}
    |expreR_bool {$$=new Literal($1,Type.BOOLEAN, @1.first_line, @1.first_column)}
    |expreR_cadena {$$=new Literal($1,Type.STRING , @1.first_line, @1.first_column)}
    | 'id' {$$=new Literal($1,Type.VARIABLE , @1.first_line, @1.first_column)}
;
// INSSTRUCCION FOR

