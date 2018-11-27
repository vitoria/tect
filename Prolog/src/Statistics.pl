:- initialization(main).

:- use_module(util).

sumStatisticsProject(_,[], Result):- Result is 0.
sumStatisticsProject(ProjectId,[Id|List], Result) :-  sumStatisticsProject(ProjectId,List, Result2), 
                    testCase:calculateStatiscs(ProjectId, Id, StatSuite), Result is Result2 + StatSuite.

calculateMediumStatisticsProject(ProjectId, [H|T],Result) :- sumStatisticsProject(ProjectId, [H|T],Z), Y is util:length_1(Z,[H|T]), Result is Z/Y.


getProjectResume([]).
getProjectResume([[Id, Name]|ProjectsTouple]):- write(Id), write(" - "), write(Name), write(" - "), 
                    Suites is getSuitesList(Id),    
                    Media is calculateMediumStatisticsProject(Id,Suites),
                    write(Media),nl, 
                    getProjectResume(ProjectsTouple).

getProjectsStatistics([ProjectsTouple]) :-
    write("#--------------# ESTATÍSTICAS #------------#"),nl,
    write(" ID - NOME DO PROJETO - MÉDIA DAS ESTATÍSTICAS DO PROJETO"),nl,
    getProjectResume(ProjectsTouple).


getProjectId([], []).
getProjectId([(Id,Name)|List]) :- [Id|getProjectId(List)].

chooseStatisticsAction(Option, [(X,Y)]) :-
    (Option =:= "1" -> getProjectsStatistics([(X,Y)]);
    Option =:= "2" -> statisticsFromAProject(getProjectId([(X,Y)]);
    write("Opção Inválida"))).
    


isValidProjId(_,[]).
isValidProjId(TestedId, [Id|ProjectsId]):-
    (TestedId =:= Id -> true;
    isValidProjId(TestedId, ProjectsId)).

statisticsFromAProject(projectsId):-
    write("#--------------# ESTATÍSTICAS #------------#"),
    write("Informe o ID de um projeto para visualizar seu relatório:"),
    read_line_to_codes(user_input, ProjectId),
    (validation:isStringNumeric(ProjectId) = true -> 
        (validation:isValidProjId(ProjectId,projectsId) = true -> 
        tty_clear,
                    Suites is getSuitesList(ProjectId),
                    Saida is generateStatisticsString(ProjectId, Suites),
                    write("#--------------# ESTATÍSTICAS #------------#"),nl,
                    write("SUITE ID - NOME DA SUITE - TAXA DE TESTES QUE PASSARAM"),nl,
                    write(Saida);
                    write("Não existe projeto com o ID informado."));
    write("O ID informado é inválido.")).

generateStatisticsString(_,[], []).
generateStatisticsString(ProjectId,[Id, Name,_,_|Suites]):- 
        write(Id), write(" - "), write(Name), write(" - "), 
        testCase:calculateStatiscs(ProjectId, Id, StatSuite),nl, 
        generateStatisticsString(ProjectId, Suites).


getSuitesList(projId) = 0.

showStatisticsMenu() :-
    generalPrints:printHeaderWithSubtitle(statistics_menu).

statisticsMenu([Id, Y]) :-
    showStatisticsMenu(),
    write("Informe a opção desejada: "),
    read_line_to_codes(user_input, Entrada),
    (validation:isOptionValid(Entrada, "1", "3") = true ->
            Option is Entrada, (Option =:= "3" -> write("Retornando ao menu anterior...");
            tty_clear, chooseStatisticsAction(Option, [Id,Y]), generalPrints:systemPause(), statisticsMenu([Id,Y]));                
    write("Opção Inválida"),
    generalPrints:systemPause(),
    statisticsMenu([Id,Y])).