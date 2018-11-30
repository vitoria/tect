:- module(register, []).

:- use_module(authentication).
:- use_module(constants).
:- use_module(utils).

saveUser(_, Username, _) :-
    constants:creation_failed(Msg),
    authentication:user(_, Username, _),
    writeln(Msg),
    utils:systemPause.

saveUser(Name, Username, Password) :-
    (assertz(authentication:user(Name, Username, Password)),
    constants:user_registered(Msg),
    writeln(Msg)),
    utils:systemPause.

createUser(Name, Username, Password, Password) :-
    utils:validString("Nome", Name, ValidName),
    ValidName,
    utils:validString("Username", Username, ValidUsername),
    ValidUsername,
    utils:validPassword(Password, Valid),
    Valid,
    saveUser(Name, Username, Password).

createUser(_, _, _, _) :-
    constants:passwords_not_match(Msg),
    writeln(Msg),
    utils:systemPause.

procedure() :-
    constants:name_const(NameMsg),
    constants:username_const(UsernameMsg),
    constants:password_const(PasswordMsg),
    constants:confirmation_password(PasswordMsg2),
    writeln(NameMsg),
    utils:readString(Name),
    writeln(UsernameMsg),
    utils:readString(Username),
    writeln(PasswordMsg),
    utils:readString(Password),
    writeln(PasswordMsg2),
    utils:readString(Password2),
    createUser(Name, Username, Password, Password2).

register() :-
    constants:sign_up_header(RegisterHeader),
    utils:printHeaderAndSubtitle(RegisterHeader),
    procedure. 