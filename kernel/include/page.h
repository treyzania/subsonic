#pragma once

#include <defs.h>
#include <types.h>

#define MEM_PAGE_SIZE 4096
#define PAGE_BITMAP_PAGES 4

extern uint8_t heap_region_start;

void* alloc_page();
void free_pages(void* page);
