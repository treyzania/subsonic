import buildlib

def compiler_builtins_codegen(ctx):
    import os
    import subprocess
    import shutil

    # compiler-builtins
    subprocess.run(['cargo', 'build'], cwd=os.path.join('vendor', 'compiler-builtins'))
    rlib_name = 'libcompiler_builtins.rlib'
    rlib_path = os.path.join(ctx.get_obj_dir(), rlib_name)
    shutil.copyfile(
        os.path.join('vendor', 'compiler-builtins', 'target', 'debug', rlib_name),
        rlib_path
    )
    ctx.add_artifact('compiler-builtins', rlib_path)

buildlib.add_phase_step('prep', 'cargo on compiler_builtins', compiler_builtins_codegen)
