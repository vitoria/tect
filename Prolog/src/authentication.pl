:- module(authentication, [authenticationMenu/0]).

:- use_module(constants).
:- use_module(register).
:- use_module(login).
:- use_module(utils).

:- dynamic user/4.

user(waza, waza, waza).

handleAfterLogin(true, UserName) :-
    tty_clear,
    write(UserName),
    writeln(", seja bem-vindo(a)!"),
    utils:systemPause.
handleAfterLogin(false, _) :- authenticationMenu.

chooseProceedure(1):- login:login(Logged, UserName), handleAfterLogin(Logged, UserName).
chooseProceedure(2):- register:register, authenticationMenu.
chooseProceedure(3):- halt.
chooseProceedure(_):-
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
    chooseProceedure(Option).
    