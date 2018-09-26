#include "login.h"

#define USERS_FILE_PATH "data/users.dat"
#define DATA_FOLDER_PATH "data"

using namespace std;

bool existingUserLogin(user *loggedUser) {
    string user, password, name;
    bool isLogged = false, foundUser = false;
    system("clear");
    printTectHeader();
    cout << "#------------# LOGIN DE USUÁRIO #----------#" << endl;
    
    cout << "Login: ";
    getline(cin, user);

    cout << "Senha: ";
    getline(cin, password);

    string fileInput;
    ifstream usersFile;
    usersFile.open(USERS_FILE_PATH, ios::in);
    if (usersFile.is_open()) {
        while (foundUser == false && getline(usersFile, fileInput)) {
            if (fileInput.compare(user) == 0) {
                foundUser = true;
            } else {
                getline(usersFile, fileInput);
                getline(usersFile, fileInput);
            }
        }
    }

    if (foundUser == true) {
        getline(usersFile, fileInput);
        if (fileInput.compare(password) == 0) {
            isLogged = true;
            getline(usersFile, name);
            loggedUser->login = user;
            loggedUser->name = name;
            cout << "Login efetuado com sucesso!" << endl;
        } else {
            cout << "Senha incorreta!" << endl;
        }
    } else {
        cout << "Usuário inexistente!" << endl;
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
    if (isUserAlredyRegistered(user) == false) {
        if (password.compare(passwordVerification) == 0) {

            if (isFolderCreated(DATA_FOLDER_PATH) == true){
                ofstream usersFile;
                usersFile.open(USERS_FILE_PATH, ios::out | ios::app);
                if (usersFile.is_open()) {
                    usersFile << user << endl << password << endl << name << endl;
                    isRegistered = true;
                    usersFile.close();
                    cout << "Usuário cadastrado com sucesso!" << endl;
                } else {
                    cout << "ERRO! Usuário não cadastrado!" << endl;
                }
            } else {
                cout << "ERRO! Diretório não encontrado ou falhou na criação." << endl;
            }
        } else {
            cout << "Senhas informadas não conferem! Usuário não cadastrado!" << endl;
        }
    } else {
        cout << "Usuário já cadastrado! Por favor, informe um usuário diferente." << endl;
    }

    return isRegistered;
}

bool isFolderCreated (const char *folderPath) {
    bool result;
    struct stat st = {0};

    if (stat(folderPath, &st) == -1) {
        result = createFolder(folderPath);
    } else {
        result = true;
    }

    return result;
}

bool createFolder(const char *folderPath) {
    bool result = false;
    if (mkdir(folderPath, 0700) == 0) {
        result = true;
    }
    return result;
}

bool isUserAlredyRegistered(string user) {
    bool foundUser = false;
    string fileInput;
    ifstream usersFile;

    usersFile.open(USERS_FILE_PATH, ios::in);
    if (usersFile.is_open()) {
        while (foundUser == false && getline(usersFile, fileInput)) {
            if (fileInput.compare(user) == 0) {
                foundUser = true;
            } else {
                getline(usersFile, fileInput);
                getline(usersFile, fileInput);
            }
        }
    }

    return foundUser;
}

void printLoginMenu() {
    system ("clear");
    printTectHeader();
    cout << "Bem-vindo! Selecione a opção desejada: " << endl;
    cout << "(1) Efetuar login" << endl;
    cout << "(2) Cadastrar novo usuário" << endl;
    cout << "(3) Sair" << endl;
}

bool loginMenu(user *loggedUser, bool *isDone) {
    char selectedOption = '0';
    bool isLogged = false;

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
            isLogged = existingUserLogin(loggedUser);
            break;
        case '2':
            registerNewUser();
            break;
        case '3':
            cout << "Encerrando sistema..." << endl;
            isLogged = false;
            *isDone = true;
            break;
        default:
            cout << "ERRO!" << endl;
            isLogged = false;
            *isDone = true;
            break;
    }
    cout << "Pressione ENTER para continuar..." << endl;
    cin.get();
    system ("clear");

    return isLogged;
}