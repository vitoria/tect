#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>
#include <string>

#include "project.h"
#include "constants.h"

void printProjectMenu();
void projectMenu();
void createProject(user);
void saveProject(Project);
void incializeIdProject();
int idProject();
bool verifyExistingProject(std::string);