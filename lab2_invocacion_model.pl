:- use_module(library(filesex)).

% Invoco a Problog a partir de un modelo 
% Y consulto el resultado para obtener 
% las consultas y su probabilidad

consultar_probabilidades(ListaValores):-
    % Problog debe estar en el path!
    absolute_file_name(path(problog),Problog,[access(exist),extensions([exe])]),
    % Nombre del modelo, que se supone está en el mismo directorio que el fuente
    absolute_file_name(modelo_problog,Modelo,[file_type(prolog)]),
    % Invoca a problog con el modelo como argumento, y envía la salida a un pipe
    process_create(Problog,[Modelo],[stdout(pipe(In))]),
    % Convierte la salida a un string
    read_string(In,_,Result),
    % Divide la salida
    split_string(Result,"\n\t","\r ",L),
    % Escribo la salida
    % writeln(Result),
    % Quito último elemento de la lista
    append(L1,[_],L),
    lista_valores(L1,ListaValores).

% Predicado auxiliar para transformar a términos y a números, como se espera
lista_valores([X,Y|T],[TermValor|T1]):-
    % Saco los dos puntos del final
    split_string(X,"",":",[X1|_]),
    term_string(TermX,X1),
    TermX =.. [puntaje,Cat,Valor],
    number_string(NumberY,Y),
    TermValor =.. [p,Cat,Valor,NumberY],
    lista_valores(T,T1).
lista_valores([],[]).

% obtiene el valor esperado por cada categoria 
agrupar_por_cat([],[]).
agrupar_por_cat([p(Cat,Valor,Prob)|Ps],Agrupado):-
    agrupar_por_cat(Ps,AgrupadoResto),
    select((Cat,ValorAux),AgrupadoResto,AgrupadoAux), !,
    ValorNuevo is (Prob * Valor) + ValorAux,
    Agrupado = [(Cat,ValorNuevo)|AgrupadoAux].
agrupar_por_cat([p(Cat,Valor,Prob)|Ps],Agrupado):-
    agrupar_por_cat(Ps,AgrupadoResto),
    ValorNuevo is (Prob * Valor),
    Agrupado = [(Cat,ValorNuevo)|AgrupadoResto].

% obtiene los valores esperados de las categorias
valores_esperados(ValoresEsperados):-
    consultar_probabilidades(Probs),
    agrupar_por_cat(Probs,ValoresEsperados).

% usada como auxiliar para obtener la categoria con mayor valor esperado
mejor_cat_acum([],Cat,_,Cat).
mejor_cat_acum([(Cat,Val)|CatVals], _, ValAnterior, CatMejor) :- 
    Val >= ValAnterior,
    mejor_cat_acum(CatVals, Cat, Val, CatMejor).
mejor_cat_acum([(_,Val)|CatVals], CatAnterior, ValAnterior, CatMejor) :- 
    Val < ValAnterior,
    mejor_cat_acum(CatVals, CatAnterior, ValAnterior, CatMejor).

% te da la categoria que tiene mayor valor esperado
mejor_cat(ValoresEsperados, Cat):-
    mejor_cat_acum(ValoresEsperados,aces,0,Cat).

% quita las categorias que ya fueron ocupadas
quitar_categorias_ocupadas([],[],[]).
quitar_categorias_ocupadas([(Cat,_)|CatVals], CategoriasOcupadas, CatValsFiltradas) :-
    select(Cat, CategoriasOcupadas, CatsOcupadasResto), !,
    quitar_categorias_ocupadas(CatVals, CatsOcupadasResto, CatValsFiltradas).
quitar_categorias_ocupadas([(Cat,V)|CatVals], CategoriasOcupadas, [(Cat,V)|CatValsFiltradas]) :-
    quitar_categorias_ocupadas(CatVals, CategoriasOcupadas, CatValsFiltradas).

% te da la categoria que tiene mayor valor esperado y que no fue ocupada
categoria_a_elegir(CategoriasOcupadas, Cat):-
    valores_esperados(ValoresEsperados),
    quitar_categorias_ocupadas(ValoresEsperados, CategoriasOcupadas, ValoresEsperadosFiltrados),
    writeln(ValoresEsperadosFiltrados),
    mejor_cat(ValoresEsperadosFiltrados, Cat).

