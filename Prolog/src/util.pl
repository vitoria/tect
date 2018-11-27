:- module(util, [concatenate_string/3]).

length_1(0,[]).
length_1(L+1, [H|T]) :- length_1(L,T).


concatenate_string(String1, String2, Resultado) :-
	name(String1, X), name(String2, Y), append(X, Y, Z), name(Resultado, Z).

concatena([], FIM, FIM).
concatena([E|T], Result, FIM) :-
    concatena(T, [E|Result], FIM).

deletaUm(Del, [Elem|Tail], Result, FIM) :-
	\+ Elem \= Del -> concatena(Tail, Result, FIM);
	deletaUm(Del, Tail, [Elem|Result], FIM).
