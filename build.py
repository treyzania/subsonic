#!/usr/bin/python3

import sys
sys.path.append('toolchain')

import buildlib

buildlib.add_phase('prep')
buildlib.add_phase('compile')
buildlib.add_phase('link')

buildlib.init_component('vendor')
buildlib.init_component('util')
buildlib.init_component('kernel')

buildlib.run_phases()

buildlib.dump_artifacts()
