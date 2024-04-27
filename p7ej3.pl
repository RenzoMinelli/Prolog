strange(Xs, Ys, P) :- strange(Xs, Ys, [], P).
strange([X|Xs], [X|Ys], Zs, P) :- X<P, !, strange(Xs, Ys, Zs, P).
strange([X|Xs], Ys, Zs, P) :- strange(Xs, Ys, [X|Zs], P).
strange([], Xs, Xs, _).
