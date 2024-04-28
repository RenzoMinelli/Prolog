par(X) :- 0 is (X mod 2).
multiplo_tres(X) :- 0 is (X mod 3).
sel_par([X|Xs], X, Z) :- par(X), X > Z, !.
sel_par([X|Xs], Y, Z) :- sel_par(Xs, Y, Z).
prob(X) :- sel_par([1,4,12,5,32,30,17,18], X, 10), multiplo_tres(X).


