#include "menuProject.h"
#include "project.h"
#include "dataManagerProject.h"
#include "login.h"
#include "system.h"
#include "constants.h"

using namespace std;

void verifyUserToProject(user loggedUser){
    vector<Project> projects = arquiveToArray();

    string input;
    cout << "Informe id do projeto: ";
    getline(cin, input);

    int id = stoi(input);

    int aux = throughArray(id, projects);

    if ((aux > -1) && (projects[aux].id == id)){
        if (projects[aux].owner.compare(loggedUser.login) == 0){
            projectMenuOwner(id, loggedUser);
        } else {
            bool isAllowedUser = false;
            for (int i = 0; i < projects[aux].users.size(); i++){
                if (projects[aux].users[i].compare(loggedUser.login) == 0){
                    isAllowedUser =  true;
                    break;
                }
            }
            if (isAllowedUser){
                projectMenuUser(id, loggedUser);
            } else {
                cout << "Usuário não tem permissão de acesso a esse projeto." << endl;
            }
        }
    } else {
        cout << "Projeto não encontrado." << endl;
        cout << PAUSE_MSG << endl;
        cin.get();
        system(CLEAR);
        systemMenu(loggedUser);
    }    
}

void printProjectMenuOwner(){
    system ("clear");
    printHeader("Menu Projeto Dono");
    cout << "(1) Editar nome do projeto" << endl;
    cout << "(2) Editar descrição do projeto" << endl;
    cout << "(3) Verificar pedidos de permissão" << endl;
    cout << "(4) Excluir projeto" << endl;
    cout << "(5) Criar suíte de testes" << endl;
    cout << "(6) Listar suítes de testes" << endl;
    cout << "(7) Consultar suítes de testes" << endl;
    cout << "(8) Gerar relatório de projeto" << endl;
    cout << "(9) Sair do projeto" << endl;

}

void projectMenuOwner(int id, user loggedUser){
    char selectedOption = '0';
    do {
        do {
            printProjectMenuOwner();
            cout << "Selecione a opção desejada: ";
            cin.get(selectedOption);
            cin.ignore();

            if (isSelectedOptionValid(selectedOption, '1', '9') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '9') == false);

        switch(selectedOption){
            case '1':
                editNameProject(id);
                break;
            case '2':
                editDescriptionProject(id);
                break;
            case '3':
                allowPermissions(id);
                break;
            case '4':
                deleteProject(id);
                systemMenu(loggedUser);
                break;
            case '5':
                createSuite(id);
                cout << "Suíte de testes criado com sucesso" << endl;
                break;
            case '6':
                listSuites(id);
                cout << "Fim." << endl;
                break;
            case '7':
                searchSuite(id);
                cout << "Consulta realizada com sucesso" << endl;
                break;
            case '8':
                generateReport(id);
                cout << "Relatório gerado com sucesso" << endl;
                break;
            case '9':
                systemMenu(loggedUser);
                cout << "Saindo do projeto" << endl;
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        cout << "Pressione qualquer tecla para continuar..." << endl;
        cin.get();
        system ("clear");
    } while (selectedOption != '5');
}

void printProjectMenuUser(){
    system ("clear");
    printHeader();
    cout << "Menu Projeto Usuário Com Acesso" << endl; 
    cout << "(1) Criar suíte de testes" << endl;
    cout << "(2) Listar suítes de testes" << endl;
    cout << "(3) Consultar suítes de testes" << endl;
    cout << "(4) Gerar relatório de projeto" << endl;
    cout << "(5) Sair do projeto" << endl;

}

void projectMenuUser(int id, user loggedUser){
    char selectedOption = '0';
    do {
        do {
            printProjectMenuUser();

            cout << "Selecione a opção desejada: ";
            cin.get(selectedOption);
            cin.ignore();

            if (isSelectedOptionValid(selectedOption, '1', '5') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '5') == false);

        switch(selectedOption){
            case '1':
                createSuite(id);
                cout << "Suíte de testes criado com sucesso" << endl;
                break;
            case '2':
                listSuites(id);
                cout << "Fim." << endl;
                break;
            case '3':
                searchSuite(id);
                cout << "Consulta realizada com sucesso" << endl;
                break;
            case '4':
                generateReport(id);
                cout << "Relatório gerado com sucesso" << endl;
                break;
            case '5':
                cout << "Saindo do projeto" << endl;
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        cout << "Pressione qualquer tecla para continuar..." << endl;
        cin.get();
        system ("clear");
    } while (selectedOption != '5');
}