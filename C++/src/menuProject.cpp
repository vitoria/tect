#include "menuProject.h"
#include "project.h"
#include "dataManagerProject.h"
#include "login.h"
#include "system.h"
#include "constants.h"
#include "suiteTest.h"
#include "generalPrints.h"

using namespace std;

void verifyUserToProject(user loggedUser){
    vector<Project> projects = arquiveToArray();

    string input;
    cout << "Informe id do projeto: ";
    getline(cin, input);

    if (input.compare("") == 0) {
        showMessage("Voce precisa informar o id do projeto!");
    } else {
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
        }
    }    
}

void printProjectMenuOwner(int id){
    printHeader();
    cout << "#--------# GERENCIAR PROJETO ";
    showID(id);
    cout << " #--------#" << endl << endl;
    cout << "(1) Ver informações do projeto" << endl;
    cout << "(2) Editar nome do projeto" << endl;
    cout << "(3) Editar descrição do projeto" << endl;
    cout << "(4) Verificar pedidos de permissão" << endl;
    cout << "(5) Excluir projeto" << endl;
    cout << "(6) Gerenciar suítes de teste" << endl;
    cout << "(7) Sair do projeto" << endl;

}

void projectMenuOwner(int id, user loggedUser){
    char selectedOption = '0';
    do {
        do {
            printProjectMenuOwner(id);
            selectedOption = readOption()[0];

            if (isSelectedOptionValid(selectedOption, '1', '6') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '6') == false);

        cout << endl;
        switch(selectedOption){
            case '1':
                showProject(id);
                break;
            case '2':
                editNameProject(id);
                pauseSystem();
                break;
            case '3':
                editDescriptionProject(id);
                pauseSystem();
                break;
            case '4':
                allowPermissions(id);
                pauseSystem();
                break;
            case '5':
                deleteProject(id);
                selectedOption = '6';
                pauseSystem();
                break;
            case '6':
                suiteTestMenu(id);
                break;
            case '7':
                pauseSystem();
                break;
            default:
                showMessage(INVALID_OPTION);
                break;
        }
    } while (selectedOption != '6');
}

void printProjectMenuUser(){
    system ("clear");
    printHeader();
    cout << "Menu Projeto Usuário Com Acesso" << endl; 
    cout << "(1) Gerenciar suítes de teste" << endl;
    cout << "(2) Sair do projeto" << endl;

}

void projectMenuUser(int id, user loggedUser){
    char selectedOption = '0';
    do {
        do {
            printProjectMenuUser();

            selectedOption = readOption()[0];

            if (isSelectedOptionValid(selectedOption, '1', '2') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '2') == false);

        switch(selectedOption){
            case '1':
                suiteTestMenu(id);
                break;
            case '2':
                cout << "Saindo do projeto" << endl;
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        pauseSystem();
    } while (selectedOption != '2');
}