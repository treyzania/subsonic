#!/bin/bash

set -ex

arch=amd64

crossas=
crosscc=
crossld=

BUILDDIR=toolchain/crossbuild

if [ "$1" == "--compile" ]; then
	if [ ! -d "$BUILDDIR" ]; then
		mkdir -p $BUILDDIR
		pushd toolchain/crosscompiler
		./doit -f -a "$arch" -o toolchain/crossbuild
		popd
	fi
	bindir=$(ls -d $BUILDDIR/$arch-*/bin)
	crossas=$(find $bindir -name '*as' -executable)
	crosscc=$(find $bindir -name '*gcc' -executable)
	crossld=$(find $bindir -name '*ld' -executable)
else
	echo 'not yet implemented!'
	exit 1
fi

tcjson=toolchain.json

if [ -f $tcjson ]; then
	echo 'toolchain config file exists!'
	exit 1
fi

rm -f $tcjson
touch $tcjson

echo "{" >> $tcjson
echo "	\"arch\": \"$arch\"," >> $tcjson
echo "	\"assembler\": \"$crossas\"," >> $tcjson
echo "	\"assembler_args\": []," >> $tcjson
echo "	\"cc\": \"$crosscc\"," >> $tcjson
echo "	\"cc_args\": []," >> $tcjson
echo "	\"rustc\": \"rustc\"," >> $tcjson
echo "	\"rustc_args\": []," >> $tcjson
echo "	\"linker\": \"$crosscc\"," >> $tcjson # this is supposed to be gcc not ld
echo "	\"ld_args\": [\"-lgcc\"]" >> $tcjson
echo "}" >> $tcjson
