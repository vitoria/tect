:- module(model, []).

:- use_module(constants).
:- use_module(userModel).
:- use_module(projectModel).
:- use_module(testSuiteModel).

initialization() :-
    userModel:loadUsers,
    projectModel:loadAllProjectData,
    testSuiteModel:loadSuites.

