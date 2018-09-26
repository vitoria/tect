#include <project.h>
#include <dataManagerProject.h>

using namespace std;

void printProjectMenu(){
    system ("clear");
    printTectHeader();
    cout << "Projeto " << ""; //adicionar varíavel com nome do projeto 
    cout << "Selecione a opção desejada: " << endl;
    cout << "(1) Editar nome do projeto" << endl;
    cout << "(2) Editar descrição do projeto" << endl;
    cout << "(3) Verificar pedidos de permissão" << endl;
    cout << "(4) Excluir projeto" << endl;
    cout << "(5) Criar suíte de testes" << endl;
    cout << "(6) Listar suítes de testes" << endl;
    cout << "(7) Consultar suítes de testes" << endl;
    cout << "(8) Gerar relatório de projeto" << endl;
    cout << "(9) Sair do projeto" << endl;

}

void projectMenu(int id){
    char selectedOption = '0';
    do {
        do {
            printProjectMenu();

            cin.get(selectedOption);
            cin.ignore();

            if (isSelectedOptionValid(selectedOption, '1', '9') == false) {
                printInvalidOptionMessage();
            }
        } while (isSelectedOptionValid(selectedOption, '1', '9') == false);

        switch(selectedOption){
            case '1':
                editNameProject(id);
                break;
            case '2':
                editDescriptionProject(id);
                break;
            case '3':
                allowPermissions(id);
                break;
            case '4':
                cout << "Projeto excluído com sucesso" << endl;
                break;
            case '5':
                createSuite(id);
                cout << "Suíte de testes criado com sucesso" << endl;
                break;
            case '6':
                listSuites(id);
                cout << "Fim." << endl;
                break;
            case '7':
                searchSuite(id);
                cout << "Consulta realizada com sucesso" << endl;
                break;
            case '8':
                generateReport(id);
                cout << "Relatório gerado com sucesso" << endl;
                break;
            case '9':
                cout << "Saindo do projeto" << endl;
                break;
            default:
                cout << "ERRO!" << endl;
                break;
        }
    
        cout << "Pressione qualquer tecla para continuar..." << endl;
        cin.get();
        system ("clear");
    } while (selectedOption != '5');
}

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
        arrayToArquive(projects, size);
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
        arrayToArquive(projects, size);
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
            arrayToArquive(projects, size);
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

    arrayToArquive(projects, size-1);

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

