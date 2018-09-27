#include "project.h"
#include "dataManagerProject.h"

using namespace std;

vector<Project> arquiveToArray(){

    vector<Project> arquive_split;

    fstream arquive;
    arquive.open(PROJECT_FILE_NAME, ios::in);

    string fileOutput;

    Project project;

    while(arquive >> project.id) {
        
        getline(arquive, fileOutput);
        getline(arquive, project.name);
        getline(arquive, project.description); 
        getline(arquive, project.owner); 
        arquive >> project.numberOfUsers;
        
        if (project.numberOfUsers > 0){
            for (int j = 0; j < project.numberOfUsers; j++){
                getline(arquive, project.users[j]);
            }
        } else {
            getline(arquive, fileOutput);
        }

        arquive >> project.numberOfRequests;
       
        if (project.numberOfRequests > 0){
            for (int j = 0; j < project.numberOfRequests; j++){
                getline(arquive, project.requests[j]);
            }
        } else {
            getline(arquive, fileOutput);
        }

        arquive_split.push_back(project);
    }

    arquive.close();

    return arquive_split;
}

void arrayToArquive(vector<Project> arquive_split){
    cleanFile();

    fstream file;
    file.open(PROJECT_FILE_NAME, ios::out);
    if (file.is_open() == true) {
        for (int i = 0; i < arquive_split.size(); i++) {
            file << arquive_split[i].id << endl;
            file << arquive_split[i].name << endl;
            file << arquive_split[i].description << endl;
            file << arquive_split[i].owner << endl;
            file << arquive_split[i].numberOfUsers << endl;
            if(arquive_split[i].numberOfUsers > 0){
                for (int j = 0; j < arquive_split[i].numberOfUsers; j++) {
                    file << arquive_split[i].users[j] << endl;
                }
            } else {
                file << endl;
            }
            file << arquive_split[i].numberOfRequests << endl;
            if(arquive_split[i].numberOfUsers > 0){
                for (int j = 0; j < arquive_split[i].numberOfRequests; j++) {
                    file << arquive_split[i].requests[j] << endl;
                }
            } else {
                file << endl;
            }
        }
    }

    file.close();
} 

void cleanFile(){
    fstream file;
    file.open(PROJECT_FILE_NAME, fstream::out | fstream::trunc);
    file.close();
}