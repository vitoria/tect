#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>
#include <string>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "validation.h"
#include "generalPrints.h"

struct user {
    std::string login;
    std::string name;
};

bool existingUserLogin(user*);
bool registerNewUser();
bool isFolderCreated (const char*);
bool createFolder(const char*);
void printLoginMenu();
bool loginMenu(user*, bool*);