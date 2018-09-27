#include "suiteTest.h"
#include "constants.h"
#include "validation.h"
#include "generalPrints.h"
#include <string>
#include <vector>
#include <fstream>
#include <iomanip>

/**
 * This struct represents a suite
 * that contains an automatic generated id,
 * a name and a simple description.
 */
struct suite {
    int id;
    std::string name;
    std::string description;
};

/**
 * This method receive a list of suites and write them in a file.
 */
void writeSuites(std::vector<suite> suites) {
    std::ofstream suitesFile(SUITES_PATH, std::ios::out);
    for (int i = 0; i < suites.size(); i++) {
        suitesFile << suites[i].id << std::endl;
        suitesFile << suites[i].name << std::endl;
        suitesFile << suites[i].description << std::endl;
    }
    suitesFile.close();
}

/**
 * This method read all the suites writen in a file
 * and put them in a vector and return it.
 */
std::vector<suite> readSuites() {
    std::ifstream suitesFile(SUITES_PATH, std::ios::in);
    std::vector<suite> suites;
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
int generateId(std::vector<suite> suites) {
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

    printHeader(CREATE_SUITE_HEADER);
    std::cout << NAME;
    std::cin >> newSuite.name;

    std::cout << DESCRIPTION;
    std::cin >> newSuite.description;

    return newSuite;
}

/**
 * Search for an suite that has the same name from the current suite
 * in the suites. If find it, returns a natural number,
 * otherwise returns a negative one.
 */
int searchSuite(std::vector<suite> suites, std::string current) {
    std::string name = removeWhiteSpaces(current);
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
 * This method checks if the suites contains a suite with the same name
 * than the current.
 */
bool containsSuite(std::vector<suite> suites, std::string current) {
    return searchSuite(suites, current) != -1;
}

/**
 * This method creates a new suite if there isnt one with the same name
 * already created and save it in the suites file.
 */
void createSuite() {
    std::vector<suite> suites = readSuites();
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
    std::vector<suite> suites = readSuites();
    std::setfill('0');

    showLine();
    std::cout << TABLE_HEADER << std::endl;
    showLine();
    for (int i = 0; i < suites.size(); i++) {
        std::cout << "-    " << std::setfill('0') << std::setw(4) << suites[i].id
        << "    | " << truncate(suites[i].name, 28) << " -" << std::endl;
    }
    showLine();
    pauseSystem();
}

/**
 * It read the user's selected suite tests and returns it.
 */
std::string readSelectedSuite() {
    std::string selectedSuite;
    std::cout << CHOOSE_SUITE;
    std::cin >> selectedSuite;
    return selectedSuite;
}

/**
 * It deletes the suite from index in the suites.
 */
void deleteSuite(std::vector<suite> suites, int index) {
    suites.erase(suites.begin() + index);
    writeSuites(suites);
}

/**
 * Delete suite test procedure.
 */
void deleteSuite() {
    printHeader(DELETE_SUITE_HEADER);
    std::string selectedSuite = readSelectedSuite();
    std::vector<suite> suites = readSuites();

    if (containsSuite(suites, selectedSuite)) {
        deleteSuite(suites, searchSuite(suites, selectedSuite));
        showMessage(SUITE_DELETED);
    } else {
        showMessage(SUITE_NOT_FOUND);
    }
}
/**
 * It shows the suiteTests main menu.
 */
void showSuiteTestMenu() {
    printHeader(SUITE_MENU_HEADER);
    std::cout << SUITE_MENU << std::endl;
}

/**
 * This method chooses the procediment that should be
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
            // TODO: go to the search suite procediment
            break;
        case EDIT_SUITE:
            // TODO: go to the edit suite procediment
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
    std::string optionSelected;
    bool isOptionValid;

    do {
        do {
            showSuiteTestMenu();
            optionSelected = readOption();;

            isOptionValid = isMenuInputStringValid(optionSelected, CREATE_SUITE, GO_BACK);

            if (!isOptionValid) {
                std::cout << INVALID_OPTION << std::endl;
            }

        } while (!isOptionValid);

        goToProcediment(optionSelected[0]);

    } while (optionSelected[0] != GO_BACK);
}
