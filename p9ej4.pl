% Implemente los siguientes predicados sobre listas de diferencias en Prolog:
% a) [prueba 2020]
% largo_ld(+L,?N) ← N es el largo de los elementos de la lista de diferencias L, sin
% contar el resto variable. Por ejemplo:
% largo_ld([a,b,c,d|LR]-LR,4).
% largo_ld([c,d|LR]-LR,2).
% b) [prueba 2021]
% not_member_ld(+X,?L) ← X es un elemento que no está presente en la lista de
% diferencias L utilizada con la notación L-LR. Por ejemplo:
% not_member_ld(6,[1,2,3,4|LR]-LR). ← Devuelve “true”.
% not_member_ld(4,[1,2,3,4|LR]-LR). ← Devuelve “false”.


largo_ld(X-X,0) :- var(X), !.

largo_ld([_|Xs]-R,N):-
    largo_ld(Xs-R,N1),
    N is N1 + 1.

not_member_ld(_,X-X):- var(X), !.
not_member_ld(X,[Y|Ys]-R):-
    X \= Y,
    not_member_ld(X,Ys-R).