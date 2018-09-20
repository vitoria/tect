#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>

#include "validation.cpp"
#include "generalPrints.cpp"

#define USERS_FILE_NAME "users.dat"

using namespace std;
//CABEÇALHOS

void printLoginMenu();

/*
Menu de login do Sistema TecT, irá retornar true para login efetuado ou false, caso contrário.
*/
bool loginMenu();

bool registerNewUser() {
    string name, user, password, passwordVerification;
    bool isRegistered = false;

    system("clear");
    printTectHeader();
    cout << "#----------# CADASTRO DE USUÁRIO #---------#" << endl;

    cout << "Nome: ";
    getline(cin, name);

    cout << "Usuário: ";
    getline(cin, user);
    
    cout << "Senha: ";
    getline(cin, password);
    
    cout << "Informe a senha novamente: ";
    getline(cin, passwordVerification);

    system("clear");
    if (password.compare(passwordVerification) == 0) {
        fstream outputFile;
        outputFile.open(USERS_FILE_NAME, ios::in | ios::app);
        if (outputFile.is_open()) {
            outputFile << user << endl << password << endl << name << endl;
            isRegistered = true;
            outputFile.close();
            cout << "Usuário cadastrado com sucesso!" << endl;
        } else {
            cout << "ERRO! Usuário não cadastrado!" << endl;
        }
    } else {
        cout << "Senhas informadas não conferem! Usuário não cadastrado!" << endl;
    }

    return isRegistered;
}

//FUNÇÕES

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
    bool isLogged = false, isDone = false;

    do {
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
                isLogged = true;
                break;
            case '2':
                registerNewUser();
                break;
            case '3':
                cout << "Encerrando sistema..." << endl;
                isLogged = false;
                isDone = true;
                break;
            default:
                cout << "ERRO!" << endl;
                isLogged = false;
                isDone = true;
                break;
        }
        cout << "Pressione ENTER para continuar..." << endl;
        cin.get();
        system ("clear");
    } while(isDone == false);

    return isLogged;
}