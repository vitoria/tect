#include "login.h"

using namespace std;

void printLoginMenu() {
    system ("clear");
    printTectHeader();
    cout << "Bem-vindo! Selecione a opção desejada: " << endl;
    cout << "(1) Efetuar login" << endl;
    cout << "(2) Cadastrar novo usuário" << endl;
    cout << "(3) Sair" << endl;
}

bool loginMenu() {
    char selectedOption = '0';
    bool loginStatus = false;

    do {
        printLoginMenu();

        cin.get(selectedOption);
        cin.ignore();

        if (isSelectedOptionValid(selectedOption, '1', '3') == false) {
            printInvalidOptionMessage();
        }
    } while (isSelectedOptionValid(selectedOption, '1', '3') == false);

    switch(selectedOption){
        case '1':
            cout << "Login efetuado" << endl;
            loginStatus = true;
            break;
        case '2':
            cout << "Usuário cadastrado" << endl;
            loginStatus = true;
            break;
        case '3':
            cout << "Encerrando sistema..." << endl;
            loginStatus = false;
            break;
        default:
            cout << "ERRO!" << endl;
            loginStatus = false;
            break;
    }

    cout << "Pressione qualquer tecla para continuar..." << endl;
    cin.get();
    system ("clear");
    return loginStatus;
}