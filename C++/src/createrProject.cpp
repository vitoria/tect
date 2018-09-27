#include "dataManagerProject.h"
#include "createrProject.h"
#include "generalPrints.h"
#include "constants.h"

using namespace std;

void createProject(user creater){

    Project newProject;

    system("clear");
    printHeader();

    cout << "#------------# CRIAÇÃO DE PROJETO #----------#" << endl;

    string name;

    do {
        cout << "Nome do projeto: ";
        getline(cin, name);
        if (verifyExistingProject(name) == true){
            cout << "Nome de projeto já criado." << endl;
        }
    } while (verifyExistingProject(name) == true);
    newProject.name = name;
    
    cout << "Descrição do projeto: ";
    getline(cin, newProject.description);

    system("clear");

    newProject.owner = creater.login;
    newProject.numberOfUsers = 0;
    newProject.numberOfRequests = 0;
    vector<string> users;
    vector<string> requests;
    newProject.users = users;
    newProject.requests = requests;

    saveProject(newProject);
    
}

void saveProject(Project project){

    fstream projectFile;
    project.id = idProject();

    vector<Project> projects = arquiveToArray();
    projects.push_back(project);
    arrayToArquive(projects);
    
}

/*
Retorna o id do projeto a partir do id do último projeto inserido.
*/
int idProject(){
    vector<Project> projects = arquiveToArray();
    int id = 1;

    if (projects.size() > 0) {
        id = (projects[projects.size()-1].id) + 1;
    }
    
    return id;
}

/*
Verifica se um nome de projeto já foi criado antes.
*/
bool verifyExistingProject(string name){
    bool existProject = false;

    vector<Project> projects = arquiveToArray();

    for (int i = 0; i < projects.size(); i++){

        if (projects[i].name.compare(name) == 0){
            existProject = true;
            break;
        }
    }
    return existProject;
}
