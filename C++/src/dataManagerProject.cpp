#include "project.h"
#include "dataManagerProject.h"

using namespace std;

int arquiveToArray(vector<Project> arquive_split){

    fstream arquive;
    arquive.open(PROJECT_FILE_NAME, ios::in);

    int size;
    string fileOutput;

    getline(arquive, fileOutput); // pega o número de projetos inseridos

    size = stoi(fileOutput); 

    for (int i = 0; i < size; i++ ){
        Project project;
        getline(arquive, fileOutput); 
        project.id = stoi(fileOutput);
        getline(arquive, project.name); 
        getline(arquive, project.description); 
        getline(arquive, project.owner); 
        getline(arquive, fileOutput); 
        project.numberOfUsers = stoi(fileOutput);
        for (int j = 0; j < project.numberOfUsers; j++){
            getline(cin, project.users[j]);
        }

        arquive_split.push_back(project);
    }

    arquive.close();

    return size;
}


void arrayToArquive(vector<Project> arquive_split, int size){
    
    /*fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::out | ios::app);
    if (projectFile.is_open()){
        projectFile << project.id << endl << project.name << endl << project.description << endl;
        projectFile << project.owner << endl;
        for (int i = 0; i < project.numberOfUsers; i++){
            projectFile << project.users[i] << endl;
        }
        projectFile.close();

        cout << "Projeto criado com sucesso!" << endl;
    } else {
        cout << "Erro ao criar projeto " << project.name << endl;
    }*/
} 