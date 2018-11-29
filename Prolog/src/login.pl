:- module(login, []).

:- use_module(constants).
:- use_module(utils).

:- dynamic user/4.

user(waza, waza, waza).

procedure(false, vitoria).

login(Logged, Username) :-
    constants:login_header(LoginHeader),
    utils:printHeaderAndSubtitle(LoginHeader),
    procedure(Logged, Username),
    utils:systemPause.