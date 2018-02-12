source $reporoot/util.sh

compile_asm entry.S kernel/entry.o
compile_c init.c kernel/init.o
