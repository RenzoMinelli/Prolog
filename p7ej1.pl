% Considere que C1, C2 y C3 son conjuntos representados como listas sin
% elementos repetidos. Implemente los siguientes predicados en Prolog puro más el
% predicado \= para chequear que dos elementos sean diferentes.

% i. intersec(+C1,+C2,?C3) ← C3 es la intersección de los conjuntos C1 y C2.
% ii. diferencia(+C1,+C2,?C3) ← C3 es el conjunto C1 - C2.

intersec([], _, []).
intersec(_, [], []).
intersec([H|T], L, [H|C]) :- select(H,L,L2), intersec(T, L2, C), !.
intersec([H|T], L, C) :- \+member(H,L), intersec(T, L, C).

diferencia([], _, []).
diferencia([H|T], L, [H|C]) :- \+member(H,L), diferencia(T,L,C), !.
diferencia([H|T], L, C) :- select(H,L,L2), diferencia(T,L2,C).

% b) Mejore la eficiencia de los predicados de la parte a) utilizando cut de manera
% que no se recorra la segunda lista lista innecesariamente.

