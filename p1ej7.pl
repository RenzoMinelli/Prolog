% Sea la siguiente definición de árbol binario (AB):

% arbol_bin(Arbol) <- Arbol es un árbol binario
% arbol_bin(vacio).
% arbol_bin(arbol(Raiz, Izq, Der)) :- arbol_bin(Izq), arbol_bin(Der).

% Defina los siguientes predicados sobre árboles binarios de naturales:

% member_ab(X, A) <- X es un elemento del AB A.
% cambiar(X, Y, Ax, Ay) <- El AB Ay se logra al cambiar en el AB Ax los X's por Y's.
% sumar(A, S) <- S tiene el valor de la suma de los elementos del AB A.
% abb(A) <- El AB A es un árbol binario de búsqueda (ABB).

arbol_bin(vacio).
arbol_bin(arbol(_, Izq, Der)) :- arbol_bin(Izq), arbol_bin(Der).

member_ab(X, arbol(X, _, _)).
member_ab(X, arbol(_, Izq, _)) :- member_ab(X, Izq).
member_ab(X, arbol(_, _, Der)) :- member_ab(X, Der).

cambiar(_, _, vacio, vacio).
cambiar(X,Y,arbol(X,Ari,Ard),arbol(Y,Ari2,Ard2)):- cambiar(X,Y,Ari,Ari2), cambiar(X,Y,Ard,Ard2).
cambiar(X,Y,arbol(Z,Ari,Ard),arbol(Z,Ari2,Ard2)):- X\=Z,cambiar(X,Y,Ari,Ari2), cambiar(X,Y,Ard,Ard2).

sumar(vacio, 0).
sumar(arbol(X,Izq,Der), S):- sumar(Izq,S1), sumar(Der,S2), S is (S1 + S2 + X).


menor_ab(vacio,_).
menor_ab(arbol(X,Izq,Der),N):- X < N, menor_ab(Izq,N), menor_ab(Der,N).

mayor_ab(vacio,_).
mayor_ab(arbol(X,Izq,Der),N):- X > N, mayor_ab(Izq,N), mayor_ab(Der,N).

abb(vacio).
abb(arbol(X,Izq,Der)) :- menor_ab(Izq,X), abb(Izq), mayor_ab(Der,X), abb(Der).

