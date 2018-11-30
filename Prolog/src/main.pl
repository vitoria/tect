:- initialization(main).
:- use_module("mainSystem").

main :- mainSystem:project:loadAllProjectData, mainSystem:systemMenu("Douglas").
