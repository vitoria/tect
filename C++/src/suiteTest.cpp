#include "suiteTest.h"
#include "constants.h"
#include "validation.h"
#include "generalPrints.h"
#include "testCase.h"
#include <string>
#include <vector>
#include <fstream>

using namespace std;

/**
 * This struct represents a suite
 * that contains an automatic generated id,
 * a name and a simple description.
 */

string generateTestSuiteFilePath(int projectId) {
    return string(DATA_FOLDER_PATH) + "/" + to_string(projectId) + "/" + string(SUITES_FILE_PATH);
}

string generateTestSuiteFolderPath(int projectId) {
    return string(DATA_FOLDER_PATH) + "/" + to_string(projectId);
}

/**
 * This method receive a list of suites and write them in a file.
 */
void writeSuites(vector<suite> suites, int projectId) {
    string filePath = generateTestSuiteFilePath(projectId);
    string folderPath = generateTestSuiteFolderPath(projectId);
    if (isFolderCreated(folderPath)){
        ofstream suitesFile(filePath, ios::out);
        for (int i = 0; i < suites.size(); i++) {
            suitesFile << suites[i].id << endl;
            suitesFile << suites[i].name << endl;
            suitesFile << suites[i].description << endl;
        }
        suitesFile.close();
    }
}

/**
 * This method read all the suites writen in a file
 * and put them in a vector and return it.
 */
vector<suite> readSuites(int projectId) {
    string filePath = generateTestSuiteFilePath(projectId);
    ifstream suitesFile(filePath, ios::in);
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

    cin.ignore();

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
void createSuite(int projectId) {
    printHeader(CREATE_SUITE_HEADER);
    vector<suite> suites = readSuites(projectId);
    suite newSuite = readSuiteInformation();

    if (containsSuite(suites, newSuite.name)) {
        showMessage(CREATION_FAILED);
    } else {
        newSuite.id = generateId(suites);
        suites.push_back(newSuite);
        writeSuites(suites, projectId);
        showMessage(CREATION_SUCCESS);
    }
}

/**
 * This method shows the informations about all suites
 * saved in the suites file.
 */
void listSuites(int projectId) {
    printHeader(SUITE_LIST_HEADER);
    vector<suite> suites = readSuites(projectId);

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
void editSuite(vector<suite> suites, int index, int projectId) {
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
        writeSuites(suites, projectId);
        showMessage(SUITE_EDITED);
    }

}

/**
 * Edit suuite procedure.
 */
void editSuite(int projectId) {
    printHeader(EDIT_SUITE_HEADER);
    string selectedSuite = readSelectedSuite();
    vector<suite> suites = readSuites(projectId);

    if (isStringNumeric(selectedSuite)) {
        int id = stringToInteger(selectedSuite);
        if (containsSuite(suites, id)) {
            editSuite(suites, searchSuite(suites, id), projectId);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    } else {
        if (containsSuite(suites, selectedSuite)) {
            editSuite(suites, searchSuite(suites, selectedSuite), projectId);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    }
}

/**
 * It deletes the suite from index in the suites.
 */
void deleteSuite(vector<suite> suites, int index, int projectId) {
    suites.erase(suites.begin() + index);
    writeSuites(suites, projectId);
}

/**
 * Delete suite test procedure.
 */
void deleteSuite(int projectId) {
    printHeader(DELETE_SUITE_HEADER);
    string selectedSuite = readSelectedSuite();
    vector<suite> suites = readSuites(projectId);

    if (isStringNumeric(selectedSuite)) {
        int id = stringToInteger(selectedSuite);
        if (containsSuite(suites, id)) {
            deleteSuite(suites, searchSuite(suites, id), projectId);
            showMessage(SUITE_DELETED);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    } else {
        if (containsSuite(suites, selectedSuite)) {
            deleteSuite(suites, searchSuite(suites, selectedSuite), projectId);
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
    cout << "Status: " << calculateStatus(current, CASE_PASSED) << "% dos casos de testes passaram." << endl;

    pauseSystem();
}

/**
 * Search suite procedure.
 */
void searchSuite(int projectId) {
    printHeader(SEARCH_SUITE_HEADER);
    string selectedSuite = readSelectedSuite();
    vector<suite> suites = readSuites(projectId);
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
 * This funcion opens the test case manager passing the test suite id.
 */
void manageTestCases(int projectId) {
    printHeader(TEST_CASE_MANAGER_HEADER);
    string selectedSuite = readSelectedSuite();
    vector<suite> suites = readSuites(projectId);
    if (isStringNumeric(selectedSuite)) {
        int id = stringToInteger(selectedSuite);
        if (containsSuite(suites, id)) {
            testCaseMenu(projectId, id);
        } else {
            showMessage(SUITE_NOT_FOUND);
        }
    } else {
        if (containsSuite(suites, selectedSuite)) {
            testCaseMenu(projectId, searchSuite(suites, selectedSuite));
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
void goToProcediment(char optionSelected, int projectId) {
    switch(optionSelected) {
        case CREATE_SUITE:
            createSuite(projectId);
            break;
        case LIST_SUITES:
            listSuites(projectId);
            break;
        case SEARCH_SUITE:
            searchSuite(projectId);
            break;
        case EDIT_SUITE:
            editSuite(projectId);
            break;
        case DELETE_SUITE:
            deleteSuite(projectId);
            break;
        case MANAGE_TEST_CASES:
            manageTestCases(projectId);
            break;
        default:
            break;
    }
}

/**
 * This method initializes the suiteTests module.
 */
void suiteTestMenu(int projectId) {
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

        goToProcediment(optionSelected[0], projectId);

    } while (optionSelected[0] != GO_BACK);
}

float calculateStatus(suite suite, int whichStatus){
    vector<Case> cases = readCases(suite.projectId, suite.id);

    float status = 0.0;

    if (cases.size() > 0){
        float statusCases = 0;
        for (int i = 0; i < cases.size(); i++){         
            if(cases[i].status == whichStatus){
                statusCases++;
            }
        }
        status = (statusCases / cases.size()) * 100;
    }
    return status;
}