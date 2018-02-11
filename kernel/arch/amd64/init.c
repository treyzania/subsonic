#include <kernel.h>

void kernel_init(void) {

	// TODO Set up basic x86 stuff for servicing the main kernel system.

	// Actually jump to the main kernel.
	kernel_main(); // Shouldn't return.

}
