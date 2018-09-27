#include "suiteTest.h"
#include "constants.h"
#include "validation.h"
#include "generalPrints.h"
#include <string>
#include <vector>
#include <fstream>

#define SUITES_PATH "suites.txt"

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

    while(suitesFile >> current.name >> current.description) {
        suites.push_back(current);
    }
    suitesFile.close();

    return suites;
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
int searchSuite(std::vector<suite> suites, suite current) {
    std::string name = removeWhiteSpaces(current.name);
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
bool containsSuite(std::vector<suite> suites, suite current) {
    return searchSuite(suites, current) != -1;
}

/**
 * This method creates a new suite if there isnt one with the same name
 * already created and save it in the suites file.
 */
void createSuite() {
    std::vector<suite> suites = readSuites();
    suite newSuite = readSuiteInformation();

    if (containsSuite(suites, newSuite)) {
        showMessage(CREATION_FAILED);
    } else {
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
    std::vector<suite> suites = readSuites();
    for (int i = 0; i < suites.size(); i++) {
        std::cout << suites[i].name << "   |   " << suites[i].description << std::endl;
    }
    pauseSystem();
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
