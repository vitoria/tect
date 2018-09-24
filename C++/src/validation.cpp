#include "validation.h"

using namespace std;

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