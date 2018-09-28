#include "project.h"
#include "dataManagerProject.h"
#include "login.h"
#include "reports.h"
#include "generalPrints.h"
#include "constants.h"
#include "validation.h"


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
    printHeader(LIST_PROJECTS_HEADER);
    vector<Project> projects = arquiveToArray();
    if (projects.size() > 0){
        showLine();
        cout << LIST_PROJECTS_TABLE_HEADER << endl;
        showLine();
        for(int i = 0; i < projects.size(); i++){
            cout << "- ";
            showID(projects[i].id);
            cout << " | ";
            cout << truncate(projects[i].name, 20);
            cout << " | ";
            cout << truncate(projects[i].owner, 12);
            cout << " | " << endl;
        }
        showLine();
    } else {
        showMessage("Nenhum projeto inserido.");
    }

    cout << endl;
    pauseSystem();
}

void editNameProject(int id){
    vector<Project> projects = arquiveToArray();

    int aux = throughArray(id, projects);

    if (projects[aux].id == id){
        cout << "Nome atual: " << projects[aux].name << endl;
        cout << "Novo nome: ";
        cin.ignore();
        getline(cin, projects[aux].name);
        

        arrayToArquive(projects);
        showMessage("Nome de projeto editado com sucesso.");
    } else {
        showMessage("Id não encontrado");
    }
}

void editDescriptionProject(int id){
    vector<Project> projects = arquiveToArray();

    int aux = throughArray(id, projects);

    if (projects[aux].id == id){
        cout << "Descrição atual: " << projects[aux].description << endl;
        cout << "Nova descrição: ";
        cin.ignore();
        getline(cin, projects[aux].description);
        arrayToArquive(projects);
        showMessage("Descrição de projeto editado com sucesso.");
    } else {
        showMessage("Id não encontrado");
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
                string fileInput;
                cout << "Dar permissão de acesso no projeto " << projects[aux].name;
                cout << " ao usuário " << projects[aux].requests[i] << " (S/N)? ";
                cin.ignore();
                getline(cin, fileInput);
                if (isMenuInputStringValid(stringToUpper(fileInput), 'S', 'S')){
                    projects[aux].users.push_back(projects[aux].requests[i]);
                    projects[aux].numberOfUsers++;
                    projects[aux].requests.erase(projects[aux].requests.begin() + i);
                    projects[aux].numberOfRequests--;
                    cout << "Permissão concedida." << endl;
                } else {
                    cout << "Permissão não concedida." << endl;
                }
            }

            arrayToArquive(projects);
            showMessage("Alterações feitas com sucesso");
        } else {
            showMessage("Nenhum pedido de acesso.");
        }
    } else {
        showMessage("Id não encontrado");
    }
}

void askPermission(user loggedUser){
    vector<Project> projects = arquiveToArray();
    string input;
    cout << "Informe id do projeto: ";
    getline(cin, input);
    int id = stoi(input);
    int aux = throughArray(id, projects);
    if (aux > -1){
        if(projects[aux].id == id){
            if (!verifyUserAskingPermission(projects[aux], loggedUser)){
                projects[aux].requests.push_back(loggedUser.login);
                projects[aux].numberOfRequests++;
                arrayToArquive(projects);
                showMessage("Pedido Realizado com Sucesso.");
            }
        } else {
        showMessage("Projeto não encontrado.");
        }
    } else {
        showMessage("Projeto não encontrado.");
    }

}

bool verifyUserAskingPermission(Project project, user loggedUser){
    bool verify = false;
    if (loggedUser.login.compare(project.owner) == 0){
        verify = true;
        showMessage("Você é o dono desse projeto.");
    }
    if (!verify){
        for (int i = 0; i < project.users.size(); i++){
            if(loggedUser.login.compare(project.users[i]) == 0){
                verify = true;
                showMessage("Você já tem permissão de acesso a esse projeto.");
                break;
            }
        }
    }
    if (!verify){
        for (int i = 0; i < project.requests.size(); i++){
            if(loggedUser.login.compare(project.requests[i]) == 0){
                verify = true;
                showMessage("Você já pediu permissão de acesso a esse projeto.");
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

void showProject(int id) {
    printHeader();
    cout << "#--------# GERENCIAR PROJETO ";
    showID(id);
    cout << " #--------#" << endl << endl;

    vector<Project> projects = arquiveToArray();

    int aux = throughArray(id, projects);

    if (projects[aux].id == id){
        cout << "ID: ";
        showID(id);
        cout << "\nNome: " << projects[aux].name << endl;
        cout << "Descrição: " << projects[aux].description << endl;
        cout << "Dono: " << projects[aux].owner << endl << endl;
        pauseSystem();
    } else {
        showMessage("Id não encontrado");
    }
}