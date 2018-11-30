:- module(statistics, [statisticsMenu/1]).

:- use_module(utils).
:- use_module(testSuite).
:- use_module(constants).
:- use_module(project).
:- use_module(mainSystem).
:- use_module(testCase).
:- use_module(model).

readNumber(Number):- 
    read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).


sumStatisticsProject(_,[], 0).
sumStatisticsProject(ProjectId,[IdSuite|List], Result) :-  
                    sumStatisticsProject(ProjectId,List, Result2),
                    testCase:calculateStatistics(ProjectId, IdSuite, StatSuite), Result is (Result2 + StatSuite).


getSuitesList(Projeto, X):- 
    findall(I, model:testSuiteModel:suite(I, _, _, Projeto), X). 

getAllSuites(Projeto, X):- 
    findall([I,J,K,Projeto], model:testSuiteModel:suite(I, J, K, Projeto), X). 

getNumberOfSuites(Count) :- 
    aggregate_all(count, model:testSuiteModel:suite(_, _, _, _), Count).

calculateMediumStatisticsProject(ProjectId, [H|T],Result) :- 
    sumStatisticsProject(ProjectId, [H|T],Z), getNumberOfSuites(Y), Result is Z/Y.


getProjectResume([]).
getProjectResume([[Id, Name]|ProjectsTouple]):- 
                getSuitesList(Id, Suites),    
                calculateMediumStatisticsProject(Id,Suites, Media),
                write(Id), write(" - "), write(Name), write(" - "), writeln(Media),
                getProjectResume(ProjectsTouple).

getProjectsStatistics(ProjectsTouple) :-
    constants:statistics_header(X), write(X),nl,
    write(" ID - NOME DO PROJETO - MÉDIA DAS ESTATÍSTICAS DO PROJETO"),nl,
    getProjectResume(ProjectsTouple).




getProjectIdList(X):- 
    findall(I, model:projectModel:project(I, _, _, _), X). 
getProjectIdToupleList(X):- 
    findall([I,J], model:projectModel:project(I, J, _, _), X). 

isValidProjId(_,[]).
isValidProjId(TestedId, [Id|ProjectsId]):-
    (TestedId =:= Id -> true;
    isValidProjId(TestedId, ProjectsId)).

statisticsFromAProject():-
    constants:statistics_header(Header),
    utils:printHeaderAndSubtitle(Header),
    write("Informe o ID de um projeto para visualizar seu relatório:"),
    readNumber(ProjectId),
    (model:projectModel:project(ProjectId, _, _, _) -> 
        tty_clear,
        getAllSuites(ProjectId, Suites),
        constants:statistics_header(Header),
        utils:printHeaderAndSubtitle(Header),
        write("SUITE ID - NOME DA SUITE - TAXA DE TESTES QUE PASSARAM"),nl,
        generateStatisticsString(ProjectId, Suites);
    write("Não existe projeto com o ID informado.")).

generateStatisticsString(_,[]).
generateStatisticsString(ProjectId,[[Id, Name,_,_]|Suites]):-
    model:testCase:calculateStatistics(ProjectId, Id, StatSuite),
    write(Id), write(" - "), write(Name), write(" - "), write(StatSuite), writeln("%"),
    generateStatisticsString(ProjectId, Suites).

showStatisticsMenu() :-
    constants:statistics_header(Header),
    utils:printHeaderAndSubtitle(Header),
    constants:statistics_menu(X),write(X).

selectOption(Option):- chooseStatisticsAction(Option),
    utils:systemPause.

statisticsMenu(LoggedUser) :-
    showStatisticsMenu(),
    utils:readOption(Option),
    ((Option =\= 3, selectOption(Option), statisticsMenu(LoggedUser)); true).

chooseStatisticsAction(1) :- getProjectIdToupleList(Result), getProjectsStatistics(Result); true.
chooseStatisticsAction(2) :- statisticsFromAProject(); true.
chooseStatisticsAction(_) :- writeln("Opção inválida").