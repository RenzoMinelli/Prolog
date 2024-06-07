% -------------utilidades-------------
ocurrencias([], _, 0).
ocurrencias([Num|L], Num, Cant) :- ocurrencias(L, Num, Cant1), Cant is Cant1 + 1.
ocurrencias([X|L], Num, Cant) :- X \= Num, ocurrencias(L, Num, Cant).

cantidad_ocurrencias(_, [], _, 0).
cantidad_ocurrencias(Dados, [Num|_], N, Num) :- 
    ocurrencias(Dados, Num, Cant), 
    Cant >= N.
cantidad_ocurrencias(Dados, [X|L], N, Num) :-
  ocurrencias(Dados, X, Cant),
  Cant < N,
  cantidad_ocurrencias(Dados, L, N, Num).

% ------------------------------------


% modelado del dado

1/6::dado(1,1); 1/6::dado(1,2); 1/6::dado(1,3); 1/6::dado(1,4); 1/6::dado(1,5); 1/6::dado(1,6).
1/6::dado(2,1); 1/6::dado(2,2); 1/6::dado(2,3); 1/6::dado(2,4); 1/6::dado(2,5); 1/6::dado(2,6).
1/6::dado(3,1); 1/6::dado(3,2); 1/6::dado(3,3); 1/6::dado(3,4); 1/6::dado(3,5); 1/6::dado(3,6).
1/6::dado(4,1); 1/6::dado(4,2); 1/6::dado(4,3); 1/6::dado(4,4); 1/6::dado(4,5); 1/6::dado(4,6).
1/6::dado(5,1); 1/6::dado(5,2); 1/6::dado(5,3); 1/6::dado(5,4); 1/6::dado(5,5); 1/6::dado(5,6).

puntaje(aces, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  writeln([V1,V2,V3,V4,V5]),
  ocurrencias([V1,V2,V3,V4,V5], 1, Puntos).

puntaje(twos, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  ocurrencias([V1,V2,V3,V4,V5], 2, N), Puntos is N*2.

puntaje(threes, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  ocurrencias([V1,V2,V3,V4,V5], 3, N), Puntos is N*3.

puntaje(fours, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  ocurrencias([V1,V2,V3,V4,V5], 4, N), Puntos is N*4.

puntaje(fives, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  ocurrencias([V1,V2,V3,V4,V5], 5, N), Puntos is N*5.

puntaje(sixes, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  ocurrencias([V1,V2,V3,V4,V5], 6, N), Puntos is N*6.

puntaje(three_of_a_kind, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, Num), 
  Num \= 0, 
  suma_lista(Dados, Puntos).
puntaje(three_of_a_kind, 0) :-
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, 0).

puntaje(four_of_a_kind, Puntos) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 4, Num),
  Num \= 0, 
  suma_lista(Dados, Puntos).
puntaje(four_of_a_kind, 0):-
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 4, 0).


puntaje(full_house, 25) :- 
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 5, Num), 
  Num \= 0.

puntaje(full_house, 0) :-
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, 0).

puntaje(full_house, 25) :-
  dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 3, Num),
  select(Num, [1,2,3,4,5,6], L),
  cantidad_ocurrencias([V1,V2,V3,V4,V5], L, 2, Num1),
  Num1 \= 0,
puntaje(full_house, 25)
puntaje(_, full_house, 0).
    
% puntaje(small_straight, Puntos) :- 
%   dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
%   ocurrencias([V1,V2,V3,V4,V5], 3, N1),
%   ocurrencias([V1,V2,V3,V4,V5], 4, N2),
%   N is N1 * N2,
%   N = 0, 
%   Puntos = 0, !.
% puntaje(small_straight, Puntos) :- 
%   dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
%   ocurrencias([V1,V2,V3,V4,V5], 1, 1),
%   ocurrencias([V1,V2,V3,V4,V5], 2, 1),
%   Puntos = 30, !.
% puntaje(small_straight, Puntos) :- 
%   dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
%     ocurrencias([V1,V2,V3,V4,V5], 2, 1),
%     ocurrencias([V1,V2,V3,V4,V5], 5, 1),
%     Puntos = 30, !.
% puntaje(small_straight, Puntos) :- 
%   dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
%     ocurrencias([V1,V2,V3,V4,V5], 5, 1),
%     ocurrencias([V1,V2,V3,V4,V5], 6, 1),
%     Puntos = 30, !.
% puntaje(small_straight, 0).

% puntaje(large_straight, Puntos) :- 
%   dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
%     ocurrencias([V1,V2,V3,V4,V5], 2, 1),
%     ocurrencias([V1,V2,V3,V4,V5], 3, 1),
%     ocurrencias([V1,V2,V3,V4,V5], 4, 1),
%     ocurrencias([V1,V2,V3,V4,V5], 5, 1),
%     cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,6], 1, Num),
%     Num \= 0,
%     Puntos = 40, !.
% puntaje(large_straight, 0).

% puntaje(yahtzee, Puntos) :- 
%   cantidad_ocurrencias([V1,V2,V3,V4,V5], [1,2,3,4,5,6], 5, Num), 
%   Num \= 0, 
%   Puntos = 50, !.
% puntaje(yahtzee, 0).

% puntaje(chance, Puntos) :- 
%   dado(1,V1),dado(2,V2),dado(3,V3),dado(4,V4),dado(5,V5),
%   suma_lista([V1,V2,V3,V4,V5], Puntos).

evidence(dado(1,1), true).
evidence(dado(2,2), true).
evidence(dado(3,2), true).
evidence(dado(4,1), true).
evidence(dado(5,5), true).
query(puntaje(Cat,Puntaje)).
