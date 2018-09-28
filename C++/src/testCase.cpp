#include "testCase.h"

using namespace std;

string generateTestCaseFilePath(int projectId, int suiteId) {
    return string(DATA_FOLDER_PATH) + "/" + to_string(projectId) + "/" + to_string(suiteId) + ".dat";
}

string generateTestCaseFolderPath(int projectId) {
    return string(DATA_FOLDER_PATH) + "/" + to_string(projectId);
}

void writeCases(vector<Case> cases, int projectId, int suiteId) {
    string filePath = generateTestCaseFilePath(projectId, suiteId);
    string folderPath = generateTestCaseFolderPath(projectId);
    if (isFolderCreated(folderPath)) {
        ofstream casesFile(filePath, ios::out);
        if (casesFile.is_open()) {
            for (int i = 0; i < cases.size(); i++) {
                casesFile << cases[i].id << endl << cases[i].name << endl << cases[i].objectives << endl << cases[i].preconditions << endl;
                casesFile << cases[i].steps.size() << endl;
                for (int j = 0; j < cases[i].steps.size(); j++) {
                    casesFile << cases[i].steps[j].description << endl;
                    casesFile << cases[i].steps[j].expectedResult << endl;
                }
                casesFile << cases[i].status << endl;
            }
            casesFile.close();
        }
    } else {
        cout << "CASE FILE NOT CREATED FLAG" << endl;
    }
}

vector<Case> readCases(int projectId, int suiteId) {
    string filePath = generateTestCaseFilePath(projectId, suiteId);
    vector<Case> cases;
    Case currentCase;
    Step currentCaseStep;
    int stepsVectorSize;
    int id;
    string trash;

    ifstream casesFile(filePath, ios::in);
    if (casesFile.is_open()) {

        while(casesFile >> currentCase.id) {
            getline(casesFile, trash);
            getline(casesFile, currentCase.name);
            getline(casesFile, currentCase.objectives);
            getline(casesFile, currentCase.preconditions);
            casesFile >> stepsVectorSize;
            getline(casesFile, trash);
            for (int i = 0; i < stepsVectorSize; i++) {
                casesFile >> currentCaseStep.description >> currentCaseStep.expectedResult;
                currentCase.steps.push_back(currentCaseStep);
            }
            casesFile >> currentCase.status;
            cases.push_back(currentCase);
        }
        casesFile.close();
    } else {
        cout << "CASE FILE NOT OPENED FLAG" << endl;
    }

    return cases;
}

bool isFolderCreated (string folderPath) {
    bool result;
    struct stat st = {0};

    if (stat(folderPath.c_str(), &st) == -1) {
        result = createFolder(folderPath);
    } else {
        result = true;
    }

    return result;
}

bool createFolder(string folderPath) {
    bool result = false;
    if (mkdir(folderPath.c_str(), 0700) == 0) {
        result = true;
    }
    return result;
}

Case readCaseInformation() {
    Case newCase;
    Step newStep;
    cin.ignore();

    cout << NAME;
    getline(cin, newCase.name);

    cout << OBJECTIVE;
    getline(cin,newCase.objectives);

    cout << PRECONDITIONS;
    getline(cin, newCase.preconditions);

    string hasAnotherStep;
    cout << CASE_STEPS_READING_HEADER << endl;
    do{
        cout << "- Passo " << newCase.steps.size() + 1 << endl;
        cout << CASE_STEP_DESCRIPTION;
        getline(cin, newStep.description);
        
        cout << CASE_STEP_EXPECTED_RESULT;
        getline(cin, newStep.expectedResult);

        newCase.steps.push_back(newStep);

        cout << CASE_STEP_CONTINUE_MESSAGE << endl;
        getline(cin, hasAnotherStep);
    } while (isMenuInputStringValid(stringToUpper(hasAnotherStep), 'S', 'S'));

    newCase.status = CASE_NOT_EXECUTED;

    return newCase;
}

int searchCase(vector<Case> cases, string current) {
    std::string name = removeWhiteSpaces(current);
    int index = 0;

    while (index < cases.size() && 
            name.compare(removeWhiteSpaces(cases[index].name)) != 0) {
        index += 1;
    }

    if (index >= cases.size()) {
        index = -1;
    }

    return index;
}

int searchCase(vector<Case> cases, int id) {
    int index = 0;

    while (index < cases.size() && 
            id != cases[index].id) {
        index += 1;
    }

    if (index >= cases.size()) {
        index = -1;
    }

    return index;
}

bool containsCase(vector<Case> cases, string current) {
    return searchCase(cases, current) != -1;
}

bool containsCase(vector<Case> cases, int id) {
    return searchCase(cases, id) != -1;
}

void createCase(int projectId, int suiteId) {
    printHeader(CREATE_CASE_HEADER);
    vector<Case> cases = readCases(projectId, suiteId);
    Case newCase = readCaseInformation();

    if (containsCase(cases, newCase.name)) {
        showMessage(CREATION_FAILED);
    } else {
        newCase.id = generateId(cases);
        cases.push_back(newCase);
        writeCases(cases, projectId, suiteId);
        showMessage(CREATION_SUCCESS);
    }
}

void listTestsCases(int projectId, int suiteId) {
    printHeader(TEST_CASE_HEADER);
    vector<Case> cases = readCases(projectId, suiteId);
    
    cout << TEST_CASE_TABLE_LINE << endl;
    cout << TEST_CASE_TABLE_HEADER << endl;
    cout << TEST_CASE_TABLE_LINE << endl;
    for(int i = 0; i < cases.size(); i++) {
        cout << "-    ";
        showID(cases[i].id);
        cout << "    | " << truncate(cases[i].name, 28) << "|" << truncate(caseStatusMessage[cases[i].status], 16) << "-" << endl;
    }
    cout << TEST_CASE_TABLE_LINE << endl;
    pauseSystem();
}

string readSelectedCase() {
    string selectedCase;
    cout << CHOOSE_CASE;
    cin >> selectedCase;
    return selectedCase;
}

void showCase(Case current) {
    printHeader(CASE_DETAILS);
    cout << "ID: ";
    showID(current.id);
    cout << "\nNome: " << current.name << endl;
    cout << "Objetivos: " << current.objectives << endl;
    cout << "Pré-condições: " << current.preconditions << endl;
    cout << "Passos: " << endl;
    for (int i = 0; i < current.steps.size(); i++) {
        cout << "Passo " << i + 1 << ":" << endl;
        cout << "\tDescrição: " << current.steps[i].description << endl;
        cout << "\tResultado esperado: " << current.steps[i].expectedResult << endl;
    }
    cout << "Status: " << caseStatusMessage[current.status] << endl;

    pauseSystem();
}

void searchCase(int projectId, int suiteId) {
    printHeader(SEARCH_CASE_HEADER);
    string selectedCase = readSelectedCase();
    vector<Case> cases = readCases(projectId, suiteId);
    if (isStringNumeric(selectedCase)) {
        int id = stringToInteger(selectedCase);
        if (containsCase(cases, id)) {
            showCase(cases[searchCase(cases, id)]);
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    } else {
        if (containsCase(cases, selectedCase)) {
            showCase(cases[searchCase(cases, selectedCase)]);
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    }
}

Case editCaseInformation(Case editedCase) {
    return editedCase;
}

void editCase(vector<Case> cases, int index, int projectId, int suiteId) {
    printHeader();
    cout << "#----------# EDITANDO CASO ";
    showID(cases[index].id);
    cout << " #----------#" << endl << endl;

    Case editedCase = readCaseInformation();

    if (containsCase(cases, editedCase.name)) {
        showMessage(CREATION_FAILED);
    } else {
        cases[index].name = editedCase.name;
        cases[index].objectives = editedCase.objectives;
        cases[index].preconditions = editedCase.preconditions;
        cases[index].status = editedCase.status;
        cases[index].steps = editedCase.steps;
        writeCases(cases, projectId, suiteId);
        showMessage(CASE_EDITED);
    }

}

void editCaseStatus(vector<Case> cases, int index, int projectId, int suiteId) {
    printHeader();
    cout << "#----------# EDITANDO STATUS ";
    showID(cases[index].id);
    cout << " #----------#" << endl << endl;

    string optionSelected;
    bool isOptionValid;
    do {
        cout << "(1) Não executado" << endl;
        cout << "(2) Passou" << endl;
        cout << "(3) Não passou" << endl;
        cout << "(4) Erro na execução" << endl;
        
        optionSelected = readOption();

        isOptionValid = isMenuInputStringValid(optionSelected, '1', '4');

        if (!isOptionValid) {
            cout << INVALID_OPTION << endl;
        }

    } while (!isOptionValid);

    int newStatus = stringToInteger(optionSelected) - 1;
    cases[index].status = newStatus;
    writeCases(cases, projectId, suiteId);
    showMessage(CASE_EDITED);
}

int readEditOption() {
    string optionSelected;
    bool isOptionValid;
    do {
        cout << "O que deseja editar?" << endl;
        cout << "(1) Dados do Caso de Teste" << endl;
        cout << "(2) Status do Caso de Teste" << endl;
        
        optionSelected = readOption();

        isOptionValid = isMenuInputStringValid(optionSelected, '1', '2');

        if (!isOptionValid) {
            std::cout << INVALID_OPTION << std::endl;
        }

    } while (!isOptionValid);
    return stringToInteger(optionSelected);
}

void editCase(int projectId, int suiteId) {
    printHeader(EDIT_CASE_HEADER);
    string selectedCase = readSelectedCase();
    vector<Case> cases = readCases(projectId, suiteId);

    int selectedOption = readEditOption();

    if (isStringNumeric(selectedCase)) {
        int id = stringToInteger(selectedCase);
        if (containsCase(cases, id)) {
            if (selectedOption == 1) {
                editCase(cases, searchCase(cases, id), projectId, suiteId);
            } else {
                editCaseStatus(cases, searchCase(cases, id), projectId, suiteId);
            }
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    } else {
        if (containsCase(cases, selectedCase)) {
            if (selectedOption == 1) {
                editCase(cases, searchCase(cases, selectedCase), projectId, suiteId);
            } else {
                editCaseStatus(cases, searchCase(cases, selectedCase), projectId, suiteId);
            }
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    }
}

void deleteCase(vector<Case> cases, int index, int projectId, int suiteId) {
    cases.erase(cases.begin() + index);
    writeCases(cases, projectId, suiteId);
}

void deleteCase(int projectId, int suiteId) {
    printHeader(DELETE_CASE_HEADER);
    string selectedCase = readSelectedCase();
    vector<Case> cases = readCases(projectId, suiteId);

    if (isStringNumeric(selectedCase)) {
        int id = stringToInteger(selectedCase);
        if (containsCase(cases, id)) {
            deleteCase(cases, searchCase(cases, id), projectId, suiteId);
            showMessage(CASE_DELETED);
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    } else {
        if (containsCase(cases, selectedCase)) {
            deleteCase(cases, searchCase(cases, selectedCase), projectId, suiteId);
            showMessage(CASE_DELETED);
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    }
}

int generateId(vector<Case> cases) {
    int id = 1;
    
    if (cases.size() > 0) {
        id = cases[cases.size() - 1].id + 1;
    }

    return id;
}

void showTestCaseMenu() {
    printHeader(TEST_CASE_MENU_HEADER);
    std::cout << TEST_CASE_MENU << std::endl;
}

void goToProcediment(char optionSelected, int projectId, int suiteId) {
    switch(optionSelected) {
        case CREATE_CASE:
            createCase(projectId, suiteId);
            break;
        case LIST_CASES:
            listTestsCases(projectId, suiteId);
            break;
        case SEARCH_CASES:
            searchCase(projectId, suiteId);
            break;
        case EDIT_CASES:
            editCase(projectId, suiteId);
            break;
        case DELETE_CASES:
            deleteCase(projectId, suiteId);
            break;
        default:
            break;
    }
}

void testCaseMenu(int projectId, int suiteId) {
    string optionSelected;
    bool isOptionValid;

    do {
        do {
            showTestCaseMenu();
            optionSelected = readOption();;

            isOptionValid = isMenuInputStringValid(optionSelected, CREATE_SUITE, GO_BACK);

            if (!isOptionValid) {
                std::cout << INVALID_OPTION << std::endl;
            }

        } while (!isOptionValid);

        goToProcediment(optionSelected[0], projectId, suiteId);

    } while (optionSelected[0] != GO_BACK);
}