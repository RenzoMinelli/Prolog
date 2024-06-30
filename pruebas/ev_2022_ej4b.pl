s --> a(N),b(M),c(MN1),d(MN2), {MN1 is M+N, MN2 is M*N}.

a(0) --> []. 
a(N) --> [a],a(N1), {N is N1+1}. 

c(0) --> []. 
c(N) --> [c],c(N1), {N is N1+1}. 

b(0) --> []. 
b(N) --> [b],b(N1), {N is N1+1}. 

d(0) --> []. 
d(N) --> [d],d(N1), {N is N1+1}. 