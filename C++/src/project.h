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

#define PROJECT_FILE_NAME "projects.dat"

struct Project{
    int id;
    string name;
    string description;
    string owner;
    int numberOfUsers;
    string *users;
    int numberOfRequests;
    string *requests;
};

void printProjectMenu();
void projectMenu(int);
void editNameProject(int);
void editDescriptionProject(int);
void allowPermissions(int);
void allowPermissions(int);
void createSuite(int);
void listSuites(int id);
void searchSuite(int id);

