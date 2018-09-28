#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "testCase.h"
#include "validation.h"
#include "constants.h"
#include "generalPrints.h"
#include "login.h"
#include "myUser.h"

const std::string caseStatusMessage[] = {"Não executado", "Passou", "Não passou", "Erro na execução"};

struct Step {
    std::string description;
    std::string expectedResult;
};

struct Case{
    int id;
    std::string name;
    std::string objectives;
    std::string preconditions;
    std::vector<Step> steps;
    int status;
    std::string authorUser;
};

std::string generateTestCaseFilePath(int, int);
std::string generateTestCaseFolderPath(int);
void writeCases(std::vector<Case>, int, int);
std::vector<Case> readCases(int, int);
Case readCaseInformation();
int searchCase(std::vector<Case>, std::string);
int searchCase(std::vector<Case>, int);
bool containsCase(std::vector<Case>, std::string);
bool containsCase(std::vector<Case>, int);
void createCase(int, int);
void listTestsCases(int, int);
std::string readSelectedCase();
void showCase(Case);
void searchCase(int, int);
Case editCaseInformation(Case);
void editCase(std::vector<Case>, int, int, int);
void editCase(int, int);
void deleteCase(std::vector<Case>, int, int, int);
void deleteCase(int, int);
int generateId(std::vector<Case>);
void showTestCaseMenu();
void goToProcediment(char, int, int);
void testCaseMenu(int, int);