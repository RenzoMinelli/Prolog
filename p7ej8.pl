% Sea G un grafo dirigido representado por las relaciones: arista(G, V1, V2) y
% vertice(G, V1).
% Defina predicados Prolog utilizando not para:
% completo(G)  Existe una arista entre todo par de vértices
% hay_camino(G,A,B)  Existe un camino entre A y B para el grafo G.
% Cuidado con los ciclos del grafo!
% conexo(G)  El grafo G es conexo (existe un camino entre todo
% par de vértices).

vertice(g1, v1).
vertice(g1, v2).
vertice(g1, v3).
arista(g1,v1,v2).
arista(g1,v2,v3).
% arista(g1,v1,v3).

vertices_sin_arista(G) :-
    vertice(G,V1),
    vertice(G,V2),
    V1 \= V2,
    \+arista(G,V1,V2),
    \+arista(G,V2,V1).

completo(G) :-
   \+vertices_sin_arista(G).

hay_camino(G,A,B) :- arista(G,A,B).
hay_camino(G,A,B) :- 
    vertice(G,X),
    A \= X,
    B \= X,
    arista(G,A,X), 
    hay_camino(G,X,B).

no_conexo(G) :-
    vertice(G,V1),
    vertice(G,V2),
    V1 \= V2,
    \+hay_camino(G,V1,V2),
    \+hay_camino(G,V2,V1).

conexo(G) :- \+no_conexo(G).

