#include "myUser.h"
#include "generalPrints.h"
#include "constants.h"
#include "validation.h"
#include <string>
#include <vector>
#include <fstream>

using namespace std;

/**
 * This struct represents a user
 * that contains name, username and password.
 */
struct user {
    string name;
    string username;
    string password;
};

/**
 * Receives a collection of users and write them in a file;
 */
void writeUser(vector<user> users) {
    ofstream usersFile(USERS_FILE_PATH, ios::out);
    for (int i = 0; i < users.size(); i++) {
        usersFile << users[i].username << endl;
        usersFile << users[i].password << endl;
        usersFile << users[i].name << endl;
    }
    usersFile.close();
}

/**
 * This method read all the users writen in a file
 * and put them in a vector and return it.
 */
vector<user> readUsers() {
    ifstream usersFile(USERS_FILE_PATH, ios::in);
    vector<user> users;
    user current;

    while(usersFile >> current.username >> current.password >> current.name) {
        users.push_back(current);
    }
    usersFile.close();

    return users;
}

/**
 * This method reads the users logged from the file and
 * return it.
 */
user readCurrentUser() {
    ifstream userLoggedFile(LOGGED_USER_FILE_PATH, ios::in);
    user current;
    if (userLoggedFile.is_open()) {
        userLoggedFile >> current.username >> current.name;
        userLoggedFile.close();
    } else {
        showMessage("Erro ao abrir o arquivo");
    }

    return current;
}

/**
 * This method returns a string that contains the logged user's username.
 */
string getLoggedUser() {
    return readCurrentUser().username;
}

/**
 * This method receives a collection of users and a user to find into this collection.
 * If there inst a user with the same username than the current, returns -1, else returns
 * its index.
 */
int searchUser(vector<user> users, user current) {
    int index = 0;
    string username = current.username;

    while (index < users.size() && username.compare(users[index].username) != 0) {
        index += 1;
    }

    if (index >= users.size()) {
        index = -1;
    }

    return index;
}

/**
 * Shows the current user's basic informations (name and username).
 */
void showUserProfile() {
    user userLogged = readCurrentUser();
    
    printHeader(MY_USER_HEADER);
    cout << NAME << userLogged.name << endl;
    cout << USERNAME << userLogged.username << endl << endl;
    pauseSystem();
}

/**
 * Change the current user's password.
 */
void changePassword() {
    vector<user> users = readUsers();
    int index = searchUser(users, readCurrentUser());
    user currentUser = users[index];

    string oldPassword;
    string newPassword;
    string newPassword2;

    printHeader(MY_USER_HEADER);
    cout << OLD_PASSWORD;
    cin >> oldPassword;
    cout << NEW_PASSWORD;
    cin >> newPassword;
    cout << REPEAT_NEW_PASSWORD;
    cin >> newPassword2;

    if (currentUser.password.compare(oldPassword) != 0) {
        showMessage(PASSWORD_INCORRECT);
    } else if (verifyPasswords(newPassword, newPassword2)) {
        currentUser.password = newPassword;
        users[index] = currentUser;
        writeUser(users);
        showMessage("Senha alterada!");
    }

}

/**
 * This method chooses the procedure that should be
 * executed according to the selected option. 
 */
void chooseProcedure(char procedure) {
    switch(procedure) {
        case MY_PROFILE:
            showUserProfile();
            break;
        case CHANGE_PASSWORD:
            changePassword();
            break;
        default:
            break;
    }
}

/**
 * It shows the my user menu.
 */
void showMyUserMenu() {
    printHeader(MY_USER_HEADER);
    cout << MY_USER_MENU << endl;
}

/**
 * This method initializes the myUser module.
 */
void myUserMenu() {
    string optionSelected;
    bool isOptionValid;

    do {
        do {
            showMyUserMenu();
            optionSelected = readOption();

            isOptionValid = isMenuInputStringValid(optionSelected, MY_PROFILE, MY_USER_BACK);

            if (!isOptionValid) {
                cout << endl;
                showMessage(INVALID_OPTION);
            }

        } while (!isOptionValid);

        chooseProcedure(optionSelected[0]);

    } while (optionSelected[0] != MY_USER_BACK);
}