:- module(projectModel, []).

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