1/6::dado1(1); 1/6::dado1(2); 1/6::dado1(3); 1/6::dado1(4); 1/6::dado1(5); 1/6::dado1(6).
1/6::dado2(1); 1/6::dado2(2); 1/6::dado2(3); 1/6::dado2(4); 1/6::dado2(5); 1/6::dado2(6).

combinacion(X,Y) :- dado1(X), dado2(Y).
suma(S) :- 
    dado1(X),
    dado2(Y),
    S is X + Y.



evidence(suma(9), true).

query(combinacion(X,Y)).
% query(suma(X)).