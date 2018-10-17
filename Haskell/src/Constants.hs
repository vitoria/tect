module Constants where
        -- Header
        header =                "#-----------------# TecT #-----------------#"
        main_header =           "#-------------# MENU PRINCIPAL #-----------#"
        my_user_header =        "#--------------# MEU USUARIO #-------------#"
        login_header =          "#------------# LOGIN DE USUARIO #----------#"
        sign_up_header =        "#----------# CADASTRO DE USUARIO #---------#"
        create_suite_header =   "#----------# CRIAR SUITE DE TEST #---------#"
        suite_menu_header =     "#------------# SUITE TEST MENU #-----------#"
        suite_list_header =     "#--------------# SUITE TESTS #-------------#"
        delete_suite_header =   "#-------------# DELETE  SUITE #------------#"
        edit_suite_header =     "#--------------# EDITE SUITE #-------------#"
        search_suite_header =   "#------------# PESQUISAR SUITE #-----------#"
        suite_details =         "#-----------# DETALHES DA SUITE #----------#"
        line =                  "--------------------------------------------"
        table_header =          "-     ID     | Nome da suite               -"

        -- Menus
        my_user_menu = "(1) Ver perfil\n(2) Alterar senha\n(3) Voltar"
        login_menu = "(1) Efetuar login\n(2) Cadastrar novo usuário\n(3) Sair"
        main_menu = "(1) Meu usuario\n(2) Criar Projeto\n(3) Pedir acesso a um projeto\n(4) Listar Projetos\n(5) Gerenciar Projeto\n(6) Gerar Relatórios\n(7) Logout\n(8) Sair"
        suite_Menu = "(1) Criar suite de teste\n(2) Listar suites de teste\n(3) Pesquisar suite de teste\n(4) Editar suite de teste\n(5) Apagar suite de teste\n(6) Gerenciar casos de teste\n(7) Voltar"
        test_Case_Menu = "(1) Criar caso de teste\n(2) Listar casos de teste\n(3) Pesquisar caso de teste\n(4) Editar caso de teste\n(5) Apagar caso de teste\n(6) Voltar"

        -- Main menu options
        my_User = '1'
        create_project = '2'
        ask_for_access_project = '3'
        search_project = '4'
        edit_project = '5'
        reports = '6'
        logout = '7'
        main_exit = '8'

        -- My user menu options
        my_profile = '1'
        change_password = '2'
        my_user_back = '3'

        -- Login menu options
        login = '1'
        sign_up = '2'
        exit = '3'

        -- Suite Tests menu options
        create_suite = '1'
        list_suites = '2'
        search_suite = '3'
        edit_suite = '4'
        delete_suite= '5'
        manage_test_cases = '6'
        go_back = '7'

        -- All from testCase
        objective = "Objetivo: "
        preconditions = "Pré-condições: "
        case_not_executed = 0
        case_passed = 1
        case_not_passed = 2
        case_error = 3
        case_steps_reading_header = " - Passos de execução do caso de testes - "
        case_step_description = "Descrição do passo: "
        case_step_expected_result = "Resultado esperado para o passo: "
        case_step_continue_message = "Deseja inserir outro passo (S/N)?"
        header2 = "#----------------------# TecT #----------------------#"
        test_case_header = "#---------------# CASOS DE TESTE #-------------------#"
        create_case_header = "#----------# CRIAR CASO DE TESTE #---------#"
        list_projects_header = "#-------------# TODOS PROJETOS #-----------#"
        search_case_header = "#--------# PESQUISAR CASO DE TESTE #-------#"
        case_details = "#-------# DETALHES DO CASO DE TESTE #------#"
        edit_case_header = "#---------# EDITAR CASO DE TESTE #---------#"
        delete_case_header = "#--------# EXCLUIR CASO DE TESTE #---------#"
        test_case_menu_header = "#--------# MENU DE CASOS DE TESTE #--------#"
        generate_report_header = "#--------# MENU DE GERAR RELATÓRIO #-------#"
        test_case_manager_header = "#-------# GERENCIAR CASOS DE TESTE #-------#"
        test_case_table_header = "- ID | Nome | Status -"
        test_case_table_line = "------------------------------------------------------"
        list_projects_table_header = "- ID | Nome | Dono -"
        choose_case = "Informe o nome ou ID do Caso de Teste: "
        case_not_found = "Caso não encontrado."
        case_edited = "Caso editado com sucesso!"
        case_deleted = "Caso deletado com sucesso!"
        create_case = '1'
        list_cases = '2'
        search_cases = '3'
        edit_cases = '4'
        delete_cases = '5'
        go_back_test_cases = '6'

        -- Paths
        data_folder_path = "data"
        suites_file_path = "suites.dat"
        users_file_path = "data/users.dat"
        logged_user_file_path = "data/logged.dat"
        suites_path = "data/reportSuite"

        min_password_characteres = 4

        folder_creation_parameter = 0700

        clear = "clear"
        invalid_option = "Opção inválida!"
        exit_msg = "Encerrando sistema..."
        logout_msg = "Saindo do usuário atual..."
        pause_msg = "Pressione ENTER para continuar..." 

        name_const = "Nome: "
        username_const = "Username: "
        password_const = "Senha: "
        confirmation_password = "Digite a senha novamente: "
        suspension_points = "..."
        description = "Descrição: "
        new_password = "Senha nova: "
        old_password = "Senha antiga: "
        password_incorrect = "Senha incorreta!"
        suite_not_found = "Suite nao encontrada"
        suite_edited = "Suite editada com sucesso!"
        creation_success = "Criado com sucesso! o/"
        choose_option = "Informe a opção desejada: "
        repeat_new_password = "Repita a senha nova: "
        suite_deleted = "Suite deletada com sucesso!"
        passwords_not_match = "As senhas não conferem!"
        choose_suite = "Informe o nome ou ID da suite: "
        creation_failed = "Nao eh possivel realizar cadastro duplicado :/"
        password_should_contains_min_characters = "A senha deve conter pelo menos 4 caracteres!"
