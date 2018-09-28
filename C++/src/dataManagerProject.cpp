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
                cout << j << endl;
                getline(arquive, fileOutput);
                cout << fileOutput << endl;
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

    fstream file;
    file.open(PROJECT_FILE_NAME, ios::out);
    if (file.is_open() == true) {
        for (int i = 0; i < arquive_split.size(); i++) {
            cout << "problema 1 " << endl;
            file << arquive_split[i].id << endl;
            file << arquive_split[i].name << endl;
            file << arquive_split[i].description << endl;
            file << arquive_split[i].owner << endl;
            file << arquive_split[i].numberOfUsers << endl;
            if(arquive_split[i].numberOfUsers > 0){
                cout << "problema 2 " << endl;
                for (int j = 0; j < arquive_split[i].numberOfUsers; j++) {
                    cout << "problema 3 " << endl;
                    file << arquive_split[i].users[j] << endl;
                }
            } else {
                file << endl;
            }
            cout << "problema 4 " << endl;
            file << arquive_split[i].numberOfRequests << endl;
            if(arquive_split[i].numberOfRequests > 0){
                cout << "problema 5 " << endl;
                for (int j = 0; j < arquive_split[i].numberOfRequests; j++) {
                    cout << "problema 6 " << endl;
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