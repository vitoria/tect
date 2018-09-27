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

void createCase(int projectId, int suiteId) {
    vector<Case> cases = readCases(projectId, suiteId);

    Case newCase = readCaseInformation();

    cases.push_back(newCase);
}

void listTestsCases() {

    cout << "Lista de casos de teste:" << endl;
    for(int i = 0; i < folder.cases.size(); i++) {
        cout << "Caso " << i+1 << " Nome: " << folder.cases[i].name <<endl;
    }
}

void searchTestsCases() {

    cout << "Digite o nome do caso:" << endl;
    string caseName;
    getline(cin, caseName);
    int posic = findTestCase(caseName);
    if (posic = -1) {
        cout << "Caso não encontrado" << endl;
        return searchTestsCases();
    }
    cout << "Nome: " << folder.cases[posic].name << endl;
    cout << "Objetivos: " << folder.cases[posic].objectives << endl;
    cout << "Pré-condições: " << folder.cases[posic].preconditions << endl;
    for(int j = 0; j < folder.cases[posic].steps.size(); j++) {
        cout << "Descrição: " << folder.cases[posic].steps[j].description << endl;
        cout << "Resultados esperados: " << folder.cases[posic].steps[j].expectedResult << endl;
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


int findTestCase(string name) {
    for(int i = 0; i < folder.cases.size(); i++) {
         if(name == folder.cases[i].name) {
             return i;
         }
    }
    return -1;    
}

int findTestCasePorId(int id) {
    for(int i = 0; i < folder.cases.size(); i++) {
         if(id == folder.cases[i].id) {
             return i;
         }
    }
    return -1;    
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




// void saveCaseInFile(Case currentCase) {

//     stringstream convertString;
//     convertString << currentCase.idProject <<endl;
//     string fileName = convertString.str();

//     fstream outFile;
//     outFile.open(fileName + ".dat", ios::out | ios::app);
//     if (outFile.is_open()) {
//         outFile << currentCase.idProject << endl;
//         outFile << currentCase.name << endl;
//         outFile << currentCase.objectives << endl;
//         outFile << currentCase.preconditions << endl;
//         outFile << "Lista de passos:" << endl;
//         for (int i = 0; i < currentCase.numberOfSteps; i++) {
//             outFile << currentCase.steps[i].description << endl;
//             outFile << currentCase.steps[i].expectedResult << endl;
//         }
//         outFile.close();
//         cout << "Caso de teste criado com sucesso!" << endl;
//     } else {
//         cout << "Erro ao salvar caso de teste " << endl;
//     }
// }



