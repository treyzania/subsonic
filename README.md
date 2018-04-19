# subsonic

An OS kernel that's not as good (or as fast) as Mach.

## Building

### Preperation

Before you do anything, make sure you have the submodules.  The simplest way to
do that is to clone the project like this:

```sh
git clone --recursive ...
```

But if you've downloaded it already, you can just do this:

```sh
git submodule update --init --recursive
```

### Configuration

First, you need to generate a `toolchain.json` file so that we know which
cross-compilers we're using.

```sh
./configure.sh --compile
```

This can take multiple tries, but it's pretty obvious what packages it wants
you to install when it fails.  **This script doesn't work perfectly, take a
look at it to figure out how to use the `./doit` script when it breaks.**

When it *does* work, it can take quite a while to build GCC and all of the
other programs that it needs.

Support for other architectures is coming after we have something that can
actually boot on x86, thanks.

### Actually building

Once you've generated a `toolchain.json`, actually building the project is
pretty easy.

```sh
./build.py
```

And all of the outputs will be in `build/`.  A manifest called `artifacts.json`
is also in that directory that tells you the different objects that were built.
