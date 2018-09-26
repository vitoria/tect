#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>
#include <string>

#include "generalPrints.h"
#include "validation.h"

#define PROJECT_FILE_NAME "projects.dat"

struct Project{
    int id;
    string name;
    string description;
    string owner;
    int numberOfUsers;
    string users[];
    int numberOfRequests;
    string requests[];
};

