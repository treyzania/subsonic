#include "page.h"

#define ALLOC_UNINITED 0
#define ALLOC_INIT_STARTED 1
#define ALLOC_INIT_FINISHED (1 << 1)
#define ALLOC_ERR (1 << 31)

static uint8_t allocator_state = ALLOC_UNINITED;

static memspace* kspace_page;

void init() {

	if (allocator_state & ALLOC_ERR) {
		// TODO Make it shit the bed.
		return;
	}

	if (allocator_state & ALLOC_INIT_FINISHED) {
		return; // We're okay, just return.
	}

}

void* kmalloc(size_t bytes) {

	init();
	return NULL; // TODO

}
