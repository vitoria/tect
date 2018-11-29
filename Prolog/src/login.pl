:- module(login, []).

:- use_module(constants).

:- dynamic user/4.

user(waza, waza, waza).

systemPause() :-
    constants:pause_msg(Msg),
    writeln(Msg),
    read_line_to_string(user_input, _).

procedure(false, vitoria).

login(Logged, Username) :-
    tty_clear,
    constants:header(Header),
    constants:login_header(LoginHeader),
    writeln(Header),
    writeln(LoginHeader),
    procedure(Logged, Username),
    systemPause. 