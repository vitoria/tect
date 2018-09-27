#include "dataManagerProject.h"
#include "createrProject.h"
<<<<<<< HEAD
=======
#include "generalPrints.h"
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90

using namespace std;

/*
<<<<<<< HEAD
Insere o valor 0 no arquivo, que indica o número de projetos criados.
*/
void incializeIdProject(){
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::out);

    projectFile << "0" << endl;

    projectFile.close();
}

/*
=======
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
Cria um projeto de testes a partir do nome e descrição.
*/
void createProject(user creater){

    Project newProject;

    system("clear");
<<<<<<< HEAD
    printTectHeader;
=======
    printHeader();
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
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
<<<<<<< HEAD
    int size = arquiveToArray(projects) + 1;
    projects.push_back(project);
    arrayToArquive(projects, size);
=======
    arquiveToArray(projects);
    projects.push_back(project);
    arrayToArquive(projects);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
    
}

/*
Incrementa o número de projetos criados e retorna esse número.
*/
int idProject(){
    vector<Project> projects;
<<<<<<< HEAD

    int size = arquiveToArray(projects);

    return (projects[size-1].id) + 1;
=======
    int id = 1;

    arquiveToArray(projects);

    if (projects.size() > 0) {
        id = (projects[projects.size()-1].id) + 1;
    }
    
    return id;
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
}

/*
Verifica se um nome de projeto já foi criado antes.
*/
bool verifyExistingProject(string name){
    bool existProject = false;

    vector<Project> projects;

<<<<<<< HEAD
    int size = arquiveToArray(projects);

    for (int i = 0; i < size; i++){
=======
    arquiveToArray(projects);

    for (int i = 0; i < projects.size(); i++){
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
        if (projects[i].name.compare(name) == 0){
            existProject = true;
            break;
        }
    }
    return existProject;
}
