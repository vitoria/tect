:- module(project, [projectMenu/2]).

:- use_module("Constants").
:- use_module("MainSystem").

% Project(id, name, description, owner)
:- dynamic project/4.
:- dynamic projectUsers/2.
:- dynamic requests/2.
:- dynamic nextProjectId/1.

nextProjectId(1).

readNumber(Number):- read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).

createDirectory(Directory):- exists_directory(Directory) -> true; make_directory(Directory).


saveProjectsToFile():-
    createDirectory('data'),
    open('data/projects.dat', write, Stream),   
    forall(project(Id, Name, Desc, Owner),(
    writeln(Stream, Id), writeln(Stream, Name), writeln(Stream, Desc), writeln(Stream, Owner), defineNextProjectId(Id))),
    close(Stream).

readProjectsFromFile():-
    exists_file('data/projects.dat') ->(
    open('data/projects.dat', read, Stream),
    forall((readLine(Stream, Id), readLine(Stream, Name), readLine(Stream, Desc), readLine(Stream, Owner)),
    assertz(project(Id, Name, Desc, Owner))));
    true.

defineNextProjectId(NewId):-
    nextProjectId(Id),
    NewId > Id,
    retract(nextProjectId(_)),
    assertz(nextProjectId(NewId)) ; true.


readLine(InStream,W) :-
    get0(InStream,Char),
    checkCharAndReadRest(Char,Chars,InStream),
    atom_chars(W,Chars).

checkCharAndReadRest(10,[],_) :- !.  % Return
checkCharAndReadRest(-1,[],_) :- !.  % End of Stream
checkCharAndReadRest(end_of_file,[],_) :- !.
checkCharAndReadRest(Char,[Char|Chars],InStream) :-
    get0(InStream,NextChar),
    checkCharAndReadRest(NextChar,Chars,InStream).

createProject(LoggedUser):-
    constants:header(Header),
    writeln(Header),
    constants:create_project_header(CreateProjectHeader),
    writeln(CreateProjectHeader),
    nextProjectId(Id),
    writeln("Nome do projeto:"),
    read_line_to_string(user_input, Name),
    writeln("Descrição do projeto:"),
    read_line_to_string(user_input, Description),
    assertz(project(Id, Name, Description, LoggedUser)),
    NewId is Id + 1,
    defineNextProjectId(NewId),
    saveProjectsToFile.

listProject():-
    constants:header(Header),
    writeln(Header),
    constants:list_project_header(ListProjectHeader),
    writeln(ListProjectHeader),
    constants:list_project_table_header(ListProjectTableHeader),
    writeln(ListProjectTableHeader),
    project(Id, Name, _, Owner),
    write(Id), write("  -  "),
    write(Name), write("  -  "),
    writeln(Owner), fail; true.

requestAccess(ProjectId, User):- project(ProjectId, _, _, Owner), User == Owner -> writeln("Você é o dono deste projeto!"); assertz(requests(ProjectId, User)).

printProjectOwnerMenu():-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:project_menu_owner(ProjectMenuOwner),
    writeln(ProjectMenuOwner).

printProjectUserMenu():-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:project_menu_user(ProjectMenuUser),
    writeln(ProjectMenuUser).

selectOptionOwner(Option, LoggedUser):-
    (Option == 1 -> writeln("INFO PROJETO");
    Option == 2 -> writeln("EDITAR NOME PROJ");
    Option == 3 -> writeln("EDITAR DESC DO PROJ");
    Option == 4 -> writeln("VERIFICAR PERMISSÕES");
    Option == 5 -> writeln("EXCLUIR PROJETO");
    Option == 6 -> writeln("GERENCIAR SUITES");
    writeln("Opção inválida!")),
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(_).

selectOptionUser(Option, LoggedUser):-
    (Option == 1 -> writeln("GERENCIAR SUITES");
    writeln("Opção inválida!")),
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(_).

projectMenu(LoggedUser, Id):-
    project(Id, _, _, LoggedUser) ->
    (printProjectOwnerMenu,
    readNumber(Option),
    Option \== 7, selectOptionOwner(Option, LoggedUser), projectMenu(LoggedUser, Id));
    (projectUsers(Id, LoggedUser) ->
    printProjectUserMenu,
    readNumber(Option),
    Option \== 2, selectOptionUser(Option, LoggedUser), projectMenu(LoggedUser, Id); mainSystem:systemMenu(LoggedUser)).


