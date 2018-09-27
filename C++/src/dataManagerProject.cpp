#include "project.h"
#include "dataManagerProject.h"

using namespace std;

void arquiveToArray(vector<Project> arquive_split){

    fstream arquive;
    arquive.open(PROJECT_FILE_NAME, ios::in);

    string fileOutput;

    Project project;

    while(getline(arquive, project.name)) {
        
        getline(arquive, project.description); 
        getline(arquive, project.owner); 
        getline(arquive, fileOutput); 
        project.numberOfUsers = stoi(fileOutput);
        for (int j = 0; j < project.numberOfUsers; j++){
            getline(arquive, project.users[j]);
        }
        getline(arquive, fileOutput); 
        project.numberOfRequests = stoi(fileOutput);
        for (int j = 0; j < project.numberOfRequests; j++){
            getline(arquive, project.requests[j]);
        }

        arquive_split.push_back(project);
    }

    arquive.close();
}

void arrayToArquive(vector<Project> arquive_split){
    
} 