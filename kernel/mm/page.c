#include <kernel.h>

static inline void page_bitmap_set(size_t pi, uint8_t state) {

	uint8_t* p = (&heap_region_start) + (pi / 8);
	uint8_t subbyte_index = 7 - pi % 8;
	if (state == 0) {
		*p |= (1 << subbyte_index);
	} else {
		*p &= ~(1 << subbyte_index);
	}

}

static inline uint8_t page_bitmap_get(size_t pi) {
	uint8_t* p = (&heap_region_start) + (pi / 8);
	uint8_t subbyte_index = 7 - pi % 8;
	return ((*p & (1 << subbyte_index)) != 0) ? 1 : 0;
}

static size_t find_free_page_index() {

	size_t byte_index = 0;

	/*
	 * First we have to do some iteration to find a byte that isn't already
	 * totally filled up.
	 */
	while (byte_index < (MEM_PAGE_SIZE * PAGE_BITMAP_PAGES)) {
		uint8_t* p = (&heap_region_start) + byte_index;
		if (*p != 0xff) {

			/*
			 * Now we iterate over the bits in the byte to figure out which onc
			 * is empty in the byte.
			 */
			for (int bit = 0; bit < 8; bit++) {
				size_t page = byte_index * 8 + bit;

				// If this succeeds then we're good.
				if (page_bitmap_get(page) == 1) {
					return page;
				}
			}
		}
	}

	return -1;

}

void* alloc_page() {

	size_t page = find_free_page_index();
	if (page != -1) {
		page_bitmap_set(page, 1);
		return (&heap_region_start) + (MEM_PAGE_SIZE * (page + PAGE_BITMAP_PAGES));
	} else {
		return NULL;
	}

}

void free_pages(void* page) {

	uint8_t* ptr_u8 = page;
	size_t pi = (ptr_u8 - (MEM_PAGE_SIZE * PAGE_BITMAP_PAGES) - (&heap_region_start)) / MEM_PAGE_SIZE;
	if (page_bitmap_get(pi) == 1) {
		page_bitmap_set(pi, 0);
	} else {
		// it wasn't set, figure out what to do later
	}

}
