<<<<<<< HEAD
:-initialization(main).

main:-
	tty_clear,

	write("#----------------------# TecT #----------------------#"),nl,
	write("(1) Efetuar Login"),nl,
	write("(2) Cadastrar novo usuário"),nl,
	write("(3) Sair"),nl,
	read_line_to_codes(user_input, OP),
	(name("1", OP) -> menuLoginCliente;
	 name("2", OP) -> menuCadastrarCliente;
	 name("3", OP) -> halt(0); main).

menuCadastrarCliente:-
    tty_clear,
    write("---------------------------------------------"),nl,
    write("---------------------------------------------"),nl,nl,
    write("| CADASTRAR NOVO CLIENTE"),nl,
    write("---------------------------------------------"),nl,nl,
    cliente:newCliente -> write("\n\nCadastro realizado com sucesso!\n"), util:press_enter, main;
    write("\nFalha no cadastro: Login já está sendo utilizado, tente novamente.\n"), util:press_enter, main.
=======
:- initialization(main).

main :- writeln("Hello world").
>>>>>>> c9c950c752e71d639c214aa11374e6d89509e06f
