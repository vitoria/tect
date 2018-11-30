:- module(profile, []).

:- use_module(constants).
:- use_module(utils).
:- use_module(authentication).
:- use_module(model).

showProfile(LoggedUser):-
                    model:userModel:user(Name, LoggedUser, _),
                    headerMyUser,
                    write("Nome: "), writeln(Name),
                    write("Username: "), writeln(LoggedUser),
                    writeln(" "),
                    utils:systemPause,
                    profileMenu(LoggedUser).

editPassword(LoggedUser):-
                    headerMyUser,
                    model:userModel:user(_, LoggedUser, Password),
                    constants:old_password(O),
                    writeln(O),
                    (read_line_to_string(user_input, Password) -> 
                        (editPasswordAux(LoggedUser)));
                    writeln(" "),
                    constants:password_incorrect(S),
                    writeln(S),
                    utils:systemPause,
                    profileMenu(LoggedUser).

editPasswordAux(LoggedUser):-
                    constants:new_password(N),
                    writeln(N),
                    read_line_to_string(user_input, Password),
                    constants:repeat_new_password(C),
                    writeln(C),
                    (read_line_to_string(user_input, Password) ->
                        (retract(model:userModel:user(Name, LoggedUser, _)),
                        assertz(model:userModel:user(Name, LoggedUser, Password)),
                        model:userModel:saveUsers,
                        writeln("Alteração de senha foi efetuada com sucesso")));
                    writeln(" "),
                    constants:passwords_not_match(M),
                    writeln(M),
                    utils:systemPause,
                    editPasswordAux(LoggedUser).

chooseOption(1, LoggedUser):- showProfile(LoggedUser).
chooseOption(2, LoggedUser):- editPassword(LoggedUser).
chooseOption(3, _):- true.
chooseOption(_, LoggedUser):- 
                utils:showPausedMsg("Opção Inválida!"),
                profileMenu(LoggedUser).

profileMenu(LoggedUser):- 
                    headerMyUser,
                    constants:my_user_menu(U),
                    writeln(U),
                    utils:readOption(Option),
                    chooseOption(Option, LoggedUser).
                    

headerMyUser:-
                    tty_clear,    
                    constants:my_user_header(X),
                    utils:printHeaderAndSubtitle(X),
                    writeln(" ").
