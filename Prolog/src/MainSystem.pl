:- module(mainSystem, [systemMenu/1]).

:- use_module("Constants").
:- use_module("Project").
:- dynamic printSystemMenu/0.


readNumber(Number):- read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).

createProject(LoggedUser):-
    tty_clear,
    project:createProject(LoggedUser),
    writeln("Projeto criado com sucesso!").

listProject():-
    tty_clear,
    project:listProject().

printSystemMenu():-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:main_menu(MainMenu),
    writeln(MainMenu).

selectOption(Option, LoggedUser):-
    (Option == 1 -> writeln("MEU USUARIO");
    Option == 2 -> writeln("CRIAR PROJETO"), createProject(LoggedUser);
    Option == 3 -> writeln("PEDIR ACESSO");
    Option == 4 -> writeln("LISTAR PROJETOS"), listProject();
    Option == 5 -> writeln("GERENCIAR PROJETO");
    Option == 6 -> writeln("GERAR RELATORIOS");
    Option == 7 -> writeln("LOGOUT")),
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(Char).

systemMenu(LoggedUser):-
    printSystemMenu,
    readNumber(Option),
    Option < 8 -> selectOption(Option, LoggedUser), systemMenu(LoggedUser); writeln("Encerrando programa...").