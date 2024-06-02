0.5::transicion(sol,nube); 0.5::transicion(sol,sol).
1/3::transicion(nube,nube); 1/3::transicion(nube,lluvia); 1/3::transicion(nube,sol).
0.5::transicion(lluvia,nube); 0.5::transicion(lluvia,lluvia).

1/3::incie(lluvia); 1/3::incie(sol); 1/3::incie(nube).

dia(0, Estado) :- incie(Estado).

dia(N, EstadoHoy) :- N>0, N1 is N-1, dia(N1, EstadoAyer), transicion(EstadoAyer, EstadoHoy).

% evidence(dia(5, sol), true).

dia_n_sin_lluvia(N) :- dia(N, Estado), Estado \= lluvia.

dias_sin_llover_acum(_, 0).
dias_sin_llover_acum(N, Faltan):-
    Faltan > 0,
    dia_n_sin_lluvia(N),
    N1 is N+1,
    Faltan1 is Faltan-1,
    dias_sin_llover_acum(N1,Faltan1).
    
diez_dias_sin_llover :- dias_sin_llover_acum(0, 10).

% query(dia(2,_)).
query(diez_dias_sin_llover).