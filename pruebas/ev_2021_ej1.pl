colocar_pieza_aux([X|Xs],[],[X|Xs]).
colocar_pieza_aux([],[X|Xs],[X|Xs]).
colocar_pieza_aux([],[],[]).

colocar_pieza_aux([X|Xs],[Y|Ys],[R|Rs]):-
    var(X), nonvar(Y),
    R = Y,
    colocar_pieza_aux(Xs,Ys,Rs).

colocar_pieza_aux([X|Xs],[Y|Ys],[R|Rs]):-
    nonvar(X), var(Y),
    R = X,
    colocar_pieza_aux(Xs,Ys,Rs).

colocar_pieza_aux([X|Xs],[Y|Ys],[_|Rs]):-
    var(X), var(Y),
    colocar_pieza_aux(Xs,Ys,Rs).

sacar_inicio([],[],[]).
sacar_inicio([X|Xs],[X|ValoresRetirados],Rs):- 
    nonvar(X), 
    sacar_inicio(Xs,ValoresRetirados, Rs).

sacar_inicio([X|Xs],[],[X|Xs]):- 
    var(X).

colocar_pieza(Xs,Ys,Rs):-
    sacar_inicio(Xs, Inicio, XsSinInicio),
    colocar_pieza_aux(XsSinInicio,Ys,RsAux),
    append(Inicio,RsAux, Rs).

resolver_puzzle_aux([],Sol,Sol) :- ground(Sol).

resolver_puzzle_aux(Piezas,SolParcial,Sol):-
    select(Pieza, Piezas, RestoPiezas),
    colocar_pieza(SolParcial, Pieza, NuevaSolParcial),
    resolver_puzzle_aux(RestoPiezas, NuevaSolParcial, Sol).

resolver_puzzle(Piezas,Solucion):- resolver_puzzle_aux(Piezas, [], Solucion).

puzzle_bien_formado(Piezas) :-
    setof(Sol,resolver_puzzle(Piezas,Sol),Soluciones),
    length(Soluciones, 1).
    
