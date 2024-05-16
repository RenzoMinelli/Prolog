% Ejercicio 3
% Escriba los siguientes predicados para árboles de enteros, representados mediante
% estructuras incompletas:
% pre_orden(A, L) L es una lista con los elementos del árbol binario A,
% obtenida al recorrerlo pre-orden.
% in_orden(A, L) L es una lista con los elementos del árbol binario A,
% obtenida al recorrerlo in-orden.
% ins_abb(A, E) El árbol binario de búsqueda A contiene al
% elemento E en la posición que le corresponde
% según su valor.

append_ld(A-AR,AR-BR,A-BR).

pre_orden(X,L-L):- var(X),!.
pre_orden(a(X,I,D),L-LR) :-
    pre_orden(I,L1-R1),
    pre_orden(D,L2-R2),
    append_ld([X|L1]-R1,L2-R2,L-LR).

in_orden(X,L-L):- var(X),!.
in_orden(a(X,I,D),L-LR) :-
    in_orden(I,L1-R1),
    in_orden(D,L2-R2),
    append_ld(L1-R1,[X|L2]-R2,L-LR).

ins_abb(a(E,_,_),E):-!.
ins_abb(a(X,I,_),E):-
    E < X, !,
    ins_abb(I,E).
ins_abb(a(_,_,D),E):-
    % E >= X, 
    ins_abb(D,E).
% A = a(3,a(2,_,_),a(7,a(5,_,_),_))