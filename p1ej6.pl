% Escriba el predicado ancestro(X, Y, L), que retorna una lista L con la línea de
% descendencia entre un ancestro X y su descendiente Y. Suponga definido el
% predicado progenitor, idéntico al de ejercicio 1 de este práctico. 
% Suponga definidos los siguientes predicados:
% progenitor(X, Y) <- X es el progenitor (madre o padre) de Y
% Por ejemplo:

progenitor(juan, jose).
progenitor(jose, pedro).
progenitor(pedro, maria).

% Si la consulta es ancestro(juan, maria, L), la lista L tiene los elementos [juan, jose,pedro,maría].

ancestro(X, Y, [X,Y]) :- progenitor(X, Y).
ancestro(X, Y, [X|L]) :- progenitor(X, Z), ancestro(Z, Y, L).

