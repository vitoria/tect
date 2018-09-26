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

    //arquive_split = new Project[size];

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
        //arquive_split[i] = project;
    }

    arquive.close();

    return size;
}


void arrayToArquive(vector<Project> arquive_split){
     // Not implemented
} 