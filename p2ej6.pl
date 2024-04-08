% Considere la representación de matrices mediante listas de listas de valores reales
% en Prolog. Por ejemplo, la siguiente matrix de tamaño 2x3:
% 1 2 3
% 4 5 6
% se representa como: [ [ 1, 2, 3 ], [ 4, 5, 6 ] ]

% Implemente los siguientes predicados:
% columna(+M,?C,?R) C es la primera columna de M en forma de lista, R es M sin la primera columna
% transpuesta(+M,?T) T es la transpuesta de la matriz T
% simetrica(+M) M es una matriz simétrica
% suma(+M,+N,?S) S es la suma de las matrices M y N
% producto(+M,+N,?P) P es el producto de las matrices M y N

columna([],[],[]).
columna([[X|Xs]|Fs],C,R) :- 
    columna(Fs,C1,R1),
    append([Xs],R1,R),
    append([X],C1,C).

transpuesta([],[]).
transpuesta(M,[F1|F1s]) :-
    columna(M,F1,R),
    transpuesta(R,F1s).
transpuesta([[]|_],[]).

simetrica(M) :- 
    transpuesta(M,M2),
    M=M2.

suma_fila([],[],[]).
suma_fila([X|Xs],[Y|Ys],[Z|Zs]):- 
    Z is X+Y, 
    suma_fila(Xs,Ys,Zs).

suma([],[],[]).
suma([F|Filas],[F2|Filas2],[F3|Filas3]) :-
    suma_fila(F,F2,F3),
    suma(Filas,Filas2,Filas3).

producto_fila([],[],0).
producto_fila([X|Xs],[Y|Ys],T) :- 
    producto_fila(Xs,Ys,T1),
    T is X*Y + T1.

producto([[]|_],_,[[]]).
producto(_,[[]|_],[[]]).
producto([Fila|Fs],M2,[[ProdElem|ProdFila]|Ps]) :-
    columna(M2,C,R),
    producto_fila(Fila,C,ProdElem),
    producto([Fila|Fs],R,ProdFila),
    producto(Fs,M2,Ps).
