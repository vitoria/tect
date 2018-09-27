#include "dataManagerProject.h"
#include "createrProject.h"
#include "generalPrints.h"

using namespace std;

/*
Insere o valor 0 no arquivo, que indica o número de projetos criados.
*/
void incializeIdProject(){
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::out);

    projectFile << "0" << endl;

    projectFile.close();
}

/*
Cria um projeto de testes a partir do nome e descrição.
*/
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
            cout << "Nome de projeto já criado";
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

    vector<Project> projects;
    int size = arquiveToArray(projects) + 1;
    projects.push_back(project);
    arrayToArquive(projects, size);
    
}

/*
Incrementa o número de projetos criados e retorna esse número.
*/
int idProject(){
    vector<Project> projects;

    int size = arquiveToArray(projects);

    return (projects[size-1].id) + 1;
}

/*
Verifica se um nome de projeto já foi criado antes.
*/
bool verifyExistingProject(string name){
    bool existProject = false;

    vector<Project> projects;

    int size = arquiveToArray(projects);

    for (int i = 0; i < size; i++){
        if (projects[i].name.compare(name) == 0){
            existProject = true;
            break;
        }
    }
    return existProject;
}
