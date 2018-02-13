source $reporoot/util.sh

export ccinvoke="$ccinvoke -Ikernel/include"

compile_c mm/alloc.c kernel/alloc.o
compile_c mm/page.c kernel/page.o

compile_rust kmain.rs kernel/kmain.o

build_component arch/$SUBSONIC_ARCH
cp $component/arch/$SUBSONIC_ARCH/link.ld $builddir/kernel_link.ld

# This is where we link the kernel image together.
echo -e "\nLinking..."
pushd $builddir
ld -T kernel_link.ld -o bin/kernel.bin -nostdlib obj/kernel/* obj/util/*
popd
