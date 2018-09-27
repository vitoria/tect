#include "project.h"
#include "dataManagerProject.h"
#include "login.h"

using namespace std;

<<<<<<< HEAD
int throughArray(int id, vector<Project> projects, int size){
    int aux = 0;

    while(projects[aux].id != id || aux < size){
=======
int throughArray(int id, vector<Project> projects){
    int aux = 0;

    while(projects[aux].id != id || aux < projects.size()){
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
        aux++;
    }

    return aux;
}

void editNameProject(int id){
    vector<Project> projects;

<<<<<<< HEAD
    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);
=======
    arquiveToArray(projects);
    int aux = throughArray(id, projects);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90

    if (projects[aux].id == id){
        cout << "Novo nome: ";
        getline(cin, projects[aux].name);
<<<<<<< HEAD
        arrayToArquive(projects, size);
=======
        arrayToArquive(projects);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
        cout << "Nome de projeto editado com sucesso." << endl;
    } else {
        cout << "Id não encontrado" << endl;
    }
}

void editDescriptionProject(int id){
    vector<Project> projects;

<<<<<<< HEAD
    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);
=======
    arquiveToArray(projects);
    int aux = throughArray(id, projects);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90

    if (projects[aux].id == id){
        cout << "Nova descrição: ";
        getline(cin, projects[aux].description);
<<<<<<< HEAD
        arrayToArquive(projects, size);
=======
        arrayToArquive(projects);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
        cout << "Descrição de projeto editado com sucesso." << endl;
    } else {
        cout << "Id não encontrado" << endl;
    }
}

void allowPermissions(int id){
    vector<Project> projects;

<<<<<<< HEAD
    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);
=======
    arquiveToArray(projects);
    int aux = throughArray(id, projects);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90

    if (projects[aux].id == id){
        if (projects[aux].numberOfRequests > 0){
            string usersString = "";

            vector<string> vetor;
            for (int i = 0; i < projects[aux].numberOfUsers; i++){
                usersString += projects[aux].users[i];
            }
            int index = projects[aux].numberOfUsers;
            for (int i = 0; i < projects[aux].numberOfRequests; i++){
                char fileInput;
                cout << "Dar permissão de acesso no projeto  " << projects[aux].name;
                cout << " ao usuário " << projects[aux].requests[i] << " (s/n)? ";
                cin >> fileInput;
                if (fileInput == 's'){
                    usersString += projects[aux].requests[i];
                    index++;
                }
            }

            split(usersString, vetor);

<<<<<<< HEAD
            arrayToArquive(projects, size);
=======
            arrayToArquive(projects);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
            cout << "Permissões dadas com sucesso" << endl;
        } else {
            cout << "Nenhum pedido de acesso." << endl;
        }
    } else {
        cout << "Id não encontrado" << endl;
    }
}

void split(string usersString, vector<string> vetor){
    
    string aux = "";
    for(int i = 0; i < usersString.size(); i++){
        if(usersString[i] ==  ' '){
            vetor.push_back(aux);
            aux = "";
        } else {
            aux += usersString[i];
        }
    }
}

void deleteProject(int id){
    vector<Project> projects;

<<<<<<< HEAD
    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);
    
    swapProject(projects, size, aux);
    projects.pop_back();

    arrayToArquive(projects, size);

}

void swapProject(vector<Project> projects, int size, int aux){
    for (int i = aux; i < size-1; i ++){
=======
    arquiveToArray(projects);
    int aux = throughArray(id, projects);
    
    swapProject(projects, aux);
    projects.pop_back();

    arrayToArquive(projects);

}

void swapProject(vector<Project> projects, int aux){
    for (int i = aux; i < projects.size()-1; i ++){
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
        projects[aux] = projects[aux+1];
    }
}

void createSuite(int id){
    //not implemented
}

void listSuites(int id){
    //not implemented
}

void searchSuite(int id){
    //not implemented
}

void generateReport(int id){
    //not implemented
}

