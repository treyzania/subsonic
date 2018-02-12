source $reporoot/util.sh

export ccinvoke="$ccinvoke -Ikernel/include"

compile_c mm/alloc.c kernel/alloc.o
compile_c mm/page.c kernel/page.o

compile_rust kmain.rs kernel/kmain.o

build_component arch/$SUBSONIC_ARCH
