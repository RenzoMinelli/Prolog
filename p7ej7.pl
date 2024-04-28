% Considere que C1, C2 y C3 son conjuntos representados como listas sin elementos
% repetidos. Implemente los siguientes predicados en Prolog utilizando not:
% i. diferencia(+C1,+C2,?C3) ← C3 es el conjunto C1 - C2.
% ii. disjuntos(+C1,+C2) ← C1 y C2 son disjuntos.

disjuntos([], _).
disjuntos([H|T], L) :- \+member(H,L), disjuntos(T,L).