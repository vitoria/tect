#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>

#include "generalPrints.cpp"

#define PROJECT_FILE_NAME "projects.dat"

using namespace std;

void createProject();
void incializeIdProject();
int idProject();
bool verifyExistingProject();

/*
Insere o valor 0 no arquivo, que indica o número de projetos criados.
*/
void incializeIdProject(){
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::out);

    projectFile << 0;

    projectFile.close();
}

/*
Cria um projeto de testes a partir do nome e descrição.
*/
void createProject(){

    string name, description;

    system("clear");
    printTectHeader;
    cout << "#------------# CRIAÇÃO DE PROJETO #----------#" << endl;

    do {
        cout << "Nome do projeto: ";
        getline(cin, name);
        if (verifyExistingProject() == true){
            cout << "Nome de projeto já criado";
        }
    } while (verifyExistingProject() == true);

    cout << "Descrição do projeto: ";
    getline(cin, description);

    system("clear");

    saveProject(name, description);
    
}

void saveProject(string name, string description){
    int id;

    id = idProject();

    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::out | ios::app);
    if (projectFile.is_open()){
        projectFile << id << endl << name << endl << description << endl;
        projectFile.close();
        cout << "Projeto criado com sucesso!" << endl;
    } else {
        cout << "Erro ao criar projeto " << name << endl;
    }
}


/*
Incrementa o número de projetos criados e retorna esse número.
*/
int idProject(){
    string value;
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::in);
    getline(projectFile, value);
    projectFile.close();

    int number;
    number = stoi(value);

    number++;

    return number;
}

/*
Verifica se um nome de projeto já foi criado antes.
*/

bool verifyExistingProject(string name){
    bool existProject = false;

    string fileOutput;
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::in);
    getline(projectFile, fileOutput);
    getline(projectFile, fileOutput);
    if (projectFile.is_open){
        while(existProject == false && getline(projectFile, fileOutput)) {
            if (fileOutput.compare(name) == 0) {
                existProject = true;
            } else {
                getline(projectFile, fileOutput);
                getline(projectFile, fileOutput);
            }
        }
    }
    return existProject;
}