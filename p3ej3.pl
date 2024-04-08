% Al principio hay tres peones blancos y tres negros,
% alineanegro y separanegro por una casilla vacía.
% En cada jugada se realiza una de las cuatro siguientes
% modificaciones:
%  Movimiento a la izquierda de un peón negro
%  Salto a la derecha de un peón blanco sobre blanco negro
%  Movimiento a la derecha de un peón blanco
%  Salto a la izquierda de un peón negro sobre blanco blanco
% Defina el siguiente predicado:
% peones(Movs) Movs es la lista de movimientos
% necesarios para intercambiar los
% peones blancos y negros.

movimiento(izqN).
movimiento(derB).
movimiento(saltoDerB).
movimiento(saltoIzqN).

aplicar_mov(izqN,[vacio,negro|R],EstadoFin) :- append([negro,vacio],R, EstadoFin).
aplicar_mov(izqN,[X|Xs],[X|Ys]) :- aplicar_mov(izqN,Xs,Ys).

aplicar_mov(derB,[blanco,vacio|R],EstadoFin) :- append([vacio,blanco],R, EstadoFin).
aplicar_mov(derB,[X|Xs],[X|Ys]) :- aplicar_mov(derB,Xs,Ys).

aplicar_mov(saltoDerB,[blanco,negro,vacio|R],EstadoFin) :- append([vacio,negro,blanco],R, EstadoFin).
aplicar_mov(saltoDerB,[X|Xs],[X|Ys]) :- aplicar_mov(saltoDerB,Xs,Ys).

aplicar_mov(saltoIzqN,[vacio,blanco,negro|R],EstadoFin) :- append([negro,blanco,vacio],R, EstadoFin).
aplicar_mov(saltoIzqN,[X|Xs],[X|Ys]) :- aplicar_mov(saltoIzqN,Xs,Ys).


estado_final([negro,negro,negro,vacio,blanco,blanco,blanco]).

peones_acum([],Estado) :- estado_final(Estado).
peones_acum([Mov|Movs],Estado) :-
    movimiento(Mov),
    aplicar_mov(Mov,Estado,EstadoAux),
    peones_acum(Movs,EstadoAux).

peones(Movs):-
    peones_acum(Movs,[blanco,blanco,blanco,vacio,negro,negro,negro]).

