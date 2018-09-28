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

    ifstream casesFile(filePath, ios::in);
    if (casesFile.is_open()) {

        while(casesFile >> currentCase.id) {
            casesFile >> currentCase.name >> currentCase.objectives >> currentCase.preconditions;
            casesFile >> stepsVectorSize;
            for (int i = 0; i < stepsVectorSize; i++) {
                casesFile >> currentCaseStep.description >> currentCaseStep.expectedResult;
                currentCase.steps.push_back(currentCaseStep);
            }
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

    if (stat(folderPath.c_str, &st) == -1) {
        result = createFolder(folderPath);
    } else {
        result = true;
    }

    return result;
}

bool createFolder(string folderPath) {
    bool result = false;
    if (mkdir(folderPath.c_str, 0700) == 0) {
        result = true;
    }
    return result;
}

Case readCaseInformation() {
    Case newCase;
    Step newStep;

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

        cout << CASE_STEP_CONTINUE_MESSAGE << endl;
        getline(cin, hasAnotherStep);
    } while (isMenuInputStringValid(stringToUpper(hasAnotherStep), 'S', 'S'));

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
    cases.push_back(newCase);
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
    cout << "Pré-condições: " << current.preconditions;
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

void editCase(int projectId, int suiteId) {
    printHeader(EDIT_CASE_HEADER);
    string selectedCase = readSelectedCase();
    vector<Case> cases = readCases(projectId, suiteId);

    if (isStringNumeric(selectedCase)) {
        int id = stringToInteger(selectedCase);
        if (containsCase(cases, id)) {
            editCase(cases, searchCase(cases, id), projectId, suiteId);
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    } else {
        if (containsCase(cases, selectedCase)) {
            editCase(cases, searchCase(cases, selectedCase), projectId, suiteId);
        } else {
            showMessage(CASE_NOT_FOUND);
        }
    }
}

void editTestsCases() {
    char opcao;
    cout << "Digite o nome do caso:" << endl;
    string caseName;
    getline(cin, caseName);
    int posic = findTestCase(caseName);
    if (posic = -1) {
        cout << "Caso não encontrado" << endl;
        return editTestsCases();
    }
    do{
        opcao = editTestsMenu();
        switch(opcao){
            case '1':
                cout << "Digite o novo nome:" << endl;
                getline(cin, folder.cases[posic].name);
                break;
            case '2':
                cout << "Digite o novo Objetivo:" << endl;
                getline(cin, folder.cases[posic].objectives);
                break;
            case '3':
                cout << "Digite as Pré-Condições:" << endl;
                getline(cin, folder.cases[posic].preconditions);
                break;
            case '4':
                cout << "Quer adicionar(1), alterar(2), ou remover(3)?" << endl;
                int opcaoStep;
                cin >> opcaoStep;
                editStepTestCase(opcaoStep, posic);
                break;
            case '0':
                return;
            default:
                cout << "Opção inválida" << endl;
                break;
        }
    } while (isSelectedOptionValid(opcao, '0', '5') == true);
}


void removeTestCase() {
    cout << "Qual caso voce deseja remover? (por id)" << endl;
    for(int i = 0; i < folder.cases.size(); i++) {
        cout << folder.cases[i].id << " " << folder.cases[i].name << endl;
    }
    int idEscolhido;
    cin >> idEscolhido;
    int i = findTestCasePorId(idEscolhido);
    folder.cases.erase(folder.cases.begin()+ i);
}

void editStepTestCase(int positSteps, int posic) {
    Step novoStep;
    int posStep;
    switch(positSteps){
        case 1:
            cout << "Digite a nova descrição:" << endl;
            getline(cin, novoStep.description);
            cout << "Digite o novo resultado esperado:" << endl;
            getline(cin, novoStep.expectedResult);
            folder.cases[posic].steps.push_back(novoStep);
            break;
        case 2:
            cout << "Qual passo voce deseja alterar?" << endl;
            cin >> posStep;
            cout << "Digite a nova descrição:" << endl;
            getline(cin, folder.cases[posic].steps[posStep-1].description);
            cout << "Digite o novo resultado esperado:" << endl;
            getline(cin, folder.cases[posic].steps[posStep-1].expectedResult);
            break;
        case 3:
            cout << "Qual passo voce deseja remover?" << endl;
            cin >> posStep;
            folder.cases[posic].steps.erase(folder.cases[posic].steps.begin() + (posStep-1));
            break;
        default:
            cout << "Opção inválida" << endl;
            break;
    }
}

int generateId(vector<Case> cases) {
    int id = 1;
    
    if (cases.size() > 0) {
        id = cases[cases.size() - 1].id + 1;
    }

    return id;
}

char editTestsMenu() {
    char opcao;
    cout << "Deseja modificar qual atributo?" << endl;
    cout << "(1) Nome" << endl;
    cout << "(2) Objetivos" << endl;
    cout << "(3) Pré-Condições" << endl;
    cout << "(4) Passos" << endl;
    cout << "(0) Sair" << endl;
    cin >> opcao;
    return opcao;
}

void menuPrincipalCases() {
    printMenuPrincipal();
    char opcaoMenu;
    cin >> opcaoMenu;
    if(isSelectedOptionValid(opcaoMenu, '1', '5') == false) {
        cout << "Opção inválida" << endl;
        return menuPrincipalCases();
    }

    switch(opcaoMenu){
        case '1':
            createCase();
            break;
        case '2':
            editTestsCases();
            break;
        case '3':
            listTestsCases();
            break;
        case '4':
            searchTestsCases();
            break;
        case '5':
            removeTestCase();
            break;
        default:
            cout << "Opção inválida" << endl;
            break;
    }
}

void printMenuPrincipal() {
    cout << "O que você deseja fazer?" << endl;
    cout << "(1) Criar um caso de teste" << endl;
    cout << "(2) Editar um caso de teste" << endl;
    cout << "(3) listar os casos teste" << endl;
    cout << "(4) Pesquisar um caso de teste" << endl;
    cout << "(5) remover um caso de teste" << endl;
}
