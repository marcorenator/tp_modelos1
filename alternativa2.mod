/* 
MODELOS Y OPTIMIZACIÓN I - FIUBA
TRABAJO PRÁCTICO GRUPAL

Alternativa de resolución N° 2: se define una variable bivalente que determina si el banco i se visitó en 
el orden j; 

Hipótesis: El camión inicia el recorrido SIN dinero.
*/

/* Conjuntos*/
set BANCOS;
set ORDEN;

/*Parametros*/
param DISTANCIA{i in BANCOS, j in BANCOS : i<>j};
param MONTO {i in BANCOS};
param MAX_DINERO;

/* Definición de Variables */
var Y{i in BANCOS, j in BANCOS : i<>j} >= 0, binary;
var U{i in BANCOS : i <> 0} >= 0, integer;
# X: vale 1 si se visita el banco i antes del j.
var X{i in BANCOS, j in BANCOS} >= 0, binary;
# DINERO: dinero que tiene el camión en el banco j
var DINERO{j in BANCOS} >=0;

/* Funcional*/
minimize z: sum{i in BANCOS, j in BANCOS : i <> j} DISTANCIA[i,j] * Y[i,j];

/* Restricciones*/
#Viajante básico
s.t. llegoJ{j in BANCOS}: sum{i in BANCOS : i<>j} Y[i,j] = 1;
s.t. voyI{i in BANCOS}: sum{j in BANCOS : i<>j} Y[i,j] = 1;
s.t. orden{i in BANCOS,j in BANCOS: i<>j and i<>0 and j<>0}: U[i] - U[j] + card(BANCOS) * Y[i,j] <= card(BANCOS) - 1;

# Cada banco se visita en un único orden
s.t. visitoEnOrden{i in BANCOS : i<>0}: sum{j in ORDEN} j * X[i,j] = U[i];
s.t. bancoEnUnicoOrden{i in BANCOS : i<>0}: sum{j in ORDEN } X[i,j] = 1;

# Dinero en el camión
s.t. dineroEnCamion{j in ORDEN: j>=1}: (sum{i in BANCOS } MONTO[i] * X[i,j]) + DINERO[j-1] = DINERO[j];

s.t. capacidadCamion{j in ORDEN}: DINERO[j] <= MAX_DINERO;

solve;

# Data Section

data;

set ORDEN := 0 1 2 3 4 5 6 7 8 9;
set BANCOS := 0 1 2 3 4 5 6 7 8 9 10;
# Distancias entre los bancos.
param DISTANCIA: 0   1   2   3   4   5   6   7   8   9   10:=  
	 	0        .   2   5   1   3   5   2   3   4   1    8
		1        2   .   3   5   7   4   4   5   7   3    4
		2        5   3   .   5   8   1   5   19  12  7    9
		3        1   5   5   .   3   4   11  4   6   6    6
		4        3   7   8   3   .   2   9   14  8   9    13
		5        5   4   1   4   12  .   7   6   8   8    6
		6        2   4   5   11  9   7   .   9   10  5    7
		7        3   6   5   9   4   5   9   .   7   3    9
		8        4   7   12  6   8   8   10  7   .   6    6
		9        1   3   7   6   9   8   5   3   6   .    15
		10       8   4   9   6   13  6   7   9   6   12   .;


# Operaciones a realizar en cada banco (+ retiros, - extracciones)
param MONTO :=
0		0
1		5
2		-1
3		1
4		2
5		-5
6		-5
7		8
8		-1
9		9
10		2;

# Capacidad máxima de dinero que el camión puede transportar
param MAX_DINERO 60;

end;