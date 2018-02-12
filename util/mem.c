#include <libk.h>

void memcpy(void* to, void* from, size_t len) {
	for (size_t i = 0; i < len; i++) {
		((uint8_t*) to)[i] = ((uint8_t*) from)[i];
	}
}
