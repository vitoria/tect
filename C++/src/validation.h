#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <string>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

bool isMenuInputStringValid(std::string, char, char);

bool isSelectedOptionValid(char, char, char);

void printInvalidOptionMessage();

std::string removeWhiteSpaces(std::string);

bool isTextValid(std::string);

std::string getWhiteSpaces(int size);

std::string truncate(std::string, int);

int stringToInteger(std::string);

bool isCharANumber(char);

bool isStringNumeric(std::string);

std::string stringToUpper(std::string);

bool verifyPasswords(std::string, std::string);

bool isFolderCreated (std::string);

bool createFolder(std::string);