#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>
#include <string>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "project.h"
#include "suiteTest.h"
#include "testCase.h"
#include "login.h"
#include "dataManagerProject.h"
#include "constants.h"


void generateSuiteReport(suite, std::vector<Case>);
void generateProjectReport(Project, std::vector<suite>);
void generateUserReport(std::string, std::vector<Project>);
void generateReport(user);