#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>

/*
Função que verifica validade de uma opção selecionada no menu por meio de um intervalo
de caracteres. É recebido o caractere da seleção e os extremos do intervalo e retornado
um booleano representando a validade.
*/
bool isSelectedOptionValid(char, char, char);
void printInvalidOptionMessage();