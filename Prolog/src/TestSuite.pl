:- module(testSuite, [suiteMenu/1]).

:- use_module("Constants").

isOptionValidSuit("1").
isOptionValidSuit("2").
isOptionValidSuit("3").
isOptionValidSuit("4").
isOptionValidSuit("5").
isOptionValidSuit("6").
isOptionValidSuit("7").
searchSuiteOption(1).
searchSuiteOption(2).

/*Suite (id, nome, descrição, idProjeto)  */
:- dynamic(suite/4).

readInt(Number) :-
                    read_line_to_codes(user_input, Codes),
                    string_to_atom(Codes, Atom),
                    atom_number(Atom, Number).

factToList(Projeto, X):- findall(I, suite(I, _, _, Projeto), X).

headerCreate:- 
                    tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:create_suite_header(C),
                    writeln(C),
                    writeln(" ").

verifyId(Projeto, Id):-
                    writeln("Id:"),    
                    readInt(ReadId),
                    ((suite(ReadId, _, _, Projeto), 
                    writeln("Id já cadastrado, por favor informe outro."),
                    verifyId(Projeto, Id));
                    Id = ReadId).

createSuite(Id, Nome, Descricao, Projeto):- 
                    headerCreate,
                    verifyId(Projeto, Id), 
                    writeln("Nome: "),
                    read_line_to_string(user_input,Nome), 
                    writeln("Descrição: "),
                    read_line_to_string(user_input, Descricao), 
                    assertz(suite(Id, Nome, Descricao, Projeto)),
                    saveTestSuite,
                    writeln("Suite criada com sucesso"),
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
                    readInt(Id),
                    ((suite(Id, Nome, Descricao, Projeto),
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
                    ((suite(Id, Nome, Descricao, Projeto),
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
                    readInt(Id),
                    ((suite(Id, Nome, Descricao, Projeto),
                    tty_clear,
                    constants:edit_suite_header(X),
                    writeln(X),
                    writeln("Dados atuais da Suite:"), showSuite(Id, Nome, Descricao, Projeto),
                    writeln(" "),
                    writeln("Informe o novo Nome da Suite: "),
                    read_line_to_string(user_input, NewNome),
                    writeln("Informe a nova descricão da Suite: "),
                    read_line_to_string(user_input, NewDescricao),
                    retract(suite(Id, Nome, Descricao, Projeto)),
                    assertz(suite(Id, NewNome, NewDescricao, Projeto)),
                    saveTestSuite,
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
                    readInt(Id),
                    ((retract(suite(Id, _, _, Projeto)),
                    writeln("Suite deletada com sucesso."),
                    saveTestSuite,
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
                    readInt(SuiteId),
                    writeln(" "),
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
                    readSuiteFromFile,
                    writeln("Informe a opção desejada: "),
                    read_line_to_string(user_input, Option),
                    (isOptionValidSuit(Option),
                    choose_action(Option, Projeto));
                    (tty_clear,
                    constants:header(H),
                    writeln(H),
                    constants:invalid_option(X),
                    writeln(" "),
                    writeln(X),
                    writeln(" "),
                    writeln("Pressione enter para voltar para o Menu de Suite..."),
                    read_line_to_string(user_input, _),
                    suiteMenu(Projeto)).

createDirectory(Directory):- exists_directory(Directory) -> true; make_directory(Directory).

saveTestSuite():- createDirectory('data'),
                    open('data/test_suite.dat', write, Stream),
                    forall(suite(Id, Nome, Descricao, Projeto), 
                    (writeln(Stream, Id),writeln(Stream, Nome),writeln(Stream, Descricao),writeln(Stream, Projeto))),
                    close(Stream).

readSuiteFromFile():-
                    exists_file('data/test_suite.dat') ->(
                    open('data/test_suite.dat', read, Stream),
                    readSuite(Stream),
                    close(Stream));
                    true.

readSuite(Stream):- at_end_of_stream(Stream).
readSuite(Stream):- readLine(Stream, Id),
                    readLine(Strem, Nome),
                    readLine(Strem, Descricao),
                    readLine(Strem, Projeto),
                    string_to_atom(Id, AtomId),
                    atom_number(AtomId, NumberId),
                    string_to_atom(Projeto, AtomProjeto),
                    atom_number(AtomProjeto, NumberProjeto),
                    assertz(suite(NumberId, Nome, Descricao, NumberProjeto)),
                    readSuite(Stream).
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
