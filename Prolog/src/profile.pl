:- module(profile, []).

:- use_module(constants).
:- use_module(utils).
:- use_module(authentication).
:- use_module(model).

showProfile(LoggedUser):-
                    model:userModel:user(Name, LoggedUser, _),
                    headerMyUser,
                    constants:name_const(N),
                    constants:username_const(U),
                    write(N), writeln(Name),
                    write(U), writeln(LoggedUser),
                    writeln(" "),
                    utils:systemPause,
                    profileMenu(LoggedUser).

editPassword(LoggedUser):-
                    headerMyUser,
                    model:userModel:user(_, LoggedUser, Password),
                    constants:old_password(O),
                    writeln(O),
                    (utils:readString(Password) -> 
                        (editPasswordAux(LoggedUser),
                        profileMenu(LoggedUser)));
                    writeln(" "),
                    constants:password_incorrect(S),
                    utils:showPausedMsg(S),
                    profileMenu(LoggedUser).

editPasswordAux(LoggedUser):-
                    constants:new_password(N),
                    writeln(N),
                    utils:readString(Password) ,
                    constants:repeat_new_password(C),
                    writeln(C),
                    (utils:readString(Password)  ->
                        (retract(model:userModel:user(Name, LoggedUser, _)),
                        assertz(model:userModel:user(Name, LoggedUser, Password)),
                        model:userModel:saveUsers,
                        constants:password_change_success(S),
                        utils:showPausedMsg(S)));
                    writeln(" "),
                    constants:passwords_not_match(M),
                    utils:showPausedMsg(M),
                    editPasswordAux(LoggedUser).

chooseOption(1, LoggedUser):- showProfile(LoggedUser).
chooseOption(2, LoggedUser):- editPassword(LoggedUser).
chooseOption(3, _):- true.
chooseOption(_, LoggedUser):- 
                constants:invalid_option(I),
                utils:showPausedMsg(I),
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
