#include "validation.h"
#include "constants.h"

using namespace std;

bool isMenuInputStringValid(string option, char intervalBegin, char intervalEnd) {
    bool result = true;

    if (option.length() != 1) {
        result = false;
    } else {
        result = isSelectedOptionValid(option[0], intervalBegin, intervalEnd);
    }

    return result;
}

bool isSelectedOptionValid(char option, char intervalBegin, char intervalEnd) {
    return (option >= intervalBegin && option <= intervalEnd);
}

void printInvalidOptionMessage() {
    system (CLEAR);
    cout << INVALID_OPTION << endl;
    cout << PAUSE_MSG << endl;
    cin.get();
    system (CLEAR);
}

std::string removeWhiteSpaces(std::string str) {
    std::string result = "";

    for (int i = 0; i < str.size(); i++) {
        if (str[i] != ' ') {
            result += str[i];
        }
    }

    return result;
}

bool isTextValid(std::string text) {
    std::string currentText = removeWhiteSpaces(text);
    return currentText.compare("") != 0;
}
