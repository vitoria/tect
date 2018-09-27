#include "system.h"
#include "constants.h"
#include "suiteTest.h"
#include "createrProject.h"
#include "menuProject.h"
#include "dataManagerProject.h"

using namespace std;

void running() {
    user loggedUser;
    bool isDone = false;
    
    while (!isDone) {
        if (loginMenu(&loggedUser, &isDone)){
            systemMenu(loggedUser);
        }
    }
}

void systemMenu(user loggedUser) {
    string optionInput;
    char selectedOption;
    do {
        do {
            printSystemMenu(loggedUser.name);

            getline(cin,optionInput);

            if (isMenuInputStringValid(optionInput, CREATE_PROJECT, LOGOUT) == false) {
                printInvalidOptionMessage();
            }

        } while (isMenuInputStringValid(optionInput, CREATE_PROJECT, LOGOUT) == false);

        system(CLEAR);

        selectedOption = optionInput[0];

        switch(selectedOption){
            case CREATE_PROJECT:
                createProject(loggedUser);
                cout << "Projeto criado" << endl;
                //suiteTestMenu();
                break;
            case ASK_FOR_ACCESS_PROJECT:
                cleanFile();
                cout << "Acesso solicitado" << endl;
                break;
            case SEARCH_PROJECT:
                verifyUserToProject(loggedUser);
                break;
            case EDIT_PROJECT:
                cout << "Projeto editado" << endl;
                break;
            case EXIT:
                cout << "Saindo do usuário atual..." << endl;
                logout();
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        cout << PAUSE_MSG << endl;
        cin.get();
        system(CLEAR);
    } while(selectedOption != LOGOUT);
}

void printSystemMenu(string userName) {
    system(CLEAR);
    printHeader();
    cout << "Bem-vindo " << userName << "! Selecione a opção desejada: \n";
    cout << MAIN_MENU << endl;
}