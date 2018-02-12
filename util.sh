
if [ -n "$component" ]; then
	echo -e "\n>>> Building component '$component'..."
fi

# Assembler wrapper.
function compile_asm() {
	output=$builddir/obj/$2
	mkdir -p $(dirname $output)
	$asminvoke $AS_ARGS ./$component/$1 -o $output
}

# C compiler wrapper.
function compile_c() {
	output=$builddir/obj/$2
	mkdir -p $(dirname $output)
	$ccinvoke $CC_ARGS ./$component/$1 -o $output
}

# Rust compiler wrapper.
function compile_rust() {
	output=$builddir/obj/$2
	mkdir -p $(dirname $output)
	$rustcinvoke $RUSTC_ARGS ./$component/$1 -o $output
}

# A ltitle bit of magic with evironmental variables to move the "component"
# information down to subsequent invocations of the build scripts.
function build_component() {
	if [ -z "$component" ]; then
		env component=$1 bash ./$component/$1/build.sh
	else
		env component=$component/$1 bash ./$component/$1/build.sh
	fi
}

# Print everything explicitly.
set -ex
