largo1([],0).
largo1([_|Xs],N):-
    largo1(Xs,N1),
    N is N1+1.

largo2([],0).
largo2([_|Xs],N):-
    N>0,
    N1 is N-1,
    largo2(Xs,N1).

largo(Xs,N) :-
    ground(Xs),
    largo1(Xs,N).

largo(Xs,N):-
    var(Xs),nonvar(N),
    largo2(Xs,N).