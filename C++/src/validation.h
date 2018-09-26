#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <string>

bool isMenuInputStringValid(std::string, char, char);
bool isSelectedOptionValid(char, char, char);
void printInvalidOptionMessage();