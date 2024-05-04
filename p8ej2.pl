% a) Implemente los siguientes predicados en Prolog sobre valores reales de manera
% que puedan invocarse para cualquier instanciación, siempre que la cantidad de
% argumentos no instanciados sea como máximo 1.
% suma(X, Y, Z)  Z es la suma entre X e Y.
% producto(X, Y, Z)  Z es el producto entre X e Y.
% cuadrado(X, Y)  Y es el cuadrado de X. Notar que para la
% invocación (-X,+Y) pueden existir 0, 1 o 2
% valores de X posibles, dependiendo de Y.
% exponencial(X, Y, Z)  Z es X^Y.

suma(X,Y,Z) :-
    nonvar(X),
    nonvar(Y),
    Z is X+Y.

suma(X,Y,Z) :-
    var(X),
    X is Z - Y.

suma(X,Y,Z) :-
    var(Y),
    Y is Z - X.

producto(X,Y,Z) :-
    nonvar(X),
    nonvar(Y),
    Z is X*Y.

producto(X,Y,Z) :-
    var(X),
    X is Z/Y.

producto(X,Y,Z) :-
    var(Y),
    Y is Z/X.


cuadrado(X,Y) :-
    var(Y),
    Y is X**2.

cuadrado(X,Y):-
    var(X),
    Y >= 0,
    X is Y**(1/2).

cuadrado(X,Y):-
    var(X),
    Y >= 0,
    X is -1*Y**(1/2).

exponencial(X,Y,Z) :-
    nonvar(X),
    nonvar(Y),
    Z is X**Y.

exponencial(X,Y,Z) :-
    var(Y),
    X >= 0,
    Y is log(Z)/log(X).

exponencial(X,Y,Z) :-
    var(X),
    X is Z**(1/Y).

exponencial(X,Y,Z) :-
    var(X),
    0 is (Y mod 2),
    X is -1*Z**(1/Y).