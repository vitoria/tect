#include "project.h"
#include "constants.h"
#include "dataManagerProject.h"

using namespace std;

string generateProjectFilePath() {
    return string(DATA_FOLDER_PATH) + "/" + string(PROJECT_FILE_NAME);
}

string generateProjectFolderPath() {
    return string(DATA_FOLDER_PATH);
}

vector<Project> arquiveToArray(){

    string filePath = generateProjectFilePath();

    vector<Project> arquive_split;

    fstream arquive;
    arquive.open(filePath, ios::in);

    string fileOutput;

    Project project;

    while(arquive >> project.id) {
        getline(arquive, fileOutput);
        getline(arquive, project.name);
        getline(arquive, project.description); 
        getline(arquive, project.owner); 
        arquive >> project.numberOfUsers;
        getline(arquive, fileOutput);
        if (project.numberOfUsers > 0){
            for (int j = 0; j < project.numberOfUsers; j++){
                getline(arquive, fileOutput);
                project.users.push_back(fileOutput);
            }
        } else {
            getline(arquive, fileOutput);
        }
        arquive >> project.numberOfRequests;
        getline(arquive, fileOutput);
        if (project.numberOfRequests > 0){
            for (int j = 0; j < project.numberOfRequests; j++){
                getline(arquive, fileOutput);
                project.requests.push_back(fileOutput);
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
    string filePath = generateProjectFilePath();
    string folderPath = generateProjectFolderPath();
    fstream file;
    
    if (isFolderCreated(folderPath)) {
        file.open(filePath, ios::out);
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
                if(arquive_split[i].numberOfRequests > 0){
                    for (int j = 0; j < arquive_split[i].numberOfRequests; j++) {
                        file << arquive_split[i].requests[j] << endl;
                    }
                } else {
                    file << endl;
                }
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