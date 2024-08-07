adyacente(T,I1,J1,I1,J2):-
    member(celda(I1,J2,_),T),
    Dif is J1-J2,
    1 is abs(Dif).

adyacente(T,I1,J1,I2,J1):-
    member(celda(I2,J1,_),T),
    Dif is I1-I2,
    1 is abs(Dif).

valor_celda([celda(I,J,V)|_],I,J,V) :- !.
valor_celda([_|Ts],I,J,V):-
    valor_celda(Ts,I,J,V).

adyacente_valido(T,I1,J1,I2,J2):-
    adyacente(T,I1,J1,I2,J2),
    valor_celda(T,I1,J1,V1),
    valor_celda(T,I2,J2,V2),
    V2 is V1+1.

viaje(T,I1,J1,I2,J2,[(I1,J1),(I2,J2)],Visitados):-
    adyacente_valido(T,I1,J1,I2,J2),
    \+member(celda(I2,J2),Visitados).

viaje(T,I1,J1,I2,J2,[(I1,J1)|Cs],Visitados):-
    adyacente_valido(T,I1,J1,I3,J3),
    \+member(celda(I3,J3),Visitados),
    viaje(T,I3,J3,I2,J2,Cs,[celda(I3,J3)|Visitados]).

viaje(T,I1,J1,I2,J2,C):- 
    member(celda(I1,J1,1),T),
    viaje(T,I1,J1,I2,J2,C,[celda(I1,J1)]).

ciclo(T,I1,J1,I2,J2,Ciclo):-
    adyacente(T,I1,J1,I2,J2),
    viaje(T,I1,J1,I2,J2,Ciclo).

viajes_para_celdas(_, [], []).

viajes_para_celdas(T, [celda(I,J,_)|Celdas], Salida):-
    findall(Camino, viaje(T,I,J,_,_,Camino), CaminosCelda),
    viajes_para_celdas(T, Celdas, CaminosResto),
    append(CaminosCelda, CaminosResto, Salida).

camino_mas_largo([], LargoAcum, LargoAcum).

camino_mas_largo([C|Cs], LargoAcum, LargoMejor):-
    length(C, Largo),
    Largo > LargoAcum, !,
    camino_mas_largo(Cs, Largo, LargoMejor).

camino_mas_largo([_|Cs], LargoAcum, LargoMejor):-
    camino_mas_largo(Cs, LargoAcum, LargoMejor).

maximo_largo_de_viaje(T, N):-
    viajes_para_celdas(T, T, Viajes),
    camino_mas_largo(Viajes, 0, N).
