:- use_module(library(random)).

% Setea el estado inicial del generador de números aleatorios
iniciar(X):- set_random(seed(X)).

% Tabla con las trece categorías
categorias([aces,twos,threes,fours,fives,sixes,three_of_a_kind,four_of_a_kind,full_house,small_straight,large_straight,yahtzee,chance]).

% Tablero inicial
inicial([s(aces,nil),s(twos,nil),s(threes,nil),s(fours,nil),s(fives,nil),s(sixes,nil),s(three_of_a_kind,nil),s(four_of_a_kind,nil),s(full_house,nil),s(small_straight,nil),s(large_straight,nil),s(yahtzee,nil),s(chance,nil)]).

% Lanza los dados, según el mapa que le pasamos en el segundo argumento
% Si en el mapa hay un 0, mantiene lo que había; de lo contrario, vuelve a lanzar ese dado
lanzamiento([],[],[]).
lanzamiento([X|T],[0|T1],[X|T2]):-
    lanzamiento(T,T1,T2).
lanzamiento([_|T],[1|T1],[X1|T2]):-
    tiro_dado(X1),
    lanzamiento(T,T1,T2).

% Lanza un dado
tiro_dado(X):-
    random(1,7,X).

% ----------------------------------------------------------------------------------


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

% VER SI SE PUEDE SACAR ESTO, PORQUE EN REALIDAD QUEDAN TODOS EN ORDEN CREO LOS SLOTS SIEMPRE.
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

%cuenta las ocurrencias de Num en la lista.
ocurrencias([], _, 0).
ocurrencias([Num|L], Num, Cant) :- ocurrencias(L, Num, Cant1), Cant is Cant1 + 1, !.
ocurrencias([_|L], Num, Cant) :- ocurrencias(L, Num, Cant).

%suma todos los numeros en la lista.
suma_lista([], 0).
suma_lista([X|L], Cant) :- suma_lista(L, Cant_rec), Cant is Cant_rec + X.

%cantidad_ocurrencias(+Dados, +Posibles, +N, -Num). hay al menos N ocurrencias de Num en los dados, Num = 0 si no hay.
cantidad_ocurrencias(_, [], _, 0).
cantidad_ocurrencias(Dados, [X|_], N, Num) :- 
    ocurrencias(Dados, X, Cant), 
    Cant >= N, 
    Num = X, !.
cantidad_ocurrencias(Dados, [_|L], N, Num) :- cantidad_ocurrencias(Dados, L, N, Num).

% BORRAR SI NO SE USA
%Res es el resultado de sacar E de la lista L.
% remover([], _, []).
% remover([X|L], E, Res) :- X = E, remover(L, E, Res), !.
% remover([X|L], E, [X|Res]) :- remover(L, E, Res).

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

ajustar_tablero([s(C, nil)|R], C, P, [s(C, P)|R]):- !.
ajustar_tablero([X|T], C, P, [X|R]) :- ajustar_tablero(T, C, P, R).

% ----------------------------------------------------------------------------------

mostrar_tablero_aux([]).
mostrar_tablero_aux([s(Campo,Valor)|Xs]):-
    writeln((Campo,Valor)),
    mostrar_tablero_aux(Xs).
mostrar_tablero(Tablero):-
    writeln('-------------------------------'),
    mostrar_tablero_aux(Tablero),
    writeln('-------------------------------').


yahtzee(humano, Seed):-
    iniciar(Seed),
    inicial(Tablero),
    yahtzee_con_ronda(1, humano, Tablero).

cambio_dados(_, _, humano, Patron):-
    writeln('Que dados desea cambiar? de una lista binaria de 5 elementos'),
    read(Patron).

relanzar_si_usuario_quiere(n, s, Dados, Dados_relanzados2):-
    cambio_dados(_, _, humano, Dados_a_relanzar),
    lanzamiento(Dados, Dados_a_relanzar, Dados_relanzados),
    writeln('Luego del primer relanzamiento:'),
    writeln(Dados_relanzados),
    writeln('Estos son los puntajes que podria obtener con los dados actuales:'),
    dar_puntajes_para_cada_categoria(Dados_relanzados, Puntajes),
    mostrar_tablero(Puntajes),
    writeln('Desea volver a lanzar los dados? (s/n)'),
    read(R),
    relanzar_si_usuario_quiere(s, R, Dados_relanzados, Dados_relanzados2).
relanzar_si_usuario_quiere(s, s, Dados, Dados_relanzados):-
    cambio_dados(_, _, humano, Dados_a_relanzar),
    lanzamiento(Dados, Dados_a_relanzar, Dados_relanzados),
    writeln('Luego de el segundo relanzamiento:'),
    writeln(Dados_relanzados),
    writeln('Estos son los puntajes que podria obtener con los dados actuales:'),
    dar_puntajes_para_cada_categoria(Dados_relanzados, Puntajes),
    mostrar_tablero(Puntajes).
relanzar_si_usuario_quiere(_, n, Dados, Dados).
    
% ojo esta funcion no actualiza el tablero, muestra puntajes hipoteticos para ayudar al usuario a decidir
% cual categoria elegir.
dar_puntajes_para_cada_categoria(Dados, Puntajes):-
    % Puntajes para cada categoría
    puntaje(Dados, aces, Puntaje_aces),
    puntaje(Dados, twos, Puntaje_twos),
    puntaje(Dados, threes, Puntaje_threes),
    puntaje(Dados, fours, Puntaje_fours),
    puntaje(Dados, fives, Puntaje_fives),
    puntaje(Dados, sixes, Puntaje_sixes),
    puntaje(Dados, three_of_a_kind, Puntaje_three_of_a_kind),
    puntaje(Dados, four_of_a_kind, Puntaje_four_of_a_kind),
    puntaje(Dados, full_house, Puntaje_full_house),
    puntaje(Dados, small_straight, Puntaje_small_straight),
    puntaje(Dados, large_straight, Puntaje_large_straight),
    puntaje(Dados, yahtzee, Puntaje_yahtzee),
    puntaje(Dados, chance, Puntaje_chance),
    % Lista de pares (Categoria, Puntaje)
    Puntajes = [s(aces, Puntaje_aces), s(twos, Puntaje_twos), s(threes, Puntaje_threes), s(fours, Puntaje_fours), s(fives, Puntaje_fives), s(sixes, Puntaje_sixes), s(three_of_a_kind, Puntaje_three_of_a_kind), s(four_of_a_kind, Puntaje_four_of_a_kind), s(full_house, Puntaje_full_house), s(small_straight, Puntaje_small_straight), s(large_straight, Puntaje_large_straight), s(yahtzee, Puntaje_yahtzee), s(chance, Puntaje_chance)].

eleccion_slot(_, _, humano, Categoria):-
    writeln('Elija una categoría:'),
    read(Categoria).


yahtzee_con_ronda(NumRonda, humano, Estado_tablero):-
    NumRonda < 14,
    writeln('Comienzo de ronda: '),
    writeln(NumRonda),
    % mostrar tablero actual
    writeln('El tablero actual es:'),
    mostrar_tablero(Estado_tablero),
    writeln('Primer lanzamiento de dados'),
    lanzamiento([_,_,_,_,_],[1,1,1,1,1], Dados),
    writeln('Dados:'),
    writeln(Dados),
    writeln('Estos son los puntos que podria obtener con los dados actuales:'),
    dar_puntajes_para_cada_categoria(Dados, Puntajes),
    mostrar_tablero(Puntajes),
    writeln('Desea volver a lanzar los dados? (s/n)'),
    read(R),
    Ultimo_relanzamiento = n,
    relanzar_si_usuario_quiere(Ultimo_relanzamiento, R, Dados, Dados_relanzados),
    % elegir slot donde asignar los puntos
    eleccion_slot(Dados_relanzados, _, humano, Categoria), % NO SE SI MANDAR EL TABLERO PARA EL HUMANO PORQUE IGUAL YA LO IMPRIMO ANTES, E IMPRIMIRLO SOLO DESPUES SERIA RARO PORQUE NO TENDRIA CRITERIO PARA DECIR SI QUIERE VOLVER A TIRAR O NO
    % Ajustar tablero
    puntaje(Dados_relanzados, Categoria, Puntaje),
    ajustar_tablero(Estado_tablero, Categoria, Puntaje, Nuevo_tablero),
    % mostrar tablero actualizado
    writeln('Tablero actualizado:'),
    mostrar_tablero(Nuevo_tablero),
    % continuar con la siguiente ronda
    NumRonda_siguiente is NumRonda + 1,
    yahtzee_con_ronda(NumRonda_siguiente, humano, Nuevo_tablero).
yahtzee_con_ronda(14, humano, Tablero):-
    writeln('Fin del juego'),
    writeln('Tablero final:'),
    mostrar_tablero(Tablero),
    writeln('Puntaje final:'),
    puntaje_tablero(Tablero, Puntaje_final),
    writeln(Puntaje_final).
% ----------------------------------------------------------------------------------
% TODO LO DE MAXI


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
    obtener_patron(Dados, Mejor_categoria, Mejor_mantener, Patron, Completados).
calcular_valores_esperados([s(Campo, Valor)|R], Dados, Mejor_ve, _, _, Completados, Patron) :-
    dados_faltantes(Dados, Campo, Faltan, Mantener, Completados),
    Ve is Valor/(6^Faltan),
    Ve > Mejor_ve,
    calcular_valores_esperados(R, Dados, Ve, Campo, Mantener, Completados, Patron), !.
calcular_valores_esperados([s(Campo, _)|R], Dados, Mejor_ve, Mejor_categoria, Mejor_mantener, Completados, Patron) :-
    dados_faltantes(Dados, Campo, _, _, Completados),
    calcular_valores_esperados(R, Dados, Mejor_ve, Mejor_categoria, Mejor_mantener, Completados, Patron).

obtener_categorias_completados([],[]).

obtener_categorias_completados([s(_,nil)|Ls],Completados):-
    obtener_categorias_completados(Ls,Completados), !.

obtener_categorias_completados([s(Cat,_)|Ls],[Cat|Completados]):-
    obtener_categorias_completados(Ls,Completados).


cambio_dados(Dados, Tablero, ia_det, Patron) :-
    obtener_categorias_completados(Tablero, Categorias_completadas),
    Cats = [s(yahtzee,50), s(large_straight, 40), s(small_straight, 30), s(full_house, 25), s(four_of_a_kind, 20), s(three_of_a_kind, 20), s(sixes, 30), s(fives, 25), s(fours, 20), s(threes, 15), s(twos, 10), s(aces, 5), s(chance, 1)],
    categorias_disponibles(Cats, Categorias_completadas, Disponibles),
    calcular_valores_esperados(Disponibles, Dados, 0, nil, nil, Categorias_completadas, Patron).

% --------------------------------------------------------------------------------------------------------------------------------

% ia_det

:- use_module(library(filesex)).

% Invoco a Problog a partir de un modelo 
% Y consulto el resultado para obtener 
% las consultas y su probabilidad

consultar_probabilidades(ListaValores):-
    % Problog debe estar en el path!
    absolute_file_name(path(problog),Problog,[access(exist),extensions([exe])]),
    % Nombre del modelo, que se supone está en el mismo directorio que el fuente
    absolute_file_name(modelo_problog_dev,Modelo,[file_type(prolog)]),
    % Invoca a problog con el modelo como argumento, y envía la salida a un pipe
    process_create(Problog,[Modelo],[stdout(pipe(In))]),
    % Convierte la salida a un string
    read_string(In,_,Result),
    % Divide la salida
    split_string(Result,"\n\t","\r ",L),
    % Escribo la salida
    % writeln(Result),
    % Quito último elemento de la lista
    append(L1,[_],L),
    lista_valores(L1,ListaValores).

% Predicado auxiliar para transformar a términos y a números, como se espera
lista_valores([X,Y|T],[TermValor|T1]):-
    % Saco los dos puntos del final
    split_string(X,"",":",[X1|_]),
    term_string(TermX,X1),
    TermX =.. [puntaje,Cat,Valor],
    number_string(NumberY,Y),
    TermValor =.. [p,Cat,Valor,NumberY],
    lista_valores(T,T1).
lista_valores([],[]).

% obtiene el valor esperado por cada categoria 
agrupar_por_cat([],[]).
agrupar_por_cat([p(Cat,Valor,Prob)|Ps],Agrupado):-
    agrupar_por_cat(Ps,AgrupadoResto),
    select((Cat,ValorAux),AgrupadoResto,AgrupadoAux), !,
    ValorNuevo is (Prob * Valor) + ValorAux,
    Agrupado = [(Cat,ValorNuevo)|AgrupadoAux].
agrupar_por_cat([p(Cat,Valor,Prob)|Ps],Agrupado):-
    agrupar_por_cat(Ps,AgrupadoResto),
    ValorNuevo is (Prob * Valor),
    Agrupado = [(Cat,ValorNuevo)|AgrupadoResto].

% obtiene los valores esperados de las categorias
valores_esperados(ValoresEsperados):-
    consultar_probabilidades(Probs),
    agrupar_por_cat(Probs,ValoresEsperados).

mejor_valor_esperado_aux([], ValMax, ValMax).
mejor_valor_esperado_aux([(_,Val)|CatVals], ValAcc, ValMax):-
    Val > ValAcc, !,
    mejor_valor_esperado_aux(CatVals, Val, ValMax).
mejor_valor_esperado_aux([_|CatVals], ValAcc, ValMax):-
    mejor_valor_esperado_aux(CatVals, ValAcc, ValMax).

% te da la categoria que tiene mayor valor esperado
mejor_valor_esperado([(Cat,Val)|CatVals], ValMax):-
    mejor_valor_esperado_aux([(Cat,Val)|CatVals], 0, ValMax).

% quita las categorias que ya fueron ocupadas
quitar_categorias_ocupadas([],_,[]).
quitar_categorias_ocupadas([(Cat,_)|CatVals], CategoriasOcupadas, CatValsFiltradas) :-
    select(Cat, CategoriasOcupadas, CatsOcupadasResto), !,
    quitar_categorias_ocupadas(CatVals, CatsOcupadasResto, CatValsFiltradas).
quitar_categorias_ocupadas([(Cat,V)|CatVals], CategoriasOcupadas, [(Cat,V)|CatValsFiltradas]) :-
    quitar_categorias_ocupadas(CatVals, CategoriasOcupadas, CatValsFiltradas).

% te da la categoria que tiene mayor valor esperado y que no fue ocupada
valor_esperado_para_patron(CategoriasOcupadas, ValorEsperado):- % se llama una vez que el patron ya esta setteado como evidencia en el modelo
    valores_esperados(ValoresEsperados),
    quitar_categorias_ocupadas(ValoresEsperados, CategoriasOcupadas, ValoresEsperadosFiltrados),
    mejor_valor_esperado(ValoresEsperadosFiltrados, ValorEsperado).

cargar_evidencias_en_archivo_aux([], _).
cargar_evidencias_en_archivo_aux([E|RestoEvidencias], Stream):-
    write(Stream, E),
    write(Stream, '.'),
    nl(Stream),
    cargar_evidencias_en_archivo_aux(RestoEvidencias, Stream).

cargar_evidencias_en_archivo(Evidencias) :-
    open('modelo_problog_dev.pl', append, Stream),
    cargar_evidencias_en_archivo_aux(Evidencias, Stream),
    close(Stream).

reiniciar_archivo :-
  open('modelo_problog.pl', read, StreamOriginal),
  read_string(StreamOriginal, _, Lines),
  close(StreamOriginal),
  open('modelo_problog_dev.pl', write, Stream),
  write(Stream, Lines),
  close(Stream).

% ACA SE TIENE QUE CAMBIAR PARA PONER UNA QUERY POR LAS CATEGORIAS QUE YA SE COMPLETARON
cargar_query(CategoriasCompletadas):-
    open('modelo_problog_dev.pl', append, Stream),
    write(Stream, 'query(puntaje(Cat,'),
    write(Stream, CategoriasCompletadas),
    write(Stream, ', Puntos)).'),
    close(Stream).

construir_evidencia(1,D,E):-
    E =.. [evidence,dado1(D),true].
construir_evidencia(2,D,E):-
    E =.. [evidence,dado2(D),true].
construir_evidencia(3,D,E):-
    E =.. [evidence,dado3(D),true].
construir_evidencia(4,D,E):-
    E =.. [evidence,dado4(D),true].
construir_evidencia(5,D,E):-
    E =.. [evidence,dado5(D),true].


generar_evidencias_aux([], [], [], _).
generar_evidencias_aux([D|RestoDados], [0|RestoPatron], [E|RestoEvidencias], I):-
    construir_evidencia(I,D,E),
    I1 is I - 1,
    generar_evidencias_aux(RestoDados, RestoPatron, RestoEvidencias, I1), !.
generar_evidencias_aux([_|RestoDados], [1|RestoPatron], RestoEvidencias, I):-
    I1 is I - 1,
    generar_evidencias_aux(RestoDados, RestoPatron, RestoEvidencias, I1).

cargar_evidencias_y_query(Dados, Patron, CategoriasCompletadas) :-
    generar_evidencias_aux(Dados, Patron, Evidencias, 5),
    reiniciar_archivo,
    cargar_evidencias_en_archivo(Evidencias),
    cargar_query(CategoriasCompletadas).

patrones_posibles(Patrones):-
    Patrones = [
                [0,0,0,0,0],
                [0,0,0,0,1],
                [0,0,0,1,0],
                [0,0,0,1,1],
                [0,0,1,0,0],
                [0,0,1,0,1],
                [0,0,1,1,0],
                % [0,0,1,1,1],
                [0,1,0,0,0],
                [0,1,0,0,1],
                [0,1,0,1,0],
                % [0,1,0,1,1],
                [0,1,1,0,0],
                % [0,1,1,0,1],
                % [0,1,1,1,0],
                % [0,1,1,1,1],
                [1,0,0,0,0],
                [1,0,0,0,1],
                [1,0,0,1,0],
                % [1,0,0,1,1],
                [1,0,1,0,0],
                % [1,0,1,0,1],
                % [1,0,1,1,0],
                % [1,0,1,1,1],
                [1,1,0,0,0]
                % [1,1,0,0,1],
                % [1,1,0,1,0],
                % [1,1,0,1,1],
                % [1,1,1,0,0]
                % [1,1,1,0,1],
                % [1,1,1,1,0],
                % [1,1,1,1,1]
                ].

patron_con_mejor_valor_esperado_aux(_, _, [], Mejor, Mejor).
patron_con_mejor_valor_esperado_aux(Dados, CategoriasCompletadas, [P|PatronesPosibles], (_, ValAcc), (MejorPatron, MejorValor)):-
    cargar_evidencias_y_query(Dados, P, CategoriasCompletadas),
    time(valor_esperado_para_patron(CategoriasCompletadas, ValorEsperado)),
    ValorEsperado > ValAcc, !,
    patron_con_mejor_valor_esperado_aux(Dados, CategoriasCompletadas, PatronesPosibles, (P, ValorEsperado), (MejorPatron, MejorValor)).
patron_con_mejor_valor_esperado_aux(Dados, CategoriasCompletadas, [_|PatronesPosibles], Acc, Mejor):-
    patron_con_mejor_valor_esperado_aux(Dados, CategoriasCompletadas, PatronesPosibles, Acc, Mejor).

patron_con_mejor_valor_esperado(Dados, CategoriasCompletadas, MejorPatron):-
    patrones_posibles(Patrones),
    patron_con_mejor_valor_esperado_aux(Dados, CategoriasCompletadas, Patrones, ([], -1), (MejorPatron, _)).



obtener_categorias_completados([],[]).

obtener_categorias_completados([s(_,nil)|Ls],Completados):-
    obtener_categorias_completados(Ls,Completados), !.

obtener_categorias_completados([s(Cat,_)|Ls],[Cat|Completados]):-
    obtener_categorias_completados(Ls,Completados).


cambio_dados(Dados, Tablero, ia_prob, Patron):-
    obtener_categorias_completados(Tablero, CategoriasCompletadas),
    patron_con_mejor_valor_esperado(Dados, CategoriasCompletadas, Patron),
    writeln(Patron).



%--------------------------------------------------------------------------------------------------------------------------------

eleccion_slot(Dados, Tablero, ia_det, Categoria) :- 
    obtener_categorias_completados(Tablero, Categorias_completadas),
    mejor_categoria(Dados, Categorias_completadas, Categoria, _), !.
eleccion_slot(Dados, Tablero, ia_det, Categoria) :- 
    obtener_categorias_completados(Tablero, Categorias_completadas),
    Cats = [aces, twos, threes, fours, fives, sixes, three_of_a_kind, four_of_a_kind, full_house, small_straight, large_straight, yahtzee, chance],
    mejor_categoria_it(Dados, Categorias_completadas, Cats, Categoria, _).

eleccion_slot(Dados, Tablero, ia_prob, Categoria) :- 
    eleccion_slot(Dados, Tablero, ia_det, Categoria).

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

% ----------------------------------------------------------------------------------
% UI IA

% IA DET
yahtzeelog(Estrategia, Seed):-
    iniciar(Seed),
    inicial(Tablero),
    yahtzeelog_con_ronda(1, Estrategia, Tablero).

yahtzeelog_con_ronda(NumRonda, Estrategia, Estado_tablero):-
    NumRonda < 14,
    writeln('Comienzo de ronda: '),
    writeln(NumRonda),
    % mostrar tablero actual
    writeln('El tablero actual es:'),
    mostrar_tablero(Estado_tablero),
    writeln('Primer lanzamiento de dados'),
    lanzamiento([_,_,_,_,_],[1,1,1,1,1], Dados),
    writeln('Dados Iniciales:'),
    writeln(Dados),
    % writeln('Estos son los puntos que podria obtener con los dados actuales:'),
    % dar_puntajes_para_cada_categoria(Dados, Puntajes),
    % mostrar_tablero(Puntajes),


    cambio_dados(Dados, Estado_tablero, Estrategia, Patron),
    lanzamiento(Dados, Patron, Dados_relanzados),

    writeln('Patron:'),
    writeln(Patron),
    writeln('Dados_relanzados:'),
    writeln(Dados_relanzados),
    
    
    cambio_dados(Dados_relanzados, Estado_tablero, Estrategia, Patron2),
    lanzamiento(Dados_relanzados, Patron2, Dados_definitivos),

    writeln('Patron2:'),
    writeln(Patron2),
    writeln('Dados_definitivos:'),
    writeln(Dados_definitivos),
    

    % elegir slot donde asignar los puntos
    eleccion_slot(Dados_definitivos, Estado_tablero, Estrategia, Categoria),
    writeln('Categoria:'),
    writeln(Categoria),

    % Ajustar tablero
    puntaje(Dados_definitivos, Categoria, Puntaje),
    writeln('Puntaje:'),
    writeln(Puntaje),
    ajustar_tablero(Estado_tablero, Categoria, Puntaje, Nuevo_tablero),
    % mostrar tablero actualizado
    writeln('Tablero actualizado:'),
    mostrar_tablero(Nuevo_tablero),
    % continuar con la siguiente ronda
    NumRonda_siguiente is NumRonda + 1,
    yahtzeelog_con_ronda(NumRonda_siguiente, Estrategia, Nuevo_tablero).

yahtzeelog_con_ronda(14, _, Tablero):-
    writeln('Fin del juego'),
    writeln('Tablero final:'),
    mostrar_tablero(Tablero),
    writeln('Puntaje final:'),
    puntaje_tablero(Tablero, Puntaje_final),
    writeln(Puntaje_final).
    