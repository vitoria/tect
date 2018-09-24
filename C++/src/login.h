#pragma once

#include <iostream>
#include <cctype>
#include <stdlib.h>
#include <cstdlib>

#include "validation.h"
#include "generalPrints.h"

void printLoginMenu();

/*
Menu de login do Sistema TecT, irá retornar true para login efetuado ou false, caso contrário.
*/
bool loginMenu();