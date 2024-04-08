suma(0,X,X).
suma(s(X),Y,s(S)):- suma(X,Y,S).

producto(0,_,0).
producto(_,0,0).
producto(s(X),Y,P):-producto(X,Y,Z),suma(Z,Y,P).
producto(Y,s(X),P):-producto(X,Y,Z),suma(Z,Y,P).

distintos(0,s(_)).
distintos(s(_),0).
distintos(s(X),s(Y)):-distintos(X,Y).

mayor(s(_),0).
mayor(s(X),s(Y)):-mayor(X,Y).
