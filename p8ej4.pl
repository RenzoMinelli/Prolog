% Considere la representación de matrices mediante functores en Prolog. Una matriz
% se representa como un functor m aplicado a una serie de filas, y cada fila es un
% functor f aplicado a una serie de celdas. Por ejemplo, la siguiente matriz de tamaño
% 2x3:
% 1 2 3
% 4 5 6
% se representa como: m(f(1, 2, 3),f(4, 5, 6))
% Implemente los siguientes predicados:
% matriz(+F,+C,+V,-M)  M es una matriz de F filas y C columnas
% donde cada celda tiene el valor V
% celda(+M,?I,?J,?V)  V es el valor de la celda (I,J) de la matriz M
% nuevo_valor(+M,+I,
% +J,+V)
%  Se sustituye el valor de la celda (I,J) de la
% matriz M por V*
% suma(+M,+N,?S)  S es la suma de las matrices M y N
% * Notar que nuevo_valor no tiene argumento de salida. Se sugiere investigar el
% predicado extralógico set_arg/3 de SWI-Prolog.

lista_con_valor([],0,_).
lista_con_valor([V|Ls],Largo,V) :- 
    Largo > 0,
    Largo1 is Largo-1,
    lista_con_valor(Ls,Largo1,V).

matriz(F,C,V,M):-
    lista_con_valor(FilaDesarmada,C,V),
    Fila =.. [f|FilaDesarmada],
    lista_con_valor(Filas,F,Fila),
    M =.. [m|Filas].

celda(M,I,J,V) :-
    arg(I,M,Fila),
    arg(J,Fila,V).

nuevo_valor(M,I,J,V):-
    arg(I,M,Fila),
    nb_setarg(J,Fila,V).

suma_listas([],[],[]).
suma_listas([X|Xs],[Y|Ys],[Z|Zs]) :-
    Z is X+Y,
    suma_listas(Xs,Ys,Zs).

suma_fila(F1,F2,FR) :- 
    F1 =.. [f|Cols1],
    F2 =.. [f|Cols2],
    suma_listas(Cols1,Cols2,ColsR),
    FR =.. [f|ColsR].

suma_filas([],[],[]).
suma_filas([F1|F1s],[F2|F2s],[F3|F3s]):-
    suma_fila(F1,F2,F3),
    suma_filas(F1s,F2s,F3s).

suma(M,N,S):-
    M =.. [m|FilasM],
    N =.. [m|FilasN],
    suma_filas(FilasM,FilasN,FilasS),
    S =.. [m|FilasS].


