## Privilaged Service Routines (PSRs)

The Subsonic kernel includes a small virtual machine that is used for performing
privilaged operations in kernel space in a managable way.  While they run in
Ring 0 (or the eqivalent), they are isolated and are not capable of arbitrary
memory access unless the owning process has perimssion to do so.  It is indeed
Turing-complete and has a stack and a heap.  Driver developers should bundle
bytecode binary with executables or generate it at runtime.

## Deployment

PSR bytecode is passed into the kernel using a channel and is placed into a
per-VM queue for execution.  At any time a process can query the state of any of
its VMs and spawn VMs at will (assuming they have permission to use PSRs).

## Use

There are VM intrinsics for interacting with channels, querying ACPI variables,
creating and managing processes, etc.  Extra permissions are given on a
by-process basis by the HWCVM manager.

Since the primary purpose of PSRs is for driver development, there is a strong
focus on making access to specific MMIO ranges easy to work with and making
hardware access fast *and* feasable.

