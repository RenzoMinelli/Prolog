exOr(Obj1, Obj2):- Obj1, !, \+Obj2.
exOr(Obj1, Obj2):- Obj2.

exOr2(Obj1,Obj2) :- Obj1, Obj2,!,fail.
exOr2(Obj1,Obj2) :- Obj1,!.
exOr2(Obj1,Obj2) :- Obj2.