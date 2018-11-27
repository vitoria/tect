:- module(project, [projectMenu/1]).

:- use_module("Constants").

% Project(id, name, description, owner)
:- dynamic project/4.
:- dynamic projectUsers/2.
:- dynamic requests/2.

readNumber(Number):- read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).

createProject(LoggedUser):-
    constants:header(Header),
    writeln(Header),
    constants:create_project_header(CreateProjectHeader),
    writeln(CreateProjectHeader),
    writeln("ID"),
    readNumber(Id),
    writeln("Nome do projeto:"),
    read_line_to_string(user_input, Name),
    writeln("Descrição do projeto:"),
    read_line_to_string(user_input, Description),
    assertz(project(Id, Name, Description, LoggedUser)).

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

projectMenu(LoggedUser):- writeln("Projeto").
