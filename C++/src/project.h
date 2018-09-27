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

#define PROJECT_FILE_NAME "projects.dat"

struct Project{
    int id;
    std::string name;
    std::string description;
    std::string owner;
    int numberOfUsers;
    std::vector<std::string> users;
    //std::string *users;
    int numberOfRequests;
    std::vector<std::string> requests;
    //std::string *requests;
};

void verifyUserToProject(user, int);
void printProjectMenuOwner();
void projectMenuOwner(int);
void printProjectMenuUser();
void projectMenuUser(int);
void editNameProject(int);
void editDescriptionProject(int);
void allowPermissions(int);
void split(std::string, std::vector<std::string>);
void createSuite(int);
void listSuites(int);
void searchSuite(int);
void generateReport(int);
void swapProject(std::vector<Project>, int, int);

