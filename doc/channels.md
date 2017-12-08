# Subsonic Channels

The primary method of inter-process communication in Subsonic is the *channel*.

Most IPC on UNIX systems requires doing some kind of syscalls that end up
performing a complicated context switch which blows out CPU caches and the
instruction pipeline.  It's possible to have shared memory between processes
which *does* allow for context-switch-free IPC, but often there's some kind of
mutex that makes that unwieldy.

I propose using kernel-assisted channels instead of traditional read and write
system calls.

A "control page" is mapped between the processes, which both can write to.  Then
a page (or set of pages) is mapped such that the "sender" process can read and
write, and the receiver process can only read, which is essentially a "data
page".  It consists of an array of structures, the format of which doesn't
matter for this discussion.  The control page includes a list of indices into
the data page(s).

The control page is basically a ring buffer and the data page(s) is/are a
simple array.  The data placed in this shouldn't have any pointers unless you're
doing something special.

We're essentially combining atomic compare-and-swaps, shared memory, and some
extra assistance from the kernel scheduler.

There are 3 states that an entry can be in:

* `00000000` : Entry empty; can be filled by some other value (index 0 in the array would be unused)
* `ffffffff` : Locked during checking.
* any other value : an actual index that hasn't been consumed yet

Each end of the channel should be behind some kind of (simple) lock, as even
though the two actions (send, receive) are thread-safe, multiple of either at
the same time probably isn't.

## Initialization

The two processes *somehow* need to decide to create a channel between them, the
procedure for this is unspecified and doesn't matter for this.  The kernel sets
up the memory mapping between them, and then both processes keep track of
"where" in the control page they are actively looking for entries (see below).

## Sending messages

The sender process checks its current "write index" and acquires the lock.  Then
it copies the structure it's writing in an open slot in the data page
(determined beforehand), and then writes the index of that slot in the data page
into the control page, such that the receiver knows that the entry is available
to read.  Then it can update the write index to the next cell, possibly wrapping
around to 0 if it's at the end of the buffer.

If the write index is *already* pointing at a field that *isn't* 0, then we
should fail, and depending on how we're trying to send the message either return
to the caller with some error code or call into the kernel to pause the thread
until there *is* an empty space.  We could decide to pass some number to the
kernel, directing it to wait until there are that many entries free so that we
won't keep context switching if we need to write several entries in quick
succession.

## Receiving messages

When we try to read a message we check the value in the control page region
at the "read index", and if it's non-zero then it copies the corresponding entry
in the data page(s) into a local buffer, sets the entry in the control page to
0, increments read index (with wraparound as needed), and returns.

As with the above, if the receiver desires, it can instead call to the kernel to
wait until there are some number of available entries instead of returning an
error code.

## Handling of empty/full buffers

Since the kernel is aware of the locations and layout of the channel data, it
is able to understand all of the data structures that are doing things between
the processes.  The scheduler just has to use the information when deciding
which thread can be resumed.
