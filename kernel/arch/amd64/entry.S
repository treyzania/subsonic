/*
 * Kernel entry for amd64 arch
 */

/* ==== Header Settings ==== */

# Multiboot settings
.set MB_ALIGN, 1 << 0
.set MB_MEMINFO, 1 << 1
.set MB_FLAGS, MB_ALIGN | MB_MEMINFO
.set MB_MAGIC, 0x1BADB002
.set MB_CHECKSUM, -(MB_MAGIC + MB_FLAGS)

# The actual multiboot header.
	.section .multiboot
	.align 4
	.long MB_MAGIC
	.long MB_FLAGS
	.long MB_CHECKSUM

/* ==== Resources ==== */

# Now set up our bootstrapping stack.
	.section .bss
	.align 16
stack_bottom:
	.skip 16384
stack_top:

/* ==== Active Code ==== */

	.section .text

	# _start: the kernel entry point
	.global _start
	.type _start, @function
_start:
	# This prints "OKAY" to the VGA screen.
	mov %rax, 0x2f592f412f4b2f4f
	mov (0xb8000), %rax

	# Now we set up to call into the C init code.
	mov $stack_top, %esp
	call kernel_init
	cli
	hlt

_oops:
	jmp _oops

	# "Debugging"
	.size _start, . - _start
