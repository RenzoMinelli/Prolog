% Ejercicio 5
% Este juego consiste en completar con cuadros negros una grilla de N X M casillas
% respetando ciertas indicaciones asociadas a las filas y columnas. Cada una de estas
% indicaciones consiste en una lista de números. Cada número representa el largo de
% una secuencia de cuadros negros en la fila o columna a la que está asociada. En el
% ejemplo que se da a continuación, la lista [3,2] asociada a la fila 3 indica que en esa
% fila hay dos (y sólo 2) secuencias de cuadros negros: la primera de largo 3 y la
% segunda de largo 2. 

% Defina el siguiente predicado:
% puzle(+Esp, ?Sol) Sol es la solución al puzle especificado por Esp.

% Esp va a ser un par de listas, la primera una lista de listas para cada fila, y la otra para columnas

columna([],[],[]).
columna([[X|Xs]|Fs],C,R) :- 
    columna(Fs,C1,R1),
    append([Xs],R1,R),
    append([X],C1,C).

sumar_unos_aux([], Contador, [Contador]) :- Contador > 0.
sumar_unos_aux([], Contador, []) :- Contador =:= 0.

sumar_unos_aux([1|Resto], Contador, Suma) :-
    NuevoContador is Contador + 1,
    sumar_unos_aux(Resto, NuevoContador, Suma).

sumar_unos_aux([0|Resto], Contador, [Contador|SumaResto]) :-
    Contador > 0,
    sumar_unos_aux(Resto, 0, SumaResto).

sumar_unos_aux([0|Resto], Contador, SumaResto) :-
    Contador =:= 0,
    sumar_unos_aux(Resto, 0, SumaResto).

sumar_unos(Lista, Suma) :- sumar_unos_aux(Lista, 0, Suma).

match(L,L).

verificar_reglas(Lista, Reglas) :-
    sumar_unos(Lista, ListaAgrupadas),
    ListaAgrupadas = Reglas.

puzle([[],[]],_).
puzle([ListasFilas,ListasColumnas],[PrimeraFilaMatriz|FilasMatriz]) :-
    [PrimeraListaFila|RestoListasFilas] = ListasFilas,
    [PrimeraListaColumna|RestoListasColumnas] = ListasColumnas,
    length(ListasFilas, M),
    length(ListasColumnas, N),
    length(PrimeraFilaMatriz, N),
    length([PrimeraFilaMatriz|FilasMatriz],M),
    columna([PrimeraFilaMatriz|FilasMatriz],C,[_|RestoFilasSinColumna]),
    verificar_reglas(PrimeraFilaMatriz,PrimeraListaFila),
    verificar_reglas(C,PrimeraListaColumna),
    puzle([RestoListasFilas,RestoListasColumnas],RestoFilasSinColumna).

    
% puzle(
%     [
%         [
%             [1], % primera fila tiene un grupo de 1
%             []   % segunda fila no tiene grupos
%         ],
%         [
%             [],  % primera columna no tiene nada
%             [1]  % segunda columna tiene un 1
%         ]
%     ],
%     R
% ).