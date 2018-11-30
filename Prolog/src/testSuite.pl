:- module(testSuite, []).

:- use_module(constants).
:- use_module(utils).
:- use_module(model).
:- use_module(project).
:- use_module(testCase).

factToList(Projeto, X):- findall(I, model:testSuiteModel:suite(I, _, _, Projeto), X).

headerCreate:- 
                    tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:create_suite_header(C),
                    writeln(C),
                    writeln(" ").

verifyId(Projeto, Id):-
                    (model:testSuiteModel:nextId(Id, Projeto);
                    Id is 1),
                    NextId is Id+1, 
                    (retract(model:testSuiteModel:nextId(_, Projeto)); true),
                    assertz(model:testSuiteModel:nextId(NextId, Projeto)),
                    testSuiteModel:saveNextId.

createSuite(Projeto):- 
                    headerCreate,
                    verifyId(Projeto, Id), 
                    writeln("Nome: "),
                    read_line_to_string(user_input,Nome), 
                    writeln("Descrição: "),
                    read_line_to_string(user_input, Descricao), 
                    assertz(testSuiteModel:suite(Id, Nome, Descricao, Projeto)),
                    writeln("Suite criada com sucesso"),
                    testSuiteModel:saveTestSuite,
                    writeln(" "),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
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
                    model:testSuiteModel:suite(Id, Nome, _, Projeto), 
                    write("-"), write("      "), write(Id), 
                    write("     | "), writeln(Nome), fail.

listSuite(Projeto):- (listSuiteAux(Projeto); true),
                    constants:line(U),
                    writeln(U),
                    writeln(" "),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto).
                    

searchSuiteOption(1).
searchSuiteOption(2).

searchSuite(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:search_suite_header(X),
                    writeln(X),
                    writeln("Selecione o parâmetro de pesquisa:\n(1) ID\n(2) Nome da Suite\n"),
                    utils:readNumber(Option),
                    (searchSuiteOption(Option),
                    ((Option =:= 1 -> (searchSuiteId(Projeto)));
                    (Option =:= 2 -> (searchSuiteNome(Projeto)))));
                    (constants:invalid_option(X),
                    writeln(X),
                    writeln("Pressione enter para voltar para o Menu de Suite..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto)).

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
                    utils:readNumber(Id),
                    ((model:testSuiteModel:suite(Id, Nome, Descricao, Projeto),
                    showSuite(Id, Nome, Descricao, Projeto), !);
                    writeln(" "),
                    writeln("A suite com o ID informado não foi encontrada.")),
                    writeln(" "),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto).

searchSuiteNome(Projeto):- 
                    writeln("Informe o Nome da Suite:"),
                    read_line_to_string(user_input, Nome),
                    ((model:testSuiteModel:suite(Id, Nome, Descricao, Projeto),
                    showSuite(Id, Nome, Descricao, Projeto), !);
                    writeln(" "), 
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
                    utils:readNumber(Id),
                    ((model:testSuiteModel:suite(Id, Nome, Descricao, Projeto),
                    tty_clear,
                    constants:edit_suite_header(X),
                    writeln(X),
                    writeln("Dados atuais da Suite:"), showSuite(Id, Nome, Descricao, Projeto),
                    writeln(" "),
                    writeln("Informe o novo Nome da Suite: "),
                    read_line_to_string(user_input, NewNome),
                    writeln("Informe a nova descricão da Suite: "),
                    read_line_to_string(user_input, NewDescricao),
                    retract(model:testSuiteModel:suite(Id, Nome, Descricao, Projeto)),
                    assertz(model:testSuiteModel:suite(Id, NewNome, NewDescricao, Projeto)),
                    testSuiteModel:saveTestSuite,
                    writeln("Suite editada com sucesso."));
                    (writeln("A suite com o id informado não foi encontrada."))),
                    writeln(" "),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto).
                
deleteSuite(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:delete_suite_header(L),
                    writeln(L),
                    writeln("Informe o ID da Suite a ser deletada:"),
                    utils:readNumber(Id),
                    ((retract(model:testSuiteModel:suite(Id, _, _, Projeto)),
                    testSuiteModel:saveTestSuite,
                    writeln("Suite deletada com sucesso."),
                    writeln(" "));
                    (writeln("Suite não encontrada."),
                    writeln(" "))),
                    writeln("Pressione enter para continuar..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto).

caseTestMenu(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:manage_test_suite(L),
                    writeln(L),
                    writeln("Informe o ID da suite a ser gerenciada:"),
                    utils:readNumber(SuiteId),
                    ((model:testSuiteModel:suite(SuiteId, _, _, Projeto),
                    writeln(" "),
                    testCase:testCaseMenu(Projeto, SuiteId));
                    (constants:suite_not_found(Nf),
                    utils:showPausedMsg(Nf))),
                    suiteMenu(Projeto).

choose_action(1, Projeto):- createSuite(Projeto).
choose_action(2, Projeto):- listSuite(Projeto).
choose_action(3, Projeto):- searchSuite(Projeto).
choose_action(4, Projeto):- editSuite(Projeto).
choose_action(5, Projeto):- deleteSuite(Projeto).
choose_action(6, Projeto):- caseTestMenu(Projeto).
choose_action(7, _):- true.
choose_action(_, Projeto):- tty_clear,
                        constants:header(H),
                        writeln(H),
                        constants:invalid_option(X),
                        utils:showPausedMsg(X),
                        suiteMenu(Projeto).


suiteMenu(Projeto):-
                    showSuiteMenu,
                    utils:readOption(Option),
                    choose_action(Option, Projeto).
