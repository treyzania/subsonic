#include <libk.h>

void memcpy(void* to, void* from, size_t len) {
	for (size_t i = 0; i < len; i++) {
		((uint8_t*) to)[i] = ((uint8_t*) from)[i];
	}
}

int memcmp(const void *s1, const void *s2, size_t n) {
	return 0; // TODO
}

void* memset(void* s, int c, size_t n) {
	for (int i = 0; i < n; i++) {
		((int*) s)[i] = c;
	}
	return s;
}
