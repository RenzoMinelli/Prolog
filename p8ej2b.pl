% a) Implemente los siguientes predicados en Prolog sobre valores reales de manera
% que puedan invocarse para cualquier instanciación, siempre que la cantidad de
% argumentos no instanciados sea como máximo 1.
% suma(X, Y, Z)  Z es la suma entre X e Y.
% producto(X, Y, Z)  Z es el producto entre X e Y.
% cuadrado(X, Y)  Y es el cuadrado de X. Notar que para la
% invocación (-X,+Y) pueden existir 0, 1 o 2
% valores de X posibles, dependiendo de Y.
% exponencial(X, Y, Z)  Z es X^Y.

% b) Implemente el predicado suma(X, Y, Z) sobre valores enteros que funcione para
% las instanciaciones de la parte a), y además para la instanciación (-X, -Y, +Z)
% considerando que X e Y serán mayores o iguales que 0.

suma(X,Y,Z) :-
    nonvar(X),
    nonvar(Y),
    Z is X+Y.

suma(X,Y,Z) :-
    nonvar(Z),
    between(0,Z,X),
    Y is Z-X.