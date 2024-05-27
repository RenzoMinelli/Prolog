0.8::camino(a,c); 0.2::camino(a,d).
0.6::camino(b,c); 0.3::camino(b,f).
0.9::camino(c,d); 0.1::camino(c,f).
0.1::camino(d,e).
0.1::camino(e,f).

hay_camino(X,Y) :- camino(X,Y).
hay_camino(X,Y) :- camino(X,Z), hay_camino(Z,Y).

0.9::camino(d,f).

query(hay_camino(a,X)).


% El mundo más probable será aquel donde seleccionamos los caminos con mayor probabilidad en cada paso.

% Cálculo de la probabilidad
% El mundo más probable selecciona los siguientes caminos:  

% camino(a,c) con probabilidad 0.8.
% camino(c,d) con probabilidad 0.9.
% camino(d,e) con probabilidad 0.1.

% P(mundo_mas_probable)=0.8×0.9×0.1=0.072

