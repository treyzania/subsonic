import os

import copy
import json
import subprocess

builddir = 'build'
bindir = os.path.join(builddir, 'bin')
objdir = os.path.join(builddir, 'obj')

for f in [builddir, bindir, objdir]:
    if not os.path.exists(f):
        os.makedirs(f)

toolchain = None
with open('toolchain.json') as tc:
    toolchain = json.loads(tc.read())
if tc is None:
    print('error loading toolchain')
    os.exit(1)

phases = []
artifacts = {}

base_c_includes = ['include']
__cur_context = []

def __output_name_for(name):
    prefix = ''
    cname = __context_name()
    if len(cname) > 0:
        prefix = cname.replace('.', '_') + '-'
    return prefix + name

def __enter_subcontext(name):
    global __cur_context
    __cur_context.append(name)

def __exit_subcontext():
    global __cur_context
    __cur_context.pop()

def __context_name(delim='_'):
    return delim.join(__cur_context)

class StepContext():
    context_name = []
    c_include = []
    def __init__(self, ctx_name):
        self.context_name = ctx_name

    def compile_asm(self, name, src, exargs=[]):
        out = self.__get_obj_artifact_path(name + '.o')
        cmd = [
            toolchain['assembler'],
            '-c',
            "-o", out,
        ]
        cmd.extend(toolchain['assembler_args'])
        cmd.extend(exargs)
        cmd.append(os.path.join(self.__get_context_name(delim='/'), src))
        print(cmd)
        subprocess.run(cmd)
        self.add_artifact(name, out)
        return name

    def add_c_include(self, path):
        self.c_include.append(path)

    def compile_c(self, name, src, exargs=[]):
        out = self.__get_obj_artifact_path(name + '.o')
        cmd = [
            toolchain['cc'],
            '-c',
            "-o", out,
            '-O2',
            '-Wall', '-Wextra',
            '-ffreestanding',
            '-nostdlib',
            '-std=gnu99',
            '-mno-red-zone'
        ]
        cmd.extend(toolchain['cc_args'])
        cmd.extend(exargs)
        cmd.extend(self.__get_include_args())
        cmd.append(os.path.join(self.__get_context_name(delim='/'), src))
        print(cmd)
        subprocess.run(cmd)
        self.add_artifact(name, out)
        return name

    def compile_rust(self, name, src, exargs=[]):
        out = self.__get_obj_artifact_path(name + '.a')
        cmd = [
            toolchain['rustc'],
            '-o', out,
            '--crate-type=staticlib',
            #'--target', os.path.join('toolchain', 'llvm-%s.json' % self.arch())
        ]
        cmd.extend(toolchain['rustc_args'])
        cmd.extend(exargs)
        cmd.append(os.path.join(self.__get_context_name(delim='/'), src))
        print(cmd)
        subprocess.run(cmd)
        self.add_artifact(name, out)
        return name

    def link_executable(self, name, linkdoc, parts):
        out = os.path.join(bindir, name)
        cmd = [
            toolchain['linker'],
            '-o', out,
            '-T', linkdoc,
            '-nostdlib'
        ]
        cmd.extend(toolchain['ld_args'])
        for p in parts:
            cmd.append(self.find_obj_artifact_path(p))
        print(cmd)
        subprocess.run(cmd)

    def get_obj_dir(self):
        return objdir

    def arch(self):
        return toolchain['arch']

    def add_artifact(self, name, path):
        artifacts[name] = {
            'component': self.__get_obj_artifact_path(name),
            'path': path
        }

    def find_obj_artifact_path(self, name):
        return artifacts[name]['path']

    def __get_context_name(self, delim='.'):
        return delim.join(self.context_name)

    def __get_obj_artifact_path(self, name):
        base_name = self.__get_context_name(delim='_')
        if base_name == '':
            return os.path.join(self.get_obj_dir(), name)
        else:
            return os.path.join(self.get_obj_dir(), base_name + '-' + name)

    def __get_include_args(self):
        args = []
        for i in base_c_includes:
            args.append('-I' + i)
        for i in self.c_include:
            args.append('-I' + os.path.join(self.__get_context_name(delim='/'), i))
        return args

def init_component(name):
    code = None
    with open(os.path.join(name, 'component.py')) as f:
        code = f.read()
    __enter_subcontext(name)
    exec(code)
    __exit_subcontext()

def add_phase(name):
    phases.append({
        'name': name,
        'steps': []
    })

def add_phase_step(pname, sname, proc):
    for p in phases:
        if p['name'] == pname:
            p['steps'].append({
                'name': sname,
                'context': copy.deepcopy(__cur_context),
                'procedure': proc
            })
            return

def run_step(step):
    ctx = StepContext(step['context'])
    step['procedure'](ctx)

def run_phases():
    for p in phases:
        print('==== Phase: %s' % p['name'])
        for s in p['steps']:
            print('== Step: %s' % s['name'])
            run_step(s)

def dump_artifacts():
    afjson = os.path.join(builddir, 'artifacts.json')
    with open(afjson, 'w') as af:
        af.write(json.dumps(artifacts, indent=4, sort_keys=True))
