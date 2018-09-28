#include "suiteTest.h"

using namespace std;

/**
 * This method receive a list of suites and write them in a file.
 */
void writeSuites(vector<suite> suites) {
    ofstream suitesFile(SUITES_PATH, ios::out);
    for (int i = 0; i < suites.size(); i++) {
        suitesFile << suites[i].id << endl;
        suitesFile << suites[i].name << endl;
        suitesFile << suites[i].description << endl;
    }
    suitesFile.close();
}

/**
 * This method read all the suites writen in a file
 * and put them in a vector and return it.
 */
vector<suite> readSuites() {
    ifstream suitesFile(SUITES_PATH, ios::in);
    vector<suite> suites;
    suite current;

    while(suitesFile >> current.id >> current.name >> current.description) {
        suites.push_back(current);
    }
    suitesFile.close();

    return suites;
}

/**
 * Generate the an id based on the last suite id. If there is 
 * no suite in the suites, the id is 1.
 */
int generateId(vector<suite> suites) {
    int id = 1;
    
    if (suites.size() > 0) {
        id = suites[suites.size() - 1].id + 1;
    }

    return id;
}

/**
 * Asks the user to informe the new suites information (name and description).
 * All these informations cannot be empty.
 */
suite readSuiteInformation() {
    suite newSuite;

    cout << NAME;
    cin >> newSuite.name;

    cout << DESCRIPTION;
    cin >> newSuite.description;

    return newSuite;
}

/**
 * Search for an suite that has the same name from the current suite
 * in the suites. If find it, returns a natural number,
 * otherwise returns a negative one.
 */
int searchSuite(vector<suite> suites, string current) {
    string name = removeWhiteSpaces(current);
    int index = 0;

    while (index < suites.size() && 
            name.compare(removeWhiteSpaces(suites[index].name)) != 0) {
        index += 1;
    }

    if (index >= suites.size()) {
        index = -1;
    }

    return index;
}

/**
 * Search for a suite that has the same id from the current suite
 * in the suites. If find it, returns a natural number,
 * otherwise returns a negative one.
 */
int searchSuite(vector<suite> suites, int id) {
    int index = 0;

    while (index < suites.size() && 
            id != suites[index].id) {
        index += 1;
    }

    if (index >= suites.size()) {
        index = -1;
    }

    return index;
}

/**
 * This method checks if the suites contains a suite with the same name
 * than the current.
 */
bool containsSuite(vector<suite> suites, string current) {
    return searchSuite(suites, current) != -1;
}

/**
 * This method checks if the suites contains a suite with the same id
 * than the current.
 */
bool containsSuite(vector<suite> suites, int id) {
    return searchSuite(suites, id) != -1;
}

/**
 * This method creates a new suite if there isnt one with the same name
 * already created and save it in the suites file.
 */
void createSuite() {
    printHeader(CREATE_SUITE_HEADER);
    vector<suite> suites = readSuites();
    suite newSuite = readSuiteInformation();

    if (containsSuite(suites, newSuite.name)) {
        showMessage(CREATION_FAILED);
    } else {
        newSuite.id = generateId(suites);
        suites.push_back(newSuite);
        writeSuites(suites);
        showMessage(CREATION_SUCCESS);
    }
}

/**
 * This method shows the informations about all suites
 * saved in the suites file.
 */
void listSuites() {
    printHeader(SUITE_LIST_HEADER);
    vector<suite> suites = readSuites();

    showLine();
    cout << TABLE_HEADER << endl;
    showLine();
    for (int i = 0; i < suites.size(); i++) {
        cout << "-    ";
        showID(suites[i].id);
        cout << "    | " << truncate(suites[i].name, 28) << " -" << endl;
    }
    showLine();
    pauseSystem();
}

/**
 * It read the user's selected suite tests and returns it.
 */
string readSelectedSuite() {
    string selectedSuite;
    cout << CHOOSE_SUITE;
    cin >> selectedSuite;
    return selectedSuite;
}

/**
 * Edit the suite in the index position.
 */
void editSuite(vector<suite> suites, int index) {
    printHeader();
    cout << "#----------# EDITING SUITE ";
    showID(suites[index].id);
    cout << " #----------#" << endl << endl;

    suite editedSuite = readSuiteInformation();

    if (containsSuite(suites, editedSuite.name)) {
        showMessage(CREATION_FAILED);
    } else {
        suites[index].name = editedSuite.name;
        suites[index].description = editedSuite.description;
        writeSuites(suites);
        showMessage(SUITE_EDITED);
    }

}

/**
 * Edit suuite procedure.
 */
void editSuite() {
    printHeader(EDIT_SUITE_HEADER);
    string selectedSuite = readSelectedSuite();
    vector<suite> suites = readSuites();

    if (isStringNumeric(selectedSuite)) {
        int id = stringToInteger(selectedSuite);
        if (containsSuite(suites, id)) {
            editSuite(suites, searchSuite(suites, id));
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    } else {
        if (containsSuite(suites, selectedSuite)) {
            editSuite(suites, searchSuite(suites, selectedSuite));
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    }
}

/**
 * It deletes the suite from index in the suites.
 */
void deleteSuite(vector<suite> suites, int index) {
    suites.erase(suites.begin() + index);
    writeSuites(suites);
}

/**
 * Delete suite test procedure.
 */
void deleteSuite() {
    printHeader(DELETE_SUITE_HEADER);
    string selectedSuite = readSelectedSuite();
    vector<suite> suites = readSuites();

    if (isStringNumeric(selectedSuite)) {
        int id = stringToInteger(selectedSuite);
        if (containsSuite(suites, id)) {
            deleteSuite(suites, searchSuite(suites, id));
            showMessage(SUITE_DELETED);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    } else {
        if (containsSuite(suites, selectedSuite)) {
            deleteSuite(suites, searchSuite(suites, selectedSuite));
            showMessage(SUITE_DELETED);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    }
}

/**
 * Show the suites details.
 */
void showSuite(suite current) {
    printHeader(SUITE_DETAILS);
    cout << "ID: ";
    showID(current.id);
    cout << "\nNome: " << current.name << endl;
    cout << "Descrição: " << current.description << endl;
    cout << "Status: " << "100\n";

    pauseSystem();
}

/**
 * Search suite procedure.
 */
void searchSuite() {
    printHeader(SEARCH_SUITE_HEADER);
    string selectedSuite = readSelectedSuite();
    vector<suite> suites = readSuites();
    if (isStringNumeric(selectedSuite)) {
        int id = stringToInteger(selectedSuite);
        if (containsSuite(suites, id)) {
            showSuite(suites[searchSuite(suites, id)]);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    } else {
        if (containsSuite(suites, selectedSuite)) {
            showSuite(suites[searchSuite(suites, selectedSuite)]);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    }
}

/**
 * It shows the suiteTests main menu.
 */
void showSuiteTestMenu() {
    printHeader(SUITE_MENU_HEADER);
    cout << SUITE_MENU << endl;
}

/**
 * This method chooses the procedure that should be
 * executed according to the selected option. 
 */
void goToProcediment(char optionSelected) {
    switch(optionSelected) {
        case CREATE_SUITE:
            createSuite();
            break;
        case LIST_SUITES:
            listSuites();
            break;
        case SEARCH_SUITE:
            searchSuite();
            break;
        case EDIT_SUITE:
            editSuite();
            break;
        case DELETE_SUITE:
            deleteSuite();
            break;
        default:
            break;
    }
}

/**
 * This method initializes the suiteTests module.
 */
void suiteTestMenu() {
    string optionSelected;
    bool isOptionValid;

    do {
        do {
            showSuiteTestMenu();
            optionSelected = readOption();

            isOptionValid = isMenuInputStringValid(optionSelected, CREATE_SUITE, GO_BACK);

            if (!isOptionValid) {
                cout << INVALID_OPTION << endl;
            }

        } while (!isOptionValid);

        goToProcediment(optionSelected[0]);

    } while (optionSelected[0] != GO_BACK);
}
