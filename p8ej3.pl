% Implemente el predicado univ(?T,?L) utilizando los predicados functor y arg. Debe
% funcionar por lo menos para las instanciaciones (+T,-L) y (-T,+L).
% (El predicado univ de SWI-Prolog se nota =.. y su lógica es la de unificar un término
% estructurado del lado izquierdo con una lista de functor + argumentos del lado
% derecho. Por ejemplo f(1,2,3) =.. [f,1,2,3]).

argumentos_acum(_,P,A,[]) :- P > A.
argumentos_acum(T,Pos,Aridad,[Arg|Args]):-
    Pos > 0,
    Pos =< Aridad,
    arg(Pos,T,Arg),
    Pos1 is Pos+1,
    argumentos_acum(T,Pos1,Aridad,Args).

argumentos(T,Args,Aridad) :-
    argumentos_acum(T,1,Aridad,Args).

univ(T,[F|Args]) :-
    functor(T,F,Aridad),
    argumentos(T,Args,Aridad).