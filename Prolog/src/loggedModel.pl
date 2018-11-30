:- module(loggedModel, []).

:- use_module(model).
:- use_module(utils).
:- use_module(constants).

:- dynamic logged/1.

saveLogged() :-
    constants:data_folder_path(DataFolder),
    constants:logged_user_file_path(LoggedFilePath),
    utils:createDirectory(DataFolder),
    open(LoggedFilePath, write, Stream),   
    forall(logged(Username),(
    writeln(Stream, Username))),
    close(Stream).

loadLogged() :-
    constants:logged_user_file_path(LoggedFilePath),
    exists_file(LoggedFilePath) -> (
    open(LoggedFilePath, read, Stream),
    readLogged(Stream),
    close(Stream));
    true.

readLogged(Stream) :- at_end_of_stream(Stream).
readLogged(Stream) :-
    utils:readLine(Stream, UsernameAtom), atom_string(UsernameAtom, Username),
    assertz(logged(Username)),
    readLogged(Stream).

login(Username) :- retractall(logged(_)), assertz(logged(Username)), saveLogged().

logout() :- retractall(logged(_)), saveLogged().