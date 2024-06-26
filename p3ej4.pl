% Ejercicio 4
% Escriba un programa Prolog que resuelva el problema de las novias celosas. Este
% problema consiste en tres parejas que deben cruzar un río de una orilla a otra en un
% bote cuya capacidad es de dos personas. La solución consiste en encontrar una
% secuencia de viajes de manera tal que en ningún momento un hombre se encuentre
% en presencia de otras mujeres sin su novia. Tenga en cuenta que, en cada cruce,
% cualquiera de los seis puede manejar el bote si se encuentra en su orilla.

% estado(Izq,Barco,Der,PosBarco).

mujer(m_1).
mujer(m_2).
mujer(m_3).

hombre(h_1).
hombre(h_2).
hombre(h_3).

pareja(h_1, m_1).
pareja(h_2, m_2).
pareja(h_3, m_3).

estado_invalido(estado(_,Barco,_,_)) :- hombre(H), member(H, Barco), mujer(M), member(M, Barco), \+pareja(H,M).
estado_invalido(estado(Izq,_,_,_)) :- hombre(H), member(H, Izq), pareja(H,Esposa), \+member(Esposa,Izq), mujer(M), member(M,Izq).
estado_invalido(estado(_,_,Der,_)) :- hombre(H), member(H, Der), pareja(H,Esposa), \+member(Esposa,Der), mujer(M), member(M,Der).

subir_barco(estado(Izq,Barco,Der,barco_izq), estado(IzqResto,NBarco,Der,barco_izq)):-
    length(Barco,CantTripulantes),
    CantTripulantes < 2,
    select(P,Izq,IzqResto),
    append([P],Barco,NBarco),
    \+estado_invalido(estado(IzqResto,NBarco,Der,barco_izq)).

subir_barco(estado(Izq,Barco,Der,barco_der), estado(Izq,NBarco,DerResto,barco_der)):-
    length(Barco,CantTripulantes),
    CantTripulantes < 2,
    select(P,Der,DerResto),
    append([P],Barco,NBarco),
    \+estado_invalido(estado(Izq,NBarco,DerResto,barco_der)).

bajar_barco(estado(Izq,Barco,Der,barco_izq), estado(NIzq,NBarco,Der,barco_izq)):-
    length(Barco,CantTripulantes),
    CantTripulantes > 0,
    select(P,Barco,NBarco),
    append([P],Izq,NIzq),
    \+estado_invalido(estado(NIzq,NBarco,Der,barco_izq)).
    
bajar_barco(estado(Izq,Barco,Der,barco_der), estado(Izq,NBarco,NDer,barco_der)):-
    length(Barco,CantTripulantes),
    CantTripulantes > 0,
    select(P,Barco,NBarco),
    append([P],Der,NDer),
    \+estado_invalido(estado(Izq,NBarco,NDer,barco_der)).

moverse(estado(Izq,Barco,Der,barco_der), estado(Izq,Barco,Der,barco_izq)).
moverse(estado(Izq,Barco,Der,barco_izq), estado(Izq,Barco,Der,barco_der)).


cambiar_estado(estado(Izq,Barco,Der,barco_izq), estado(IzqN,BarcoN,Der,barco_izq)) :-
    subir_barco(estado(Izq,Barco,Der,barco_izq), estado(IzqN,BarcoN,Der,barco_izq)).

cambiar_estado(estado(Izq,Barco,Der,barco_der), estado(Izq,BarcoN,DerN,barco_der)) :-
    subir_barco(estado(Izq,Barco,Der,barco_der), estado(Izq,BarcoN,DerN,barco_der)).

cambiar_estado(estado(Izq,Barco,Der,barco_izq), estado(IzqN,BarcoN,Der,barco_izq)) :-
    bajar_barco(estado(Izq,Barco,Der,barco_izq), estado(IzqN,BarcoN,Der,barco_izq)).

cambiar_estado(estado(Izq,Barco,Der,barco_der), estado(Izq,BarcoN,DerN,barco_der)) :-
    bajar_barco(estado(Izq,Barco,Der,barco_der), estado(Izq,BarcoN,DerN,barco_der)).

cambiar_estado(estado(Izq,Barco,Der,Lado),EstadoN) :- 
    length(Barco,CantTripulantes),
    CantTripulantes > 0,
    moverse(estado(Izq,Barco,Der,Lado),EstadoN).

estado_final(estado([],[],Der,barco_der)):-
    member(m_1,Der),
    member(m_2,Der),
    member(m_3,Der),
    member(h_1,Der),
    member(h_2,Der),
    member(h_3,Der).

viajes_acum([Estado|[]]) :- estado_final(Estado).
viajes_acum([Estado1, Estado2 | Estados]) :-
    cambiar_estado(Estado1,Estado2),
    viajes_acum([Estado2|Estados]).

estado_inicial(estado([h_1,m_1,h_2,m_2,h_3,m_3],[],[],barco_izq)).
viajes([E|Es]):-
    estado_inicial(E),
    viajes_acum([E|Es]).