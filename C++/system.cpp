#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>

#include "login.cpp"
//#include "generalPrints.cpp"
//#include "validation.cpp"

using namespace std;

//CABEÇALHOS

void running();
void systemMenu();
void printSystemMenu();

//FUNÇÕES

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
    
        cout << "Pressione ENTER para continuar..." << endl;
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