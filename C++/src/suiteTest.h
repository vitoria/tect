#pragma once

#include "suiteTest.h"
#include "constants.h"
#include "validation.h"
#include "generalPrints.h"
#include <string>
#include <vector>
#include <fstream>

/**
 * This struct represents a suite
 * that contains an automatic generated id,
 * a name and a simple description.
 */
struct suite {
    int id;
    std::string name;
    std::string description;
    int projectId;
};


void suiteTestMenu();

void createSuite();

std::vector<suite> readSuites();

void listSuites();

void editSuite();

void deleteSuite();

void searchSuite();