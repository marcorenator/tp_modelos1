/* 
MODELOS Y OPTIMIZACI�N I - FIUBA
TRABAJO PR�CTICO GRUPAL

Alternativa de resoluci�n N� 1: se define una variable bivalente que determina si la ciudad i se visit� antes 
que la j; con esta herramienta se podr� saber cu�nto dinero lleva el cami�n y si podr� extraer o 
depositar en el pr�ximo paso.

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
# X: vale 1 si se visita la ciudad i antes que la j.
var X{i in BANCOS, j in BANCOS } >= 0, binary;
# DINERO: dinero que tiene el cami�n en la ciudad j
var DINERO{j in BANCOS } >=0;

/* Funcional*/
minimize z: sum{i in BANCOS, j in BANCOS : i <> j} DISTANCIA[i,j] * Y[i,j];

/* Restricciones*/
#Viajante b�sico
s.t. llegoJ{j in BANCOS}: sum{i in BANCOS : i<>j} Y[i,j] = 1;
s.t. voyI{i in BANCOS}: sum{j in BANCOS : i<>j} Y[i,j] = 1;
s.t. orden{i in BANCOS,j in BANCOS: i<>j and i<>'ORIGEN' and j<>'ORIGEN'}: U[i] - U[j] + card(BANCOS) * Y[i,j] <= card(BANCOS) - 1;


# Restricciones para saber si una ciudad se visit� antes que la otra
s.t. visitoAntes1{i in BANCOS, j in BANCOS : i<>j and i<>'ORIGEN' and j<>'ORIGEN'}: (-1)*999999*(1-X[i,j]) + U[i] <= U[j]; 
s.t. visitoAntes2{i in BANCOS, j in BANCOS : i<>j and i<>'ORIGEN' and j<>'ORIGEN'}: U[j] <= U[i] + X[i,j]*999999;

# Dinero en el cami�n
s.t. dineroEnCamion{j in BANCOS }: (sum{i in BANCOS : i<>j and i<>'ORIGEN'} MONTO[i] * X[i,j]) + MONTO[j] = DINERO[j];
s.t. capacidadCamion{j in BANCOS }: DINERO[j] <= MAX_DINERO;

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