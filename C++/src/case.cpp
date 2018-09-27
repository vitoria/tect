#include <testCase.h>
#include <case.h>

using namespace std;



void createCase(int code) {

    Case testCase;
    testCase.idProject = code;
    cout << "Nome: ";
    getline(cin, testCase.name);
    cout << "Objetivo: ";
    getline(cin, testCase.objectives);
    cout << "Pré-condições: ";
    getline(cin, testCase.preconditions);
    
    int pos = 0;
    char haveNext;
    do{
        cout << "Por favor, insira um passo:" << endl;
        getline(cin, testCase.steps[pos].description);
        cout << "Qual o resultado esperado para o passo " << pos + 1 << "?:" << endl;
        getline(cin, testCase.steps[pos].expectedResult);
        cout << "Deseja inserir outro passo (s/n)? " << endl;
        cin >> haveNext;
        pos++;
    } while (haveNext == 's' && pos <= 9);
    testCase.numberOfSteps = pos;
    saveCaseInFile(testCase);
}
void saveCaseInFile(Case testCase) {

    stringstream convertString;
    convertString << testCase.idProject <<endl;
    string fileName = convertString.str();

    fstream outFile;
    outFile.open(fileName + ".dat", ios::out | ios::app);
    if (outFile.is_open()) {
        outFile << testCase.idProject << endl;
        outFile << testCase.name << endl;
        outFile << testCase.objectives << endl;
        outFile << testCase.preconditions << endl;
        outFile << "Lista de passos:" << endl;
        for (int i = 0; i < testCase.numberOfSteps; i++) {
            outFile << testCase.steps[i].description << endl;
            outFile << testCase.steps[i].expectedResult << endl;
        }
        outFile.close();
        cout << "Caso de teste criado com sucesso!" << endl;
    } else {
        cout << "Erro ao salvar caso de teste " << endl;
    }
}



