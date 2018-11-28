:- module(testSuite, [suiteMenu/1]).

:- use_module("Constants").

isOptionValidSuit("1").
isOptionValidSuit("2").
isOptionValidSuit("3").
isOptionValidSuit("4").
isOptionValidSuit("5").
isOptionValidSuit("6").
isOptionValidSuit("7").

/*Suite (id, nome, descrição, idProjeto)  */
:- dynamic(suite/4).

suite(1, "nome1", "desc1", 1).
suite(2, "nome2", "desc2", 1).
suite(3, "nome3", "desc3", 2).
suite(4, "nome4", "desc4", 2).
suite(5, "nome5", "desc5", 2).

readInt(Number) :-
                    read_line_to_codes(user_input, Codes),
                    string_to_atom(Codes, Atom),
                    atom_number(Atom, Number).

factToList(Projeto, X):- findall(I, suite(I, _, _, Projeto), X).


verify(Projeto):- factToList(Projeto, X),
                    writeln(X).

headerCreate:- 
                    tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:create_suite_header(C),
                    writeln(C),
                    writeln(" ").


createSuite(ID, Nome, Descricao, Projeto):- 
                    headerCreate,
                    writeln("Id:"),    
                    readInt(ID), 
                    writeln("Nome: "),
                    read_line_to_string(user_input,Nome), 
                    writeln("Descrição: "),
                    read_line_to_string(user_input, Descricao), 
                    assertz(suite(ID, Nome, Descricao, Projeto)),
                    suiteMenu(Projeto).

showSuiteMenu:- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:suite_menu_header(S),
                    writeln(S),
                    constants:suite_menu(X),
                    writeln(X),
                    writeln(" ").

listSuiteAux(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:suite_list_header(L),
                    writeln(L),
                    writeln(" "),
                    constants:line(U),
                    writeln(U),
                    constants:table_header(T),
                    writeln(T),
                    writeln(U),
                    suite(Id, Nome, _, Projeto), 
                    write("-"), write("      "), write(Id), 
                    write("     | "), writeln(Nome), fail.

listSuite(Projeto):- (listSuiteAux(Projeto); true),
                    constants:line(U),
                    writeln(U),
                    writeln(" "),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto).
                    
                    

searchSuite(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:search_suite_header(X),
                    writeln(X),
                    writeln("Selecione o parâmetro de pesquisa:\n(1) ID\n(2) Nome da Suite\n"),
                    readInt(Option),
                    ((Option =:= 1 -> (searchSuiteId(Projeto)));
                    (Option =:= 2 -> (searchSuiteNome(Projeto)))).

showSuite(Id, Nome, Descricao, Projeto):-
                    tty_clear,
                    constants:header(H),
                    writeln(H), 
                    constants:suite_details(X),
                    writeln(X),
                    writeln(" "),
                    write("Suite ID "), writeln(Id),
                    write("Nome: "), writeln(Nome),
                    write("Descrição: "), writeln(Descricao),
                    write("ID Projeto da Suite: "), writeln(Projeto).

searchSuiteId(Projeto):- 
                    writeln("Informe o ID da Suite:"),
                    readInt(Id),
                    ((suite(Id, Nome, Descricao, Projeto),
                    showSuite(Id, Nome, Descricao, Projeto), !);
                    tty_clear,
                    writeln("A suite com o ID informado não foi encontrada.")),
                    writeln(" "),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto).

searchSuiteNome(Projeto):- 
                    writeln("Informe o Nome da Suite:"),
                    read_line_to_string(user_input, Nome),
                    ((suite(Id, Nome, Descricao, Projeto),
                    showSuite(Id, Nome, Descricao, Projeto), !);
                    tty_clear,
                    writeln("A suite com o nome informado não foi encontrada.")),
                    writeln(" "),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto).

editSuite(Projeto):-  tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:suite_list_header(L),
                    writeln(L),
                    writeln("Informe o ID da Suite:"),
                    read(Id),
                    suite(Id, Nome, Descricao, Projeto),
                    tty_clear,
                    constants:edit_suite_header(X),
                    writeln(X),
                    writeln("Dados atuais da Suite:"), showSuite(Id, Nome, Descricao, Projeto),
                    writeln(" "),
                    writeln("Informe o novo Nome da Suite: "),
                    read(NewNome),
                    writeln("Informe a nova descricão da Suite: "),
                    read(NewDescricao),
                    retract(suite(Id, Nome, Descricao, Projeto)),
                    assertz(suite(Id, NewNome, NewDescricao, Projeto)),
                    writeln("Suite editada com sucesso.").
                
deleteSuite(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:delete_suite_header(L),
                    writeln(L),
                    writeln("Informe o ID da Suite a ser deletada:"),
                    read(Id),
                    retract(suite(Id, _, _, Projeto)).

caseTestMenu(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:manage_test_suite(L),
                    writeln(L),
                    writeln("Informe o ID da suite a ser gerenciada:"),
                    read(SuiteId),
                    write("O id da suite a ser chamada é: "), write(SuiteId),
                    write(" e o id do projeto é "), writeln(Projeto),
                    writeln("CHAMAR O MÉTODO AQUI DO MENU DO CASO DE TESTE").

goBack():- writeln("Retornar para o menu anterior").

choose_action(Option, Projeto):-
                    (Option =:= "1" -> (createSuite(_, _, _, Projeto)));
                    (Option =:= "2" -> (listSuite(Projeto)));
                    (Option =:= "3" -> (searchSuite(Projeto)));
                    (Option =:= "4" -> (editSuite(Projeto)));
                    (Option =:= "5" -> (deleteSuite(Projeto)));
                    (Option =:= "6" -> (caseTestMenu(Projeto)));
                    (Option =:= "7" -> (goBack)).
    

suiteMenu(Projeto):-
                    showSuiteMenu,
                    writeln("Informe a opção desejada: "),
                    read_line_to_string(user_input, Option),
                    isOptionValidSuit(Option),
                    choose_action(Option, Projeto).

