:- initialization(main).
:- use_module("MainSystem").

main :- mainSystem:project:readProjectsFromFile, mainSystem:systemMenu("Mateus").
