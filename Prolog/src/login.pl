:- module(login, []).

:- use_module(constants).
:- use_module(authentication).
:- use_module(utils).
:- use_module(model).

isLoginValid(Username, Password, true) :-
    constants:welcome(Msg),
    model:userModel:user(Name, Username, Password),
    write(Name),
    utils:showPausedMsg(Msg).
isLoginValid(_, _, false) :-
    constants:login_failed(Msg),
    utils:showPausedMsg(Msg).

procedure(Logged, Username) :-
    constants:username_const(UsernameMsg),
    constants:password_const(PasswordMsg),
    writeln(UsernameMsg),
    utils:readString(Username),
    writeln(PasswordMsg),
    utils:readString(Password),
    isLoginValid(Username, Password, Logged).

login(Logged, Username) :-
    constants:login_header(LoginHeader),
    utils:printHeaderAndSubtitle(LoginHeader),
    procedure(Logged, Username).