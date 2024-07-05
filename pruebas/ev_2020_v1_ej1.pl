rotaciones(F,F).
rotaciones(f(F1,F2),f(F2,F1)).

domino_matchea(f(_,Valor),Fichas,f(Valor,Otro), FResto):- 
    select(f(Valor,Otro),Fichas,FResto).

domino_matchea(f(_,Valor),Fichas,f(Valor,Otro), FResto):- 
    select(f(Otro,Valor),Fichas,FResto).

colocacion_aux(_,[],[]) :- !.
colocacion_aux(FichaAnterior,Fichas,[F|ColAux]):-
    domino_matchea(FichaAnterior,Fichas,F,FResto), !,
    colocacion_aux(F,FResto,ColAux).
colocacion_aux(_,_,[]). % si no hay ninguna ficha que matchea cortamos


colocacion([],[]).
colocacion(Fichas, [FR|ColAux]):-
    select(F,Fichas,FResto),
    rotaciones(F,FR),
    colocacion_aux(FR,FResto,ColAux).

valor([],0).
valor([f(V1,V2)|Cs],N):-
    valor(Cs,N2),
    N is N2 + V1 + V2.

mayor_valor_aux([],CMejor, ValMejor, CMejor, ValMejor).
mayor_valor_aux([C|Cs], _, ValAcum, CMejor, ValMejor):-
    valor(C, V),
    V > ValAcum, !,
    mayor_valor_aux(Cs, C, V, CMejor, ValMejor).

mayor_valor_aux([_|Cs], CAcum, ValAcum, CMejor, ValMejor):-
    mayor_valor_aux(Cs, CAcum, ValAcum, CMejor, ValMejor).

mayor_valor(Fichas,Col) :-
    findall(C,colocacion(Fichas,C),ColAux),
    mayor_valor_aux(ColAux,nil,0,Col,_).
