source $reporoot/util.sh

export ccinvoke="$ccinvoke -Ikernel/include"

compile_c mm/alloc.c kernel/alloc.o
compile_rust kmain.rs kernel/kmain.o

build_component arch/$SUBSONIC_ARCH
