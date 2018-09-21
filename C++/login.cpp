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
bool validateLogin();

bool registerNewUser();

void printLoginMenu();

/*
Menu de login do Sistema TecT, irá retornar true para login efetuado ou false, caso contrário.
*/
bool loginMenu();

//FUNÇÕES

void jumpFileLine(fstream *file) {
    char ch;
    if (file->is_open()){
        while (ch != '\n' && file->get(ch)) {
            //file >> ch;
        }
    }
}

bool existingUserLogin() {
    string user, password, name;
    bool isLogged = false, foundUser = false;
    system("clear");
    printTectHeader();
    cout << "#------------# LOGIN DE USUÁRIO #----------#" << endl;
    
    cout << "Login: ";
    getline(cin, user);

    cout << "Senha: ";
    getline(cin, password);

    string fileOutput = "";
    fstream usersFile;
    usersFile.open(USERS_FILE_NAME, ios::in);
    if (usersFile.is_open()) {
        while (foundUser == false || getline(usersFile, fileOutput)) {
            if (fileOutput.compare(user) == 0) {
                foundUser = true;
            } else {
                getline(usersFile, fileOutput);
                getline(usersFile, fileOutput);
            }
        }
    }

    if (foundUser == true) {
        getline(usersFile, fileOutput);
        if (fileOutput.compare(password)) {
            isLogged = true;
            usersFile >> name;
        }
    }

    usersFile.close();

    return isLogged;
}

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
        fstream usersFile;
        usersFile.open(USERS_FILE_NAME, ios::out | ios::app);
        if (usersFile.is_open()) {
            usersFile << user << endl << password << endl << name << endl;
            isRegistered = true;
            usersFile.close();
            cout << "Usuário cadastrado com sucesso!" << endl;
        } else {
            cout << "ERRO! Usuário não cadastrado!" << endl;
        }
    } else {
        cout << "Senhas informadas não conferem! Usuário não cadastrado!" << endl;
    }

    return isRegistered;
}

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
                isLogged = existingUserLogin();
                isDone = true;
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