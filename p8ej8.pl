between(M,N,M) :- M=<N.
between(M,N,K) :-
    M<N,
    M2 is M+1,
    between(M2,N,K).
par(N) :- N mod 2 =:= 0.
par_menor(N,M) :-
    between(1,N,M),
    par(M).
todos_q(Q,Xs) :-
    findall(X,(append(Q,[X],TL), T=..TL, call(T),!),Xs).