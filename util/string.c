#include <libk.h>

size_t strlen(const char* str) {
	size_t i = 0;
	while (str[i] != 0) {
		i++;
	}
	return i;
}

size_t strcpy(char* to, char* from, size_t max) {
	size_t i = 0;
	while (from[i] != 0 && i < max) {
		to[i] = from[i];
		i++;
	}
	if (i < max) {
		to[i + 1] = 0;
	}
	return i;
}
