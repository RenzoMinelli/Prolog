% Escriba los siguientes predicados sobre listas de diferencias.
% Para las listas de diferencias utilice la representación mediante términos
% estructurados de la forma: X-Xr
% l_ld(L, LD) LD es una lista de diferencias equivalente a la lista L.
% ld_l(LD, L) L es la lista equivalente a la lista de diferencias LD.
% append_ld(A,B,C) C es la lista de diferencia equivalente a concatenar
% las listas de diferencias A y B.
% inserta_ld(L1,X,L2) L2 es la lista de diferencias resultante de insertar el
% elemento X al comienzo de la lista de diferencias L1.
% insertz_ld(L1,X,L2) L2 es la lista de diferencias resultante de insertar el
% elemento X al final de la lista de diferencias L1.
% rotacion_ld(L1, L2) L2 es la lista de diferencias que resulta de rotar un
% lugar a la izquierda, en forma circular, los elementos
% de la lista de diferencias L1.
% Ejemplo: rotacion_ld([a,b,c|X]-X, [b,c,a|Y]-Y)
% reverse_ld(L,R) R es la lista de diferencias que representa el inverso
% de la lista común L.
% quicksort_ld(L,S) S es la lista de diferencias ordenada que representa
% la lista común L ordenada utilizando el algoritmo
% quicksort.

l_ld([],LD-LD).
l_ld([X|Xs],[X|LD2]-R):-
    l_ld(Xs,LD2-R).

ld_l(LD-[],LD).

append_ld(A-AR,AR-BR,A-BR).

inserta_ld(A-Ar,X,[X|A]-Ar).

insertz_ld(A-[X|Br],X,A-Br).

rotacion_ld([X|Xs]-[X|Br],Xs-Br).

reverse_ld([],B-B).
reverse_ld([X|Xs],B-Br):-
    reverse_ld(Xs,B-[X|Br]).