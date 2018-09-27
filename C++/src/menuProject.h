#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>
#include <string>
#include <vector>

#include "generalPrints.h"
#include "validation.h"
#include "login.h"
#include "project.h"

#define PROJECT_FILE_NAME "projects.dat"

void verifyUserToProject(user, int);
void printProjectMenuOwner();
void projectMenuOwner(int);
void printProjectMenuUser();
void projectMenuUser(int);