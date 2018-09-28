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

void generateSuiteReport(suite, vector<Case>);
void generateProjectReport(Project, vector<suite>);
void generateUserReport(string, vector<Project>);
void generateReport(user);