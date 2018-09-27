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
    int numberOfRequests;
    std::vector<std::string> requests;
};

void verifyUserToProject(user, int);
void printProjectMenuOwner();
void projectMenuOwner(int);
void printProjectMenuUser();
void projectMenuUser(int);
<<<<<<< HEAD
int throughArray(int, std::vector<Project>, int);
=======
int throughArray(int, std::vector<Project>);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
void editNameProject(int);
void editDescriptionProject(int);
void allowPermissions(int);
void split(std::string, std::vector<std::string>);
void deleteProject(int);
void createSuite(int);
void listSuites(int);
void searchSuite(int);
void generateReport(int);
<<<<<<< HEAD
void swapProject(std::vector<Project>, int, int);
=======
void swapProject(std::vector<Project>, int);
>>>>>>> 473c4df85d7e1741b3efaa3f03a418dfaf2bbe90
