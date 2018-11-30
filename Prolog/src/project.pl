:- module(project, [projectMenu/2]).

:- use_module(constants).
:- use_module(utils).

% Project(id, name, description, owner)
:- dynamic project/4, projectUser/2, request/2, nextProjectId/1.

nextProjectId(1).

createDirectory(Directory):- exists_directory(Directory) -> true; make_directory(Directory).

saveAllProjectData():-
    saveProjectsToFile,
    saveProjectUsers,
    saveRequests.

saveProjectsToFile():-
    constants:data_folder_path(FolderPath),
    createDirectory(FolderPath),
    constants:projects_file_path(ProjectsFilePath),
    open(ProjectsFilePath, write, Stream),   
    forall(project(Id, Name, Desc, Owner),(
    writeln(Stream, Id), writeln(Stream, Name), writeln(Stream, Desc), writeln(Stream, Owner))),
    close(Stream).

saveProjectUsers():-
    constants:data_folder_path(FolderPath),
    createDirectory(FolderPath),
    constants:project_users_file_path(ProjectUsersFilePath),
    open(ProjectUsersFilePath, write, Stream),   
    forall(projectUser(Id, User),(
    writeln(Stream, Id), writeln(Stream, User))),
    close(Stream).

saveRequests():-
    constants:data_folder_path(FolderPath),
    createDirectory(FolderPath),
    constants:requests_file_path(RequestsFilePath),
    open(RequestsFilePath, write, Stream),
    forall(request(Id, User),(
    writeln(Stream, Id), writeln(Stream, User))),
    close(Stream).

loadAllProjectData():-
    readProjectsFromFile,
    readProjectUsersFromFile,
    readRequestsFromFile.

readProjectsFromFile():-
    constants:projects_file_path(ProjectsFilePath),
    exists_file(ProjectsFilePath) ->(
    open(ProjectsFilePath, read, Stream),
    readProject(Stream),
    close(Stream),
    nextProjectId(MaxId),
    NewMaxId is MaxId + 1,
    defineNextProjectId(NewMaxId));
    true.

readProjectUsersFromFile():-
    constants:project_users_file_path(ProjectUsersFilePath),
    exists_file(ProjectUsersFilePath) ->(
    open(ProjectUsersFilePath, read, Stream),
    readProjectUser(Stream),
    close(Stream));
    true.

readRequestsFromFile():-
    constants:requests_file_path(RequestsFilePath),
    exists_file(RequestsFilePath) ->(
    open(RequestsFilePath, read, Stream),
    readRequest(Stream),
    close(Stream));
    true.

readProject(Stream):- at_end_of_stream(Stream).
readProject(Stream):-
    utils:readLine(Stream, Id),
    utils:readLine(Stream, Name),
    utils:readLine(Stream, Desc),
    utils:readLine(Stream, Owner),
    string_to_atom(Id, AtomId),
    atom_number(AtomId, NumberId),
    string_to_atom(StringName, Name),
    string_to_atom(StringDesc, Desc),
    string_to_atom(StringOwner, Owner),
    assertz(project(NumberId, StringName, StringDesc, StringOwner)),
    defineNextProjectId(NumberId),
    readProject(Stream).

readProjectUser(Stream) :- at_end_of_stream(Stream).
readProjectUser(Stream):-
    utils:readLine(Stream, Id),
    utils:readLine(Stream, User),
    string_to_atom(Id, AtomId),
    atom_number(AtomId, NumberId),
    string_to_atom(StringUser, User),
    assertz(projectUser(NumberId, StringUser)),
    readProjectUser(Stream).

readRequest(Stream):- at_end_of_stream(Stream).
readRequest(Stream):-
    utils:readLine(Stream, Id),
    utils:readLine(Stream, User),
    string_to_atom(Id, AtomId),
    atom_number(AtomId, NumberId),
    string_to_atom(StringUser, User),
    assertz(request(NumberId, StringUser)),
    readRequest(Stream).

defineNextProjectId(NewId):-
    nextProjectId(Id),
    (NewId > Id,
    retract(nextProjectId(_)),
    assertz(nextProjectId(NewId))) ; true.

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

requestAccess(ProjectId, User):- project(ProjectId, _, _, Owner), User == Owner -> writeln("Você é o dono deste projeto!");(
    ((projectUser(ProjectId, User), writeln("Você já possui permissão de acesso à este projeto!"));
    (request(ProjectId, User), writeln("Você já solicitou acesso à este projeto, aguarde a avaliação."));
    assertz(request(ProjectId, User)), writeln("Acesso solicitado com sucesso."))).

printProjectOwnerMenu():-
    constants:project_menu_owner_header(ProjectMenuOwnerHeader),
    utils:printHeaderAndSubtitle(ProjectMenuOwnerHeader),
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

verifyPermissions(Id):-
    (request(Id, _),
    foreach(request(Id, User), ((projectUser(Id, User), writeln("O usuário já possui permissão no projeto."));(
        write("Deseja dar permissão de acesso a "),
        write(User),
        writeln(" ao projeto atual? (S/N)"),
        read_line_to_string(user_input, Response),
        (Response == "S"; Response == "s") -> (
            assertz(projectUser(Id, User)), retract(request(Id, User)),
            write("Solicitação de "), write(User), writeln(" aprovada.")
            ); write("Solicitação de "), write(User), writeln(" negada.")
        )))); writeln("Não existem solicitações para o projeto.").

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
        (retract(projectUser(Id, _)); true),
        (retract(request(Id, _)); true),
        writeln("Projeto removido com sucesso!")
        ); writeln("Projeto não removido.").

selectOptionOwner(Option, Id):- optionOwner(Option, Id),
    saveAllProjectData, (Option == 5; Option == 7;
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(_)).

optionOwner(1, Id):- projectInfo(Id).
optionOwner(2, Id):- editProjectName(Id).
optionOwner(3, Id):- editProjectDesc(Id).
optionOwner(4, Id):- verifyPermissions(Id).
optionOwner(5, Id):- removeProject(Id).
optionOwner(6, Id):- writeln("GERENCIAR SUITES").
optionOwner(_, _):- writeln("Opção inválida!").

selectOptionUser(1, Id):- optionUser(Option, Id),
    writeln("Pressione qualquer tecla para continuar..."),
    get_char(_).

optionUser(1, Id):- writeln("GERENCIAR SUITES").
optionUser(_, _):- writeln("Opção inválida!").    

ownerProjectMenu(Id):-
    printProjectOwnerMenu,
    utils:readNumber(Option),
    ((Option =\= 7, selectOptionOwner(Option, Id), (Option == 5; ownerProjectMenu(Id))); true).

userProjectMenu(Id):-
    printProjectUserMenu,
    utils:readNumber(Option),
    ((Option =\= 2, selectOptionUser(Option, Id), userProjectMenu(Id)); true).

projectMenu(LoggedUser, Id):-
    (project(Id, _, _, LoggedUser), ownerProjectMenu(Id)); (projectUser(Id, LoggedUser), userProjectMenu(Id));
    (accessPermission(LoggedUser, Id); writeln("Você não possui permissão para acessar este projeto.")).

accessPermission(LoggedUser, Id):- project(Id, _, _, LoggedUser), projectUser(Id, LoggedUser).