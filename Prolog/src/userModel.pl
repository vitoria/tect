:- module(userModel, []).

:- use_module(model).
:- use_module(utils).
:- use_module(constants).

:- dynamic user/3.

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