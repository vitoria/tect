#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>

using namespace std;

/*
Função que verifica validade de uma opção selecionada no menu por meio de um intervalo
de caracteres. É recebido o caractere da seleção e os extremos do intervalo e retornado
um booleano representando a validade.
*/
bool isSelectedOptionValid(char, char, char);
void printInvalidOptionMessage();

bool isSelectedOptionValid(char option, char intervalBegin, char intervalEnd) {
    return (option >= intervalBegin && option <= intervalEnd);
}

void printInvalidOptionMessage() {
    system ("clear");
    cout << "Opção inválida!" << endl;
    cout << "Pressione qualquer tecla para continuar..." << endl;
    cin.get();
    system ("clear");
}