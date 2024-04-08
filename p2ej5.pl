% Considere la representación de vectores mediante listas de valores reales en Prolog.
% Implemente los siguientes predicados:
% neg(+V,?W) W es el vector opuesto a V
% suma(+V,+W,?T) T es la suma de los vectores V y W
% dot(+V,+W,?P) P es el producto punto entre V y W
% dist(+V,+W,?D) D es la distancia euclídea entre V y W

neg([],[]).
neg([X|Xs],[Y|Ys]) :- Y is (X * -1), neg(Xs,Ys).

suma([],[],[]).
suma([],[X|Xs],[X|Xs]).
suma([X|Xs],[],[X|Xs]).
suma([X|Xs],[Y|Ys],[Z|Zs]) :- Z is X+Y, suma(Xs,Ys,Zs).

dot([],[],0).
dot([X|Xs],[Y|Ys],P) :- dot(Xs,Ys,P1), P is X*Y + P1.

dist_acum([],[],Acum,D) :- sqrt(Acum,D).
dist_acum([X|Xs],[Y|Ys],Acum,D) :- Acum1 is Acum + (X-Y)**2, dist_acum(Xs,Ys,Acum1,D).
dist(X,Y,D) :- dist_acum(X,Y,0,D).