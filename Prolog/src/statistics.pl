:- module(authentication, [authenticationMenu/0]).

:- use_module(util).
:- use_module(testSuite).
:- use_module(constants).
:- use_module(project).
:- use_module(testCase).

isOptionValidStst("1").
isOptionValidStat("2").
isOptionValidStat("3").

readNumber(Number):- read_line_to_codes(user_input, Codes), string_to_atom(Codes, Atom), atom_number(Atom, Number).


sumStatisticsProject(_,[], Result):- Result is 0.
sumStatisticsProject(ProjectId,[IdSuite|List], Result) :-  sumStatisticsProject(ProjectId,List, Result2),
                    testCase:calculateStatiscs(ProjectId, IdSuite, StatSuite), Result is Result2 + StatSuite.


getSuitesList(Projeto, X):- findall(I, testSuite:suite(I, _, _, Projeto), X). 
getAllSuites(Projeto, X):- findall([I,J,K,Projeto],project(I, J, K, Projeto), X). 

length_1([], 0).
length_1([H|T], N) :- length_1(T, N1), N is N1 + 1.

calculateMediumStatisticsProject(ProjectId, [H|T],Result) :- sumStatisticsProject(ProjectId, [H|T],Z), length_1([H|T], Y), Result is Z/Y.


getProjectResume([]).
getProjectResume([[Id, Name]|ProjectsTouple]):- write(Id), write(" - "), write(Name), write(" - "), 
                   getSuitesList(Id, Suites),    
                   calculateMediumStatisticsProject(Id,Suites, Media),
                    write(Media),nl, 
                    getProjectResume(ProjectsTouple).

getProjectsStatistics([ProjectsTouple]) :-
    write("#--------------# ESTATÍSTICAS #------------#"),nl,
    write(" ID - NOME DO PROJETO - MÉDIA DAS ESTATÍSTICAS DO PROJETO"),nl,
    getProjectResume(ProjectsTouple).




getProjectIdList(X):- findall(I, project:project(I, _, _, _), X). 
getProjectIdToupleList(X):- findall([I,J], project:project(I, J, _, _), X). 

chooseStatisticsAction(Option) :-
    getProjectIdList(Result),
    getProjectIdToupleList(Result2),
    (Option =:= 1 -> getProjectsStatistics(Result2);
    Option =:= 2 -> statisticsFromAProject(Result);
    write("Opção Inválida")).
    


isValidProjId(_,[]).
isValidProjId(TestedId, [Id|ProjectsId]):-
    (TestedId =:= Id -> true;
    isValidProjId(TestedId, ProjectsId)).

statisticsFromAProject(ProjectsId):-
    write("#--------------# ESTATÍSTICAS #------------#"),
    write("Informe o ID de um projeto para visualizar seu relatório:"),
    readNumber(ProjectId),
    (isValidProjId(ProjectId,ProjectsId) -> 
        tty_clear,
        getAllSuites(ProjectId, Suites),
        write("#--------------# ESTATÍSTICAS #------------#"),nl,
        write("SUITE ID - NOME DA SUITE - TAXA DE TESTES QUE PASSARAM"),nl,
        generateStatisticsString(ProjectId, Suites);
    write("Não existe projeto com o ID informado.")).

generateStatisticsString(_,[]).
generateStatisticsString(ProjectId,[Id, Name,_,_|Suites]):-
        write(Id), write(" - "), write(Name), write(" - "), 
        testCase:calculateStatiscs(ProjectId, Id, StatSuite), write(StatSuite),nl,
        generateStatisticsString(ProjectId, Suites).


showStatisticsMenu() :-
    write("(1) Visualizar estatísticas de projeto"),nl,
    write("(2) Visualizar estatísticas de suite de testes de um projeto"),nl,
    write("(3) Voltar").


statisticsMenu(LoggedUser) :-
    showStatisticsMenu(),

    write("Informe a opção desejada: "),
    readNumber(Entrada),
    (isOptionValidStat(Entrada) ->
           (Entrada =:= 3 -> write("Retornando ao menu anterior..."), mainSystem:systemMenu(LoggedUser);
                                (tty_clear, chooseStatisticsAction(Entrada))));                
    write("Opção Inválida"), statisticsMenu(LoggedUser).