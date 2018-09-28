#include "generalPrints.h"
#include "constants.h"
#include <iomanip>

using namespace std;

void printHeader() {
    system(CLEAR);
    cout << HEADER << endl;
}

void printHeader(string subtitle) {
    printHeader();
    cout << subtitle << endl << endl;
}

void showMessage(string msg) {
    cout << msg;
    cin.get();
    cin.ignore();
    system(CLEAR);
}

void pauseSystem() {
    showMessage(PAUSE_MSG);
}

string readOption() {
    string optionSelected;
    cout << endl << CHOOSE_OPTION;
    getline(cin, optionSelected);
    return optionSelected;
}

void showLine() {
    cout << LINE << endl;
}

void showID(int id) {
    cout << setfill('0') << setw(4) << id;
}