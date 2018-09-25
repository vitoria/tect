#include <testCase.h>

#define CASE_FILE_NAME "testCases.dat"

using namespace std;

void createCase(int codProject, string user){

    Case testeCase;

    testeCase.idProject = codProject;
    testeCase.user = user;

    system("clear");
    printTectHeader;
    cout << "#------------# CRIAÇÃO DE CASO DE TESTE #----------#" << endl;

    cout << "Nome: ";
    getline(cin, testeCase.name);

    cout << "Objetivo: ";
    getline(cin, testeCase.goal);

    cout << "Pré-condições: ";
    getline(cin, testeCase.preconditions);

    char aux = 's';
    int index = 1;

    do{
        cout << "Podem ser inseridos no máximo 10 passos." << endl; 
        cout << "Insira um passo: ";
        getline(cin, testeCase.steps[index - 1].description);
        cout << "Insira o resultado esperado para o passo" << index << ": ";
        getline(cin, testeCase.steps[index - 1].expectedResult);
        cout << "Deseja inserir outro passo (s/n)? ";
        cin >> aux;
        index++;
    } while (aux == 's' && index < 10);

    saveCase(testeCase);
}

void saveCase(Case testCase){
    fstream caseFile;
    caseFile.open(CASE_FILE_NAME, ios::out | ios::app);
    if (caseFile.is_open()){
        caseFile << testCase.idProject << endl;
        caseFile << testCase.user << endl;
        caseFile << testCase.name << endl;
        caseFile << testCase.goal << endl;
        caseFile << testCase.preconditions << endl;
        // Inserir os passos no arquivo.
        caseFile.close();
        cout << "Projeto criado com sucesso!" << endl;
    } else {
        cout << "Erro ao caso de teste " << endl;
}
}

