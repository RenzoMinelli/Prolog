append_ld(A-B,B-Br,A-Br).
ld_l(LD-[],LD).

es_lista([]).
es_lista([_|_]).
% solo_pares([14,[5,4],[2,[8,3,[],10]],6], [14,4,2,8,10,6]).

solo_pares_aux(L,[L|R]-R) :- 
    \+es_lista(L),
    0 is L mod 2, !. % cuando es numero par devolverlo
solo_pares_aux(L,R-R) :- 
    \+es_lista(L),
    1 is L mod 2. % cuando es numero impar no devolverlo

solo_pares_aux([],R-R).
solo_pares_aux([L|Ls],Pares-PR) :-
    solo_pares_aux(Ls, ParesResto-PRR),
    solo_pares_aux(L,ParesL-PLR),
    append_ld(ParesResto-PRR,ParesL-PLR, Pares-PR). % aca esta la ineficiencia

solo_pares(L,Pares):-
    solo_pares_aux(L,P-Pr),
    ld_l(P-Pr,Pares).


l --> a(N),b(N2),c(N3),{N2 is N*2, N3 is N*3}.

a(0) --> [].
a(N) --> [a],a(N1),{N is N1+1}.

b(0) --> [].
b(N) --> [b],b(N1),{N is N1+1}.

c(0) --> [].
c(N) --> [c],c(N1),{N is N1+1}.


