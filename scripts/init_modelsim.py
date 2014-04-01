#!/usr/bin/python
# -*- coding: utf-8 -*-

'''Modelsim init script
'''

# Copyright © 2013 Kevin Thibedeau

from __future__ import print_function, division

import subprocess as subp
import os
import sys
import copy


def new_modelsim_ini():
    # Attempt a vmap in the cwd. This will create a new modelsim.ini file
    env = { 'MGC_WD': os.getcwd(), 'PATH': os.environ['PATH'] }
    p = subp.Popen(['vmap', 'foo', 'bar'], env=env, stderr=subp.STDOUT, stdout=subp.PIPE)
    p.communicate()


# Check if modelsim.ini already exists
ini_path = os.path.join(os.getcwd(), 'modelsim.ini')
if os.path.exists(ini_path):
    print('modelsim.ini exists: Doing nothing')
    sys.exit(0)

print('Generating modelsim.ini...')

new_modelsim_ini()

# Check that we succeeded in making a fresh modelsim.ini
if not os.path.exists(ini_path):
    print('ERROR: Could not create modelsim.ini')
    sys.exit(1)

# Modify the library section of this new ini file

lines = []
with open(ini_path, 'r') as fh:
    lines = fh.readlines()

if len(lines) == 0:
    print('ERROR: Empty modelsim.ini file')
    sys.exit(1)

def modify_ini(lines):
    # We will replace everything between the [Library] header
    # and our dummy map foo = bar.

    # Find library section
    lib_start = 0
    lib_end = 0
    for i, l in enumerate(lines):
        if '[Library]' in l:
            lib_start = i
            
        if 'foo = bar' in l:
            lib_end = i
            break

    if lib_end == lib_start: # Nothing found
        return lines

    new_lib = \
    '''[Library]
std = $MODEL_TECH/../std
ieee = $MODEL_TECH/../ieee
vital2000 = $MODEL_TECH/../vital2000
modelsim_lib = $MODEL_TECH/../modelsim_lib

others=$MGC_WD/modelsim.map

'''
    new_lines = copy.copy(lines)
    del new_lines[lib_start:lib_end+1]
    new_lines.insert(lib_start, new_lib)

    return new_lines

lines = modify_ini(lines)

with open(ini_path, 'w') as fh:
    fh.writelines(lines)

print('success')


