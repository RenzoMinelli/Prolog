p(d, e).
p(a, d).
p(b, c).
p(a, b).
p(9, 8).
q(X, Y) :- q(X, Z), p(Z, Y).
q(X, Y) :- p(X, Y).