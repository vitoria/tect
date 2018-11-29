:- module(register, []).

:- use_module(constants).

:- dynamic user/4.

user(waza, waza, waza).

validPassword(Password, true) :-
    atom_string(Atom, Password),
    atom_length(Atom, Length),
    Length > 3.
validPassword( false) :-
    constants:password_should_contains_min_characters(Msg),
    writeln(Msg).


validString(_, String, true) :-
    atom_string(Atom, String),
    atom_length(Atom, Length),
    Length > 0.
validString(Field,_, false) :-
    constants:string_not_empty(Msg),
    write(Field),
    writeln(Msg).

saveUser(_, Username, _) :-
    constants:creation_failed(Msg),
    user(_, Username, _),
    writeln(Msg),
    systemPause.

saveUser(Name, Username, Password) :-
    (assertz(user(Name, Username, Password)),
    constants:user_registered(Msg),
    writeln(Msg)),
    systemPause.
    

createUser(Name, Username, Password, Password) :-
    validString("Nome", Name, ValidName),
    ValidName,
    validString("Username", Username, ValidUsername),
    ValidUsername,
    validPassword(Password, Valid),
    Valid,
    saveUser(Name, Username, Password).

createUser(_, _, _, _) :-
    constants:passwords_not_match(Msg),
    writeln(Msg),
    systemPause.

systemPause() :-
    constants:pause_msg(Msg),
    writeln(Msg),
    read_line_to_string(user_input, _).

proceedure() :-
    constants:name_const(NameMsg),
    constants:username_const(UsernameMsg),
    constants:password_const(PasswordMsg),
    constants:confirmation_password(PasswordMsg2),
    writeln(NameMsg),
    readString(Name),
    writeln(UsernameMsg),
    readString(Username),
    writeln(PasswordMsg),
    readString(Password),
    writeln(PasswordMsg2),
    readString(Password2),
    createUser(Name, Username, Password, Password2).

readString(String) :- read_line_to_string(user_input, String).

register() :-
    tty_clear,
    constants:header(Header),
    constants:sign_up_header(RegisterHeader),
    writeln(Header),
    writeln(RegisterHeader),
    proceedure. 