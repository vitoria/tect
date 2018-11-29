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
    writeln(Stream, Id), writeln(Stream, Name), writeln(Stream, Desc), writeln(Stream, Owner))),
    close(Stream).

readProjectsFromFile():-
    exists_file('data/projects.dat') ->(
    open('data/projects.dat', read, Stream),
    % generateInputList(Stream, StringList),
    readProject(Stream, StringList),
    close(Stream));
    true.

generateInputList(-1, []).
generateInputList(end_of_file, []).
generateInputList(Stream, [Line|List]):-
    read_line_to_string(Stream, Line), 
    at_end_of_stream(Stream) -> true;
    generateInputList(Stream, List).

printList([]).
printList([H|List]):-
    writeln(H),
    printList(List).

assertProjects([Id, Name, Desc, Owner|StringList]):-
    assertz(project(Id, Name, Desc, Owner)),
    defineNextProjectId(Id),
    assertProjects(StringList).
assertProjects([]).
assertProjects([_|[]]).

defineNextProjectId(NewId):-
    nextProjectId(Id),
    (NewId > Id,
    retract(nextProjectId(_)),
    assertz(nextProjectId(NewId))) ; true.

readProject(Stream, []) :- at_end_of_stream(Stream).
readProject(Stream, [Id|[Name|[Desc|[Owner|List]]]]):-
    readLine(Stream, Id),
    readLine(Stream, Name),
    readLine(Stream, Desc),
    readLine(Stream, Owner),
    assertz(project(Id, Name, Desc, Owner)),
    readProject(Stream, List).


readLine(Stream, Line):-
    get0(Stream,Char),
    checkCharAndReadRest(Char,Chars,Stream),
    atom_chars(Line,Chars).

checkCharAndReadRest(10,[],_) :- !.  % Return
checkCharAndReadRest(-1,[],_) :- !.  % End of Stream
checkCharAndReadRest(end_of_file,[],_) :- !.
checkCharAndReadRest(Char,[Char|Chars],Stream) :-
    get0(Stream,NextChar),
    checkCharAndReadRest(NextChar,Chars,Stream).

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
    saveProjectsToFile,
    writeln("Projeto criado com sucesso!").

listProject():-
    constants:header(Header),
    writeln(Header),
    constants:list_project_header(ListProjectHeader),
    writeln(ListProjectHeader),
    constants:list_projects_table_header(ListProjectsTableHeader),
    writeln(ListProjectsTableHeader),
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

projectInfo(Id):-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:project_detais_header(ProjectDetailsHeader),
    writeln(ProjectDetailsHeader),
    project(Id, Name, Desc, Owner),
    write("ID: "),
    writeln(Id),
    write("Nome do Projeto: "),
    writeln(Name),
    write("Descrição: "),
    writeln(Desc),
    write("Proprietário: "),
    writeln(Owner).
    

editProjectName(Id):-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:edit_project_header(EditProjectHeader),
    writeln(EditProjectHeader),
    project(Id, Name, Desc, Owner),
    write("Nome anterior: "),
    writeln(Name),
    writeln("Informe o novo Nome: "),
    read_line_to_string(user_input, NewName),
    retract(project(Id, Name, Desc, Owner)),
    assertz(project(Id, NewName, Desc, Owner)),
    writeln("Projeto editado com sucesso!").

editProjectDesc(Id):-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:edit_project_header(EditProjectHeader),
    writeln(EditProjectHeader),
    project(Id, Name, Desc, Owner),
    write("Descrição anterior: "),
    writeln(Desc),
    writeln("Informe a nova Descrição: "),
    read_line_to_string(user_input, NewDesc),
    retract(project(Id, Name, Desc, Owner)),
    assertz(project(Id, Name, NewDesc, Owner)),
    writeln("Projeto editado com sucesso!").

removeProject(Id):-
    tty_clear,
    constants:header(Header),
    writeln(Header),
    constants:remove_project_header(RemoveProjectHeader),
    writeln(RemoveProjectHeader),
    writeln("Realmente deseja remover o projeto atual? (S/N)"),
    read_line_to_string(user_input, Response),
    (Response == "S"; Response == "s") -> (
        retract(project(Id, _, _, _)),
        (retract(projectUsers(Id, _)); true),
        (retract(requests(Id, _)); true),
        writeln("Projeto removido com sucesso!")
        ); writeln("Projeto não removido.").

selectOptionOwner(Option, Id):-
    (Option == 1 -> projectInfo(Id);
    Option == 2 -> editProjectName(Id);
    Option == 3 -> editProjectDesc(Id);
    Option == 4 -> writeln("VERIFICAR PERMISSÕES");
    Option == 5 -> removeProject(Id);
    Option == 6 -> writeln("GERENCIAR SUITES");
    writeln("Opção inválida!")), (Option == 5;
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(_)).

selectOptionUser(Option, Id):-
    (Option == 1 -> writeln("GERENCIAR SUITES");
    writeln("Opção inválida!")),
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(_).

ownerProjectMenu(Id):-
    printProjectOwnerMenu,
    readNumber(Option),
    Option \== 7, selectOptionOwner(Option, Id), (Option == 5; ownerProjectMenu(Id)).

userProjectMenu(Id):-
    printProjectUserMenu,
    readNumber(Option),
    Option \== 2, selectOptionUser(Option, Id), userProjectMenu(Id).

projectMenu(LoggedUser, Id):-
    project(Id, _, _, LoggedUser) -> ownerProjectMenu(Id); projectUsers(Id, LoggedUser), userProjectMenu(Id); true.


