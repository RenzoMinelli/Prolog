:- use_module(library(lists)).

% -------------utilidades-------------
ocurrencias([], _, 0).
ocurrencias([Num|L], Num, Cant) :- ocurrencias(L, Num, Cant1), Cant is Cant1 + 1.
ocurrencias([X|L], Num, Cant) :- X \= Num, ocurrencias(L, Num, Cant).

cantidad_ocurrencias(_, [], _, 0).
cantidad_ocurrencias(Dados, [X|_], N, Num) :- 
  ocurrencias(Dados, X, Cant), 
  Cant >= N,
  Num = X.
cantidad_ocurrencias(Dados, [X|L], N, Num) :-
  ocurrencias(Dados, X, Cant),
  Cant < N,
  cantidad_ocurrencias(Dados, L, N, Num).

suma_lista([], 0).
suma_lista([X|L], Cant) :- suma_lista(L, Cant_rec), Cant is Cant_rec + X.

% ------------------------------------


% modelado del dado

1/6::dado(1,1); 1/6::dado(1,2); 1/6::dado(1,3); 1/6::dado(1,4); 1/6::dado(1,5); 1/6::dado(1,6).
1/6::dado(2,1); 1/6::dado(2,2); 1/6::dado(2,3); 1/6::dado(2,4); 1/6::dado(2,5); 1/6::dado(2,6).
1/6::dado(3,1); 1/6::dado(3,2); 1/6::dado(3,3); 1/6::dado(3,4); 1/6::dado(3,5); 1/6::dado(3,6).
1/6::dado(4,1); 1/6::dado(4,2); 1/6::dado(4,3); 1/6::dado(4,4); 1/6::dado(4,5); 1/6::dado(4,6).
1/6::dado(5,1); 1/6::dado(5,2); 1/6::dado(5,3); 1/6::dado(5,4); 1/6::dado(5,5); 1/6::dado(5,6).

puntaje_por_categoria(aces, [V1,V2,V3,V4,V5], Puntos) :- 
  ocurrencias([V1,V2,V3,V4,V5], 1, Puntos).

puntaje_por_categoria(twos, [V1,V2,V3,V4,V5], Puntos) :- 
  ocurrencias([V1,V2,V3,V4,V5], 2, N), Puntos is N*2.

puntaje_por_categoria(threes, [V1,V2,V3,V4,V5], Puntos) :- 
  ocurrencias([V1,V2,V3,V4,V5], 3, N), Puntos is N*3.

puntaje_por_categoria(fours, [V1,V2,V3,V4,V5], Puntos) :- 
  ocurrencias([V1,V2,V3,V4,V5], 4, N), Puntos is N*4.

puntaje_por_categoria(fives, [V1,V2,V3,V4,V5], Puntos) :- 
  ocurrencias([V1,V2,V3,V4,V5], 5, N), Puntos is N*5.

puntaje_por_categoria(sixes, [V1,V2,V3,V4,V5], Puntos) :- 
  ocurrencias([V1,V2,V3,V4,V5], 6, N), Puntos is N*6.

puntaje_por_categoria(three_of_a_kind, [V1,V2,V3,V4,V5], Puntos) :- 
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, Num), 
  Num \= 0, 
  suma_lista([V1,V2,V3,V4,V5], Puntos).
puntaje_por_categoria(three_of_a_kind, 0) :-
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, 0).

puntaje_por_categoria(four_of_a_kind, [V1,V2,V3,V4,V5], Puntos) :- 
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 4, Num),
  Num \= 0, 
  suma_lista([V1,V2,V3,V4,V5], Puntos).
puntaje_por_categoria(four_of_a_kind, [V1,V2,V3,V4,V5], 0):-
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 4, 0).

puntaje_por_categoria(full_house, [V1,V2,V3,V4,V5], 0) :-
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, 0).

puntaje_por_categoria(full_house, [V1,V2,V3,V4,V5], 25) :- 
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 5, Num), 
  Num \= 0.

puntaje_por_categoria(full_house, [V1,V2,V3,V4,V5], 25) :-
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, Num),
  Num \= 0,
  select(Num, [1,2,3,4,5,6], L),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], L, 2, Num1),
  Num1 \= 0.

puntaje_por_categoria(full_house, [V1,V2,V3,V4,V5], 0) :-
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, Num),
  Num \= 0,
  select(Num, [1,2,3,4,5,6], L),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], L, 2, 0).

hay_small_straight([V1,V2,V3,V4,V5]):-
  ocurrencias([V1,V2,V3,V4,V5], 1, N1), N1 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 2, N2), N2 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 3, N3), N3 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 4, N4), N4 > 0.

hay_small_straight([V1,V2,V3,V4,V5]):-
  ocurrencias([V1,V2,V3,V4,V5], 2, N2), N2 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 3, N3), N3 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 4, N4), N4 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 5, N5), N5 > 0.

hay_small_straight([V1,V2,V3,V4,V5]):-
  ocurrencias([V1,V2,V3,V4,V5], 3, N3), N3 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 4, N4), N4 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 5, N5), N5 > 0,
  ocurrencias([V1,V2,V3,V4,V5], 6, N6), N6 > 0.

puntaje_por_categoria(small_straight, Dados, 30) :- hay_small_straight(Dados). 
puntaje_por_categoria(small_straight, Dados, 0) :- \+hay_small_straight(Dados).

hay_large_straight([V1,V2,V3,V4,V5]):-
  ocurrencias([V1,V2,V3,V4,V5], 2, 1),
  ocurrencias([V1,V2,V3,V4,V5], 3, 1),
  ocurrencias([V1,V2,V3,V4,V5], 4, 1),
  ocurrencias([V1,V2,V3,V4,V5], 5, 1),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,6], 1, Num),
  Num \= 0.

puntaje_por_categoria(large_straight, Dados, 40) :- hay_large_straight(Dados).
puntaje_por_categoria(large_straight, Dados, 0) :- \+hay_large_straight(Dados).

puntaje_por_categoria(yahtzee, [V1,V2,V3,V4,V5], 50) :- 
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 5, Num), 
  Num \= 0.
puntaje_por_categoria(yahtzee, [V1,V2,V3,V4,V5], 0):-
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 5, 0). 

puntaje_por_categoria(chance, [V1,V2,V3,V4,V5], Puntos) :- 
  suma_lista([V1,V2,V3,V4,V5], Puntos).

evidence(dado(1,2), true).
evidence(dado(2,3), true).
evidence(dado(3,4), true).
evidence(dado(4,5), true).
% evidence(dado(5,3), true).

puntaje(Categoria, Puntos):-
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  puntaje_por_categoria(Categoria, [V1,V2,V3,V4,V5], Puntos).
  % writeln(Categoria, [V1,V2,V3,V4,V5], Puntos).

query(puntaje(Cat, Puntos)).
