:- module(mainSystem, [systemMenu/1]).

:- use_module(authentication).
:- use_module(constants).
:- use_module(project).
:- use_module(utils).
:- use_module(profile).
:- use_module(model).

createProject(LoggedUser):- project:createProject(LoggedUser).

listProject():- project:listProject().

requestAccess(LoggedUser):-
    constants:request_access_header(RequestAccessHeader),
    utils:printHeaderAndSubtitle(RequestAccessHeader),
    constants:get_proj_id(GetProjId),
    writeln(GetProjId),
    utils:readNumber(Id),
    model:projectModel:project(Id, _, _, _) -> project:requestAccess(Id, LoggedUser); writeln("Id informado inválido.").

manageProject(LoggedUser):-
    constants:manage_project_header(RequestAccessHeader),
    utils:printHeaderAndSubtitle(RequestAccessHeader),
    constants:get_proj_id(GetProjId),
    writeln(GetProjId),
    utils:readNumber(Id),
    model:projectModel:project(Id, _, _, _) -> (project:projectMenu(LoggedUser, Id)); writeln("Id informado inválido.").

printSystemMenu():-
    constants:main_menu(MainMenu),
    constants:main_header(MainHeader),
    utils:printHeaderAndSubtitle(MainHeader),
    writeln(MainMenu).

selectOption(Option, LoggedUser):- option(Option, LoggedUser),
    model:projectModel:saveAllProjectData, utils:systemPause.

option(1, LoggedUser):- profile:profileMenu(LoggedUser).
option(2, LoggedUser):- createProject(LoggedUser).
option(3, LoggedUser):- requestAccess(LoggedUser).
option(4, _):- listProject().
option(5, LoggedUser):- manageProject(LoggedUser).
option(6, LoggedUser):- write("MEU USUARIO: "), writeln(LoggedUser), writeln("GERAR RELATORIOS").
option(7, _):- model:loggedModel:logout, authentication:authenticationMenu.
option(8, _):- halt.
option(_,_):- writeln("Opção inválida!").

systemMenu(LoggedUser):-
    printSystemMenu,
    utils:readOption(Option),
    selectOption(Option, LoggedUser),
    systemMenu(LoggedUser).