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

#define OBJECTIVE "Objetivo: "
#define PRECONDITIONS "Pré-condições: "
#define CASE_NOT_EXECUTED 0
#define CASE_PASSED 1
#define CASE_NOT_PASSED 2
#define CASE_ERROR 3
#define CASE_STEPS_READING_HEADER " - Passos de execução do caso de testes - "
#define CASE_STEP_DESCRIPTION "Descrição do passo: "
#define CASE_STEP_EXPECTED_RESULT "Resultado esperado para o passo: "
#define CASE_STEP_CONTINUE_MESSAGE "Deseja inserir outro passo (S/N)?"
#define CREATE_CASE_HEADER     "#----------# CRIAR CASO DE TESTE #---------#"
#define TEST_CASE_HEADER       "#--------------------# CASOS DE TESTE #------------------------#"
#define TEST_CASE_TABLE_HEADER "-     ID     |             Nome            |       Status      -"
#define TEST_CASE_TABLE_LINE   "----------------------------------------------------------------"

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
};

Case readCaseInformation();
int searchCase(std::vector<Case>, std::string);
int searchCase(std::vector<Case>, int);
bool containsCase(std::vector<Case>, std::string);
bool containsCase(std::vector<Case>, int);
void createCase(int, int);
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