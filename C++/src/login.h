#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>

#include "validation.h"
#include "generalPrints.h"

struct user {
    string login;
    string name;
};

bool existingUserLogin(user*);
bool registerNewUser();
void printLoginMenu();
bool loginMenu(user*, bool*);