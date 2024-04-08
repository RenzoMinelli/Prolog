% El problema del «ataque de las k reinas» consiste en
% distribuir k reinas en un tablero de n por n, de forma que
% toda casilla del tablero quede atacada por una reina, y
% ninguna reina sea atacada por otra.
% Defina el siguiente predicado:
% kreinas(K,N,Reinas) Reinas es una solución al
% problema del ataque de las K
% reinas en un tablero de tamaño
% N por N.
columna([],[],[]).
columna([[X|Xs]|Fs],C,R) :- 
    columna(Fs,C1,R1),
    append([Xs],R1,R),
    append([X],C1,C).


kreinas(0,0,_).

kreinas(K,N,[[X|Fila]|Reinas]) :- 
    N > 0,
    K > 0,
    columna([[X|Fila]|Reinas],C,[_|R]),
    member(1,C),
    member(1, Fila),
    K1 is K-2,
    N1 is N-1,
    kreinas(K1,N1,R).

kreinas(K,N,[[X|Fila]|Reinas]) :-
    N > 0,
    K > 0,
    columna([[X|Fila]|Reinas],C,[_|R]),
    member(1,C),
    \+member(1, Fila),
    K1 is K-1,
    N1 is N-1,
    kreinas(K1,N1,R).

kreinas(K,N,[[X|Fila]|Reinas]) :-
    N > 0,
    K > 0,
    columna([[X|Fila]|Reinas],C,[_|R]),
    \+member(1,C),
    member(1, Fila),
    K1 is K-1,
    N1 is N-1,
    kreinas(K1,N1,R).
