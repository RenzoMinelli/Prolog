progenitor(homero,bart).
0.8::progenitor(homero,lisa).
progenitor(homero,maggie).
progenitor(marge,bart).
0.7::progenitor(marge,lisa).
progenitor(marge,maggie).
progenitor(abraham,homero).
progenitor(mona,homero).
progenitor(abraham,herb).
progenitor(clancy,marge).
progenitor(clancy,patty).
progenitor(clancy,selma).
progenitor(jackie,marge).
progenitor(jackie,patty).
progenitor(jackie,selma).
0.1::progenitor(selma,ling).
hermano(X,Y) :- progenitor(P,X),progenitor(P,Y), not(X=Y).
ancestro(X,Y) :- progenitor(X,Y).
ancestro(X,Y) :- progenitor(Z,Y), ancestro(X,Z).


% query(ancestro(X,lisa)).
% query(hermano(X,lisa)).
query(hermano(bart,lisa)).