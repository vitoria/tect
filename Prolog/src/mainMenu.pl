:-initialization(main).


main:-
	tty_clear,
    write("#----------------------# TecT #----------------------#"),nl,
    write("#----------------# MENU PRINCIPAL #----------------------#"),nl,
	write("(1) Meu usuario"),nl,
	write("(2) Criar Projeto"),nl,
    write("(3) Pedir acesso a um projeto"),nl,
    write("(4) Listar Projetos"),nl,
    write("(5) Gerenciar Projeto"),nl,
    write("(6) Gerar Relatórios"),nl,
    write("(7) Logout"),nl,
    write("(8) Sair"),nl,
	read_line_to_codes(user_input, OP),
	(name("1", OP) -> menuLoginCliente;
     name("2", OP) -> menuCadastrarCliente;
     name("3", OP) -> menuCadastrarCliente;
     name("4", OP) -> menuCadastrarCliente;
     name("5", OP) -> menuCadastrarCliente;
     name("6", OP) -> menuCadastrarCliente;
     name("7", OP) -> menuCadastrarCliente;
	 name("8", OP) -> halt(0); main).

