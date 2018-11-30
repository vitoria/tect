:- module(project, [projectMenu/2]).

:- use_module(constants).
:- use_module(utils).
:- use_module(model).

createProject(LoggedUser):-
    constants:create_project_header(CreateProjectHeader),
    utils:printHeaderAndSubtitle(CreateProjectHeader),
    model:projectModel:nextProjectId(Id),
    writeln("Nome do projeto:"),
    read_line_to_string(user_input, Name),
    writeln("Descrição do projeto:"),
    read_line_to_string(user_input, Description),
    assertz(model:projectModel:project(Id, Name, Description, LoggedUser)),
    NewId is Id + 1,
    model:projectModel:defineNextProjectId(NewId),
    writeln("Projeto criado com sucesso!").

listProject():-
    constants:list_project_header(ListProjectHeader),
    utils:printHeaderAndSubtitle(ListProjectHeader),
    writef('%2l | %25l | %15l\n' , ["ID", "Nome", "Dono"]),
    model:projectModel:project(Id, Name, _, Owner),
    writef('%3c | %25l | %15l\n', [Id, Name, Owner]),
    fail; true.

requestAccess(ProjectId, User):-
    model:projectModel:project(ProjectId, _, _, Owner),
    User == Owner -> writeln("Você é o dono deste projeto!");(
    ((model:projectModel:projectUser(ProjectId, User), writeln("Você já possui permissão de acesso à este projeto!"));
    (model:projectModel:request(ProjectId, User), writeln("Você já solicitou acesso à este projeto, aguarde a avaliação."));
    assertz(model:projectModel:request(ProjectId, User)), writeln("Acesso solicitado com sucesso."))).

printProjectOwnerMenu():-
    constants:project_menu_header(ProjectMenuHeader),
    utils:printHeaderAndSubtitle(ProjectMenuHeader),
    constants:project_menu_owner(ProjectMenuOwner),
    writeln(ProjectMenuOwner).

printProjectUserMenu():-
    constants:project_menu_header(ProjectMenuHeader),
    utils:printHeaderAndSubtitle(ProjectMenuHeader),
    constants:project_menu_user(ProjectMenuUser),
    writeln(ProjectMenuUser).

projectInfo(Id):-
    constants:project_detais_header(ProjectDetailsHeader),
    utils:printHeaderAndSubtitle(ProjectDetailsHeader),
    model:projectModel:project(Id, Name, Desc, Owner),
    write("ID: "),
    writeln(Id),
    write("Nome do Projeto: "),
    writeln(Name),
    write("Descrição: "),
    writeln(Desc),
    write("Proprietário: "),
    writeln(Owner).

editProjectName(Id):-
    constants:edit_project_header(EditProjectHeader),
    utils:printHeaderAndSubtitle(EditProjectHeader),
    model:projectModel:project(Id, Name, Desc, Owner),
    write("Nome anterior: "),
    writeln(Name),
    writeln("Informe o novo Nome: "),
    read_line_to_string(user_input, NewName),
    retract(model:projectModel:project(Id, Name, Desc, Owner)),
    assertz(model:projectModel:project(Id, NewName, Desc, Owner)),
    writeln("Projeto editado com sucesso!").

editProjectDesc(Id):-
    constants:edit_project_header(EditProjectHeader),
    utils:printHeaderAndSubtitle(EditProjectHeader),
    model:projectModel:project(Id, Name, Desc, Owner),
    write("Descrição anterior: "),
    writeln(Desc),
    writeln("Informe a nova Descrição: "),
    read_line_to_string(user_input, NewDesc),
    retract(model:projectModel:project(Id, Name, Desc, Owner)),
    assertz(model:projectModel:project(Id, Name, NewDesc, Owner)),
    writeln("Projeto editado com sucesso!").

verifyPermissions(Id):-
    constants:project_permissions_header(PermissionsHeader),
    utils:printHeaderAndSubtitle(PermissionsHeader),
    (model:projectModel:request(Id, _),
    foreach(model:projectModel:request(Id, User), ((model:projectModel:projectUser(Id, User), writeln("O usuário já possui permissão no projeto."));(
        write("Deseja dar permissão de acesso a "),
        write(User),
        writeln(" ao projeto atual? (S/N)"),
        read_line_to_string(user_input, Response),
        (Response == "S"; Response == "s") -> (
            assertz(model:projectModel:projectUser(Id, User)), retract(model:projectModel:request(Id, User)),
            write("Solicitação de "), write(User), writeln(" aprovada.")
            ); write("Solicitação de "), write(User), writeln(" negada."), retract(model:projectModel:request(Id, User))
        )))); writeln("Não existem solicitações para o projeto.").

removeProject(Id):-
    constants:remove_project_header(RemoveProjectHeader),
    utils:printHeaderAndSubtitle(RemoveProjectHeader),
    writeln("Realmente deseja remover o projeto atual? (S/N)"),
    read_line_to_string(user_input, Response),
    (Response == "S"; Response == "s") -> (
        retract(model:projectModel:project(Id, _, _, _)),
        (retract(model:projectModel:projectUser(Id, _)); true),
        (retract(model:projectModel:request(Id, _)); true),
        writeln("Projeto removido com sucesso!")
        ); writeln("Projeto não removido.").

selectOptionOwner(Option, Id):- optionOwner(Option, Id),
    model:projectModel:saveAllProjectData, (Option == 5; Option == 7;
    utils:systemPause).

optionOwner(1, Id):- projectInfo(Id).
optionOwner(2, Id):- editProjectName(Id).
optionOwner(3, Id):- editProjectDesc(Id).
optionOwner(4, Id):- verifyPermissions(Id).
optionOwner(5, Id):- removeProject(Id).
optionOwner(6, Id):- writeln(Id), writeln("GERENCIAR SUITES").
optionOwner(_, _):- writeln("Opção inválida!").

selectOptionUser(1, Id):- optionUser(Option, Id), writeln(Option),
    utils:systemPause.

optionUser(1, Id):- writeln(Id), writeln("GERENCIAR SUITES").
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
    (model:projectModel:project(Id, _, _, LoggedUser), ownerProjectMenu(Id)); (model:projectModel:projectUser(Id, LoggedUser), userProjectMenu(Id));
    (accessPermission(LoggedUser, Id); writeln("Você não possui permissão para acessar este projeto.")).

accessPermission(LoggedUser, Id):- model:projectModel:project(Id, _, _, LoggedUser), model:projectModel:projectUser(Id, LoggedUser).