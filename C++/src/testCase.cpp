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
                casesFile << cases[i].idCase << endl << cases[i].name << endl << cases[i].objectives << endl << cases[i].preconditions << endl;
                casesFile << cases[i].steps.size() << endl;
                for (int j = 0; j < cases[i].steps.size(); j++) {
                    casesFile << cases[i].steps[j].description << endl;
                    casesFile << cases[i].steps[j].expectedResult << endl;
                }
            }
        }
    }
}

// std::vector<Case> readCases(int projectId, int suiteId) {
//     std::ifstream suitesFile(SUITES_PATH, std::ios::in);
//     std::vector<suite> suites;
//     suite current;

//     while(suitesFile >> current.id >> current.name >> current.description) {
//         suites.push_back(current);
//     }
//     suitesFile.close();

//     return suites;
// }

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

void createCase() {

    Case caseImpl;
    Step step;
    caseImpl.idCase = generateId();
    cout << "Nome: ";
    getline(cin, caseImpl.name);
    cout << "Objetivo: ";
    getline(cin, caseImpl.objectives);
    cout << "Pré-condições: ";
    getline(cin, caseImpl.preconditions);
    char haveNext;
    do{
        cout << "Por favor, insira um passo:" << endl;
        getline(cin, step.description);
        cout << "Qual o resultado esperado para o passo " << caseImpl.steps.size() << "?:" << endl;
        getline(cin, step.expectedResult);
        caseImpl.steps.push_back(step);
        cout << "Deseja inserir outro passo (s/n)? " << endl;
        cin >> haveNext;
    } while (haveNext == 's' && caseImpl.steps.size() <= 9);

    folder.arrayCases.push_back(caseImpl);
}

void listTestsCases() {

    cout << "Lista de casos de teste:" << endl;
    for(int i = 0; i < folder.arrayCases.size(); i++) {
        cout << "Caso " << i+1 << " Nome: " << folder.arrayCases[i].name <<endl;
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
    cout << "Nome: " << folder.arrayCases[posic].name << endl;
    cout << "Objetivos: " << folder.arrayCases[posic].objectives << endl;
    cout << "Pré-condições: " << folder.arrayCases[posic].preconditions << endl;
    for(int j = 0; j < folder.arrayCases[posic].steps.size(); j++) {
        cout << "Descrição: " << folder.arrayCases[posic].steps[j].description << endl;
        cout << "Resultados esperados: " << folder.arrayCases[posic].steps[j].expectedResult << endl;
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
                getline(cin, folder.arrayCases[posic].name);
                break;
            case '2':
                cout << "Digite o novo Objetivo:" << endl;
                getline(cin, folder.arrayCases[posic].objectives);
                break;
            case '3':
                cout << "Digite as Pré-Condições:" << endl;
                getline(cin, folder.arrayCases[posic].preconditions);
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
    for(int i = 0; i < folder.arrayCases.size(); i++) {
         if(name == folder.arrayCases[i].name) {
             return i;
         }
    }
    return -1;    
}

int findTestCasePorId(int id) {
    for(int i = 0; i < folder.arrayCases.size(); i++) {
         if(id == folder.arrayCases[i].idCase) {
             return i;
         }
    }
    return -1;    
}

void removeTestCase() {
    cout << "Qual caso voce deseja remover? (por id)" << endl;
    for(int i = 0; i < folder.arrayCases.size(); i++) {
        cout << folder.arrayCases[i].idCase << " " << folder.arrayCases[i].name << endl;
    }
    int idEscolhido;
    cin >> idEscolhido;
    int i = findTestCasePorId(idEscolhido);
    folder.arrayCases.erase(folder.arrayCases.begin()+ i);
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
            folder.arrayCases[posic].steps.push_back(novoStep);
            break;
        case 2:
            cout << "Qual passo voce deseja alterar?" << endl;
            cin >> posStep;
            cout << "Digite a nova descrição:" << endl;
            getline(cin, folder.arrayCases[posic].steps[posStep-1].description);
            cout << "Digite o novo resultado esperado:" << endl;
            getline(cin, folder.arrayCases[posic].steps[posStep-1].expectedResult);
            break;
        case 3:
            cout << "Qual passo voce deseja remover?" << endl;
            cin >> posStep;
            folder.arrayCases[posic].steps.erase(folder.arrayCases[posic].steps.begin() + (posStep-1));
            break;
        default:
            cout << "Opção inválida" << endl;
            break;
    }
}

int generateId() {
    int id = 1;
    
    if (folder.arrayCases.size() > 0) {
        id = folder.arrayCases[folder.arrayCases.size() - 1].idCase + 1;
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




// void saveCaseInFile(Case caseImpl) {

//     stringstream convertString;
//     convertString << caseImpl.idProject <<endl;
//     string fileName = convertString.str();

//     fstream outFile;
//     outFile.open(fileName + ".dat", ios::out | ios::app);
//     if (outFile.is_open()) {
//         outFile << caseImpl.idProject << endl;
//         outFile << caseImpl.name << endl;
//         outFile << caseImpl.objectives << endl;
//         outFile << caseImpl.preconditions << endl;
//         outFile << "Lista de passos:" << endl;
//         for (int i = 0; i < caseImpl.numberOfSteps; i++) {
//             outFile << caseImpl.steps[i].description << endl;
//             outFile << caseImpl.steps[i].expectedResult << endl;
//         }
//         outFile.close();
//         cout << "Caso de teste criado com sucesso!" << endl;
//     } else {
//         cout << "Erro ao salvar caso de teste " << endl;
//     }
// }



