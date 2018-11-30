:- module(mainSystem, [systemMenu/1]).

:- use_module(constants).
:- use_module(project).
:- use_module(utils).

createProject(LoggedUser):- project:createProject(LoggedUser).

listProject():- project:listProject().

requestAccess(LoggedUser):-
    constants:request_access_header(RequestAccessHeader),
    utils:printHeaderAndSubtitle(RequestAccessHeader),
    writeln("Informe o ID do projeto:"),
    utils:readNumber(Id),
    project:project(Id, _, _, _) -> project:requestAccess(Id, LoggedUser); writeln("Id informado inválido.").

manageProject(LoggedUser):-
    constants:manage_project_header(RequestAccessHeader),
    utils:printHeaderAndSubtitle(RequestAccessHeader),
    writeln("Informe o ID do projeto:"),
    utils:readNumber(Id),
    project:project(Id, _, _, _) -> (project:projectMenu(LoggedUser, Id)); writeln("Id informado inválido.").

printSystemMenu():-
    constants:main_menu(MainMenu),
    utils:printHeaderAndSubtitle(MainMenu).

selectOption(Option, LoggedUser):- option(Option, LoggedUser),
    project:saveAllProjectData, writeln("Pressione qualquer tecla para continuar..."),
    get_char(_).

option(1, LoggedUser):- writeln("MEU USUARIO").
option(2, LoggedUser):- createProject(LoggedUser).
option(3, LoggedUser):- requestAccess(LoggedUser).
option(4, _):- listProject().
option(5, LoggedUser):- manageProject(LoggedUser).
option(6, LoggedUser):- writeln("GERAR RELATORIOS").
option(7, LoggedUser):- writeln("LOGOUT").
option(_,_):- writeln("Opção inválida!").

systemMenu(LoggedUser):-
    printSystemMenu,
    utils:readNumber(Option),
    Option =\= 8 -> selectOption(Option, LoggedUser), systemMenu(LoggedUser); writeln("Encerrando programa...").