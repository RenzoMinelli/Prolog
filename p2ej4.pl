% a) Defina los siguientes predicados en Prolog:

% insertionsort(+L,?S) S es el resultado de ordenar la lista L utilizando el algoritmo insertion sort
% mergesort(+L,?S) S es el resultado de ordenar la lista L utilizando el algoritmo merge sort
% quicksort(+L,?S) S es el resultado de ordenar la lista L utilizando el algoritmo quick sort

% insertionsort([],[]).
% insertionsort([X],[X]).
% insertionsort([X|Xs], [S|Ss]) :- X < S,

insertionsort(L,S) :- insertionsort_acc(L,[],S).

insertionsort_acc([],Ac,Ac).
insertionsort_acc([X|Xs],Ac,R) :- insertar_ordenado(X,Ac,NAc), insertionsort_acc(Xs,NAc,R).

insertar_ordenado(X,[],[X]).
insertar_ordenado(X,[O|Os],R) :- X < O, append([X], [O|Os], R).
insertar_ordenado(X,[O|Os],R) :- X >= O, insertar_ordenado(X,Os, R2), append([O], R2, R).

merge(L,[],L).
merge([],L,L).
merge([L1|L1s],[L2|L2s],[L1|Ms]) :- L1 =< L2, merge(L1s,[L2|L2s],Ms).
merge([L1|L1s],[L2|L2s],[L2|Ms]) :- L1 > L2, merge([L1|L1s],L2s,Ms).

cantidad_elems([],0).
cantidad_elems([X|Xs],N):- cantidad_elems(Xs,N1), N is N1 + 1.

primeros_n_elementos(_, 0, []).
primeros_n_elementos([X|Xs], N, [X|Ns]) :-
    N > 0,
    N1 is N - 1,
    primeros_n_elementos(Xs, N1, Ns).

ultimos_n_elementos(Lista, N, Resultado) :-
    cantidad_elems(Lista, Longitud),
    Longitud >= N,
    Cantidad is Longitud - N,
    drop(Lista, Cantidad, Resultado).

drop(Lista, 0, Lista).
drop([_|Resto], N, Resultado) :-
    N > 0,
    N1 is N - 1,
    drop(Resto, N1, Resultado).
    

partir_mitad_aux(L,L1,L2) :- 
    cantidad_elems(L,Largo),
    Largo mod 2 =:= 0,
    Mitad is Largo // 2, 
    primeros_n_elementos(L,Mitad, L1), 
    ultimos_n_elementos(L,Mitad,L2).

partir_mitad_aux(L,L1,L2) :- 
    cantidad_elems(L,Largo),
    Largo mod 2 =\= 0,
    Mitad is Largo // 2, 
    Mitad1 is Mitad+1,
    primeros_n_elementos(L,Mitad1, L1), 
    ultimos_n_elementos(L,Mitad,L2).

mergesort([],[]).
mergesort([X],[X]).

mergesort(L,S) :-
    partir_mitad_aux(L,L1,L2),
    mergesort(L1,S1),
    mergesort(L2,S2),
    merge(S1,S2,S).

