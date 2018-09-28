#include "project.h"
#include "dataManagerProject.h"
#include "login.h"
#include "reports.h"

using namespace std;

int throughArray(int id, vector<Project> projects){
    int aux = -1;

    if (projects.size() > 0){
        aux++;
        while(projects[aux].id != id && aux < projects.size()){
            aux++;
        }
    }
    return aux;
}

void listProjects(){
    vector<Project> projects = arquiveToArray();
    if (projects.size() > 0){
        for(int i = 0; i < projects.size(); i++){
            cout << "Id do Projeto: " << projects[i].id << " - Nome: " << projects[i].name << " - Description: "
            << projects[i].description << " - Dono: " << projects[i].owner << endl;
        }
    } else {
        cout << "Nenhum projeto inserido." << endl;
    }
}

void editNameProject(int id){
    vector<Project> projects = arquiveToArray();

    int aux = throughArray(id, projects);

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
    vector<Project> projects = arquiveToArray();

    int aux = throughArray(id, projects);

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
    vector<Project> projects = arquiveToArray();

    int aux = throughArray(id, projects);
    if (projects[aux].id == id){
        if (projects[aux].requests.size() > 0){
            string usersString = "";
            vector<string> vetor;
            for (int i = 0; i < projects[aux].requests.size(); i++){
                char fileInput;
                cout << "Dar permissão de acesso no projeto " << projects[aux].name;
                cout << " ao usuário " << projects[aux].requests[i] << " (s/n)? ";
                cin >> fileInput;
                if (fileInput == 's'){
                    projects[aux].users.push_back(projects[aux].requests[i]);
                    projects[aux].numberOfUsers++;
                    projects[aux].requests.erase(projects[aux].requests.begin() + i);
                    projects[aux].numberOfRequests--;

                }
            }

            arrayToArquive(projects);
            cout << "Permissões dadas com sucesso" << endl;
        } else {
            cout << "Nenhum pedido de acesso." << endl;
        }
    } else {
        cout << "Id não encontrado" << endl;
    }
}

void askPermission(user loggedUser){
    vector<Project> projects = arquiveToArray();
    string input;
    cout << "Informe id do projeto: ";
    getline(cin, input);
    int id = stoi(input);
    int aux = throughArray(id, projects);
    if (projects[aux].id == id){
        if (!verifyUserAskingPermission(projects[aux], loggedUser)){
            projects[aux].requests.push_back(loggedUser.login);
            projects[aux].numberOfRequests++;
            arrayToArquive(projects);
        }
    }

}

bool verifyUserAskingPermission(Project project, user loggedUser){
    bool verify = false;
    for (int i = 0; i < project.users.size(); i++){
        if(loggedUser.login.compare(project.users[i]) == 0){
            verify = true;
            cout << "Você já tem permissão de acesso a esse projeto." << endl;
            break;
        }
    }
    if (!verify){
        for (int i = 0; i < project.requests.size(); i++){
            if(loggedUser.login.compare(project.requests[i]) == 0){
                verify = true;
                cout << "Você já pediu permissão de acesso a esse projeto." << endl;
                break;
            }
        }
    }
    return verify;

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
    cout << vetor[vetor.size()-1] << endl;
}

void deleteProject(int id){
    vector<Project> projects = arquiveToArray();

    int aux = throughArray(id, projects);
    
    projects.erase(projects.begin() + aux);

    arrayToArquive(projects);
}

void swapProject(vector<Project> projects, int aux){
    for (int i = aux; i < projects.size()-1; i ++){
        projects[aux] = projects[aux+1];
    }
}
