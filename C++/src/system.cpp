#include "system.h"
#include "constants.h"
#include "suiteTest.h"
#include "createrProject.h"
#include "menuProject.h"
#include "dataManagerProject.h"

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

            optionInput = readOption();
            cin.ignore();

            if (isMenuInputStringValid(optionInput, CREATE_PROJECT, LOGOUT) == false) {
                printInvalidOptionMessage();
            }

        } while (isMenuInputStringValid(optionInput, CREATE_PROJECT, LOGOUT) == false);

        system(CLEAR);

        selectedOption = optionInput[0];

        switch(selectedOption){
            case CREATE_PROJECT:
                createProject(loggedUser);
                break;
            case ASK_FOR_ACCESS_PROJECT:
                askPermission(loggedUser);
                break;
            case SEARCH_PROJECT:
                cleanFile();
                // not implemented
                break;
            case EDIT_PROJECT:
                verifyUserToProject(loggedUser);
                break;
            case LOGOUT:
                cout << LOGOUT_MSG << endl;
                logout();
                break;
            default:
                cout << INVALID_OPTION << endl;
                break;
        }
    
        cout << PAUSE_MSG << endl;
        cin.get();
        system(CLEAR);
    } while(selectedOption != LOGOUT);
}

void printSystemMenu(string userName) {
    system(CLEAR);
    printHeader();
    cout << "Bem-vindo " << userName << "!" << endl;
    cout << MAIN_MENU << endl;
}