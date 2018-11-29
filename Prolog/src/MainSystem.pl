:- module(mainSystem, [systemMenu/1]).

:- use_module("Constants").
:- use_module("Project").


readNumber(Number):- read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).

createProject(LoggedUser):-
    tty_clear,
    project:createProject(LoggedUser).

listProject():-
    tty_clear,
    project:listProject().

requestAccess(LoggedUser):-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:request_access_header(RequestAccessHeader),
    writeln(RequestAccessHeader),
    writeln("Informe o ID do projeto:"),
    readNumber(Id),
    project:project(Id, _, _, _) -> project:requestAccess(Id, LoggedUser); writeln("Id informado inválido.").

manageProject(LoggedUser):-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:manage_project_header(ManageProjectHeader),
    writeln(ManageProjectHeader),
    writeln("Informe o ID do projeto:"),
    readNumber(Id),
    project:project(Id, _, _, _) -> (project:projectMenu(LoggedUser, Id)); writeln("Id informado inválido.").

printSystemMenu():-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:main_menu(MainMenu),
    writeln(MainMenu).

selectOption(Option, LoggedUser):-
    (Option == 1 -> writeln("MEU USUARIO");
    Option == 2 -> writeln("CRIAR PROJETO"), createProject(LoggedUser);
    Option == 3 -> writeln("PEDIR ACESSO"), requestAccess(LoggedUser);
    Option == 4 -> writeln("LISTAR PROJETOS"), listProject();
    Option == 5 -> writeln("GERENCIAR PROJETO"), manageProject(LoggedUser);
    Option == 6 -> writeln("GERAR RELATORIOS");
    Option == 7 -> writeln("LOGOUT");
    writeln("Opção inválida!")),
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(_).

systemMenu(LoggedUser):-
    printSystemMenu,
    readNumber(Option),
    Option \== 8 -> selectOption(Option, LoggedUser), systemMenu(LoggedUser); writeln("Encerrando programa...").