#include "suiteTest.h"
#include "constant.h"

typedef struct suite {
    string name;
    string description;
} suite;

void showSuiteTestMenu() {
    system(CLEAR);
    printHeader();
    cout << SUITE_MENU << endl;
}

void suiteTestMenu() {
    string optionSelected;
    bool isOptionValid;

    do {
        showSuiteTestMenu();
        cin >> optionSelected;

        isOptionValid = isMenuInputStringValid(optionSelected, CREATE_SUITE, GO_BACK);

        if (!isOptionValid) {
            cout << INVALID_OPTION << endl;
        }

    } while (!isOptionValid);

    goToProcediment(optionSelected);
}

void goToProcediment(char optionSelected) {
    switch(optionSelected) {
        case CREATE_SUITE:
            // TODO: go to the create suite procediment
            break;
        case LIST_SUITES:
            // TODO: go to the list suites procediment
            break;
        case SEARCH_SUITE:
            // TODO: go to the search suite procediment
            break;
        case EDIT_SUITE:
            // TODO: go to the edit suite procediment
            break;
        case DELETE_SUITE:
            // TODO: go to the delete procediment
            break;
        default:
            // TODO: go to the previous menu
            break;
    }
}

void createSuite() {
    suite newSuite = readSuiteInformation();

    // TODO: Validate the suite information and save it in the file
}

suite readSuiteInformation() {
    suite newSuite;

    cout << NAME;
    cin >> newSuite.name;
    
    cout << DESCRIPTION;
    cin >> newSuite.description;

    return newSuite;
}