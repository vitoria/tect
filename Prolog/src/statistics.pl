:- module(statistics).

:- use_module(utils).
:- use_module(testSuite).
:- use_module(constants).
:- use_module(project).
:- use_module(mainSystem).
:- use_module(testCase).

isOptionValidStst(1).
isOptionValidStat(2).
isOptionValidStat(3).

readNumber(Number):- 
    read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).


sumStatisticsProject(_,[], Result):- Result is 0.
sumStatisticsProject(ProjectId,[IdSuite|List], Result) :-  
                    sumStatisticsProject(ProjectId,List, Result2),
                    testCase:calculateStatiscs(ProjectId, IdSuite, StatSuite), Result is Result2 + StatSuite.


getSuitesList(Projeto, X):- 
    findall(I, testSuite:suite(I, _, _, Projeto), X). 
getAllSuites(Projeto, X):- 
    findall([I,J,K,Projeto],project(I, J, K, Projeto), X). 

getNumberOfSuites(Count) :- 
    aggregate_all(count, testSuite:suite(_, _, _, _), Count).

calculateMediumStatisticsProject(ProjectId, [H|T],Result) :- 
    sumStatisticsProject(ProjectId, [H|T],Z), getNumberOfSuites(Y), Result is Z/Y.


getProjectResume([]).
getProjectResume([[Id, Name]|ProjectsTouple]):- 
                write(Id), write(" - "), write(Name), write(" - "), 
                getSuitesList(Id, Suites),    
                calculateMediumStatisticsProject(Id,Suites, Media),
                write(Media),nl, 
                getProjectResume(ProjectsTouple).

getProjectsStatistics([ProjectsTouple]) :-
    constants:statistics_header(X), write(X),nl,
    write(" ID - NOME DO PROJETO - MÉDIA DAS ESTATÍSTICAS DO PROJETO"),nl,
    getProjectResume(ProjectsTouple).




getProjectIdList(X):- 
    findall(I, project:project(I, _, _, _), X). 
getProjectIdToupleList(X):- 
    findall([I,J], project:project(I, J, _, _), X). 

chooseStatisticsAction(Option) :-
    getProjectIdList(Result),
    getProjectIdToupleList(Result2),
    (Option =:= 1 -> getProjectsStatistics(Result2);
    Option =:= 2 -> statisticsFromAProject(Result)).
    


isValidProjId(_,[]).
isValidProjId(TestedId, [Id|ProjectsId]):-
    (TestedId =:= Id -> true;
    isValidProjId(TestedId, ProjectsId)).

statisticsFromAProject(ProjectsId):-
    constants:statistics_header(X), write(X),
    write("Informe o ID de um projeto para visualizar seu relatório:"),
    readNumber(ProjectId),
    (isValidProjId(ProjectId,ProjectsId) -> 
        tty_clear,
        getAllSuites(ProjectId, Suites),
        write(X),nl,
        write("SUITE ID - NOME DA SUITE - TAXA DE TESTES QUE PASSARAM"),nl,
        generateStatisticsString(ProjectId, Suites);
    write("Não existe projeto com o ID informado.")).

generateStatisticsString(_,[]).
generateStatisticsString(ProjectId,[Id, Name,_,_|Suites]):-
        write(Id), write(" - "), write(Name), write(" - "), 
        testCase:calculateStatiscs(ProjectId, Id, StatSuite), write(StatSuite),nl,
        generateStatisticsString(ProjectId, Suites).



showStatisticsMenu() :-
    constants:statistics_menu(X),write(X).


statisticsMenu(LoggedUser) :-
    showStatisticsMenu(),
    write("Informe a opção desejada: "),
    readNumber(Entrada),
    (isOptionValidStat(Entrada) ->
           (Entrada =:= 3 -> write("Retornando ao menu anterior..."),util:systemPause(), mainSystem:systemMenu(LoggedUser);
                                (tty_clear, chooseStatisticsAction(Entrada))));                
    write("Opção Inválida"), util:systemPause(), statisticsMenu(LoggedUser).
