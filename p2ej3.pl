% Defina los siguientes predicados en Prolog:

% suma(+L,?S) S es la suma de los elementos de la lista L
% pares(+L,?P) P es una lista conteniendo solo los elementos pares de la lista L
% mayores(+L,+X,?M) M es una lista con los elementos de L que son mayores que X
% merge(+L1,+L2,?L3) L3 es el resultado de combinar ordenadamente los elementos de las listas (ordenadas) L1 y L2

suma([],0).
suma([X|L],N) :- suma(L,N1), N is (N1 + X).

pares([],[]).
pares([X|L],P) :- 0 is (X mod 2), pares(L,P2), append([X],P2,P).
pares([X|L],P) :- 0 =\= (X mod 2), pares(L,P).

mayores([],_,[]).
mayores([L|Ls], X, M) :- L > X, mayores(Ls,X,M2), M = [L|M2].
mayores([L|Ls], X, M) :- L =< X, mayores(Ls,X,M).

merge(L,[],L).
merge([],L,L).
merge([L1|L1s],[L2|L2s],[L1|Ms]) :- L1 =< L2, merge(L1s,[L2|L2s],Ms).
merge([L1|L1s],[L2|L2s],[L2|Ms]) :- L1 > L2, merge([L1|L1s],L2s,Ms).