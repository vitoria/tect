#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>
#include <fstream>
#include <string>

#include "project.h"

std::vector<Project> arquiveToArray();
void arrayToArquive(std::vector<Project>);
void cleanFile();