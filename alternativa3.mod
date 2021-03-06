/* 
MODELOS Y OPTIMIZACI�N I - FIUBA
TRABAJO PR�CTICO GRUPAL

Alternativa de resoluci�n N� 3: se utiliza la variable Y[i,j] para determinar el dinero del cami�n en cada ciudad

Hip�tesis: El cami�n inicia el recorrido SIN dinero.
*/

/* Conjuntos*/
set BANCOS;

/*Parametros*/
param DISTANCIA{i in BANCOS, j in BANCOS : i<>j};
param MONTO {i in BANCOS};
param MAX_DINERO;

/* Definici�n de Variables */
var Y{i in BANCOS, j in BANCOS : i<>j} >= 0, binary;
var U{i in BANCOS : i<>'ORIGEN'} >= 0, integer;
# DINERO: dinero que tiene el cami�n en el banco i
var DINERO{j in BANCOS } >=0;

/* Funcional*/
minimize z: sum{i in BANCOS, j in BANCOS : i <> j} DISTANCIA[i,j] * Y[i,j];

/* Restricciones*/
#Viajante b�sico
s.t. llegoJ{j in BANCOS}: sum{i in BANCOS : i<>j} Y[i,j] = 1;
s.t. voyI{i in BANCOS}: sum{j in BANCOS : i<>j} Y[i,j] = 1;
s.t. orden{i in BANCOS,j in BANCOS : i<>j and i<>'ORIGEN' and j<>'ORIGEN'}: U[i] - U[j] + card(BANCOS) * Y[i,j] <= card(BANCOS) - 1;

# Dinero en el cami�n
s.t. dineroEnCamion1{i in BANCOS, j in BANCOS: i<>j and i<>'ORIGEN'}: DINERO[i] + MONTO[j] - DINERO[j] <= (1-Y[i,j]) * 999999;
s.t. dineroEnCamion2{i in BANCOS, j in BANCOS: i<>j and i<>'ORIGEN'}: DINERO[i] + MONTO[j] - DINERO[j] >= - (1-Y[i,j]) * 999999;

s.t. capacidadCamion{j in BANCOS}: DINERO[j] <= MAX_DINERO;

solve;

# Data Section

data;
set BANCOS := ORIGEN PORTENO DELPLATA DELOSANDES PLURAL DELNORTE PAMPEANO COOPERATIVO SOL REPUBLICA VIENTOSDELSUR; 

# Distancias entre los bancos.
param DISTANCIA:   ORIGEN PORTENO DELPLATA DELOSANDES PLURAL DELNORTE PAMPEANO COOPERATIVO SOL REPUBLICA VIENTOSDELSUR:=
	 	ORIGEN       .       2       5         1         3      5        2          3       4      1           8
		PORTENO      2       .       3         5         7      4        4          5       7      3           4
		DELPLATA     5       3       .         5         8      1        5          19      12     7           9
		DELOSANDES   1       5       5         .         3      4        11         4       6      6           6
		PLURAL       3       7       8         3         .      2        9          14      8      9           13
		DELNORTE     5       4       1         4         12      .       7          6       8      8           6
		PAMPEANO     2       4       5         11        9      7        .          9       10     5           7
		COOPERATIVO  3       6       5         9         4      5        9          .       7      3           9
		SOL          4       7       12        6         8      8        10         7       .      6           6
		REPUBLICA    1       3       7         6         9      8        5          3       6      .           15
		VIENTOSDELSUR 8      4       9         6         13     6        7          9       6      12          .;


# Operaciones a realizar en cada banco (+ retiros, - extracciones)
param MONTO :=
ORIGEN		0
PORTENO		5
DELPLATA	-1
DELOSANDES	1
PLURAL		2
DELNORTE	-5
PAMPEANO	-5
COOPERATIVO	8
SOL			-1
REPUBLICA	9
VIENTOSDELSUR	2;

# Capacidad m�xima de dinero que el cami�n puede transportar
param MAX_DINERO 60;

end;