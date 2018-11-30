:- module(model, []).

:- use_module(constants).
:- use_module(userModel).
:- use_module(projectModel).
:- use_module(testSuiteModel).
:- use_module(loggedModel).
:- use_module(testCase).

initialization() :-
    loggedModel:loadLogged,
    userModel:loadUsers,
    projectModel:loadAllProjectData,
    testSuiteModel:loadSuites,
    testCase:loadAllTestCasesData.

