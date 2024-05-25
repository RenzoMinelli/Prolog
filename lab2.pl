% categorias posibles
categoria(aces).
categoria(twos).
categoria(threes).
categoria(fours).
categoria(fives).
categoria(sixes).
categoria(three_of_a_kind).
categoria(four_of_a_kind).
categoria(full_house).
categoria(small_straight).
categoria(large_straight).
categoria(yahtzee).
categoria(chance).

% solo primera seccion
categoria_primera_seccion(aces).
categoria_primera_seccion(twos).
categoria_primera_seccion(threes).
categoria_primera_seccion(fours).
categoria_primera_seccion(fives).
categoria_primera_seccion(sixes).

% sin considerar si se suma 63 o mas en primera seccion
puntaje_subtablero([], 0).
puntaje_subtablero([s(_,N)|Ts], Puntaje):-
    puntaje_subtablero(Ts, N1),
    Puntaje is N1 + N.

% solo slots primera seccion
slots_primera_seccion([], []).
slots_primera_seccion([s(Cat,N)|Ts], [s(Cat,N)|Resto]):-
    categoria_primera_seccion(Cat), !,
    slots_primera_seccion(Ts,Resto).

slots_primera_seccion([s(_,_)|Ts], PrimeraSeccion):-
    % \+categoria_primera_seccion(Cat), 
    slots_primera_seccion(Ts,PrimeraSeccion).

% verificar si en los slots de seccion 1 suma mas de 62
seccion_1_mayor_62(Tablero) :-
    slots_primera_seccion(Tablero, PrimeraSeccion),
    puntaje_subtablero(PrimeraSeccion, Puntaje),
    Puntaje > 62.

% puntaje real de un tablero chequeando si se cumple condicion de primera seccion
puntaje_tablero(Tablero, Puntaje):-
    seccion_1_mayor_62(Tablero), !,
    puntaje_subtablero(Tablero, Puntaje1),
    Puntaje is Puntaje1 + 35.

puntaje_tablero(Tablero, Puntaje):-
    % \+ seccion_1_mayor_62(Tablero), 
    puntaje_subtablero(Tablero, Puntaje).