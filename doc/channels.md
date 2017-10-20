# Subsonic Channels

The primary method of inter-process communication in Subsonic is the *channel*.

## Structure

Channels are grouped by pairs of execution domains, so two processes that have
a pair of channels between them have 3 different sets of pages.  The first set
is used for signalling and contains metadata and the array of mutexes, which are
ordered by channel number.  This page is marked `rw` on both sides.  The other
two sets are where the actual data lives, and is marked `rw` on the sending side
and `ro` on the receiving side.  Processes are responsible for handling
malicious input across the channels, and should respond to corrupted mutex data
by immediately closing the channel.

## Construction

Channels are created by talking to the IPC manager using the `mkchan` kernel
call.  Channels can be created between processes and the kernel and are used for
creating and managing processes, etc.  They are used for executing Privilaged
Service Routines (PSRs) for programs such as device drivers.
