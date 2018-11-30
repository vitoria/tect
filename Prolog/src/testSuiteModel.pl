:- module(testSuiteModel, []).

:- use_module(model).
:- use_module(utils).
:- use_module(constants).

/*Suite (id, nome, descrição, idProjeto)  */
:- dynamic(suite/4).

loadSuites():- readSuiteFromFile.


saveTestSuite():- utils:createDirectory('data'),
                    open('data/test_suite.dat', write, InStream),
                    forall(suite(Id, Nome, Descricao, Projeto), 
                    (writeln(InStream, Id),
                    writeln(InStream, Nome),
                    writeln(InStream, Descricao),
                    writeln(InStream, Projeto))),
                    close(InStream).

readSuiteFromFile():-
                    exists_file('data/test_suite.dat') ->(
                    open('data/test_suite.dat', read, InStream),
                    readSuite(InStream),
                    close(InStream));
                    true.

readSuite(InStream):- at_end_of_stream(InStream).
readSuite(InStream):- utils:readLine(InStream, Id),
                    utils:readLine(InStream, Nome),
                    utils:readLine(InStream, Descricao),
                    utils:readLine(InStream, Projeto),
                    string_to_atom(Id, AtomId),
                    atom_number(AtomId, NumberId),
                    string_to_atom(Projeto, AtomProjeto),
                    atom_number(AtomProjeto, NumberProjeto),
                    assertz(suite(NumberId, Nome, Descricao, NumberProjeto)),
                    readSuite(InStream).
