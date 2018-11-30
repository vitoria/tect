:- module(authentication, [authenticationMenu/0]).

:- use_module(constants).
:- use_module(register).
:- use_module(login).
:- use_module(utils).

:- dynamic user/4.

user(waza, waza, waza).

saveUsers() :-
    constants:data_folder_path(DataFolder),
    constants:users_file_path(UserFilePath),
    utils:createDirectory(DataFolder),
    open(UserFilePath, write, Stream),   
    forall(user(Name, Username, Password),(
    writeln(Stream, Name), writeln(Stream, Username), writeln(Stream, Password))),
    close(Stream).

loadUsers() :-
    constants:users_file_path(UserFilePath),
    exists_file(UserFilePath) -> (
    open(UserFilePath, read, Stream),
    readUser(Stream),
    close(Stream));
    true.

readUser(Stream) :- at_end_of_stream(Stream).
readUser(Stream) :-
    utils:readLine(Stream, NameAtom), atom_string(NameAtom, Name),
    utils:readLine(Stream, UsernameAtom), atom_string(UsernameAtom, Username),
    utils:readLine(Stream, PasswordAtom), atom_string(PasswordAtom, Password),
    assertz(user(Name, Username, Password)),
    readUser(Stream).

handleAfterLogin(true, UserName) :-
    saveUsers,
    write(UserName),
    writeln(" Should go to the main menu").
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

initialization() :- loadUsers, authenticationMenu.
    