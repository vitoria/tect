#include "generalPrints.h"
#include "constants.h"
#include <iomanip>

using namespace std;

void printHeader() {
    system(CLEAR);
    cout << HEADER << endl;
}

void printHeader(std::string subtitle) {
    printHeader();
    std::cout << subtitle << std::endl << std::endl;
}

void showMessage(std::string msg) {
    std::cout << msg;
    std::cin.get();
    std::cin.get();
    system(CLEAR);
}

void pauseSystem() {
    showMessage(PAUSE_MSG);
}

std::string readOption() {
    std::string optionSelected;
    std::cout << std::endl << CHOOSE_OPTION;
    std::cin >> optionSelected;
    return optionSelected;
}

void showLine() {
    std::cout << LINE << std::endl;
}

void showID(int id) {
    std::cout << std::setfill('0') << std::setw(4) << id;
}