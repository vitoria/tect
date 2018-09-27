#include "project.h"
#include "dataManagerProject.h"

using namespace std;

<<<<<<< HEAD
int arquiveToArray(vector<Project> arquive_split){
=======
void arquiveToArray(vector<Project> arquive_split){
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90

    fstream arquive;
    arquive.open(PROJECT_FILE_NAME, ios::in);

<<<<<<< HEAD
    int size;
    string fileOutput;

    getline(arquive, fileOutput); // pega o número de projetos inseridos

    size = stoi(fileOutput); 

    for (int i = 0; i < size; i++ ){
        Project project;
        getline(arquive, fileOutput); 
        project.id = stoi(fileOutput);
        getline(arquive, project.name); 
=======
    string fileOutput;

    Project project;

    while(getline(arquive, project.name)) {
        
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
        getline(arquive, project.description); 
        getline(arquive, project.owner); 
        getline(arquive, fileOutput); 
        project.numberOfUsers = stoi(fileOutput);
        for (int j = 0; j < project.numberOfUsers; j++){
<<<<<<< HEAD
            getline(cin, project.users[j]);
=======
            getline(arquive, project.users[j]);
        }
        getline(arquive, fileOutput); 
        project.numberOfRequests = stoi(fileOutput);
        for (int j = 0; j < project.numberOfRequests; j++){
            getline(arquive, project.requests[j]);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
        }

        arquive_split.push_back(project);
    }

    arquive.close();
<<<<<<< HEAD

    return size;
}


void arrayToArquive(vector<Project> arquive_split, int size){
     /*projectFile.open(PROJECT_FILE_NAME, ios::out | ios::app);
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
=======
}

void arrayToArquive(vector<Project> arquive_split){
    
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
} 