#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>

#include "generalPrints.cpp"

struct Step {
    string description;
    string expectedResult;
};
struct Case{
    int idProject;
    string user;
    string name;
    string goal;
    string preconditions;
    Step steps[10];
};

void createCase(int codProject, string user);
void saveCase(Case testCase);