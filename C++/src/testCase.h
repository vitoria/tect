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
#define SEARCH_CASE_HEADER     "#--------# PESQUISAR CASO DE TESTE #-------#"
#define CASE_DETAILS           "#-------# DETALHES DO CASO DE TESTE #------#"
#define EDIT_CASE_HEADER       "#---------# EDITAR CASO DE TESTE #---------#"
#define DELETE_CASE_HEADER     "#--------# EXCLUIR CASO DE TESTE #---------#"
#define TEST_CASE_MENU_HEADER  "#--------# MENU DE CASOS DE TESTE #--------#"
#define TEST_CASE_MENU         "(1) Criar caso de teste\n(2) Listar casos de teste\n(3) Pesquisar caso de teste\n(4) Editar caso de teste\n(5) Apagar caso de teste\n(6) Voltar"
#define TEST_CASE_HEADER       "#--------------------# CASOS DE TESTE #------------------------#"
#define TEST_CASE_TABLE_HEADER "-     ID     |             Nome            |       Status      -"
#define TEST_CASE_TABLE_LINE   "----------------------------------------------------------------"
#define CHOOSE_CASE "Informe o nome ou ID do Caso de Teste: "
#define CASE_NOT_FOUND "Caso não encontrado."
#define CASE_EDITED "Caso editado com sucesso!"
#define CASE_DELETED "Caso deletado com sucesso!"
#define CREATE_CASE '1'
#define LIST_CASES '2'
#define SEARCH_CASES '3'
#define EDIT_CASES '4'
#define DELETE_CASES '5'


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

std::string generateTestCaseFilePath(int, int);
std::string generateTestCaseFolderPath(int);
void writeCases(std::vector<Case>, int, int);
std::vector<Case> readCases(int, int);
bool isFolderCreated (std::string);
bool createFolder(std::string);
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