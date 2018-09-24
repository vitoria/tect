#include "system.h"

using namespace std;

void running() {
    bool isLogged = loginMenu();
    
    if (isLogged){
        systemMenu();
    }
}

void systemMenu() {
    char selectedOption = '0';
    do {
        do {
            printSystemMenu();

            cin.get(selectedOption);
            cin.ignore();

            if (isSelectedOptionValid(selectedOption, '1', '5') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '5') == false);

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
                cout << "Encerrando sistema..." << endl;
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

void printSystemMenu() {
    system ("clear");
    printTectHeader();
    cout << "Bem-vindo #NOME_DO_USUARIO#! Selecione a opção desejada: " << endl;
    cout << "(1) Criar Projeto" << endl;
    cout << "(2) Pedir acesso a um projeto" << endl;
    cout << "(3) Pesquisar Projeto" << endl;
    cout << "(4) Editar Projeto" << endl;
    cout << "(5) Sair" << endl;
}