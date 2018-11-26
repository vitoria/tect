:- module(testSuite, [suiteMenu/1]).

:- use_module("Constants").

isOptionValidSuit(1).
isOptionValidSuit(2).
isOptionValidSuit(3).
isOptionValidSuit(4).
isOptionValidSuit(5).
isOptionValidSuit(6).
isOptionValidSuit(7).

/*Suite (id, nome, descrição, idProjeto)  */
:- dynamic(suite/4).

suite(1, nome1, desc1, 1).
suite(2, nome2, desc2, 1).
suite(3, nome3, desc3, 2).
suite(4, nome4, desc4, 2).
suite(5, nome5, desc5, 2).


createSuite(ID, Nome, Descricao, Projeto):- 
    !,
    writeln("Id:"),    
    read(ID), 
    writeln("Nome: "),
    read(Nome), 
    writeln("Descrição: "),
    read(Descricao), 
    asserta(suite(ID, Nome, Descricao, Projeto)).

showSuiteMenu:- 
    constants:suite_menu(X),
    writeln(X).

listSuite(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:suite_list_header(L),
                    writeln(L),
                    writeln(" "),
                    constants:table_header(T),
                    writeln(T),
                    writeln(" "),
                    suite(Id, Nome, _, Projeto), 
                    write("      "), write(Id), write(" - "), 
                    write("     "), writeln(Nome), fail.

searchSuite(Projeto):- tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:search_suite_header(X),
                    writeln(X),
                    writeln("Selecione o parâmetro de pesquisa:\n(1) ID\n(2) Nome da Suite\n"),
                    read(Option),
                    ((Option =:= 1 -> (searchSuiteId(Projeto)));
                    (Option =:= 2 -> (searchSuiteNome(Projeto)))).

showSuite(Id, Nome, Descricao, Projeto):- tty_clear,
                    constants:search_suite_header(X),
                    writeln(X),
                    writeln("Suite encontrada:\n"),
                    write("Suite ID "), writeln(Id),
                    write("Nome: "), writeln(Nome),
                    write("Descrição: "), writeln(Descricao),
                    write("ID Projeto da Suite: "), writeln(Projeto).

searchSuiteId(Projeto):- tty_clear,
                    writeln("Informe o ID da Suite:"),
                    read(Id),
                    (suite(Id, Nome, Descricao, Projeto),
                    showSuite(Id, Nome, Descricao, Projeto), !);
                    tty_clear,
                    writeln("A suite com o ID informado não foi encontrada.").

searchSuiteNome(Projeto):- tty_clear,
                    writeln("Informe o Nome da Suite:"),
                    read(Nome),
                    (suite(Id, Nome, Descricao, Projeto),
                    showSuite(Id, Nome, Descricao, Projeto), !);
                    tty_clear,
                    writeln("A suite com o nome informado não foi encontrada.").

                    

choose_action(Option, Projeto):-
    (Option =:= 1 -> (createSuite(_, _, _, Projeto)));
    (Option =:= 2 -> (listSuite(Projeto)));
    (Option =:= 3 -> (searchSuite(Projeto)));
    (Option =:= 4 -> (editSuite(Projeto)));
    (Option =:= 5 -> (deleteSuite(Projeto)));
    (Option =:= 6 -> (caseTestMenu(Projeto)));
    (Option =:= 7 -> (goBack)).
    

suiteMenu(Projeto):-
    tty_clear,
    showSuiteMenu,
    writeln("Informe a opção desejada: "),
    read(Option),
    isOptionValidSuit(Option),
    choose_action(Option, Projeto).

