#!/bin/bash

set -e

arch=i686

crossas=
crosscc=

bindir=

if [ "$1" == "--compile" ]; then
	source toolchain/crosscompiler/toolvers
	BUILDDIR=toolchain/crossbuild
	# This will need changing when/if we add support for arm.
	binexpr=$arch-elf-$GCCVER-$(uname)-$(uname -m)
	if [ ! -d "$BUILDDIR/$binexpr/bin" ]; then
		mkdir -p $BUILDDIR
		pushd toolchain/crosscompiler
		./doit -f -a "$arch" -o $BUILDDIR
		popd
	fi
	echo 'Out dir name:' $binexpr
	bindir=$(ls -d $BUILDDIR/$binexpr/bin)
else
	bindir=$(realpath $1)
fi

# This is where we actually find the executables.
crossas=$(find $bindir -name '*as' -executable)
crosscc=$(find $bindir -name '*gcc' -executable)

tcjson=toolchain.json

if [ -f $tcjson ]; then
	echo 'toolchain config file exists!'
	exit 1
fi

rm -f $tcjson
touch $tcjson

echo 'Generating toolchain.json...'
echo "{" >> $tcjson
echo "	\"arch\": \"$arch\"," >> $tcjson
echo "	\"assembler\": \"$crossas\"," >> $tcjson
echo "	\"assembler_args\": []," >> $tcjson
echo "	\"cc\": \"$crosscc\"," >> $tcjson
echo "	\"cc_args\": []," >> $tcjson
echo "	\"rustc\": \"rustc\"," >> $tcjson
echo "	\"rustc_args\": []," >> $tcjson
echo "	\"linker\": \"$crosscc\"," >> $tcjson # This is indeed supposed to be gcc not ld because of `-lgcc`, for now.
echo "	\"ld_args\": [\"-lgcc\"]" >> $tcjson
echo "}" >> $tcjson
