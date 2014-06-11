/* 
MODELOS Y OPTIMIZACIÓN I - FIUBA
TRABAJO PRÁCTICO GRUPAL

Alternativa de resolución N° 2: se define una variable bivalente que determina si el banco i se visitó en 
el orden j; 

Hipótesis: El camión inicia el recorrido SIN dinero.
*/

/* Conjuntos*/
set BANCOS;

/*Parametros*/
param DISTANCIA{i in BANCOS, j in BANCOS : i<>j};
param MONTO {i in BANCOS};
param MAX_DINERO;

/* Definición de Variables */
var Y{i in BANCOS, j in BANCOS : i<>j} >= 0, binary;
var U{i in BANCOS } >= 0, integer;
# X: vale 1 si se visita el banco i antes del j.
var X{i in BANCOS, j in BANCOS : i<>j} >= 0, binary;
# DINERO: dinero que tiene el camión en el banco j
var DINERO{j in BANCOS} >=0;

/* Funcional*/
minimize z: sum{i in BANCOS, j in BANCOS : i <> j} DISTANCIA[i,j] * Y[i,j];

/* Restricciones*/
#Viajante básico
s.t. llegoJ{j in BANCOS}: sum{i in BANCOS : i<>j} Y[i,j] = 1;
s.t. voyI{i in BANCOS}: sum{j in BANCOS : i<>j} Y[i,j] = 1;
s.t. orden{i in BANCOS,j in BANCOS: i<>j}: U[i] - U[j] + card(BANCOS) * Y[i,j] <= card(BANCOS) - 1;

# Cada banco se visita en un único orden
s.t. visitoEnOrden{i in BANCOS }: sum{j in BANCOS : i<>j} j * X[i,j] = U[i];
s.t. bancoEnUnicoOrden{i in BANCOS}: sum{j in BANCOS: i<>j} X[i,j] = 1;

# Dinero en el camión
s.t. dineroEnCamion{j in BANCOS: j>=1}: (sum{i in BANCOS : i<>j} MONTO[i] * X[i,j]) + DINERO[j-1] = DINERO[j];

s.t. capacidadCamion{j in BANCOS}: DINERO[j] <= MAX_DINERO;

solve;

# Data Section

data;
set BANCOS := ORIGEN PORTENO DELPLATA DELOSANDES PLURAL DELNORTE PAMPEANO COOPERATIVO SOL REPUBLICA VIENTOSDELSUR; 

# Distancias entre los bancos.
param DISTANCIA:   ORIGEN PORTENO DELPLATA DELOSANDES PLURAL DELNORTE PAMPEANO COOPERATIVO SOL REPUBLICA VIENTOSDELSUR:=
	 	ORIGEN       .       2       4         1         3      5        2         3        4      1           8
		PORTENO      2       .       3         5         7      4        4         5        7      3           4
		DELPLATA     4       3       .         5         8      1        5         9        12     7           9
		DELOSANDES   1       5       5         .         3      4        11        4        6      6           6
		PLURAL       3       7       8         3         .      2        9         4        8      9           13
		DELNORTE     5       4       1         4         2      .        7         6        8      8           6
		PAMPEANO     2       4       5         11        9      7        .         9        10     5           7
		COOPERATIVO  3       6       5         9         4      5        9         .        7      3           9
		SOL          4       7       12        6         8      8        10        7        .      6           6
		REPUBLICA    1       3       7         6         9      8        5         3        6      .           15
		VIENTOSDELSUR 8      4       9         6         13     6        7         9        6      12          .;


# Operaciones a realizar en cada banco (+ retiros, - extracciones)
param MONTO :=
ORIGEN		0
PORTENO		500000
DELPLATA	-900000
DELOSANDES	1500000
PLURAL		200000
DELNORTE	-500000
PAMPEANO	-150000
COOPERATIVO	800000
SOL			-500000
REPUBLICA	900000
VIENTOSDELSUR	200000;

# Capacidad máxima de dinero que el camión puede transportar
param MAX_DINERO 6000000;

end;