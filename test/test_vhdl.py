#!/usr/bin/python
# -*- coding: utf-8 -*-

'''Ripyl protocol decode library
   can.py test suite
'''

# Copyright © 2014 Kevin Thibedeau

# This file is part of VHDL-extras.


from __future__ import print_function, division

import random
import test.test_support as tsup


class TestVHDL(tsup.VHDLTestCase):

    def test_binaryio(self):
        entity = 'test.test_binaryio'
        self.run_simulation(entity, TEST_OUT_DIR='test/test-output')

    def test_gray_code(self):
        entity = 'test.test_gray_code'
        self.run_simulation(entity)

    def test_gray_counter(self):
        entity = 'test.test_gray_counter'
        self.run_simulation(entity)

    def test_bcd_conversion(self):
        entity = 'test.test_bcd_conversion'
        self.run_simulation(entity)

    def test_characters_handling(self):
        entity = 'test.test_characters_handling'
        self.run_simulation(entity)

    def test_sizing(self):
        entity = 'test.test_sizing'
        self.run_simulation(entity)

    #def test_ddfs(self):
    #    entity = 'test.test_ddfs'
    #    self.run_simulation(entity)

    #def test_crc_ops(self):
    #    entity = 'test.test_crc_ops'
    #    self.run_simulation(entity)


class TestRandVHDL(tsup.RandomSeededTestCase):

    def test_crc_ops(self):
        entity = 'test.test_crc_ops'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_ddfs(self):
        entity = 'test.test_ddfs'

        min_freq = 1e4
        max_freq = 5e5

        self.test_name = 'Testbench ' + entity
        self.trial_count = 10
        for i in xrange(self.trial_count):
            self.update_progress(i+1)

            freq = float(random.randint(min_freq, max_freq))

            self.run_simulation(entity, update=False, TGT_FREQ=freq)

