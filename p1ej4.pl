# borrar_todo recibe una lista, un elemento y en tercer lugar la lista sin ese elemento
borrar_todo([],X,[]).
borrar_todo([X|Xs],X,Ys):- borrar_todo(Xs,X,Ys).
borrar_todo([X|Xs],Z,[X|Ys]):- X\=Z, borrar_todo(Xs,Z,Ys).

sin_repetidos([],[]).
sin_repetidos([X|Xs],[X|Ys]):- borrar_todo(Xs,X,Zs), sin_repetidos(Zs,Ys).

conjunto([]).
conjunto(C):- sin_repetidos(C,C).

conj_iguales([],[]).
conj_iguales([X|Xs],C):- member(X,C), borrar_todo(C,X,C2), conj_iguales(Xs,C2).
conj_iguales(C,[X|Xs]):- member(X,C), borrar_todo(C,X,C2), conj_iguales(Xs,C2).

subconjunto(_,[]).
subconjunto(C,[X|Xs]):- member(X,C), subconjunto(C,Xs), conjunto(C), conjunto([X|Xs]).

interseccion([], _, []).
interseccion([X|Xs], Ys, [X|Zs]) :- member(X, Ys), interseccion(Xs, Ys, Zs).

