#include "system.h"
#include "constants.h"

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
                cout << "Projeto criado" << endl;
                break;
            case ASK_FOR_ACCESS_PROJECT:
                cout << "Acesso solicitado" << endl;
                break;
            case SEARCH_PROJECT:
                cout << "Projeto encontrado" << endl;
                break;
            case EDIT_PROJECT:
                cout << "Projeto editado" << endl;
                break;
            case LOGOUT:
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
    printTectHeader();
    cout << "Bem-vindo " << userName << "! Selecione a opção desejada: \n";
    cout << "(1) Criar Projeto\n"
            "(2) Pedir acesso a um projeto\n"
            "(3) Pesquisar Projeto\n"
            "(4) Editar Projeto\n"
            "(5) Logout\n";
}