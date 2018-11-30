:- module(authentication, [authenticationMenu/0]).

:- use_module(constants).
:- use_module(register).
:- use_module(login).
:- use_module(utils).
:- use_module(mainSystem).
:- use_module(model).

handleAfterLogin(true, UserName) :-
    model:userModel:saveUsers,
    mainSystem:systemMenu(UserName).
handleAfterLogin(false, _) :- authenticationMenu.

chooseProcedure(1):- login:login(Logged, UserName), handleAfterLogin(Logged, UserName).
chooseProcedure(2):- register:register, authenticationMenu.
chooseProcedure(3):- halt.
chooseProcedure(_):-
    constants:invalid_option(Msg),
    utils:showPausedMsg(Msg),
    authenticationMenu.

showAuthenticationMenu():-
    constants:authentication_header(AuthenticationHeader),
    constants:login_menu(Menu),
    utils:printHeaderAndSubtitle(AuthenticationHeader),
    writeln(Menu).

authenticationMenu():-
    showAuthenticationMenu,
    utils:readOption(Option),
    chooseProcedure(Option).

initialization() :- model:initialization(), authenticationMenu().
    