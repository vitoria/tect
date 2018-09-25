#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <string>

struct Step {
    string description;
    string expectedResult;
};
struct Case{
    int idProject;
    string name;
    string goal;
    string preconditions;
    Step steps[10];
};