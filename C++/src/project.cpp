#include "project.h"
#include "dataManagerProject.h"
#include "login.h"

using namespace std;

int throughArray(int id, vector<Project> projects, int size){
    int aux = 0;

    while(projects[aux].id != id || aux < size){
        aux++;
    }

    return aux;
}

void editNameProject(int id){
    vector<Project> projects;

    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);

    if (projects[aux].id == id){
        cout << "Novo nome: ";
        getline(cin, projects[aux].name);
        arrayToArquive(projects);
        cout << "Nome de projeto editado com sucesso." << endl;
    } else {
        cout << "Id não encontrado" << endl;
    }
}

void editDescriptionProject(int id){
    vector<Project> projects;

    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);

    if (projects[aux].id == id){
        cout << "Nova descrição: ";
        getline(cin, projects[aux].description);
        arrayToArquive(projects);
        cout << "Descrição de projeto editado com sucesso." << endl;
    } else {
        cout << "Id não encontrado" << endl;
    }
}

void allowPermissions(int id){
    vector<Project> projects;

    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);

    if (projects[aux].id == id){
        if (projects[aux].numberOfRequests > 0){
            string usersString = "";
            //int newSize = projects[aux].numberOfUsers + projects[aux].numberOfRequests;
            vector<string> vetor;
            for (int i = 0; i < projects[aux].numberOfUsers; i++){
                usersString += projects[aux].users[i];
                //newArray[i] = projects[aux].users[i];
            }
            int index = projects[aux].numberOfUsers;
            for (int i = 0; i < projects[aux].numberOfRequests; i++){
                char fileInput;
                cout << "Dar permissão de acesso no projeto  " << projects[aux].name;
                cout << " ao usuário " << projects[aux].requests[i] << " (s/n)? ";
                cin >> fileInput;
                if (fileInput == 's'){
                    usersString += projects[aux].requests[i];
                    //newArray[index] == projects[aux].requests[i];
                    index++;
                }
            }

            // fazer split da string usersString e colocar em um array
            split(usersString, vetor);

            //*projects[aux].users = newArray; //arrays com posições nulas
            arrayToArquive(projects);
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

    int size = arquiveToArray(projects);
    int aux = throughArray(id, projects, size);
    
    swapProject(projects, size, aux);
    projects.pop_back();

    arrayToArquive(projects);

}

void swapProject(vector<Project> projects, int size, int aux){
    for (int i = aux; i < size-1; i ++){
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

