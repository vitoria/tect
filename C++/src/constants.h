#pragma once

// Main menu options
#define MY_USER '1'
#define CREATE_PROJECT '2'
#define ASK_FOR_ACCESS_PROJECT '3'
#define SEARCH_PROJECT '4'
#define EDIT_PROJECT '5'
#define LOGOUT '6'
#define MAIN_EXIT '7'

// My user menu options
#define MY_PROFILE '1'
#define CHANGE_PASSWORD '2'
#define MY_USER_BACK '3'

// Paths
#define DATA_FOLDER_PATH "data"
#define SUITES_PATH "suites.dat"
#define USERS_FILE_PATH "data/users.dat"
#define LOGGED_USER_FILE_PATH "data/logged.dat"

#define EXIT '3'
#define EXIT_MSG "Encerrando sistema..."
#define LOGIN '1'
#define SIGN_UP '2'
#define LOGOUT_MSG "Saindo do usuário atual..."
#define CLEAR "clear"
#define PAUSE_MSG "Pressione ENTER para continuar..." 
#define INVALID_OPTION "Opção inválida!"
#define MAIN_MENU "(1) Meu usuario\n(2) Criar Projeto\n(3) Pedir acesso a um projeto\n(4) Pesquisar Projeto\n(5) Editar Projeto\n(6) Logout\n(7) Sair"
#define LOGIN_MENU "(1) Efetuar login\n(2) Cadastrar novo usuário\n(3) Sair"
#define SUITE_MENU "(1) Criar suite de teste\n(2) Listar suites de teste\n(3) Pesquisar suite de teste\n(4) Editar suite de teste\n(5) Apagar suite de teste\n(6) Voltar"
#define MY_USER_MENU "(1) Ver perfil\n(2) Alterar senha\n(3) Voltar"
#define CREATE_SUITE '1'
#define LIST_SUITES '2'
#define SEARCH_SUITE '3'
#define EDIT_SUITE '4'
#define DELETE_SUITE '5'
#define GO_BACK '6'

// Header
#define HEADER              "#-----------------# TecT #-----------------#"
#define MAIN_HEADER         "#-------------# MENU PRINCIPAL #-----------#"
#define MY_USER_HEADER         "#--------------# MEU USUARIO #-------------#"
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
#define SUSPENSION_POINTS "..."
#define NAME "Nome: "
#define USERNAME "Username: "
#define DESCRIPTION "Descrição: "
#define CHOOSE_OPTION "Informe a opção desejada: "
#define CREATION_SUCCESS "Criado com sucesso! '\'o/"
#define CREATION_FAILED "Nao eh possivel realizar cadastro duplicado :/"
#define CHOOSE_SUITE "Informe o nome ou ID da suite: "
#define SUITE_NOT_FOUND "Suite nao encontrada"
#define SUITE_DELETED "Suite deletada com sucesso!"
#define SUITE_EDITED "Suite editada com sucesso!"
#define MIN_PASSWORD_CHARACTERES 4
#define PASSWORD_INCORRECT "Senha incorreta!"
#define OLD_PASSWORD "Senha antiga: "
#define NEW_PASSWORD "Senha nova: "
#define REPEAT_NEW_PASSWORD "Repita a senha nova: "
#define PASSWORDS_NOT_MATCH "As senhas não conferem!"
#define PASSWORD_SHOULD_CONTAINS_MIN_CHARACTERS "A senha deve conter pelo menos 4 caracteres!"
