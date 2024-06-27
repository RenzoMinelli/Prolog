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

% recorrido de cambios de estado que la suma es T
recorrido([estado([],[a,b,c,d],right)],0).
recorrido([E1,E2|Estados],T):-
    cruce(E1,E2,T1),
    recorrido([E2|Estados],T2),
    T is T1+T2.

problema([estado([a,b,c,d],[],left)|RestoCamino]):-
    recorrido([estado([a,b,c,d],[],left)|RestoCamino], T),
    T < 15.
    
    