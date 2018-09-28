#include "validation.h"
#include "constants.h"
#include "generalPrints.h"

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

string removeWhiteSpaces(string str) {
    string result = "";

    for (int i = 0; i < str.size(); i++) {
        if (str[i] != ' ') {
            result += str[i];
        }
    }

    return result;
}

bool isTextValid(string text) {
    string currentText = removeWhiteSpaces(text);
    return currentText.compare("") != 0;
}

string getWhiteSpaces(int size) {
    string whiteSpaces = "";
    for (int i = 0; i < (size - 1); i++) {
        whiteSpaces += " ";
    }
    return whiteSpaces;
}

string truncate(string text, int size) {
    if (text.size() > size) {
        text = text.substr(size - 3);
        text += SUSPENSION_POINTS;
    }
    return (text + getWhiteSpaces(size - text.size()));
}

int stringToInteger(string str) {
    int result = -1;
    if (isStringNumeric(str)) {
        result = stoi(str);
    }
    return result;
}

bool isCharANumber(char ch) {
    bool result = false;
    if (ch >= '0' && ch <= '9') {
        result = true;
    }
    return result;
}

bool isStringNumeric(string str) {
    bool result = true;
    for (int i = 0; i < str.size() && result; i++) {
        result = isCharANumber(str[i]);
    }
    return result;
}

string stringToUpper(string str) {
    for (int i = 0; i < str.size(); i++) {
        str[i] = toupper(str[i]);
    }
    return str;
}

bool verifyPasswords(string password, string password2) {
    bool isValid = true;
    
    if (password.compare(password2) != 0) {
        showMessage(PASSWORDS_NOT_MATCH);
        isValid = false;
    } else if (password.size() < MIN_PASSWORD_CHARACTERES) {
        showMessage(PASSWORD_SHOULD_CONTAINS_MIN_CHARACTERS);
        isValid = false;
    }

    return isValid;
}

bool isFolderCreated (string folderPath) {
    bool result;
    struct stat folderRestrict = {0};

    if (stat(folderPath.c_str(), &folderRestrict) == -1) {
        result = createFolder(folderPath);
    } else {
        result = true;
    }

    return result;
}

bool createFolder(string folderPath) {
    bool result = false;
    if (mkdir(folderPath.c_str(), FOLDER_CREATION_PARAMETER) == 0) {
        result = true;
    }
    return result;
}