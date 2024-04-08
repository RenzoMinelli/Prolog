% Se busca colorear un mapa, de forma que no haya dos
% países vecinos con los mismos colores.
% El mapa se representa por una lista de regiones de la
% forma:
% region(Nombre, Color, ColoresVecinos)
% En la figura: [region(a, A, [B,C,D]), region(b, B, [A,C,E]), ...]
% Defina el siguiente predicado:
% colorear(Mapa, Colores) Mapa se encuentra coloreado con Colores, de
% forma tal que no hay dos vecinos iguales.

% colorear([],_).
% colorear([region(_, Color, ColoresVecinos)|Ms],Colores):-
%     member(Color, Colores),
%     \+member(Color, ColoresVecinos),
%     colorear(Ms,Colores).

colorear([],_).
colorear([region(_, Color, ColoresVecinos)|Ms],Colores):-
    member(Color, Colores),
    colorear(Ms,Colores),
    \+member(Color, ColoresVecinos).

colorear(
    [
        region(a,Ca,[Cb, Cc, Cd]),
        region(b,Cb,[Ca, Cc, Ce]), 
        region(c,Cc,[Ca, Cb, Cd, Ce]),
        region(d,Cd,[Ca, Cc, Cf]),
        region(e,Ce,[Cb, Cc, Cf]),
        region(f,Cf,[Cd, Cc, Ce])
    ],
    [
        color_1, color_2, color_3, color_4
    ]
).