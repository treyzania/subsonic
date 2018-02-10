#include <mm/page.h>

memspace* memspace_create() {
	return NULL; // TODO Write the memory allocator.
}

void memspace_destroy(memspace* ms) {
	// TODO Write the memory allocator.
}

mempage* page_allocate(memspace* owner, uint8_t flags) {
	return NULL; // TODO Write the memory allocator.
}

void page_deallocate(mempage* page) {
	// TODO Write the memory allocator.
}

retcode page_bind(memspace* ms) {
	// TODO Write the memory allocator.
}
