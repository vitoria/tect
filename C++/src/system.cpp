#include "system.h"

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

            if (isMenuInputStringValid(optionInput, '1', '5') == false) {
                printInvalidOptionMessage();
            }
        } while (isMenuInputStringValid(optionInput, '1', '5') == false);

        system("clear");

        selectedOption = optionInput[0];

        switch(selectedOption){
            case '1':
                cout << "Projeto criado" << endl;
                break;
            case '2':
                cout << "Acesso solicitado" << endl;
                break;
            case '3':
                cout << "Projeto encontrado" << endl;
                break;
            case '4':
                cout << "Projeto editado" << endl;
                break;
            case '5':
                cout << "Saindo do usuário atual..." << endl;
                logout();
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        cout << "Pressione ENTER para continuar..." << endl;
        cin.get();
        system ("clear");
    } while (selectedOption != '5');
}

void printSystemMenu(string userName) {
    system ("clear");
    printTectHeader();
    cout << "Bem-vindo " << userName << "! Selecione a opção desejada: " << endl;
    cout << "(1) Criar Projeto" << endl;
    cout << "(2) Pedir acesso a um projeto" << endl;
    cout << "(3) Pesquisar Projeto" << endl;
    cout << "(4) Editar Projeto" << endl;
    cout << "(5) Logout" << endl;
}