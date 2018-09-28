#include "dataManagerProject.h"
#include "createrProject.h"
#include "generalPrints.h"
#include "constants.h"

using namespace std;

void createProject(user creater){

    Project newProject;

    printHeader("#------------# CRIAÇÃO DE PROJETO #----------#");

    string name;

    do {
        cout << "Nome do projeto: ";
        getline(cin, name);
        if (verifyExistingProject(name) == true){
            cout << "Nome de projeto já criado." << endl;
        }
    } while (verifyExistingProject(name) == true);
    newProject.name = name;
    
    if (newProject.name.compare("") == 0) {
        showMessage("Voce precisa informar um nome valido!");
    } else {
        cout << "Descrição do projeto: ";
        getline(cin, newProject.description);

        newProject.owner = creater.login;
        vector<string> users;
        vector<string> requests;
        newProject.numberOfUsers = 0;
        newProject.users = users;
        newProject.numberOfRequests = 0;
        newProject.requests = requests;

        saveProject(newProject);

        showMessage("\nProjeto criado!");
    }
    
}

void saveProject(Project project){

    project.id = idProject();

    vector<Project> projects = arquiveToArray();
    projects.push_back(project);
    arrayToArquive(projects);
    
}

string generateProjectFolderPath(int projectId) {
    return string(DATA_FOLDER_PATH) + "/" + to_string(projectId);
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
