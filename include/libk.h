#pragma once

#include "types.h"

void memcpy(void* to, void* from, size_t len);
int memcmp(const void *s1, const void *s2, size_t n);
void* memset(void* s, int c, size_t n);

size_t strlen(char* str, size_t max);
size_t strcpy(char* to, char* from, size_t max);
