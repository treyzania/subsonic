import buildlib

def compile_utils(ctx):
    ctx.compile_c('mem', 'mem.c')
    ctx.compile_c('string', 'string.c')

buildlib.add_phase_step('compile', 'compile utils', compile_utils)
