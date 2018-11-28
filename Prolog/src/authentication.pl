:- module(authentication, [authenticationMenu/0]).

:- use_module("Constants").

chooseProceedure(1):- writeln("Login").
chooseProceedure(2):- writeln("Cadastro").
chooseProceedure(3):- halt.
chooseProceedure(_):-
    constants:invalid_option(Msg),
    writeln(Msg),
    systemPause,
    authenticationMenu.

showAuthenticationMenu():-
    constants:header(Header),
    constants:login_menu(Menu),
    writeln(Header),
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
    