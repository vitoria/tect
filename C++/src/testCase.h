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
    std::string description;
    std::string expectedResult;
};

struct Case{
    int idCase;
    std::string name;
    std::string objectives;
    std::string preconditions;
    std::vector<Step> steps;
};

struct testCases{
    std::vector<Case> arrayCases;
};

void createCase();
void listTestsCases();
void searchTestsCases();
void editTestsCases();
int findTestCase(std::string);
void removeTestCase();
int findTestCasePorId(int);
void removeTestCase();
void editStepTestCase(int, int);
int generateId();
char editTestsMenu();
void menuPrincipalCases();
void printMenuPrincipal();