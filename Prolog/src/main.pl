:- initialization(main).

:- use_module(authentication, [authenticationMenu]).

main :- authentication:authenticationMenu.
