import buildlib

def compile_kernel(ctx):
    ctx.add_c_include('include')
    #ctx.compile_c('alloc', 'mm/alloc.c')
    #ctx.compile_c('page', 'mm/page.c')
    ctx.compile_asm('start', 'arch/x86/start.S')
    ctx.compile_c('init', 'arch/x86/init.c')
    ctx.compile_c('vgaterm', 'arch/x86/terminal.c')
    ctx.compile_rust('kmain', 'kmain.rs',
        exargs=[
            '--extern',
            'compiler_builtins=' + ctx.find_obj_artifact_path('compiler-builtins'),
        ])

def link_kernel(ctx):
    kobjs = [
        'start',
        'init',
        'vgaterm',
        #'page',
        #'alloc',
        'compiler-builtins',
        'kmain',
        'mem',
        'string'
    ]
    ctx.link_executable('kernel.bin', 'kernel/arch/x86/link.ld', kobjs)

buildlib.add_phase_step('compile', 'compile kernel', compile_kernel)
buildlib.add_phase_step('link', 'link kernel binary', link_kernel)
