source $reporoot/util.sh

compile_c mem.c util/mem.o
compile_c string.c util/string.o
compile_c llvm_intrinsics.c util/llvmi.o
