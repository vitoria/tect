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
    int idCase;
    string name;
    string objectives;
    string preconditions;
    vector<Step> steps;
};


struct testCases{
    vector<Case> arrayCases;
};

void createCase(int);
void listTestsCases();
void searchTestsCases();
void editTestsCases(string name);
int findTestCase(string name);
void removeTestCase(string name);