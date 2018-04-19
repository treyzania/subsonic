#!/bin/bash

set -ex

if [ -z "$1" ]; then
	echo 'must specify an architecture!'
	exit 1
fi

cd toolchain

bpath=$(realpath crossbuild)
mkdir -p $bpath

pushd crosscompiler
./doit -f -a "$1" -o $bpath
