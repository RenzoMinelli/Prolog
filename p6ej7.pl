p(f(X),f(X)).
p(d, f(e)).
p(f(a), d).
p(f(b), c).
p(a, f(b)).
q(X, Y) :- p(f(Z), Y), q(X, Z).
q(X, Y) :- p(X, f(Y)).
