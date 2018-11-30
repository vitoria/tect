:- module(model, []).

:- use_module(constants).
:- use_module(userModel).
:- use_module(projectModel).

initialization() :-
    userModel:loadUsers,
    projectModel:loadAllProjectData.

