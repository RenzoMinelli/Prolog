% % Escriba el siguiente predicado en prolog. La solución no podrá invocarse
% recursivamente más de n veces, siendo n el largo de la lista original. Se sugiere
% utilizar listas de diferencias.
% listaCapicua(+L, ?LCap) LCap es una lista capicúa con el doble de elementos
% de L, y se cumple que L es prefijo de LCap.
% Ejemplos:
% listaCapicua([a,b,c], [a,b,c,c,b,a]).
% listaCapicua([a,b], [a,b,b,a]).
% listaCapicua([a], [a,a]).
% listaCapicua([], []).

listaCapicua_aux([],L-L).
listaCapicua_aux([X|Xs],[X|L2]-R):-
    listaCapicua_aux(Xs,L2-[X|R]).

listaCapicua(L,LC):-
    listaCapicua_aux(L,LC-[]).