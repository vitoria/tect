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

void suiteTestMenu(int);

void createSuite(int);

std::vector<suite> readSuites();

void listSuites(int);

void editSuite(int);

void deleteSuite(int);

void searchSuite(int);