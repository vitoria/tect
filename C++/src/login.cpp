#include "login.h"
#include "constants.h"

using namespace std;

bool existingUserLogin(user *loggedUser) {
    string user, password, name;
    bool isLogged = false, foundUser = false;
    system(CLEAR);
    printHeader();
    cout << LOGIN_HEADER << endl;
    
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

    if (isLogged == true) {
        saveLoggedUser(loggedUser);
    }

    return isLogged;
}

void saveLoggedUser(user *loggedUser) {
    ofstream loggedUserFile;
    loggedUserFile.open(LOGGED_USER_FILE_PATH, ios::out);
    if (loggedUserFile.is_open() == true) {
        loggedUserFile << loggedUser->login << endl;
        loggedUserFile << loggedUser->name << endl;
        loggedUserFile.close();
    }
}

bool isUserLogged(user *loggedUser) {
    bool isLogged = false;
    ifstream loggedUserFile;
    loggedUserFile.open(LOGGED_USER_FILE_PATH, ios::in);
    if (loggedUserFile.is_open() == true) {
        getline(loggedUserFile, loggedUser->login);
        getline(loggedUserFile, loggedUser->name);
        isLogged = true;
        loggedUserFile.close();
    }
    return isLogged;
}

void logout() {
    remove(LOGGED_USER_FILE_PATH);
}

bool registerNewUser() {
    string name, user, password, passwordVerification;
    bool isRegistered = false;

    system(CLEAR);
    printHeader();
    cout << SIGN_UP_HEADER << endl;

    cout << "Nome: ";
    getline(cin, name);

    cout << "Usuário: ";
    getline(cin, user);
    
    cout << "Senha: ";
    getline(cin, password);
    
    cout << "Informe a senha novamente: ";
    getline(cin, passwordVerification);

    system(CLEAR);
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
    system (CLEAR);
    printHeader();
    cout << LOGIN_MENU << endl;
}

bool loginMenu(user *loggedUser, bool *isDone) {
    string optionInput;
    char selectedOption;
    bool isLogged = isUserLogged(loggedUser);

    if (isLogged == false) {
        do {
            printLoginMenu();

            getline(cin,optionInput);

        if (isMenuInputStringValid(optionInput, LOGIN, LOGOUT) == false) {
            printInvalidOptionMessage();
        }
    } while (isMenuInputStringValid(optionInput, LOGIN, LOGOUT) == false);

        selectedOption = optionInput[0];

    switch(selectedOption){
        case LOGIN:
            isLogged = existingUserLogin(loggedUser);
            break;
        case SIGN_UP:
            registerNewUser();
            break;
        case EXIT:
            cout << "Encerrando sistema..." << endl;
            isLogged = false;
            *isDone = true;
            break;
        default:
            cout << INVALID_OPTION << endl;
            isLogged = false;
            *isDone = true;
            break;
        }

    } else {
        cout << "Bem-vindo de volta " << loggedUser->name << "!" << endl;
    }

    cout << PAUSE_MSG << endl;
    cin.get();
    system (CLEAR);

    return isLogged;
}