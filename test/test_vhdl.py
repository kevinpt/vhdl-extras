#!/usr/bin/python
# -*- coding: utf-8 -*-

'''VHDL-extras library
   Test suite
'''

# Copyright © 2014 Kevin Thibedeau

# This file is part of VHDL-extras.


from __future__ import print_function, division

import random
import test.test_support as tsup
import unittest
import os


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

    def test_glitch_filter(self):
        entity = 'test.test_glitch_filter'
        self.run_simulation(entity)

    def test_array_glitch_filter(self):
        entity = 'test.test_array_glitch_filter'
        self.run_simulation(entity)

    def test_hamming_size(self):
        entity = 'test.test_hamming_size'
        self.run_simulation(entity)



class TestRandVHDL(tsup.RandomSeededTestCase):

    def test_timing_ops(self):
        entity = 'test.test_timing_ops'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_crc_ops(self):
        entity = 'test.test_crc_ops'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_simple_fifo(self):
        entity = 'test.test_simple_fifo'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_fifo(self):
        entity = 'test.test_fifo'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_packet_fifo(self):
        entity = 'test.test_packet_fifo'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_hamming_edac(self):
        entity = 'test.test_hamming_edac'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_dual_port_ram(self):
        entity = 'test.test_dual_port_ram'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_rom(self):
        entity = 'test.test_rom'
        self.test_name = 'Testbench ' + entity
        self.trial_count = 20
        for i in xrange(self.trial_count):
            self.update_progress(i+1)

            rom_size = random.randint(1, 256)
            rom_width = random.randint(1, 128)
            hex_format = random.choice((True, False))

            rom_format = 'HEX_TEXT' if hex_format else 'BINARY_TEXT'

            # Create randomized ROM file
            rom = [random.randint(0, 2**rom_width-1) for _ in xrange(rom_size)]

            rom_file = 'test/test-output/rom_in.txt'
            with open(rom_file, 'w') as fh:
                for w in rom:
                    if hex_format:
                        print('{:0{}x}'.format(w, (rom_width + 3) // 4), file=fh)
                    else:
                        print('{:0{}b}'.format(w, rom_width), file=fh)

            out_rom_file = 'test/test-output/rom_out.txt'
            #out_rom_file = 'rom_out.txt'

            self.run_simulation(entity, update=False, ROM_FILE=rom_file, \
                OUT_ROM_FILE=out_rom_file, FORMAT=rom_format, ROM_SIZE=rom_size, ROM_WIDTH=rom_width)

            self.assertTrue(os.path.exists(out_rom_file), 'Missing ROM output')

            #print('ROM format:', rom_format)
            #print('In:')
            #with open(rom_file, 'r') as fh:
            #    for l in fh: print(l, end='')

            #print('Out:')
            #with open(out_rom_file, 'r') as fh:
            #    for l in fh: print(l, end='')

            # Read back the simulated ROM and verify contents
            with open(out_rom_file, 'r') as fh:
                rom_out = [int(l.strip(), base=2) for l in fh.readlines()]

            self.assertEqual(len(rom), len(rom_out), 'ROM length mismatch')
            self.assertEqual(rom, rom_out, 'ROM mismatch')

    #@unittest.skip('debug')
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

