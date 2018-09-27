#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>
#include <string>

#include "project.h"

void printProjectMenu();
void projectMenu();
void createProject();
void saveProject(Project);
void incializeIdProject();
int idProject();
bool verifyExistingProject(std::string);