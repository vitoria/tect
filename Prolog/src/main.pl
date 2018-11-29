:- initialization(main).
:- use_module("MainSystem").

main :- mainSystem:project:loadAllProjectData, mainSystem:systemMenu("Mateus").
