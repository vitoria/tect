#include <testCase.h>
#include <validation.h>

using namespace std;

testCases folder;

void createCase(int code) {

    Case caseImpl;
    caseImpl.idCase = code;
    cout << "Nome: ";
    getline(cin, caseImpl.name);
    cout << "Objetivo: ";
    getline(cin, caseImpl.objectives);
    cout << "Pré-condições: ";
    getline(cin, caseImpl.preconditions);
    
    int pos = 0;
    char haveNext;
    do{
        cout << "Por favor, insira um passo:" << endl;
        getline(cin, caseImpl.steps[pos].description);
        cout << "Qual o resultado esperado para o passo " << pos + 1 << "?:" << endl;
        getline(cin, caseImpl.steps[pos].expectedResult);
        cout << "Deseja inserir outro passo (s/n)? " << endl;
        cin >> haveNext;
        pos++;
    } while (haveNext == 's' && pos <= 9);

    folder.arrayCases.push_back;
}

void listTestsCases() {

    cout << "Lista de casos de teste:" << endl;
    for(int i = 0; i < folder.arrayCases.size(); i++) {
        cout << "Caso " << i+1 << " Nome: " << folder.arrayCases[i].name <<endl;
    };
}

void searchTestsCases() {

    cout << "Digite o nome do caso:" << endl;
    string caseName;
    getline(cin, caseName);
    int posic = findTestCase(caseName);
    cout << "Nome: " << folder.arrayCases[posic].name << endl;
    cout << "Objetivos: " << folder.arrayCases[posic].objectives << endl;
    cout << "Pré-condições: " << folder.arrayCases[posic].preconditions << endl;
    for(int j = 0; j < folder.arrayCases[posic].steps.size(); j++) {
        cout << "Descrição: " << folder.arrayCases[posic].steps[j].description << endl;
        cout << "Resultados esperados: " << folder.arrayCases[posic].steps[j].expectedResult << endl;
        };
    };

void editTestsCases(string name) {

    cout << "Digite o nome do caso:" << endl;
    string caseName;
    getline(cin, caseName);
    int posic = findTestCase(caseName);
    do{
        cout << "Deseja modificar qual atributo?" << endl;
        cout << "(1) Nome" << endl;
        cout << "(2) Objetivos" << endl;
        cout << "(3) Pré-Condições" << endl;
        cout << "(4) Passos" << endl;
        cout << "(0) Sair" << endl;
        int opcao;
        cin >> opcao;
        switch(opcao){
            case 1:
                cout << "Digite o novo nome:" << endl;
                getline(cin, folder.arrayCases[posic].name);
                break;
            case 2:
                cout << "Digite o novo Objetivo:" << endl;
                getline(cin, folder.arrayCases[posic].objectives);
                break;
            case 3:
                cout << "Digite as Pré-Condições:" << endl;
                getline(cin, folder.arrayCases[posic].preconditions);
                break;
            case 4:
                cout << "Quer adicionar(1), alterar(2), ou remover(3)?" << endl;
                int opcaoStep;
                cin >> opcaoStep;
                switch(opcaoStep){
                    case 1:
                        cout << "Digite a nova descrição:" << endl;
                        Step novoStep;
                        getline(cin, novoStep.description);
                        cout << "Digite o novo resultado esperado:" << endl;
                        getline(cin, novoStep.expectedResult);
                        folder.arrayCases[posic].steps.push_back(novoStep);
                        break;
                    case 2:
                        cout << "Qual passo voce deseja alterar?" << endl;
                        int posStep;
                        cin >> posStep;
                        cout << "Digite a nova descrição:" << endl;
                        getline(cin, folder.arrayCases[posic].steps[posStep-1].description);
                        cout << "Digite o novo resultado esperado:" << endl;
                        getline(cin, folder.arrayCases[posic].steps[posStep-1].expectedResult);
                        break;
                    case 3:
                        cout << "Qual passo voce deseja remover?" << endl;
                        int posStep;
                        cin >> posStep;
                        folder.arrayCases[posic].steps.erase(folder.arrayCases[posic].steps.begin() + (posStep-1));
                        break;
                    default:
                        cout << "Opção inválida" << endl;
                        break;
                }

            break;
        default:
            cout << "Opção inválida" << endl;
            break;
        }} while (isSelectedOptionValid(opcao, "0", "5") == true);
        
}


int findTestCase(string name) {
    for(int i = 0; i < folder.arrayCases.size(); i++) {
         if(name == folder.arrayCases[i].name) {
             return i;
         };
    };
    return -1;    
}

void removeTestCase(string name) {
    int i = findTestCase(name);
    folder.arrayCases.erase(folder.arrayCases.begin()+ i);
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



