#!/bin/bash

# Make sure we're in a sane location before we do *anything*.
cd $(dirname $(realpath $0))

export builddir=build
toolchaincfg=toolchain.conf

export reporoot=$(dirname $(realpath $0))

if [ -e $builddir ]; then
	echo $0': already built, remove the `'$builddir'` directory'
	exit 1
fi

if [ ! -f $toolchaincfg ]; then
	echo $0': no toolchain configuration found, need to generate a toolchain.conf?'
	exit 1
fi

# Pull in our cross-compilation toolchain arguments.
source $toolchaincfg

# Make sure things exist.
mkdir -p $builddir/{bin,codegen,obj}

# Figure out how we invoke gcc.
export asminvoke="$ASSEMBLER"
export ccinvoke="$CC -c -ffreestanding -nostdlib -Iinclude"
export rustcinvoke="$RUSTC --crate-type staticlib -C panic=abort"

# This is for later
export component=

# Now include our "build library" of bash functions.
source util.sh

# Now we actually build things.
build_component util
build_component kernel
