#include "reports.h"

using namespace std;

void generateReport(user loggedUser){
    char selectedOption;
    int projectId;
    int suiteId;
    vector<suite> suites;
    vector<Project> projects;
    vector<suite> projectSuites;
    Project projectOfReport;
    string userLogin;
    bool isAllowed;


    system("clear");
    printHeader(GENERATE_REPORT_HEADER);

    cout << "(1) Gerar relatório de uma suite de testes" << endl;
    cout << "(2) Gerar relatório de um projeto" << endl;
    cout << "(3) Gerar relatório de participação de usuário em todos os projetos" << endl;
    
    selectedOption = readOption()[0];

    switch (selectedOption){
        case '1':{
            cout << "Digite o código do projeto que contém a suite de testes: ";
            cin >> projectId;
            isAllowed = false;
            projects = arquiveToArray();
            for(int i = 0; i < projects.size(); i++){
                if(projects[i].id == projectId){
                    if (projects[i].owner.compare(loggedUser.login) == 0){
                        isAllowed = true;
                    } else {
                        for(int j = 0; j < projects[i].users.size(); j++){
                            if(projects[i].users[j] == loggedUser.login){
                                isAllowed = true;
                            }
                        }
                    }
                    break;
                }
            }
            if(isAllowed) {
                cout << "Digite o código da suite de testes: ";
                cin >> suiteId;

                suite suiteOfReport;
                vector<suite> suitesOfProject;
                vector<Case> cases;
                cases = readCases(projectId, suiteId);
                vector<Case> casesOfSuite;

                suites = readSuites(projectId);
                for(int j = 0; j < suites.size(); j++){
                    if(suites[j].projectId == projectId){
                        suitesOfProject.push_back(suites[j]);
                    }
                    if(suites[j].id == suiteId){
                        suiteOfReport = suites[j];
                    }
                }
                for(int i = 0; i < cases.size(); i++){
                    casesOfSuite.push_back(cases[i]);
                }

                system("clear");
                generateSuiteReport(suiteOfReport, casesOfSuite);
                cout << endl;
                showMessage("Relatório da suite de testes gerado com sucesso");
            }
            else{
                showMessage("Você não tem acesso a esse projeto!");
            }
            break;
        }
        case '2':{
            suites = readSuites(projectId);
            projects = arquiveToArray();

            cout << "Digite o código do projeto base para o relatório: ";
            cin >> projectId;

            isAllowed = false;
            projects = arquiveToArray();
            for(int i = 0; i < projects.size(); i++){
                if(projects[i].id == projectId){
                    if (projects[i].owner.compare(loggedUser.login) == 0){
                        isAllowed = true;
                    } else {
                        for(int j = 0; j < projects[i].users.size(); j++){
                            if(projects[i].users[j] == loggedUser.login){
                                isAllowed = true;
                            }
                        }
                    }
                }
            }

            if(isAllowed){
                for(int j = 0; j < suites.size(); j++){
                    if(suites[j].projectId == projectId){
                        projectSuites.push_back(suites[j]);
                    }
                }

                for(int i = 0; i < projects.size(); i++){
                    if(projects[i].id == projectId){
                        projectOfReport = projects[i];
                    }
                }

                system("clear");
                generateProjectReport(projectOfReport, projectSuites);
                cout << "" << endl;
                cout << "Relatório do projeto gerado com sucesso" << endl;
            }
            else{
                system("clear");
                cout << "Usuário logado no sistema não tem acesso a esse projeto" << endl;
                cout << "Redirecionado ao menu inicial..." << endl;

            }
            break;
        }
        case '3':{
            projects = arquiveToArray();
            cout << "Digite o login do usuário base para o relatório: ";
            cin >> userLogin;

            system("clear");
            generateUserReport(userLogin, projects);

            break;
        }
        default:{
            showMessage(INVALID_OPTION);
            break;
        }
    }

}

void generateSuiteReport(suite reportSuite, vector<Case> suiteTestCases){

    float passingPercentage;
    float notPassingPercentage;
    float problemsPercentage;
    float notExecutedPercentage;

    cout << SUITES_PATH + to_string(reportSuite.id) + ".dat" << endl;

    std::ofstream reportFile(SUITES_PATH + to_string(reportSuite.id) + ".dat", std::ios::in);

    reportFile << "Relatório da suíte de testes " << reportSuite.name << endl;
    cout << "Relatório da suíte de testes " << reportSuite.name << endl;
    reportFile << "" << endl;
    cout << "" << endl;

    for(int i = 0; i < suiteTestCases.size(); i++){
        reportFile << "Nome do caso de testes: " << suiteTestCases[i].name << endl;
        cout << "Nome do caso de testes: " << suiteTestCases[i].name << endl;
        reportFile << "Objetivos: " << suiteTestCases[i].objectives << endl;
        cout << "Objetivos: " << suiteTestCases[i].objectives << endl;
        reportFile << "Pré condições: " << suiteTestCases[i].preconditions << endl;
        cout << "Pré condições: " << suiteTestCases[i].preconditions << endl;
        reportFile << "Passos: " << endl;
        cout << "Passos: " << endl;
        for(int j = 0; j < suiteTestCases[i].steps.size(); j++){
            reportFile << "Descrição: " << suiteTestCases[i].steps[j].description << endl;
            cout << "Descrição: " << suiteTestCases[i].steps[j].description << endl;
            reportFile << "Resultado esperado: " << suiteTestCases[i].steps[j].expectedResult << endl;
            cout << "Resultado esperado: " << suiteTestCases[i].steps[j].expectedResult << endl;
        }
        reportFile << "" << endl;
        cout << "" << endl;
        reportFile << "Status do caso: " << suiteTestCases[i].status << endl;
        cout << "Status do caso: " << suiteTestCases[i].status << endl;
        reportFile << "" << endl;
        cout << "" << endl;

        string status = caseStatusMessage[suiteTestCases[i].status];

        if(status == "Não executado"){
            notExecutedPercentage++;
        }
        else if(status == "Passou"){
            passingPercentage++;
        }
        else if(status == "Não passou"){
            notPassingPercentage++;
        }        
        else{
            problemsPercentage++;
        }
    }

    notExecutedPercentage = calculateStatus(reportSuite, 1);

    passingPercentage = calculateStatus(reportSuite, 2);

    notPassingPercentage = calculateStatus(reportSuite, 3);

    problemsPercentage = calculateStatus(reportSuite, 4);

    reportFile << "Percentual de casos de testes que passaram: " << int(passingPercentage) << "%" << endl;
    cout << "Percentual de casos de testes que passaram: " << int(passingPercentage) << "%" << endl;
    reportFile << "Percentual de casos de testes que não passaram: " << int(notPassingPercentage) << "%" << endl;
    cout << "Percentual de casos de testes que não passaram: " << int(notPassingPercentage) << "%" << endl;
    reportFile << "Percentual de casos de testes em que ocorreram problemas de execução: " << int(problemsPercentage) << "%" << endl;
    cout << "Percentual de casos de testes em que ocorreram problemas de execução: " << int(problemsPercentage) << "%" << endl;
    reportFile << "Percentual de casos de testes não executados: " << int(notExecutedPercentage) << "%" << endl;
    cout << "Percentual de casos de testes não executados: " << int(notExecutedPercentage) << "%" << endl;

}

void generateProjectReport(Project reportProject, vector<suite> projectSuites){

    float passingPercentage;
    int numberOfCases;

    std::ofstream reportFile(PROJECT_FILE_NAME + reportProject.id, std::ios::in);

    vector<Case> suiteCases;

    reportFile << "Relatório do projeto de testes " << reportProject.name << endl;
    cout << "Relatório do projeto de testes " << reportProject.name << endl;
    reportFile << "Descrição do projeto:" << reportProject.description << endl;
    cout << "Descrição do projeto: " << reportProject.description << endl;
    reportFile << "Dono do projeto: " << reportProject.owner << endl;
    cout << "Dono do projeto: " << reportProject.owner << endl;
    reportFile << "" << endl;
    cout << "" << endl;

    for(int i = 0; i < projectSuites.size(); i++){

        suiteCases = readCases(reportProject.id, projectSuites[i].id);
        reportFile << "Nome da suite de testes: " << projectSuites[i].name << endl;
        cout << "Nome da suite de testes: " << projectSuites[i].name << endl;
        reportFile << "Descrição da suite de testes: " << projectSuites[i].description << endl;
        cout << "Descrição da suite de testes: " << projectSuites[i].description << endl;

        for(int j = 0; j < suiteCases.size(); j++){
            numberOfCases++;
            reportFile << "Nome do caso de testes: " << suiteCases[j].name << endl;
            cout << "Nome do caso de testes: " << suiteCases[j].name << endl;
            reportFile << "Objetivos: " << suiteCases[j].objectives << endl;
            cout << "Objetivos: " << suiteCases[j].objectives << endl;
            reportFile << "Pré condições: " << suiteCases[j].preconditions << endl;
            cout << "Pré condições: " << suiteCases[j].preconditions << endl;
            reportFile << "Passos: " << endl;
            cout << "Passos: " << endl;
            for(int l = 0; l < suiteCases[j].steps.size(); l++){
                reportFile << "Descrição do passo: " << suiteCases[j].steps[l].description << endl;
                cout << "Descrição do passo: " << suiteCases[j].steps[l].description << endl;
                reportFile << "Resultado esperado: " << suiteCases[j].steps[l].expectedResult << endl;
                cout << "Resultado esperado: " << suiteCases[j].steps[l].expectedResult << endl;
            }
            reportFile << "" << endl;
            cout << "" << endl;
            reportFile << "Status do caso: " << suiteCases[i].status << endl;
            cout << "Status do caso: " << suiteCases[i].status << endl;
            reportFile << "" << endl;
            cout << "" << endl;
            string status = caseStatusMessage[suiteCases[i].status];
            if(status == caseStatusMessage[1]){
                passingPercentage++;
            }
        }
    }

    passingPercentage /= numberOfCases;
    passingPercentage *= 100;

    reportFile << "Percentual de casos de testes que passaram: " << int(passingPercentage) << endl;
    cout << "Percentual de casos de testes que passaram: " << int(passingPercentage) << endl;

}

void generateUserReport(string userLogin, vector<Project> projects){

    std::ofstream reportFile(USERS_FILE_PATH + userLogin, std::ios::in);
    int numberOfCreatedTests;
    int numberOfPassingTests;
    vector<Project> userProjects;
    vector<suite> suites;
    vector<Case> cases;

    reportFile << "Relatório de participação do usuário " << userLogin << endl;
    cout << "Relatório de participação do usuário" << userLogin << endl;
    reportFile << "" << endl;
    cout << "" << endl;
    reportFile << "Projetos com participação do usuário:" << endl;
    cout << "Projetos com participação do usuário:" << endl;

    for(int i = 0; i < projects.size(); i++){
        for(int j = 0; j < projects[i].users.size(); j++){
            if(projects[i].users[j] == userLogin){
                userProjects.push_back(projects[i]);
            }
        }
    }  

    for(int i = 0; i < userProjects.size(); i++){
        reportFile << "Id do projeto: " << userProjects[i].id << endl;
        cout << "Id do projeto: " << userProjects[i].id << endl;
        reportFile << "Nome do projeto: " << userProjects[i].name << endl;
        cout << "Nome do projeto: " << userProjects[i].name << endl;
        reportFile << "Descrição do projeto:" << userProjects[i].description << endl;
        cout << "Descrição do projeto: " << userProjects[i].description << endl;
        reportFile << "Dono do projeto: " << userProjects[i].owner << endl;
        cout << "Dono do projeto: " << userProjects[i].owner << endl;
        reportFile << "" << endl;
        cout << "" << endl;
        suites = readSuites(userProjects[i].id);
        for(int j = 0; j < suites.size(); j++){
            if(suites[j].projectId == userProjects[i].id){
                reportFile << "Nome da suite de testes: " << suites[j].name << endl;
                cout << "Nome da suite de testes: " << suites[j].name << endl;
                reportFile << "Descrição da suite de testes: " << suites[j].description << endl;
                cout << "Descrição da suite de testes: " << suites[j].description << endl;
                cases = readCases(userProjects[i].id, suites[j].id);
                for(int k = 0; k < cases.size(); k++){
                    numberOfCreatedTests++;
                    reportFile << "Nome do caso de testes: " << cases[k].name << endl;
                    cout << "Nome do caso de testes: " << cases[k].name << endl;
                    reportFile << "Objetivos: " << cases[k].objectives << endl;
                    cout << "Objetivos: " << cases[k].objectives << endl;
                    reportFile << "Pré condições: " << cases[k].preconditions << endl;
                    cout << "Pré condições: " << cases[k].preconditions << endl;
                    reportFile << "Passos: " << endl;
                    cout << "Passos: " << endl;
                    for(int l = 0; l < cases[k].steps.size(); l++){
                        reportFile << "Descrição do passo: " << cases[k].steps[l].description << endl;
                        cout << "Descrição do passo: " << cases[k].steps[l].description << endl;
                        reportFile << "Resultado esperado: " << cases[k].steps[l].expectedResult << endl;
                        cout << "Resultado esperado: " << cases[k].steps[l].expectedResult << endl;
                    }
                    string status = caseStatusMessage[cases[k].status];
                    if(status == caseStatusMessage[1]){
                        numberOfPassingTests++;
                    }
                }
            }
        }

    }

    float percentage;

    percentage = numberOfPassingTests / numberOfCreatedTests;

    reportFile << "Porcentagem de casos de teste criados pelo usuário que passaram: " <<  int(percentage) << endl;
    cout << "Porcentagem de casos de teste criados pelo usuário que passaram: " <<  int(percentage) << endl;

}