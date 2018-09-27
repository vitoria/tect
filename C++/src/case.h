#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>


struct Step {
    string description;
    string expectedResult;
};
struct Case{
    int idProject;
    string name;
    string objectives;
    string preconditions;
    vector<Step> steps;
    int numberOfSteps;
};