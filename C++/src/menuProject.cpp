#include "menuProject.h"
#include "project.h"
#include "dataManagerProject.h"
#include "login.h"
#include "system.h"
#include "constants.h"
#include "suiteTest.h"

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
        //systemMenu(loggedUser);
    }    
}

void printProjectMenuOwner(){
    system ("clear");
    printHeader("Menu Projeto Dono");
    cout << "(1) Editar nome do projeto" << endl;
    cout << "(2) Editar descrição do projeto" << endl;
    cout << "(3) Verificar pedidos de permissão" << endl;
    cout << "(4) Excluir projeto" << endl;
    cout << "(5) Gerenciar suítes de teste" << endl;
    cout << "(6) Gerar relatório de projeto" << endl;
    cout << "(7) Sair do projeto" << endl;

}

void projectMenuOwner(int id, user loggedUser){
    char selectedOption = '0';
    do {
        do {
            printProjectMenuOwner();
            cout << "Selecione a opção desejada: ";
            cin.get(selectedOption);
            cin.ignore();

            if (isSelectedOptionValid(selectedOption, '1', '7') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '7') == false);

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
                selectedOption = '7';
                break;
            case '5':
                suiteTestMenu(id);
                break;
            case '6':
                generateReport(id);
                cout << "Relatório gerado com sucesso" << endl;
                break;
            case '7':
                cout << "Saindo do projeto" << endl;
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        cout << "Pressione qualquer tecla para continuar..." << endl;
        cin.get();
        system ("clear");
    } while (selectedOption != '7');
}

void printProjectMenuUser(){
    system ("clear");
    printHeader();
    cout << "Menu Projeto Usuário Com Acesso" << endl; 
    cout << "(1) Gerenciar suítes de teste" << endl;
    cout << "(2) Gerar relatório de projeto" << endl;
    cout << "(3) Sair do projeto" << endl;

}

void projectMenuUser(int id, user loggedUser){
    char selectedOption = '0';
    do {
        do {
            printProjectMenuUser();

            cout << "Selecione a opção desejada: ";
            cin.get(selectedOption);
            cin.ignore();

            if (isSelectedOptionValid(selectedOption, '1', '3') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '3') == false);

        switch(selectedOption){
            case '1':
                suiteTestMenu(id);
                break;
            case '2':
                generateReport(id);
                cout << "Relatório gerado com sucesso" << endl;
                break;
            case '3':
                cout << "Saindo do projeto" << endl;
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        cout << "Pressione qualquer tecla para continuar..." << endl;
        cin.get();
        system ("clear");
    } while (selectedOption != '3');
}