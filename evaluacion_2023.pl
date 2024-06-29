tiempo(a,1).
tiempo(b,2).
tiempo(c,5).
tiempo(d,8).

mayor(A,B,A) :- A>B, !.
mayor(_,B,B).

% cruce izq -> derecha 1 persona
cruce(estado(Izq1,Der1,left),estado(Izq2,Der2,right),T):-
    select(P1,Izq1,Izq2),
    append([P1],Der1,Der2Aux),
    sort(Der2Aux,Der2),
    tiempo(P1,T).

% cruce izq -> derecha 2 personas
cruce(estado(Izq1,Der1,left),estado(Izq2,Der2,right),T):-
    select(P1,Izq1,Izq2Aux),
    select(P2,Izq2Aux,Izq2),
    append([P1,P2],Der1,Der2Aux),
    sort(Der2Aux,Der2),
    tiempo(P1,T1), tiempo(P2,T2),
    mayor(T1,T2,T).

% cruce der -> izq 1 persona
cruce(estado(Izq1,Der1,right),estado(Izq2,Der2,left),T):-
    select(P1,Der1,Der2),
    append([P1],Izq1,Izq2Aux),
    sort(Izq2Aux,Izq2),
    tiempo(P1,T).

% cruce der -> izq 2 personas
cruce(estado(Izq1,Der1,right),estado(Izq2,Der2,left),T):-
    select(P1,Der1,Der2Aux),
    select(P2,Der2Aux,Der2),
    append([P1,P2],Izq1,Izq2Aux),
    sort(Izq2Aux,Izq2),
    tiempo(P1,T1), tiempo(P2,T2),
    mayor(T1,T2,T).

camino(X,Y,Visitados,[X,Y],T) :-
    cruce(X,Y,T),
    \+member(Y,Visitados).

camino(X,Y,Visitados,[X|Camino], T):-
    cruce(X,Z,T1),
    \+member(Z,Visitados),
    camino(Z,Y,[X|Visitados],Camino, T2),
    T is T1 + T2.

% Estado final
final(estado([],Final,_)):-
    sort(Final,[a,b,c,d]).
% Estado inicial
inicial(estado([a,b,c,d],[],left)).
   
% recorrido de cambios de estado que la suma es T
recorrido(Camino,T):-
    inicial(X),
    camino(X,Y,[],Camino,T),
    final(Y).

problema(Camino):-
    recorrido(Camino, T),
    T < 15.
    
    
1/6::dado(1,1);1/6::dado(1,2);1/6::dado(1,3);1/6::dado(1,4);1/6::dado(1,5);1/6::dado(1,6).
1/6::dado(2,1);1/6::dado(2,2);1/6::dado(2,3);1/6::dado(2,4);1/6::dado(2,5);1/6::dado(2,6).
1/6::dado(3,1);1/6::dado(3,2);1/6::dado(3,3);1/6::dado(3,4);1/6::dado(3,5);1/6::dado(3,6).

escalera:-
    dado(X,1), dado(Y,2), dado(Z,3),
    X \= Y, Y\=Z.

escalera:-
    dado(X,2), dado(Y,3), dado(Z,4),
    X \= Y, Y\=Z.

escalera:-
    dado(X,3), dado(Y,4), dado(Z,5),
    X \= Y, Y\=Z.

escalera:-
    dado(X,4), dado(Y,5), dado(Z,6),
    X \= Y, Y\=Z.

todos_iguales :-
    dado(1,X), dado(2,X), dado(3,Z).
query(escalera).
query(todos_iguales).

% dado(1).
% dado(2).
% dado(3).

% 1/6::elegir(X,1) ; 1/6::elegir(X,2) ; 1/6::elegir(X,3) ; 1/6::elegir(X,4) ; 1/6::elegir(X,5) ; 1/6::elegir(X,6).

% dado(X,Y) :- dado(X),elegir(X,Y).
% todos_iguales2 :- dado(1,Y), dado(2,Y), dado(3,Y).

escalera2 :- dado(1,X),dado(2,Y),dado(3,Z),Y is X+1, Z is Y+1. % 1 2 3
escalera2 :- dado(1,X),dado(2,Y),dado(3,Z),Y is X+2, Z is X+1. % 1 3 2
escalera2 :- dado(1,X),dado(2,Y),dado(3,Z),X is Y+1, Z is Y+2. % 2 1 3
escalera2 :- dado(1,X),dado(2,Y),dado(3,Z),X is Z+2, Y is Z+1. % 2 3 1
escalera2 :- dado(1,X),dado(2,Y),dado(3,Z),X is Y+2, Z is Y+1. % 3 1 2
escalera2 :- dado(1,X),dado(2,Y),dado(3,Z),X is Z+2, Y is Z+1. % 3 2 1

query(escalera2).
% query(todos_iguales2).