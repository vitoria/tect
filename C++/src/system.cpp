#include "system.h"
#include "constants.h"
#include "suiteTest.h"

using namespace std;

void running() {
    user loggedUser;
    bool isDone = false;
    
    while (!isDone) {
        if (loginMenu(&loggedUser, &isDone)){
            systemMenu(loggedUser, &isDone);
        }
    }
}

void systemMenu(user loggedUser, bool *isDone) {
    string optionInput;
    char selectedOption;
    do {
        do {
            printSystemMenu(loggedUser.name);

            optionInput = readOption();
            cin.ignore();

            if (isMenuInputStringValid(optionInput, CREATE_PROJECT, MAIN_EXIT) == false) {
                printInvalidOptionMessage();
            }

        } while (isMenuInputStringValid(optionInput, CREATE_PROJECT, MAIN_EXIT) == false);

        selectedOption = optionInput[0];

        switch(selectedOption){
            case CREATE_PROJECT:
                cout << "Projeto criado" << endl;
                suiteTestMenu();
                //TODO: Criar projetos
                break;
            case ASK_FOR_ACCESS_PROJECT:
                cout << "Acesso solicitado" << endl;
                //TODO: Acessar projetos
                break;
            case SEARCH_PROJECT:
                cout << "Projeto encontrado" << endl;
                //TODO: Buscar projetos
                break;
            case EDIT_PROJECT:
                cout << "Projeto editado" << endl;
                //TODO: Editar projetos
                break;
            case LOGOUT:
                cout << LOGOUT_MSG << endl;
                logout();
                break;
            case MAIN_EXIT:
                *isDone = true;
                return;
            default:
                cout << INVALID_OPTION << endl;
                break;
        }
    
        pauseSystem();
    } while(selectedOption != LOGOUT && selectedOption != MAIN_EXIT);
}

void printSystemMenu(string userName) {
    system(CLEAR);
    printHeader(MAIN_HEADER);
    cout << MAIN_MENU << endl;
}