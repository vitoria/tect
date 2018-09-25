#include <project.h>

#define PROJECT_FILE_NAME "projects.dat"

using namespace std;

struct Project{
    int id;
    string name;
    string description;
    string owner;
    string users[];
};

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

void projectMenu(){
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
                cout << "Nome de projeto editado com sucesso" << endl;
                break;
            case '2':
                cout << "Descrição de projeto editado com sucesso" << endl;
                break;
            case '3':
                cout << "Permissões dadas com sucesso" << endl;
                break;
            case '4':
                cout << "Projeto excluído com sucesso" << endl;
                break;
            case '5':
                cout << "Suíte de testes criado com sucesso" << endl;
                break;
            case '6':
                cout << "Fim." << endl;
                break;
            case '7':
                cout << "Consulta realizada com sucesso" << endl;
                break;
            case '8':
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

/*
Insere o valor 0 no arquivo, que indica o número de projetos criados.
*/
void incializeIdProject(){
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::out);

    projectFile << 0;
    projectFile << "*";

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

    do {
        cout << "Nome do projeto: ";
        getline(cin, newProject.name);
        if (verifyExistingProject() == true){
            cout << "Nome de projeto já criado";
        }
    } while (verifyExistingProject() == true);

    cout << "Descrição do projeto: ";
    getline(cin, newProject.description);

    system("clear");

    newProject.id = idProject();

    saveProject(newProject);
    
}

void saveProject(Project project){
    

    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::out | ios::app);
    if (projectFile.is_open()){
        projectFile << id << endl << name << endl << description << endl;
        projectFile << "*";
        projectFile.close();
        cout << "Projeto criado com sucesso!" << endl;
    } else {
        cout << "Erro ao criar projeto " << name << endl;
    }
}


/*
Incrementa o número de projetos criados e retorna esse número.
*/
//falta sobrescrever linha com o número de projetos
int idProject(){
    string value;
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::in);
    getline(projectFile, value);
    projectFile.close();

    int number;
    number = stoi(value);

    number++;

    return number;
}

/*
Verifica se um nome de projeto já foi criado antes.
*/

bool verifyExistingProject(string name){
    bool existProject = false;

    string fileOutput;
    fstream projectFile;
    projectFile.open(PROJECT_FILE_NAME, ios::in);
    getline(projectFile, fileOutput);
    getline(projectFile, fileOutput);
    if (projectFile.is_open){
        while(existProject == false && getline(projectFile, fileOutput)) {
            if (fileOutput.compare(name) == 0) {
                existProject = true;
            } else {
                getline(projectFile, fileOutput);
                getline(projectFile, fileOutput);
            }
        }
    }
    return existProject;
}
