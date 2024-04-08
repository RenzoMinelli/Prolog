sumaLista([],0).
sumaLista([s(X)|Xs],s(N)):- sumaLista(Xs,N1), N = N1. %mal
