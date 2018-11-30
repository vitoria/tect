:- module(model, []).

:- use_module(constants).
:- use_module(userModel).
:- use_module(projectModel).
:- use_module(loggedModel).

initialization() :-
    loggedModel:loadLogged,
    userModel:loadUsers,
    projectModel:loadAllProjectData.

