largo_ld(R-R,0):- var(R), !.
largo_ld([_|L]-R,N):-
    largo_ld(L-R,N1),
    N is N1 + 1.

s -->{W = w(N)},W,W.

w(0) --> [].
w(1) --> [0].
w(1) --> [1].
w(N) --> [1],w(N1),{N is N1+1}.
w(N) --> [0],w(N1),{N is N1+1}.
