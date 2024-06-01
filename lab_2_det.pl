puntaje(Dados, aces, Puntos) :- ocurrencias(Dados, 1, Puntos).

puntaje(Dados, twos, Puntos) :- ocurrencias(Dados, 2, N), Puntos is N*2.

puntaje(Dados, threes, Puntos) :- ocurrencias(Dados, 3, N), Puntos is N*3.

puntaje(Dados, fours, Puntos) :- ocurrencias(Dados, 4, N), Puntos is N*4.

puntaje(Dados, fives, Puntos) :- ocurrencias(Dados, 5, N), Puntos is N*5.

puntaje(Dados, sixes, Puntos) :- ocurrencias(Dados, 6, N), Puntos is N*6.

puntaje(Dados, three_of_a_kind, Puntos) :- cantidad_ocurrencias(Dados, [1,2,3,4,5,6], 3, Num), Num \= 0, suma_lista(Dados, Puntos), !.
puntaje(_, three_of_a_kind, 0).

puntaje(Dados, four_of_a_kind, Puntos) :- cantidad_ocurrencias(Dados, [1,2,3,4,5,6], 4, Num), Num \= 0, suma_lista(Dados, Puntos), !.
puntaje(_, four_of_a_kind, 0).

puntaje(Dados, full_house, Puntos) :- 
    cantidad_ocurrencias(Dados, [1,2,3,4,5,6], 5, Num), 
    Num \= 0, 
    Puntos = 25, !.
puntaje(Dados, full_house, Puntos) :-
    cantidad_ocurrencias(Dados, [1,2,3,4,5,6], 3, Num),
    Num = 0, 
    Puntos = 0, !.
puntaje(Dados, full_house, Puntos) :-
    cantidad_ocurrencias(Dados, [1,2,3,4,5,6], 3, Num),
    select(Num, [1,2,3,4,5,6], L),
    cantidad_ocurrencias(Dados, L, 2, Num1),
    Num1 \= 0,
    Puntos = 25, !.
puntaje(_, full_house, 0).
    
puntaje(Dados, small_straight, Puntos) :- 
    ocurrencias(Dados, 3, N1),
    ocurrencias(Dados, 4, N2),
    N is N1 * N2,
    N = 0, 
    Puntos = 0, !.
puntaje(Dados, small_straight, Puntos) :- 
    ocurrencias(Dados, 1, 1),
    ocurrencias(Dados, 2, 1),
    Puntos = 30, !.
puntaje(Dados, small_straight, Puntos) :- 
    ocurrencias(Dados, 2, 1),
    ocurrencias(Dados, 5, 1),
    Puntos = 30, !.
puntaje(Dados, small_straight, Puntos) :- 
    ocurrencias(Dados, 5, 1),
    ocurrencias(Dados, 6, 1),
    Puntos = 30, !.
puntaje(_, small_straight, 0).

puntaje(Dados, large_straight, Puntos) :- 
    ocurrencias(Dados, 2, 1),
    ocurrencias(Dados, 3, 1),
    ocurrencias(Dados, 4, 1),
    ocurrencias(Dados, 5, 1),
    cantidad_ocurrencias(Dados, [1,6], 1, Num),
    Num \= 0,
    Puntos = 40, !.
puntaje(_, large_straight, 0).

puntaje(Dados, yahtzee, Puntos) :- cantidad_ocurrencias(Dados, [1,2,3,4,5,6], 5, Num), Num \= 0, Puntos = 50, !.
puntaje(_, yahtzee, 0).

puntaje(Dados, chance, Puntos) :- suma_lista(Dados, Puntos).

%--------------------------------------------------------------------------------------------------------------------------------

ocurrencias([], _, 0).
ocurrencias([X|L], Num, Cant) :- X = Num, ocurrencias(L, Num, Cant1), Cant is Cant1 + 1,!.
ocurrencias([_|L], Num, Cant) :- ocurrencias(L, Num, Cant).

cantidad_ocurrencias(_, [], _, 0).
cantidad_ocurrencias(Dados, [X|_], N, Num) :- 
    ocurrencias(Dados, X, Cant), 
    Cant >= N, 
    Num = X, !.
cantidad_ocurrencias(Dados, [_|L], N, Num) :- cantidad_ocurrencias(Dados, L, N, Num).

chequear_escalera(Dados, [X|L1], Largo, Faltan, [X|L2]) :-
    ocurrencias(Dados, X, Cant_X),
    Cant_X > 0,
    chequear_escalera(Dados, L1, Largo, Faltan1, L2),
    Faltan is Faltan1 - 1, !.
chequear_escalera(Dados, [_|L1], Largo, Faltan, L2) :- chequear_escalera(Dados, L1, Largo, Faltan, L2), !.
chequear_escalera(_, [], Largo, Largo, []).

% Ver si se puede apendear al final los que ya estan completados y listo en vez de repetirlos
obtener_prioridades([],[6,5,4,3,2,1,6,5,4,3,2,1]).
obtener_prioridades([sixes|Completados], Lista) :- obtener_prioridades(Completados, Lista1), select(6, Lista1, Lista), !.
obtener_prioridades([fives|Completados], Lista) :- obtener_prioridades(Completados, Lista1), select(5, Lista1, Lista), !.
obtener_prioridades([fours|Completados], Lista) :- obtener_prioridades(Completados, Lista1), select(4, Lista1, Lista),!.
obtener_prioridades([threes|Completados], Lista) :- obtener_prioridades(Completados, Lista1), select(3, Lista1, Lista), !.
obtener_prioridades([twos|Completados], Lista) :- obtener_prioridades(Completados, Lista1), select(2, Lista1, Lista), !.
obtener_prioridades([aces|Completados], Lista) :- obtener_prioridades(Completados, Lista1), select(1, Lista1, Lista), !.
obtener_prioridades([_|Completados], Lista) :- obtener_prioridades(Completados, Lista), !.

chequear_iguales(Dados, [X|_], Largo, Faltan, [Num], Completados) :-
    obtener_prioridades(Completados, Prioridades),
    cantidad_ocurrencias(Dados, Prioridades, X, Num), 
    Num \= 0, 
    Faltan is Largo-X, !.
chequear_iguales(Dados, [_|L1], Largo, Faltan, L2, Completados) :- chequear_iguales(Dados, L1, Largo, Faltan, L2, Completados).
chequear_iguales(_, [], Largo, Largo, [],_).

remover([], _, []).
remover([X|L], E, Res) :- X = E, remover(L, E, Res), !.
remover([X|L], E, [X|Res]) :- remover(L, E, Res).

suma_lista([], 0).
suma_lista([X|L], Cant) :- suma_lista(L, Cant_rec), Cant is Cant_rec + X.

categorias_disponibles([], _, []).
categorias_disponibles([s(Campo, _)|R], Completadas, Disponibles) :-
    member(Campo, Completadas),
    categorias_disponibles(R, Completadas, Disponibles), !.
categorias_disponibles([E|R], Completadas, [E|Disponibles]) :- categorias_disponibles(R, Completadas, Disponibles).

%--------------------------------------------------------------------------------------------------------------------------------

dados_faltantes(Dados, yahtzee, Faltan, Mantener, Completados) :- chequear_iguales(Dados, [5,4,3,2,1], 5, Faltan, Mantener, Completados).

dados_faltantes(Dados, large_straight, Faltan1, Mantener1,_) :- 
    chequear_escalera(Dados, [1,2,3,4,5], 5, Faltan1, Mantener1),
    chequear_escalera(Dados, [2,3,4,5,6], 5, Faltan2, _),
    Faltan2 >= Faltan1, !.
dados_faltantes(Dados, large_straight, Faltan2, Mantener2,_) :- 
    chequear_escalera(Dados, [2,3,4,5,6], 5, Faltan2, Mantener2).

dados_faltantes(Dados, small_straight, Faltan1, Mantener1,_) :-
    chequear_escalera(Dados, [1,2,3,4], 4, Faltan1, Mantener1),
    chequear_escalera(Dados, [2,3,4,5], 4, Faltan2, _),
    chequear_escalera(Dados, [3,4,5,6], 4, Faltan3, _),
    Faltan2 >= Faltan1,
    Faltan3 >= Faltan1, !.
dados_faltantes(Dados, small_straight, Faltan2, Mantener2,_) :-
    chequear_escalera(Dados, [2,3,4,5], 4, Faltan2, Mantener2),
    chequear_escalera(Dados, [3,4,5,6], 4, Faltan3, _),
    Faltan3 >= Faltan2, !.
dados_faltantes(Dados, small_straight, Faltan3, Mantener3,_) :-
    chequear_escalera(Dados, [3,4,5,6], 4, Faltan3, Mantener3).

% todos iguales son full house
dados_faltantes(Dados, full_house, 0, [Num], _) :- 
    cantidad_ocurrencias(Dados, [1,2,3,4,5,6], 5, Num), 
    Num \= 0, !.
    
dados_faltantes(Dados, full_house, Faltan, [Mantener1|Mantener2], Completados) :-
    chequear_iguales(Dados, [3,2,1], 3, Faltan1, [Mantener1], Completados),
    remover(Dados, Mantener1, Dados1),
    chequear_iguales(Dados1, [2,1], 2, Faltan2, Mantener2, Completados),
    Faltan is Faltan1 + Faltan2.

dados_faltantes(Dados, four_of_a_kind, Faltan, Mantener, Completados) :- chequear_iguales(Dados, [4,3,2,1], 4, Faltan, Mantener, Completados).

dados_faltantes(Dados, three_of_a_kind, Faltan, Mantener, Completados) :- chequear_iguales(Dados, [3,2,1], 3, Faltan, Mantener, Completados).

dados_faltantes(Dados, sixes, Faltan, [6], _) :- ocurrencias(Dados, 6, Cant), Faltan is 5-Cant.

dados_faltantes(Dados, fives, Faltan, [5], _) :- ocurrencias(Dados, 5, Cant), Faltan is 5-Cant.

dados_faltantes(Dados, fours, Faltan, [4], _) :- ocurrencias(Dados, 4, Cant), Faltan is 5-Cant.

dados_faltantes(Dados, threes, Faltan, [3], _) :- ocurrencias(Dados, 3, Cant), Faltan is 5-Cant.

dados_faltantes(Dados, twos, Faltan, [2], _) :- ocurrencias(Dados, 2, Cant), Faltan is 5-Cant.

dados_faltantes(Dados, aces, Faltan, [1], _) :- ocurrencias(Dados, 1, Cant), Faltan is 5-Cant.

dados_faltantes([], chance, 5, [], _).
dados_faltantes([D|RestoDados], chance, Faltan, Mantener, _) :- 
    D > 3, 
    dados_faltantes(RestoDados, chance, Faltan1, Mantener, []), 
    member(D, Mantener), 
    Faltan is Faltan1 - 1, !.
dados_faltantes([D|RestoDados], chance, Faltan, [D|Mantener], _) :- 
    D > 3, 
    dados_faltantes(RestoDados, chance, Faltan1, Mantener, []), 
    Faltan is Faltan1 - 1, !.
dados_faltantes([_|RestoDados], chance, Faltan, Mantener, _) :- dados_faltantes(RestoDados, chance, Faltan, Mantener,[]).
%--------------------------------------------------------------------------------------------------------------------------------

obtener_patron_aux([], _, [], _).
obtener_patron_aux([Mantener|L1], [Mantener], [1|L2], 0) :- Mantener =< 3, obtener_patron_aux(L1, [Mantener], L2, 0), !.
obtener_patron_aux([Mantener|L1], [Mantener], [0|L2], 0) :- obtener_patron_aux(L1, [Mantener], L2, 0), !.
obtener_patron_aux([Mantener|L1], [Mantener], [0|L2], Cant) :- Cant1 is Cant - 1, obtener_patron_aux(L1, [Mantener], L2, Cant1), !.
obtener_patron_aux([D|L1], [Mantener], [1|L2], Cant) :- D =< 3, obtener_patron_aux(L1, [Mantener], L2, Cant), !.
obtener_patron_aux([_|L1], [Mantener], [0|L2], Cant) :- obtener_patron_aux(L1, [Mantener], L2, Cant), !.

obtener_patron([], yahtzee, _, [], _).
obtener_patron([Mantener|L1], yahtzee, [Mantener], [0|L2], _) :- obtener_patron(L1, yahtzee, [Mantener], L2, _) ,!.
obtener_patron([_|L1], yahtzee, [Mantener], [1|L2], _) :- obtener_patron(L1, yahtzee, [Mantener], L2, _).

obtener_patron(Dados, four_of_a_kind, [Mantener], Patron, Completados) :- \+member(yahtzee, Completados), obtener_patron(Dados, yahtzee, [Mantener], Patron, Completados), !.
obtener_patron(Dados, four_of_a_kind, [Mantener], Patron, _) :- 
    ocurrencias(Dados, Mantener, Cant),
    Cant < 4,
    obtener_patron(Dados, yahtzee, [Mantener], Patron, _),!.
obtener_patron(Dados, four_of_a_kind, [Mantener], Patron, _) :- obtener_patron_aux(Dados, [Mantener], Patron, 4).

obtener_patron(Dados, three_of_a_kind, [Mantener], Patron, Completados) :- \+member(yahtzee, Completados), obtener_patron(Dados, yahtzee, [Mantener], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [Mantener], Patron, Completados) :- \+member(four_of_a_kind, Completados), obtener_patron(Dados, four_of_a_kind, [Mantener], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [6], Patron, Completados) :- \+member(sixes, Completados), obtener_patron(Dados, yahtzee, [6], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [5], Patron, Completados) :- \+member(fives, Completados), obtener_patron(Dados, yahtzee, [5], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [4], Patron, Completados) :- \+member(fours, Completados), obtener_patron(Dados, yahtzee, [4], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [3], Patron, Completados) :- \+member(threes, Completados), obtener_patron(Dados, yahtzee, [3], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [2], Patron, Completados) :- \+member(sixes, Completados), obtener_patron(Dados, yahtzee, [2], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [1], Patron, Completados) :- \+member(sixes, Completados), obtener_patron(Dados, yahtzee, [1], Patron, Completados), !.
obtener_patron(Dados, three_of_a_kind, [Mantener], Patron, _) :- 
    ocurrencias(Dados, Mantener, Cant),
    Cant < 3,
    obtener_patron(Dados, yahtzee, [Mantener], Patron, _),!.
obtener_patron(Dados, three_of_a_kind, [Mantener], Patron, _) :- obtener_patron_aux(Dados, [Mantener], Patron, 3).

obtener_patron([], large_straight, _, [], _).
obtener_patron(_, large_straight, Mantener, [0,0,0,0,0], _) :- length(Mantener, 5), !.
obtener_patron([D|L1], large_straight, Mantener, [0|L2], _) :-
    select(D, Mantener, Mantener1),
    obtener_patron(L1, large_straight, Mantener1, L2, _), !.
obtener_patron([_|L1], large_straight, Mantener, [1|L2], _) :- obtener_patron(L1, large_straight, Mantener, L2, _).

obtener_patron(Dados, small_straight, Mantener, Patron, Completados) :- \+member(large_straight, Completados), obtener_patron(Dados, large_straight, Mantener, Patron, Completados), !.
obtener_patron([], small_straight, _, [], _).
obtener_patron(_, small_straight, Mantener, [0,0,0,0,0], _) :- length(Mantener, X), X >= 4, !.
obtener_patron([D|L1], small_straight, Mantener, [0|L2], _) :-
    select(D, Mantener, Mantener1),
    obtener_patron(L1, small_straight, Mantener1, L2, _), !.
obtener_patron([_|L1], small_straight, Mantener, [1|L2], _) :- obtener_patron(L1, small_straight, Mantener, L2, _).

obtener_patron([], full_house, _, [], _).
obtener_patron([D|L1], full_house, Mantener, [0|L2], _) :- member(D, Mantener), obtener_patron(L1, full_house, Mantener, L2, []),!.
obtener_patron([_|L1], full_house, Mantener, [1|L2], _) :- obtener_patron(L1, full_house, Mantener, L2, []).

obtener_patron(Dados, sixes, _, Patron, _) :- obtener_patron(Dados, yahtzee, [6], Patron, []).

obtener_patron(Dados, fives, _, Patron, _) :- obtener_patron(Dados, yahtzee, [5], Patron, []).

obtener_patron(Dados, fours, _, Patron, _) :- obtener_patron(Dados, yahtzee, [4], Patron, []).

obtener_patron(Dados, threes, _, Patron, _) :- obtener_patron(Dados, yahtzee, [3], Patron, []).

obtener_patron(Dados, twos, _, Patron, _) :- obtener_patron(Dados, yahtzee, [2], Patron, []).

obtener_patron(Dados, aces, _, Patron, _) :- obtener_patron(Dados, yahtzee, [1], Patron, []).

obtener_patron([], chance, _, [], _).
obtener_patron([D|L1], chance, _, [0|L2], _) :- D > 3, obtener_patron(L1, chance, [], L2, []), !.
obtener_patron([_|L1], chance, _, [1|L2], _) :- obtener_patron(L1, chance, [], L2, []).
%--------------------------------------------------------------------------------------------------------------------------------

calcular_valores_esperados([], Dados, _, Mejor_categoria, Mejor_mantener, Completados, Patron) :- 
    % writeln('-------------------------------'),
    obtener_patron(Dados, Mejor_categoria, Mejor_mantener, Patron, Completados).
    % writeln((Mejor_categoria, Patron)),
    % writeln('-------------------------------').
calcular_valores_esperados([s(Campo, Valor)|R], Dados, Mejor_ve, _, _, Completados, Patron) :-
    dados_faltantes(Dados, Campo, Faltan, Mantener, Completados),
    Ve is Valor/(6^Faltan),
    Ve > Mejor_ve,
    % writeln((Campo, Ve)),
    calcular_valores_esperados(R, Dados, Ve, Campo, Mantener, Completados, Patron), !.
calcular_valores_esperados([s(Campo, Valor)|R], Dados, Mejor_ve, Mejor_categoria, Mejor_mantener, Completados, Patron) :-
    dados_faltantes(Dados, Campo, Faltan, _, Completados),
    Ve is Valor/(6^Faltan),
    % writeln((Campo, Ve)),
    calcular_valores_esperados(R, Dados, Mejor_ve, Mejor_categoria, Mejor_mantener, Completados, Patron).

obtener_categorias_completados([],[]).

obtener_categorias_completados([s(Cat,nil)|Ls],Completados):-
    obtener_categorias_completados(Ls,Completados), !.

obtener_categorias_completados([s(Cat,_)|Ls],[Cat|Completados]):-
    obtener_categorias_completados(Ls,Completados).


cambio_dados(Dados, Tablero, ia_det, Patron) :-
    obtener_categorias_completados(Tablero, Categorias_completadas),
    Cats = [s(yahtzee,50), s(large_straight, 40), s(small_straight, 30), s(full_house, 25), s(four_of_a_kind, 20), s(three_of_a_kind, 20), s(sixes, 30), s(fives, 25), s(fours, 20), s(threes, 15), s(twos, 10), s(aces, 5), s(chance, 1)],
    categorias_disponibles(Cats, Categorias_completadas, Disponibles),
    calcular_valores_esperados(Disponibles, Dados, 0, nil, nil, Categorias_completadas, Patron).

%--------------------------------------------------------------------------------------------------------------------------------

eleccion_slot(Dados, Tablero, ia_det, Categoria) :- 
    obtener_categorias_completados(Tablero, Categorias_completadas),
    mejor_categoria(Dados, Categorias_completadas, Categoria, _), !.
eleccion_slot(Dados, Tablero, ia_det, Categoria) :- 
    obtener_categorias_completados(Tablero, Categorias_completadas),
    Cats = [aces, twos, threes, fours, fives, sixes, three_of_a_kind, four_of_a_kind, full_house, small_straight, large_straight, yahtzee, chance],
    mejor_categoria_it(Dados, Categorias_completadas, Cats, Categoria, _).

mejor_categoria_it(_, _, [], _, 0).
mejor_categoria_it(Dados, Completados, [Cat|L], Cat, Puntos1) :-
    \+member(Cat, Completados),
    mejor_categoria_it(Dados, Completados, L, _, Puntos),
    puntaje(Dados, Cat, Puntos1),
    Puntos1 >= Puntos.
mejor_categoria_it(Dados, Completados, [Cat|L], Categoria, Puntos) :-
    \+member(Cat, Completados),
    mejor_categoria_it(Dados, Completados, L, Categoria, Puntos),
    puntaje(Dados, Cat, Puntos1),
    Puntos1 < Puntos.
mejor_categoria_it(Dados, Completados, [Cat|L], Categoria, Puntos) :-
    member(Cat, Completados),
    mejor_categoria_it(Dados, Completados, L, Categoria, Puntos).


mejor_categoria(Dados, Completados, yahtzee, Puntos) :-
    \+ member(yahtzee, Completados),
    puntaje(Dados, yahtzee, Puntos),
    Puntos > 0, !.
mejor_categoria(Dados, Completados, large_straight, Puntos) :-
    \+ member(large_straight, Completados),
    puntaje(Dados, large_straight, Puntos),
    Puntos > 0, !.
mejor_categoria(Dados, Completados, small_straight, Puntos) :-
    \+ member(small_straight, Completados),
    puntaje(Dados, small_straight, Puntos),
    Puntos > 0, !.
mejor_categoria(Dados, Completados, full_house, Puntos) :-
    \+ member(full_house, Completados),
    puntaje(Dados, full_house, Puntos),
    Puntos > 0, !.
mejor_categoria(Dados, Completados, four_of_a_kind, Puntos) :-
    \+ member(four_of_a_kind, Completados),
    puntaje(Dados, four_of_a_kind, Puntos),
    Puntos > 0, !.
mejor_categoria(Dados, Completados, sixes, Puntos) :-
    \+ member(sixes, Completados),
    ocurrencias(Dados, 6, Cant),
    Cant >= 3,
    puntaje(Dados, sixes, Puntos),!.
mejor_categoria(Dados, Completados, fives, Puntos) :-
    \+ member(fives, Completados),
    ocurrencias(Dados, 5, Cant),
    Cant >= 3,
    puntaje(Dados, fives, Puntos),!.
mejor_categoria(Dados, Completados, fours, Puntos) :-
    \+ member(fours, Completados),
    ocurrencias(Dados, 4, Cant),
    Cant >= 3,
    puntaje(Dados, fours, Puntos),!.
mejor_categoria(Dados, Completados, threes, Puntos) :-
    \+ member(threes, Completados),
    ocurrencias(Dados, 3, Cant),
    Cant >= 3,
    puntaje(Dados, threes, Puntos),!.
mejor_categoria(Dados, Completados, twos, Puntos) :-
    \+ member(twos, Completados),
    ocurrencias(Dados, 2, Cant),
    Cant >= 3,
    puntaje(Dados, twos, Puntos),!.
mejor_categoria(Dados, Completados, aces, Puntos) :-
    \+ member(aces, Completados),
    ocurrencias(Dados, 1, Cant),
    Cant >= 3,
    puntaje(Dados, aces, Puntos),!.
mejor_categoria(Dados, Completados, chance, Puntos) :-
    \+ member(chance, Completados),
    puntaje(Dados, chance, Puntos),
    Puntos > 20, !.
mejor_categoria(Dados, Completados, three_of_a_kind, Puntos) :-
    \+ member(three_of_a_kind, Completados),
    puntaje(Dados, three_of_a_kind, Puntos),
    Puntos > 0, !.
mejor_categoria(Dados, Completados, chance, Puntos) :-
    \+ member(chance, Completados),
    puntaje(Dados, chance, Puntos), !.
mejor_categoria(Dados, Completados, sixes, Puntos) :-
    \+ member(sixes, Completados),
    ocurrencias(Dados, 6, Cant),
    Cant = 2,
    puntaje(Dados, sixes, Puntos),!.
mejor_categoria(Dados, Completados, fives, Puntos) :-
    \+ member(fives, Completados),
    ocurrencias(Dados, 5, Cant),
    Cant = 2,
    puntaje(Dados, fives, Puntos),!.
mejor_categoria(Dados, Completados, fours, Puntos) :-
    \+ member(fours, Completados),
    ocurrencias(Dados, 4, Cant),
    Cant = 2,
    puntaje(Dados, fours, Puntos),!.
mejor_categoria(Dados, Completados, threes, Puntos) :-
    \+ member(threes, Completados),
    ocurrencias(Dados, 3, Cant),
    Cant = 2,
    puntaje(Dados, threes, Puntos),!.
mejor_categoria(Dados, Completados, twos, Puntos) :-
    \+ member(twos, Completados),
    ocurrencias(Dados, 2, Cant),
    Cant = 2,
    puntaje(Dados, twos, Puntos),!.
mejor_categoria(Dados, Completados, aces, Puntos) :-
    \+ member(aces, Completados),
    ocurrencias(Dados, 1, Cant),
    Cant = 2,
    puntaje(Dados, aces, Puntos),!.