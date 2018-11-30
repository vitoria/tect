:- module(testCases, [suiteMenu/2]).

:- use_module(constants).
:- use_module(utils).
/*testCase(projectId, suiteId, caseId, name, goals, status, preconditions).
step(stepId, caseId, details, expectedResult).
*/
:- dynamic testCase/7.
:- dynamic step/4.

:-initialization(main).

main:-
    loadAllTestCasesData,
    writeln('Digite o id do projeto:'),
    readNumber(ProjectId),
    writeln('Digite o id da suite de testes: '),
    readNumber(SuiteId),
    suiteMenu(ProjectId, SuiteId).

nextCaseId(1).

readNumber(Number):- read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).

createDirectory(Directory):- exists_directory(Directory) -> true; make_directory(Directory).

saveAllTestCasesData():-
    saveTestCasesToFile(),
    saveSteps().

saveTestCasesToFile():-
    createDirectory('data'),
    open('data/testCases.dat', write, Stream),   
    forall(testCase(ProjectId, SuiteId, CaseId, Name, Goals, Status, Preconditions),(
    writeln(Stream, ProjectId), writeln(Stream, SuiteId), writeln(Stream, CaseId), writeln(Stream, Name), writeln(Stream, Goals), writeln(Stream, Status), writeln(Stream, Preconditions))),
    close(Stream).

saveSteps():-
    createDirectory('data'),
    open('data/steps.dat', write, Stream),   
    forall(step(StepId, CaseId, Details, ExpectedResult),(
    writeln(Stream, StepId), writeln(Stream, CaseId), writeln(Stream, Details), writeln(Stream, ExpectedResult))),
    close(Stream).

loadAllTestCasesData():-
    readTestCasesFromFile,
    readStepsFromFile.

readTestCasesFromFile():-
    exists_file('data/testCases.dat') ->(
    open('data/testCases.dat', read, Stream),
    readTestCase(Stream),
    close(Stream));
    true.

readStepsFromFile():-
    exists_file('data/steps.dat') ->(
    open('data/steps.dat', read, Stream),
    readSteps(Stream),
    close(Stream));
    true.

readSteps(Stream):- at_end_of_stream(Stream).
readSteps(Stream):-
    utils:readLine(Stream, StepId),
    utils:readLine(Stream, CaseId),
    utils:readLine(Stream, Details),
    utils:readLine(Stream, ExpectedResult),
    string_to_atom(StepId, AtomId1),
    atom_number(AtomId1, StepNumberId),
    string_to_atom(CaseId, AtomId2),
    atom_number(AtomId2, CaseNumberId),
    string_to_atom(StringDetails, Details),
    string_to_atom(StringExpectedResult, ExpectedResult),
    assertz(step(StepNumberId, CaseNumberId, StringDetails, StringExpectedResult)),
    readSteps(Stream).
    

readTestCase(Stream):- at_end_of_stream(Stream).
readTestCase(Stream):-
    utils:readLine(Stream, ProjectId),
    utils:readLine(Stream, SuiteId),
    utils:readLine(Stream, CaseId),
    utils:readLine(Stream, Name),
    utils:readLine(Stream, Goals),
    utils:readLine(Stream, Status),
    utils:readLine(Stream, Preconditions),
    string_to_atom(ProjectId, AtomId1),
    atom_number(AtomId1, ProjectNumberId),
    string_to_atom(SuiteId, AtomId2),
    atom_number(AtomId2, SuiteNumberId),
    string_to_atom(CaseId, AtomId3),
    atom_number(AtomId3, CaseNumberId),
    string_to_atom(StringName, Name),
    string_to_atom(StringGoals, Goals),
    string_to_atom(StringStatus, Status),
    string_to_atom(StringPreconditions, Preconditions),
    assertz(testCase(ProjectNumberId, SuiteNumberId, CaseNumberId, StringName, StringGoals, StringStatus, StringPreconditions)),
    readTestCase(Stream).

stepCount(0).

executed('Passou').
executed('Nao passou').
executed('Erro na execucao').

pass('Passou').

printSuiteMenu():- 
    utils:printHeader(),
    constants: edit_suite_header(EditSuiteHeader),
    writeln(EditSuiteHeader),
    constants: test_Case_Menu(TestMenu),
    writeln(TestMenu).

suiteMenu(ProjectId, SuiteId) :-
    printSuiteMenu,
    readNumber(Option),
    selectOptionTestCase(Option, ProjectId, SuiteId).

selectOptionTestCase(Option, ProjectId, SuiteId):-
    constants:test_case_header(CaseHeader),
    ((Option == 1 -> createTestCase(ProjectId, SuiteId);
    Option == 2 -> writeln(CaseHeader), listTestCases(ProjectId, SuiteId, 1);
    Option == 3 -> searchTestCase(ProjectId, SuiteId);
    Option == 4 -> editTestCase(ProjectId, SuiteId);
    Option == 5 -> deleteTestCase(ProjectId, SuiteId);
    Option == 6 -> write('Voltar para o menu de suites');
    writeln('Opcao invalida!')),
    writeln('Pressione qualquer tecla para continuar...'),
    get_char(_)),
    suiteMenu(ProjectId, SuiteId).

createTestCase(ProjectId, SuiteId):-
    constants:create_case_header(CaseHeader),
    utils:printHeaderAndSubtitle(CaseHeader),
    getNumberOfTestCases(NumberOfCases),
    NewNumberOfCases is NumberOfCases + 1,
    createCase(ProjectId, SuiteId, NewNumberOfCases).

getNumberOfTestCases(Count) :- 
    aggregate_all(count, testCase(_, _, _, _, _, _, _), Count).

createCase(ProjectId, SuiteId, CaseId) :-
    constants:name_const(NameConst),
    constants:goal(GoalConst),
    constants:preconditions(PreConst),
    constants:case_steps_reading_header(Steps),
    writeln(NameConst),
    read_line_to_string(user_input, Name), nl,
    writeln(GoalConst),
    read_line_to_string(user_input, Goal), nl,
    writeln(PreConst),
    read_line_to_string(user_input, Preconditions), nl,
    assertz(testCase(ProjectId, SuiteId, CaseId, Name, Goal, 'Nao executado',  Preconditions)),
    writeln(Steps),
    stepCount(StepId),
    continueSteps(ProjectId, SuiteId, CaseId, StepId).

continueSteps(ProjectId, SuiteId, CaseId, StepId) :-
    writeln(CaseId),
    constants:case_step_description(CaseDesc),
    constants:case_step_expected_result(CaseResult),
    constants:case_step_continue_message(CaseContinueMsg),
    NewStepId is StepId + 1,
    writeln(CaseDesc),
    read_line_to_string(user_input, Description), 
    writeln(CaseResult),
    read_line_to_string(user_input, ExpectedResult),
    assertz(step(NewStepId, CaseId, Description, ExpectedResult)),
    writeln('Deseja inserir outro passo ((1)Sim, (2)Não)?'),
    readNumber(Option),
    ((Option == 1) -> continueSteps(ProjectId, SuiteId, CaseId, NewStepId);
    (Option == 2) -> writeln('Pressione qualquer tecla para continuar...'), get_char(_), saveAllTestCasesData(), suiteMenu(ProjectId, SuiteId);
    writeln('Opcao invalida. Nenhum passo a mais será adicionado. Redirecionando para o menu da suite de testes...'),
    saveAllTestCasesData(),
    writeln('Pressione qualquer tecla para continuar...'),
    get_char(_),
    suiteMenu(ProjectId, SuiteId)).

listTestCases(ProjectId, SuiteId, CurrentCase) :-
    constants:test_case_header(CaseHeader),
    utils:printHeaderAndSubtitle(CaseHeader),
    getNumberOfTestCases(NumberOfCases),
    NewNumberOfCases is NumberOfCases + 1,
    ((CurrentCase < NewNumberOfCases) ->
        listCase(ProjectId, SuiteId, CurrentCase),
        NewCurrentCase is CurrentCase + 1,
        listTestCases(ProjectId, SuiteId, NewCurrentCase));
    writeln('Pressione qualquer tecla para continuar...'),
    get_char(_),
    suiteMenu(ProjectId, SuiteId).

listCase(ProjectId, SuiteId, CurrentCase) :-
    testCase(ProjectId, SuiteId, CurrentCase, Name, Goals, Status, Preconditions),
    write('Id: '),
    write(CurrentCase), nl,
    write('Nome: '),
    write(Name), nl,
    write('Objetivos: '),
    write(Goals), nl,
    write('Pre-condicoes: '),
    write(Preconditions), nl,
    write('Status: '),
    write(Status), nl.

searchTestCase(ProjectId, SuiteId) :-
    constants:search_case_header(Search),
    utils:printHeaderAndSubtitle(Search),
    writeln('Informe o id do Caso de Teste: '),
    readNumber(CaseId),
    ((validCaseId(CaseId) ->
        listCase(ProjectId, SuiteId, CaseId),
        writeln('Passos:'),
        listSteps(1, CaseId));
    (write('Id nao cadastrado para casos de teste.'), nl)),
    writeln('Pressione qualquer tecla para continuar...'),
    get_char(_),
    suiteMenu(ProjectId, SuiteId).

getNumberOfSteps(Count):-
    aggregate_all(count, step(_,_,_,_), Count).

listSteps(StepId, CaseId):-
    getNumberOfSteps(StepsCount),
    NewStepsCount is StepsCount + 1,
    ((NewStepsCount > StepId) ->
    step(StepId, CaseId, Details, ExpectedResult),
    write('Passo '), writeln(StepId),
    write('Descricao: '), writeln(Details),
    write('Resultado esperado: '), writeln(ExpectedResult),
    NextStepId is StepId + 1,
    listSteps(NextStepId, CaseId));
    write('').

validCaseId(Id) :-
    getNumberOfTestCases(NumberOfCases),
    NewNumberOfCases is NumberOfCases + 1,
    Id < NewNumberOfCases.

editTestCase(ProjectId, SuiteId) :-
    constants:edit_case_header(CaseHeader),
    utils:printHeaderAndSubtitle(CaseHeader),
    writeln('Informe o id do Caso de Teste: '),
    readNumber(CaseId), nl,
    (validCaseId(CaseId) -> menuEditCase(ProjectId, SuiteId, CaseId));
    (writeln('Id nao cadastrado para casos de teste.'),
    writeln('Pressione qualquer tecla para continuar...'),
    get_char(_),
    suiteMenu(ProjectId, SuiteId)).

overwriteCase(ProjectId, SuiteId, CaseId):-
    testCase(ProjectId, SuiteId, CaseId, Name, Goal, Status, Preconditions),
    retract(testCase(ProjectId, SuiteId, CaseId, Name, Goal, Status, Preconditions)),
    createCase(ProjectId, SuiteId, CaseId).

menuEditCase(ProjectId, SuiteId, CaseId) :-
    writeln(CaseHeader),
    writeln('(1) Editar Dados do Caso de Teste'),
    writeln('(2) Editar Status do Caso de Teste'),
    writeln('(3) Voltar'),
    read_line_to_string(user_input, Selected), nl,
    atom_number(Selected, Option),
    ((Option == 1 -> write('Editando Caso de Testes'), nl,
    writeln('Estado atual'),
    listCase(ProjectId, SuiteId, CaseId), nl,
    writeln('Estado novo'),
    overwriteCase(ProjectId, SuiteId, CaseId),
    listCase(ProjectId, SuiteId, CaseId), nl),
    saveAllTestCasesData();
    (Option == 2 -> menuChangeStatus(ProjectId, SuiteId, CaseId));
    (Option == 3 -> suiteMenu(ProjectId, SuiteId));
    (write(invalid_option), suiteMenu(ProjectId, SuiteId))).

menuChangeStatus(ProjectId, SuiteId, CaseId) :-
    constants:test_case_header(CaseHeader),
    writeln(CaseHeader),
    writeln('- Editando Caso de Testes'),
    writeln('Estado atual'),
    listCase(ProjectId, SuiteId, CaseId), nl,
    writeln('-- Alterar status do Caso de Testes'),
    writeln('(1) Passou'),
    writeln('(2) Nao passou'),
    writeln('(3) Erro na execucao'),
    writeln('(4) Voltar'),
    readNumber(Option),
    (((Option == 1 -> NewStatus = 'Passou');
    (Option == 2 -> NewStatus = 'Nao passou');
    (Option == 3 -> NewStatus = 'Erro na execucao')),
    testCase(ProjectId, SuiteId, CaseId, Name, Goal, OldStatus, Preconditions),
    retract(testCase(ProjectId, SuiteId, CaseId, Name, Goal, OldStatus, Preconditions)),
    assertz(testCase(ProjectId, SuiteId, CaseId, Name, Goal, NewStatus, Preconditions)), saveAllTestCasesData());
    (write('Opcao invalida.'), menuChangeStatus(ProjectId, SuiteId, CaseId)),
    suiteMenu(ProjectId, SuiteId).

deleteTestCase(ProjectId, SuiteId) :-
    constants:delete_case_header(CaseHeader),
    utils:printHeaderAndSubtitle(CaseHeader),
    writeln('Informe o id do caso de teste: '),
    readNumber(CaseId),
    (validCaseId(CaseId) -> listCase(ProjectId, SuiteId, CaseId), write('Tem certeza que deseja excluir esse caso de testes? ((1)Sim/(2)Nao)'), nl,
    readNumber(Option),
    (((Option == 1) -> retract(testCase(ProjetId, SuiteId, CaseId, _, _, _, _)), writeln('Caso de testes excluido com sucesso.'), saveAllTestCasesData());
    (writeln('Caso de testes nao excluido.'))),
    suiteMenu(ProjectId, SuiteId));
    writeln('Id informado nao cadastrado.'),
    writeln('Pressione qualquer tecla para continuar...'),
    get_char(_),
    suiteMenu(ProjectId, SuiteId).

increment(Number, Result):-
    Result is Number + 1.

getNumberOfExecutedTests(ProjectId, SuiteId, CaseId, AuxNumber, Number):-
    getNumberOfTestCases(CasesNumber),
    increment(CasesNumber, NewCasesNumber),
    increment(CaseId, NewCaseId),
    increment(AuxNumber, NewNumber),
    ((NewCasesNumber > CaseId) ->testCase(ProjectId, SuiteId, CaseId, _, _, Status, _),
        (executed(Status) -> getNumberOfExecutedTests(ProjectId, SuiteId, NewCaseId, NewNumber, Number);
    getNumberOfExecutedTests(ProjectId, SuiteId, NewCaseId, AuxNumber, Number)));
    writeln(''),
    Number is AuxNumber.

getNumberOfPassingTests(ProjectId, SuiteId, CaseId, AuxNumber, Number):-
    getNumberOfTestCases(CasesNumber),
    increment(CasesNumber, NewCasesNumber),
    increment(CaseId, NewCaseId),
    increment(AuxNumber, NewNumber),
    ((NewCasesNumber > CaseId) ->testCase(ProjectId, SuiteId, CaseId, _, _, Status, _),
        (pass(Status) -> getNumberOfPassingTests(ProjectId, SuiteId, NewCaseId, NewNumber, Number);
    getNumberOfPassingTests(ProjectId, SuiteId, NewCaseId, AuxNumber, Number)));
    Number is AuxNumber.

calculateStatistics(ProjectId, SuiteId, StatSuite):-
    getNumberOfExecutedTests(ProjectId, SuiteId, 1, 0, Executed),
    getNumberOfPassingTests(ProjectId, SuiteId, 1, 0, Passing),
    ((Executed == 0) -> StatSuite is 0;
        calculate(Passing, Executed, StatSuite)),
    writeln('Resultado na funcao'),
    writeln(StatSuite).

calculate(Passing, Executed, Result):-
    Result is (Passing/Executed) * 100.0.