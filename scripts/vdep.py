#!/usr/bin/python
# -*- coding: utf-8 -*-

'''VHDL Dependency tool
'''

# Copyright © 2013 Kevin Thibedeau

from __future__ import print_function, division

import os
import sys
import re
from color import error

class FileInfo(object):
    def __init__(self, fname):
        self.name = fname
        self.lib = os.path.split(os.path.dirname(fname))[1]

        self.packages = []
        self.pkg_body_defs = []
        self.uses = []
        self.depends = set()

    use_re = re.compile('^ *use +(.+);')
    pkg_re = re.compile('^ *package +(.+) +is')
    generic_pkg_re = re.compile('^ *package.*is +new +(.+)')

    def parse(self):
        uses = []
        pkg_defs = []
        pkg_body_defs = []

        try:
            with open(self.name, 'r') as fh:
                for line in fh:
                    # Find use statements
                    m = self.use_re.match(line)
                    if m:
                        # FIX: VHDL may allow use statements without a library: use pkg.foo;
                        #print('# use:', m.group(1).split('.')[:2])
                        #m.group(1).split('.')[:2]
                        uses.append(m.group(1).split('.')[:2])

                    # Find generic package instances
                    m = self.generic_pkg_re.match(line)
                    if m:
                        uses.append(m.group(1).split('.')[:2])

                    m = self.pkg_re.match(line)
                    if m:
                        fields = m.group(1).split()
                        if fields[0].lower() == 'body':
                            pkg_body_defs.append(fields[1])
                        else:
                            #print('## pkg:', fields[0])
                            pkg_defs.append(self.lib + '.' + fields[0])
        except IOError:
            pass

        self.uses = uses
        self.packages = pkg_defs
        self.pkg_body_defs = pkg_body_defs




def find_dependencies(dep_infos):
    all_packages = {}
    std_libs = ['std', 'ieee']

    for fi in dep_infos:
        for p in fi.packages:
            all_packages[p] = fi.name

    for fi in dep_infos:
        for u in fi.uses:
            if u[0] in std_libs:
                continue

            lib_name = u[0] + '.' + u[1]
            if lib_name in all_packages:
                dep_name = all_packages[lib_name]
                if dep_name != fi.name:
                    fi.depends.add(dep_name)
            else:
                print(error('ERROR: unsatisfied dependency: {} in {}'.format(\
                    '.'.join(u), fi.name)), file=sys.stderr)


def sort_dependencies(dep_infos):
    targets = set()
    new_infos = []
    # put all leaf nodes first
    for fi in dep_infos:
        if not fi.depends:
            targets.add(fi.name)
            new_infos.append(fi)

    #print('### targets', targets)

    while len(targets) < len(dep_infos):
        for fi in dep_infos:
            if fi.name in targets:
                continue

            satisfied = all([d in targets for d in fi.depends])
            if satisfied:
                targets.add(fi.name)
                new_infos.append(fi)

    return new_infos


def find_source(path):
    sources = []
    for root, dirs, files in os.walk(path):
        for f in files:
            if f.endswith('.vhdl'):
                sources.append(os.path.join(root, f))

    return sources

#files = find_source('src/extras')


files = sys.argv[1:]

dep_infos = []
for f in files:
    fi = FileInfo(f)
    fi.parse()
    dep_infos.append(fi)


find_dependencies(dep_infos)
dep_infos = sort_dependencies(dep_infos)

for fi in dep_infos:
    target = os.path.basename(os.path.splitext(fi.name)[0]) + '.tag'
    dep_tags = [os.path.basename(os.path.splitext(d)[0]) + '.tag' for d in fi.depends]
    print('{}: {}'.format(target, ' '.join(dep_tags)))




