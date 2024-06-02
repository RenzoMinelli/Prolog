0.5::moneda(cara); 0.5::moneda(cruz).

lanzamiento_acum(1, Resultado) :- 
    moneda(Resultado).
lanzamiento_acum(N, Resultado) :- 
    N > 1, 
    N1 is N - 1, 
    lanzamiento_acum(N1, cruz), 
    moneda(Resultado).


lanzamiento(N):-
    % writeln('lan - N:'),
    % writeln(N),
    lanzamiento_acum(N,cruz).

query(lanzamiento(3)).