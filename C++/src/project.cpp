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

void editNameProject(int id){
    Project *projects;

    int size = arquiveToArray(projects);
    int aux = 0;

    while(projects[aux].id != id || aux < size){
        aux++;
    }

    if (projects[aux].id == id){
        cout << "Novo nome: ";
        getline(cin, projects[aux].name);
        cout << "Nome de projeto editado com sucesso." << endl;
    } else {
        cout << "Id não encontrado" << endl;
    }
}

void editDescriptionProject(int id){
    Project *projects;

    int size = arquiveToArray(projects);
    int aux = 0;

    while(projects[aux].id != id || aux < size){
        aux++;
    }

    if (projects[aux].id == id){
        cout << "Nova descrição: ";
        getline(cin, projects[aux].description);
        cout << "Descrição de projeto editado com sucesso." << endl;
    } else {
        cout << "Id não encontrado" << endl;
    }
}
