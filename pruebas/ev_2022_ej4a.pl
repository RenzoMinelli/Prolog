0.4::cara.

0.7::urna1(rojo); 0.3::urna1(azul).
0.5::urna2(azul); 0.3::urna2(rojo); 0.2::urna2(negro).

gano :- cara, urna1(azul).
gano :- cara, urna2(azul).
gano :- urna1(C), urna2(C).

query(gano).