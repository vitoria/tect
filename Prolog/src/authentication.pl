:- module(authentication, [authenticationMenu/0]).

:- use_module(constants).
:- use_module(register).
:- use_module(login).

handleAfterLogin(true, UserName) :-
    tty_clear,
    write(UserName),
    writeln(", seja bem-vindo(a)!"),
    systemPause.
handleAfterLogin(false, _) :- authenticationMenu.

chooseProceedure(1):- login:login(Logged, UserName), handleAfterLogin(Logged, UserName).
chooseProceedure(2):- register:register, authenticationMenu.
chooseProceedure(3):- halt.
chooseProceedure(_):-
    constants:invalid_option(Msg),
    writeln(Msg),
    systemPause,
    authenticationMenu.

showAuthenticationMenu():-
    constants:header(Header),
    constants:authentication_header(AuthenticationHeader),
    constants:login_menu(Menu),
    writeln(Header),
    writeln(AuthenticationHeader),
    writeln(Menu).
    
readOption(Option):-
    constants:choose_option(Msg),
    writeln(Msg),
    readNumber(Option).

readNumber(Number) :-
    read_line_to_codes(user_input, Codes),
    string_to_atom(Codes, Atom),
    atom_number(Atom, Number).

systemPause() :-
    constants:pause_msg(Msg),
    writeln(Msg),
    read_line_to_string(user_input, _).

authenticationMenu():-
    tty_clear,
    showAuthenticationMenu,
    readOption(Option),
    chooseProceedure(Option).
    