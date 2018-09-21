#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>

#include "generalPrints.cpp"

#define PROJECT_FILE_NAME "projects.dat"

using namespace std;

//CABEÇALHOS
void createProject();
void incializeIdProject();
int idProject();

/*
Insere o valor 0 no arquivo, que indica o número de projetos criados
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
    int id;
    string name, description;

    system("clear");
    printTectHeader;
    cout << "#------------# CRIAÇÃO DE PROJETO #----------#" << endl;

    cout << "Nome do projeto: ";
    getline(cin, name);

    cout << "Descrição do projeto: ";
    getline(cin, description);

    system("clear");

    id = idProject();

    //verficar se existe outro projeto com mesmo nome

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
Incrementa o número de projetos criados e retorna esse número
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