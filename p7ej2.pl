p(X,Y,Z):- q(X,Y,Z).
p(X,Y,Z):- N is X + 1, p(N,Y,Z).
q(X,X,[X]):- X > 0.
q(X,Y,[X|Z]):- N is X - 1, q(N,Y,Z).
   