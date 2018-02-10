#!/bin/bash

# Make sure we're in a sane location before we do *anything*.
cd $(dirname $(realpath $0))

builddir=build
toolchaincfg=toolchain.conf

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

# Now enable printing all the annoying things.
set -ex

# Make sure things exist.
mkdir -p $builddir/{bin,codegen,obj}

# Figure out how we invoke gcc.
export ASMINVOKE="$ASSEMBLER"
export CCINVOKE="$CC -c -ffreestanding -nostdlib -Iinclude"
export RUSTCINVOKE="$RUSTC --crate-type cdylib --emit obj"

# This is for later
export component=

# Assembler wrapper.
function compile_asm() {
	src=$1
	output=$builddir/obj/$2
	mkdir -p $(dirname $output)
	$ASMINVOKE $AS_ARGS ./$component/$src -o $output
}

# C compiler wrapper.
function compile_c() {
	src=$1
	output=$builddir/obj/$2
	mkdir -p $(dirname $output)
	$CCINVOKE $CC_ARGS ./$component/$src -o $output
}

# Rust compiler wrapper.
function compile_rust() {
	src=$1
	output=$builddir/obj/$2
	mkdir -p $(dirname $output)
	$RUSTCINVOKE $RUSTC_ARGS ./$component/$src -o $output
}

# Since functions are executed in their own subprocesses, we keep all of our
# variables but get a new context to mess around in.
function build_component() {
	if [ -z "$component" ]; then
		export component=$1
	else
		export component=$component/$1
	fi
	source $component/build.sh
}

# Now we actually build things.
build_component kernel
