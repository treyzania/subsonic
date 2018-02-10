#pragma once

#include <defs.h>
#include <types.h>

#define MEM_PAGE_SIZE 1024

struct mem_page_t;
struct mem_space_t;

typedef struct mem_page_t mempage;
typedef struct mem_space_t memspace;

struct mem_page_t {
	uint64_t start_page;
	memspace* owner;
	uint8_t flags;
};

struct mem_space_t {
	uint64_t space_id;
	uint64_t num_regions;
	mempage pages[];
};

/**
 * Creates a memory space, incrementing its ID.
 */
memspace* memspace_create();

/**
 * Destroys a memory space and allows all containing pages to be freed.
 */
void memspace_destroy(memspace* ms);

/**
 * Allocates a page in the memory space for its owner.
 */
mempage* page_allocate(memspace* owner, uint8_t flags);

/**
 * Frees a page as applicable.
 */
void page_deallocate(mempage* page);

/**
 * Binds page settings to the memory manager, as applicable.
 */
retcode page_bind(memspace* ms);
