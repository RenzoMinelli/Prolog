
append_all_dl([],R-R).

append_all_dl([X-L|Resto],X-Sr):-
    append_all_dl(Resto,L-Sr).
    
