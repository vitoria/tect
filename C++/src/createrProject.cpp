#include "dataManagerProject.h"
#include "createrProject.h"

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
void createProject(){

    Project newProject;

    system("clear");
    printTectHeader;
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

    saveProject(newProject);
    
}

void saveProject(Project project){

    fstream projectFile;
    project.id = idProject();

    vector<Project> projects;
    int size = arquiveToArray(projects) + 1;
    projects.push_back(project);
    arrayToArquive(projects);
    
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
}

/*
Incrementa o número de projetos criados e retorna esse número.
*/
//falta sobrescrever linha com o número de projetos
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
