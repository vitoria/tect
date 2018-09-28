#pragma once

// Header
#define HEADER              "#-----------------# TecT #-----------------#"
#define MAIN_HEADER         "#-------------# MENU PRINCIPAL #-----------#"
#define MY_USER_HEADER      "#--------------# MEU USUARIO #-------------#"
#define LOGIN_HEADER        "#------------# LOGIN DE USUÁRIO #----------#"
#define SIGN_UP_HEADER      "#----------# CADASTRO DE USUÁRIO #---------#"
#define CREATE_SUITE_HEADER "#----------# CRIAR SUITE DE TEST #---------#"
#define SUITE_MENU_HEADER   "#------------# SUITE TEST MENU #-----------#"
#define SUITE_LIST_HEADER   "#--------------# SUITE TESTS #-------------#"
#define DELETE_SUITE_HEADER "#-------------# DELETE  SUITE #------------#"
#define EDIT_SUITE_HEADER   "#--------------# EDITE SUITE #-------------#"
#define SEARCH_SUITE_HEADER "#------------# PESQUISAR SUITE #-----------#"
#define SUITE_DETAILS       "#-----------# DETALHES DA SUITE #----------#"
#define LINE                "--------------------------------------------"
#define TABLE_HEADER        "-     ID     | Nome da suite               -"

// Menus
#define MY_USER_MENU "(1) Ver perfil\n(2) Alterar senha\n(3) Voltar"
#define LOGIN_MENU "(1) Efetuar login\n(2) Cadastrar novo usuário\n(3) Sair"
#define MAIN_MENU "(1) Meu usuario\n(2) Criar Projeto\n(3) Pedir acesso a um projeto\n(4) Pesquisar Projeto\n(5) Editar Projeto\n(6) Logout\n(7) Sair"
#define SUITE_MENU "(1) Criar suite de teste\n(2) Listar suites de teste\n(3) Pesquisar suite de teste\n(4) Editar suite de teste\n(5) Apagar suite de teste\n(6) Gerenciar casos de teste\n(7) Voltar"
#define TEST_CASE_MENU "(1) Criar caso de teste\n(2) Listar casos de teste\n(3) Pesquisar caso de teste\n(4) Editar caso de teste\n(5) Apagar caso de teste\n(6) Voltar"

// Main menu options
#define MY_USER                '1'
#define CREATE_PROJECT         '2'
#define ASK_FOR_ACCESS_PROJECT '3'
#define SEARCH_PROJECT         '4'
#define EDIT_PROJECT           '5'
#define LOGOUT                 '6'
#define MAIN_EXIT              '7'

// My user menu options
#define MY_PROFILE      '1'
#define CHANGE_PASSWORD '2'
#define MY_USER_BACK    '3'

// Login menu options
#define LOGIN   '1'
#define SIGN_UP '2'
#define EXIT    '3'

// Suite Tests menu options
#define CREATE_SUITE        '1'
#define LIST_SUITES         '2'
#define SEARCH_SUITE        '3'
#define EDIT_SUITE          '4'
#define DELETE_SUITE        '5'
#define MANAGE_TEST_CASES   '6'
#define GO_BACK             '7'

//All from testCase
#define OBJECTIVE "Objetivo: "
#define PRECONDITIONS "Pré-condições: "
#define CASE_NOT_EXECUTED 0
#define CASE_PASSED 1
#define CASE_NOT_PASSED 2
#define CASE_ERROR 3
#define CASE_STEPS_READING_HEADER " - Passos de execução do caso de testes - "
#define CASE_STEP_DESCRIPTION "Descrição do passo: "
#define CASE_STEP_EXPECTED_RESULT "Resultado esperado para o passo: "
#define CASE_STEP_CONTINUE_MESSAGE "Deseja inserir outro passo (S/N)?"
#define CREATE_CASE_HEADER     "#----------# CRIAR CASO DE TESTE #---------#"
#define SEARCH_CASE_HEADER     "#--------# PESQUISAR CASO DE TESTE #-------#"
#define CASE_DETAILS           "#-------# DETALHES DO CASO DE TESTE #------#"
#define EDIT_CASE_HEADER       "#---------# EDITAR CASO DE TESTE #---------#"
#define DELETE_CASE_HEADER     "#--------# EXCLUIR CASO DE TESTE #---------#"
#define TEST_CASE_MENU_HEADER  "#--------# MENU DE CASOS DE TESTE #--------#"
#define TEST_CASE_MANAGER_HEADER  "#-------# GERENCIAR CASOS DE TESTE #-------#"
#define TEST_CASE_HEADER       "#--------------------# CASOS DE TESTE #------------------------#"
#define TEST_CASE_TABLE_HEADER "-     ID     |             Nome            |       Status      -"
#define TEST_CASE_TABLE_LINE   "----------------------------------------------------------------"
#define CHOOSE_CASE "Informe o nome ou ID do Caso de Teste: "
#define CASE_NOT_FOUND "Caso não encontrado."
#define CASE_EDITED "Caso editado com sucesso!"
#define CASE_DELETED "Caso deletado com sucesso!"
#define CREATE_CASE '1'
#define LIST_CASES '2'
#define SEARCH_CASES '3'
#define EDIT_CASES '4'
#define DELETE_CASES '5'
#define GO_BACK_TEST_CASES '6'

// Paths
#define DATA_FOLDER_PATH "data"
#define SUITES_FILE_PATH "suites.dat"
#define USERS_FILE_PATH "data/users.dat"
#define LOGGED_USER_FILE_PATH "data/logged.dat"

#define MIN_PASSWORD_CHARACTERES 4

#define FOLDER_CREATION_PARAMETER 0700

#define CLEAR "clear"
#define INVALID_OPTION "Opção inválida!"
#define EXIT_MSG "Encerrando sistema..."
#define LOGOUT_MSG "Saindo do usuário atual..."
#define PAUSE_MSG "Pressione ENTER para continuar..." 

#define NAME "Nome: "
#define USERNAME "Username: "
#define SUSPENSION_POINTS "..."
#define DESCRIPTION "Descrição: "
#define NEW_PASSWORD "Senha nova: "
#define OLD_PASSWORD "Senha antiga: "
#define PASSWORD_INCORRECT "Senha incorreta!"
#define SUITE_NOT_FOUND "Suite nao encontrada"
#define SUITE_EDITED "Suite editada com sucesso!"
#define CREATION_SUCCESS "Criado com sucesso! o/"
#define CHOOSE_OPTION "Informe a opção desejada: "
#define REPEAT_NEW_PASSWORD "Repita a senha nova: "
#define SUITE_DELETED "Suite deletada com sucesso!"
#define PASSWORDS_NOT_MATCH "As senhas não conferem!"
#define CHOOSE_SUITE "Informe o nome ou ID da suite: "
#define CREATION_FAILED "Nao eh possivel realizar cadastro duplicado :/"
#define PASSWORD_SHOULD_CONTAINS_MIN_CHARACTERS "A senha deve conter pelo menos 4 caracteres!"
