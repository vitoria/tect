#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <string>

bool isMenuInputStringValid(std::string, char, char);

bool isSelectedOptionValid(char, char, char);

void printInvalidOptionMessage();

std::string removeWhiteSpaces(std::string);

bool isTextValid(std::string);

std::string truncate(std::string, int);