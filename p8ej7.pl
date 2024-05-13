% Implemente los siguientes predicados de segundo orden. Asuma que los
% argumentos U, B y T contendrán predicados unarios (por ejemplo par/1), binarios
% (por ejemplo doble/2) o ternarios (por ejemplo suma/3) respectivamente.
% any(+L,+U)  Algún elemento de L cumple la propiedad U.
% all(+L,+U)  Todos los elementos de L cumplen la propiedad
% U.
% map(+L,+B,?L2)  L2 es el resultado de aplicar la función B a todos
% los elementos de L.
% combine(+L1,+L2,+T,
% ?L3)
%  L3 es el resultado de aplicar el operador T a
% elementos en las mismas posiciones de L1 y L2.
% fold(+L,+T,?F)  F es el resultado de realizar un fold sobre la lista
% L con el operador T. Por ejemplo, si T fuera la
% suma la operación sería:
% F = L1 + L2 + … + Ln-1 + Ln

par(X) :- 0 is X mod 2.
masdos(X,Y):- Y is X+2.

any([X|_], U):-
    Comp =.. [U,X],
    Comp.
any([_|Xs], U) :- any(Xs, U).

all([],_).
all([X|Xs],U):-
    Comp =.. [U,X], 
    Comp,
    all(Xs,U).

map([],_,[]).
map([X|Xs],B,[Y|Ys]) :-
    Comp =.. [B,X,Y],
    Comp,
    map(Xs,B,Ys).

combine([],[],_,[]).
combine([X|Xs],[Y|Ys],T,[Z|Zs]):-
    Comp=..[T,X,Y,Z],
    Comp,
    combine(Xs,Ys,T,Zs).
