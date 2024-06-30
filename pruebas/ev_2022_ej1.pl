vertice(a). 
vertice(b). 
vertice(c). 
vertice(d). 
vertice(e). 
vertice(f). 
vertice(g). 
vertice(h). 
vertice(i). 

arista(a,c).
arista(b,e).
arista(c,f).
arista(d,h).
arista(g,h).
arista(g,i).
arista(i,h).
arista(i,i).

conectados(X,Y) :- arista(X,Y).
conectados(X,Y) :- arista(Y,X).

camino(X,Y,Visitados):-
    conectados(X,Y),
    \+member(Y,Visitados).

camino(X,Y,Visitados):-
    conectados(X,Z),
    \+member(Z,Visitados),
    camino(Z,Y,[X|Visitados]).

camino(X,Y) :- camino(X,Y, []).

elegir_no_visitado([],V) :- vertice(V).
elegir_no_visitado([C|Cs],V) :-
    elegir_no_visitado(Cs,V),
    \+member(V,C).

componente_conexa(V,C):-
    setof(X,camino(V,X),C1),
    member(V,C1),
    sort(C1,C).

componente_conexa(V,C):-
    setof(X,camino(V,X),C1),
    \+member(V,C1),
    C2 = [V|C1],
    sort(C2,C).

existe_vertice_faltante(Vertices, V):-
    vertice(V),
    \+member(V,Vertices).

componentes_conexas_aux([C|CAux], VerticesVisitados) :-
    existe_vertice_faltante(VerticesVisitados, V), !,
    componente_conexa(V,C),
    append(VerticesVisitados, C, NewVerticesVisitados),
    componentes_conexas_aux(CAux, NewVerticesVisitados).

componentes_conexas_aux([], VerticesVisitados) :-
    \+existe_vertice_faltante(VerticesVisitados,_).

componentes_conexas(Cs) :- componentes_conexas_aux(Cs,[]).