not_member_ld(_,[]-[]).

not_member_ld(X,[Y|L]-LR) :-
    X \= Y,
    not_member_ld(X,L-LR).


s --> a(N), b(N2), {N2 is N**2}.

a(0) --> [].
a(N) --> [a],a(N1),{N is N1+1}.

b(0) --> [].
b(N) --> [b],b(N1),{N is N1+1}.