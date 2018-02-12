#pragma once

#include "types.h"

void memcpy(void* to, void* from, size_t len);

size_t strlen(char* str, size_t max);
size_t strcpy(char* to, char* from, size_t max);
