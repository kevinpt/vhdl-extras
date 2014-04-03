#!/usr/bin/python
# -*- coding: utf-8 -*-

'''Ripyl protocol decode library
   test support functions
'''

# Copyright © 2013 Kevin Thibedeau

# This file is part of Ripyl.

# Ripyl is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# Ripyl is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with Ripyl. If not, see <http://www.gnu.org/licenses/>.

from __future__ import print_function, division

import struct
import os
import array
import sys
import unittest
import random
import time
import gc
from eng import eng_si
import scripts.color as color

import subprocess as subp


def relativelyEqual(a, b, epsilon):
    ''' Adapted from: http://floating-point-gui.de/errors/comparison/ '''
    
    if a == b: # take care of the inifinities
        return True
    
    elif a * b == 0.0: # either a or b is zero
        return abs(a - b) < epsilon ** 2
        
    else: # relative error
        return abs(a - b) / (abs(a) + abs(b)) < epsilon


def run_modelsim(entity, log_file, generics=None):
    env = { 'MGC_WD': os.getcwd(), 'PATH': os.environ['PATH'] }
    vsim_cmd = ['vsim', '-c', entity, '-l', log_file, '-do', 'run -all; quit']

    if generics is not None:
        vsim_cmd.extend('-G{}={}'.format(k, v) for k, v in generics.iteritems())

    p = subp.Popen(vsim_cmd, env=env, stderr=subp.STDOUT, stdout=subp.PIPE)
    p.communicate()
    return modelsim_success(log_file)

def modelsim_success(log_file):
    with open(log_file, 'r') as fh:
        for ln in fh:
            if ln.startswith('# Stopped at') or ln.startswith('# FATAL ERROR'):
                return False

    return True


class VHDLTestCase(unittest.TestCase):
    def __init__(self, methodName='runTest'):
        unittest.TestCase.__init__(self, methodName=methodName)
        self.test_name = 'Unnamed test'
        self.trial = 0
        self.trial_count = 0

    @classmethod
    def setupClass(cls):
        out_dir = os.path.join('test', 'test-output')
        if not os.path.exists(out_dir):
            os.mkdir(out_dir)

    def setUp(self):
        print('\n')

    def update_progress(self, cur_trial, dotted=True):
        self.trial = cur_trial
        if not dotted:
            print('\r  {} {} / {}  '.format(self.test_name, self.trial, self.trial_count), end='')
        else:
            if self.trial == 1:
                print('  {} '.format(self.test_name), end='')
            endc = '' if self.trial % 100 else '\n'
            print('.', end=endc)

        sys.stdout.flush()


    def run_simulation(self, entity, **generics):
        log_file = os.path.join('test', 'test-output', entity.split('.')[1] + '.log')
        self.test_name = 'Testbench ' + entity
        self.update_progress(1)
        status = run_modelsim(entity, log_file, generics)
        if not status:
            with open(log_file, 'r') as fh:
                for ln in fh: print(ln, end='')
        self.assertTrue(status, 'Simulation failed')


    def assertRelativelyEqual(self, a, b, epsilon, msg=None):
        if not relativelyEqual(a, b, epsilon):
            if msg is None:
                msg = '{} != {}'.format(a, b)
            raise self.failureException(msg)



class RandomSeededTestCase(unittest.TestCase):
    def __init__(self, methodName='runTest', seedVarName='TEST_SEED'):
        unittest.TestCase.__init__(self, methodName=methodName)
        self.seed_var_name = seedVarName
        self.test_name = 'Unnamed test'
        self.trial = 0
        self.trial_count = 0

    @classmethod
    def setupClass(cls):
        out_dir = os.path.join('test', 'test-output')
        if not os.path.exists(out_dir):
            os.mkdir(out_dir)

    def setUp(self):
        # In sub classes use the following to call this setUp() from an overrided setUp()
        # super(<sub-class>, self).setUp()
        
        # Use seed from enviroment if it is set
        try:
            seed = long(os.environ[self.seed_var_name])
        except KeyError:
            random.seed()
            seed = long(random.random() * 1e9)

        print(color.note('\n * Random seed: {} *'.format(seed)))
        random.seed(seed)

    def update_progress(self, cur_trial, dotted=True):
        self.trial = cur_trial
        if not dotted:
            print('\r  {} {} / {}  '.format(self.test_name, self.trial, self.trial_count), end='')
        else:
            if self.trial == 1:
                print('  {} '.format(self.test_name), end='')
            endc = '' if self.trial % 100 else '\n'
            print('.', end=endc)

        sys.stdout.flush()


    def assertRelativelyEqual(self, a, b, epsilon, msg=None):
        if not relativelyEqual(a, b, epsilon):
            if msg is None:
                msg = '{} != {}'.format(a, b)
            raise self.failureException(msg)


def timedtest(f):
    '''Decorator that times execution of a test case'''
    def wrapper(self, *args, **kwargs):
        gc.disable()
        try:
            t_start = time.time()
            result = f(self, *args, **kwargs)
            t_end = time.time()
            try:
                _t_start = self._t_start
                t_start = _t_start if isinstance(_t_start, float) else t_start
                self._t_start = None
            except:
                pass

        finally:
            gc.enable()

        delta = t_end - t_start

        iterations = None
        units_processed = 1
        unit_name = 'units'
        if result:
            try:
                if len(result) >= 2:
                    iterations = result[0]
                    units_processed = result[1]

                    if len(result) >= 3:
                        unit_name = result[2]
            except TypeError:
                iterations = result
            

        if iterations:
            per_iter = delta / iterations
        else:
            per_iter = delta

        processing_rate = units_processed / delta

        print('*   Test duration: total {}, per iteration {}, rate {}'.format( \
            eng_si(delta, 's'), eng_si(per_iter, 's'), eng_si(processing_rate, unit_name + '/s') ))

    return wrapper

