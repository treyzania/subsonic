/*
 * LLVM requires some silly things for us to build projects, even if we don't
 * actually end up using them.
 *
 * Since these implementatios don't actually do anything we're probably breaking
 * a lot of stuff that we'll worry about later.
 */

void __umodti3() {

}

void __udivti3() {

}
