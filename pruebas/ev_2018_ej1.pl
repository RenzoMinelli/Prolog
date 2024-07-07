diccionario([c,a,s,a]).
diccionario([c,a,o,s]).
diccionario([c,a,s,a,m,i,e,n,t,o]).
diccionario([d,e]).
diccionario([p,a,p,e,l]).
diccionario([t,r,a,p,o]).
diccionario([a,y,e,r]).

lista_incluida([],_).

lista_incluida([X|Xs],[X|Resto]) :-
    lista_incluida(Xs,Resto).

prediccion(Pref,PalDict) :-
    diccionario(PalDict),
    lista_incluida(Pref,PalDict).

distanciaSimplificada([],[],0).

distanciaSimplificada([X|Xs],[Y|Ys],N) :-
    X \= Y, !,
    distanciaSimplificada(Xs,Ys,N1),
    N is N1 +1.

distanciaSimplificada([X|Xs],[X|Ys],N) :-
    distanciaSimplificada(Xs,Ys,N).

equivalente(Palabra,Equivalente, Distancia) :-
    length(Palabra, N),
    diccionario(Equivalente),
    length(Equivalente, N),
    distanciaSimplificada(Palabra, Equivalente, Distancia).


correccionFrase([],[],0).

correccionFrase([P|Ps], [C|Cs], N):-
    correccionFrase(Ps,Cs,N1),
    equivalente(P,C,D),
    N is N1 + D.

correccionesFrase(Frase, Correciones) :-
    setof(D-C, correccionFrase(Frase,C,D),Correciones).