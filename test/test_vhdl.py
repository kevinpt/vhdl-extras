#!/usr/bin/python
# -*- coding: utf-8 -*-

'''Ripyl protocol decode library
   can.py test suite
'''

# Copyright © 2014 Kevin Thibedeau

# This file is part of VHDL-extras.


from __future__ import print_function, division

#import unittest
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


