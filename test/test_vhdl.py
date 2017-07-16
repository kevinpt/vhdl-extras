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

    def test_secded_size(self):
        entity = 'test.test_secded_size'
        self.run_simulation(entity)

    def test_lcar_ops(self):
        entity = 'test.test_lcar_ops'

        self.test_name = 'Testbench ' + entity
        self.trial_count = 20 # Go up to maximal length rules for 22-bit array
        for i in xrange(self.trial_count):
            self.update_progress(i+1)

            self.run_simulation(entity, update=False, WIDTH=i+2)

    def test_lfsr_ops(self):
        entity = 'test.test_lfsr_ops'

        self.test_name = 'Testbench ' + entity
        self.trial_count = 10
        for i in xrange(self.trial_count):
            self.update_progress(i+1)

            self.run_simulation(entity, update=False, WIDTH=i+2, KIND='normal')
            self.run_simulation(entity, update=False, WIDTH=i+2, KIND='inverted')
            self.run_simulation(entity, update=False, WIDTH=i+2, KIND='normal', FULL_CYCLE='true')
            self.run_simulation(entity, update=False, WIDTH=i+2, KIND='inverted', FULL_CYCLE='true')

    def test_muxing(self):
        entity = 'test.test_muxing'
        self.run_simulation(entity)

    def test_muxing_2008(self):
        entity = 'test_2008.test_muxing_2008'
        self.run_simulation(entity)

    def test_strings_fixed(self):
        entity = 'test.test_strings_fixed'
        self.run_simulation(entity)

    def test_strings_unbounded(self):
        entity = 'test.test_strings_unbounded'
        self.run_simulation(entity)

    def test_strings_bounded(self):
        entity = 'test_2008.test_strings_bounded'
        self.run_simulation(entity)

    def test_text_buffering(self):
        entity = 'test.test_text_buffering'
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

    def test_secded_edac(self):
        entity = 'test.test_secded_edac'
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


    def test_parity_ops(self):
        entity = 'test.test_parity_ops'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_handshake_synchronizer(self):
        entity = 'test.test_handshake_synchronizer'

        self.test_name = 'Testbench ' + entity
        self.trial_count = 50
        for i in xrange(self.trial_count):
            self.update_progress(i+1)

            # Select random frequencies for tx and rx sides
            tx_freq = '{}MHz'.format(random.randint(1, 100))
            rx_freq = '{}MHz'.format(random.randint(1, 100))
            self.run_simulation(entity, update=False, TEST_SEED=self.seed, TX_FREQ=tx_freq, RX_FREQ=rx_freq)

    def test_secded_codec(self):
        entity = 'test.test_secded_codec'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_strings_maps(self):
        entity = 'test.test_strings_maps'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_reg_file(self):
        entity = 'test.test_reg_file'


        self.test_name = 'Testbench ' + entity
        self.trial_count = 10
        for i in xrange(self.trial_count):
            self.update_progress(i+1)

            num_regs = random.randint(1, 10);
            reg_size = 16
            nibbles = (reg_size + 3) // 4

            strobe_mask = [random.randint(0, 2**reg_size-1) for _ in xrange(num_regs)]
            direct_read_mask = [random.randint(0, 2**reg_size-1) for _ in xrange(num_regs)]

            strobe_mask = 'X"{}"'.format('_'.join('{:0{}x}'.format(r, nibbles) for r in strobe_mask))
            direct_read_mask = 'X"{}"'.format('_'.join('{:0{}x}'.format(r, nibbles) for r in direct_read_mask))

            self.run_simulation(entity, update=False, TEST_SEED=self.seed, NUM_REGS=num_regs, \
              STROBE_BIT_MASK_BV=strobe_mask, DIRECT_READ_BIT_MASK_BV=direct_read_mask)

    def test_reg_file_2008(self):
        entity = 'test_2008.test_reg_file'


        self.test_name = 'Testbench ' + entity
        self.trial_count = 10
        for i in xrange(self.trial_count):
            self.update_progress(i+1)

            num_regs = random.randint(1, 10);
            reg_size = 16
            nibbles = (reg_size + 3) // 4

            strobe_mask = [random.randint(0, 2**reg_size-1) for _ in xrange(num_regs)]
            direct_read_mask = [random.randint(0, 2**reg_size-1) for _ in xrange(num_regs)]

            strobe_mask = 'X"{}"'.format('_'.join('{:0{}x}'.format(r, nibbles) for r in strobe_mask))
            direct_read_mask = 'X"{}"'.format('_'.join('{:0{}x}'.format(r, nibbles) for r in direct_read_mask))

            self.run_simulation(entity, update=False, TEST_SEED=self.seed, NUM_REGS=num_regs, \
              STROBE_BIT_MASK_BV=strobe_mask, DIRECT_READ_BIT_MASK_BV=direct_read_mask)

    def test_interrupt_ctl(self):
        entity = 'test.test_interrupt_ctl'
        self.run_simulation(entity, TEST_SEED=self.seed)

    def test_bit_ops(self):
        entity = 'test.test_bit_ops'
        #self.run_simulation(entity, TEST_SEED=self.seed)

        self.test_name = 'Testbench ' + entity
        self.trial_count = 10
        for i in xrange(self.trial_count):
            self.update_progress(i+1)
            self.run_simulation(entity, update=False)

