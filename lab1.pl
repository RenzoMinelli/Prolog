% pertenece(?X,?L) ← El elemento X pertenece a la lista L.
% Ej.: pertenece(c,[a,d,c,a]).

pertenece(X,[X|_]).
pertenece(X,[_|Ys]) :- pertenece(X,Ys).

% no_pertenece(+X,+L) ← El elemento X no pertenece a la lista L.
% Ej.: no_pertenece(b,[a,d,c,a]).

no_pertenece(_, []).
no_pertenece(E, [X|L]) :- X\=E, no_pertenece(E, L).

% elegir(?X,?L,?R) ← La lista R resulta de eliminar el elemento X de la lista L.
% Ej: elegir(a,[a,b,a,a],[a,b,a]).

elegir(X,[X|Xs],Xs).
elegir(X,[Y|Ys],[Y|Res]) :- elegir(X,Ys,Res).

% contenida(+L1,+L2) ← todos los elementos de L1 pertenecen a L2.
% Ej.: contenida([a,b,a,a],[a,b,c]).

contenida([],_).
contenida([X|XT], L):-
    pertenece(X, L),
    contenida(XT, L).

% permutacion(+L1,?L2) ← La lista L2 es una permutación de la lista L1.
% Ej.: permutacion([a,b,c],[c,a,b]).

permutacion([], []).
permutacion([N|L], R) :- permutacion(L,I), elegir(N,R,I).

% suma(+L,?S) ← S es la suma de los elementos de la lista L.
% Ej: suma([1,2,3,4],10).

suma([], 0).
suma([N|L], S) :- suma(L, X), S is X + N.

% rango(+N,?R) ← R es la lista que contiene los elementos de 1 a N.
% Ej: suma(5,[1,2,3,4,5]).

rango(1,[1]).
rango(N,R):-
    N > 1,
    N1 is N-1,
    rango(N1,R1),
    append(R1,[N],R).

% tomar_n(+L,+N,?L1,?L2) ← L1 es una lista con los primeros N elementos de la
% lista L, L2 es una lista con el resto de los elementos de la lista L.
% Ej.: tomar_n([a,b,c,d,e,f,g],3,[a,b,c],[d,e,f,g]).

tomar_n(L,0,[],L).
tomar_n([X|Xs],N,[X|L1],L2) :- 
    N > 0,
    N1 is N-1,
    tomar_n(Xs,N1,L1,L2).

% columna(+F,?C,?R) ← M es una matriz representada como lista de listas de
% números, C es la primera columna de M en forma de lista y R es M sin la primera
% columna.
% Ej.: columna([[1,2,3],[4,5,6]], [1,4], [[2,3],[5,6]]).

columna([],[],[]).
columna([[F|RestoFila]|MT], [F|CT], [RestoFila|RT]):-
    columna(MT, CT, RT).

% transpuesta(+M,?T) ← M es una matriz representada como lista de listas de
% números, T es la transpuesta de la matriz M.
% Ej.: transpuesta([[1,2,3],[4,5,6]], [[1,4],[2,5],[3,6]]).

transpuesta([[]|_], []).
transpuesta(M, [C|T]) :- columna(M, C, R), transpuesta(R, T).


% bloques(+M,+K,?B) ← M es una matriz que representa un sudoku de orden K, B es
% su lista de bloques, donde cada bloque es una lista de K² números obtenidos de
% M. Notar que cada bloque es lista simple, no lista de listas. La cantidad de bloques
% a obtener será también K². Por ejemplo (ver también Fig. 2):
% ?- bloques([[2,1,3,4], [4,3,2,1], [1,2,4,3], [3,4,1,2]], 2, B).
% B = [[2,1,4,3], [3,4,2,1], [1,2,3,4], [4,3,1,2]]

% primeras_k_columnas(M,0,[],M).
% primeras_k_columnas(M,K,[C|Cols],RestoColsM):-
%     K>0,
%     K1 is K-1,
%     columna(M,C,RestoM),
%     primeras_k_columnas(RestoM,K1,Cols,RestoColsM).

achatar([],[]).
achatar([L|Ls],R) :-
    achatar(Ls,LsAchatado),
    append(L,LsAchatado,R).

primeros_k_de_filas([],_,[],[]).
primeros_k_de_filas([F|M],K,[KElems|Fs],[RestoFila|RestoFilasM]) :-
    tomar_n(F,K,KElems,RestoFila),
    primeros_k_de_filas(M,K,Fs,RestoFilasM).

bloques_en_fila([[]|_],_,[]).
bloques_en_fila(M,K,[L1|RestoBloques]) :-
    primeros_k_de_filas(M,K,B1,RestoM),
    achatar(B1,L1),
    bloques_en_fila(RestoM,K,RestoBloques).

bloques([],_,[]).
bloques(M,K,Bloques) :-
    tomar_n(M,K,KPrimerasFilas,RestoFilas),
    bloques_en_fila(KPrimerasFilas,K,BloquesFila),
    bloques(RestoFilas,K,BloquesResto),
    append(BloquesFila,BloquesResto,Bloques). % ver si se puede mergear de otra forma
