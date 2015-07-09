
.. image:: http://kevinpt.github.io/vhdl-extras/_static/vhdl-extras-sm.png

===================
VHDL-extras Library
===================

This library provides some "extra" bits of code that are not found in the standard VHDL libraries. With VHDL-extras you can create designs that will resize to varying data widths, compute with time, frequency, and clock cycles, include error correction, and many more commonly encountered issues in digital logic design. These packages can be used for logic simulations and, in most cases, can be synthesized to hardware with an FPGA or ASIC target.

All of the packages are designed to work with VHDL-93. Alternate packages supporting newer VHDL standards are provided where new language features provide enhanced functionality or where forward compatibility is broken. The core code should work in most VHDL-93 compliant tools. In one instance with the `timing_ops <http://kevinpt.github.io/vhdl-extras/rst/packages.html#timing-ops>`_ package, a simplified Xilinx specific implementation is provided because of limitations with the XST synthesizer (fixed in Vivado).

Requirements
------------

You can use the VHDL-extras library files piecemeal with no tools other than the simulator or synthesizer you will process them with. If you wish to use the provided Modelsim build scripts you will need Modelsim, Python 2.x, sed, grep, and GNU make. To run the test suite you will need Python 2.7 and Modelsim. See the sections on `installation <http://kevinpt.github.io/vhdl-extras/index.html#installation>`_ and `testing <http://kevinpt.github.io/vhdl-extras/index.html#testing>`_ for more information on setting up the VHDL-extras library. You can get optional colorized output from the build and test scripts by installing the Python colorama package.

Documentation
-------------

Take a look at the `online documentation <http://kevinpt.github.io/vhdl-extras/index.html>`_ for more information on what you can do with VHDL-extras.


Download
--------
You can access the VHDL-extras Git repository from `Github <https://github.com/kevinpt/vhdl-extras>`_. `Packaged source code <https://drive.google.com/folderview?id=0B5jin2146-EXV2NfS3V2VXBsQnM&usp=sharing>`_ is also available for download.

The Code
--------

The VHDL-extras library contains the following packages:

* Core packages

    `pipelining <http://kevinpt.github.io/vhdl-extras/rst/packages.html#pipelining>`_ -- Pipeline registers

    `sizing <http://kevinpt.github.io/vhdl-extras/rst/packages.html#sizing>`_ -- Generalized integer logarithms and array size computation

    `synchronizing <http://kevinpt.github.io/vhdl-extras/rst/packages.html#synchronizing>`_ -- Clock domain synchronizing components

    `timing_ops <http://kevinpt.github.io/vhdl-extras/rst/packages.html#timing-ops>`_ -- Conversions for time, frequency, and clock cycles

* Error handling

    `crc_ops <http://kevinpt.github.io/vhdl-extras/rst/packages.html#crc-ops>`_ -- Compute CRCs

    `hamming_edac <http://kevinpt.github.io/vhdl-extras/rst/packages.html#hamming-edac>`_ -- Generalized Hamming error correction encoding and decoding

    `parity_ops <http://kevinpt.github.io/vhdl-extras/rst/packages.html#parity-ops>`_ -- Basic parity operations

    `secded_edac <http://kevinpt.github.io/vhdl-extras/rst/packages.html#secded-edac>`_ -- Hamming extension with double-error detection

* Encoding

    `bcd_conversion <http://kevinpt.github.io/vhdl-extras/rst/packages.html#bcd-conversion>`_ -- Encode and decode packed Binary Coded Decimal

    `gray_code <http://kevinpt.github.io/vhdl-extras/rst/packages.html#gray-code>`_ -- Encode and decode Gray code

    `muxing <http://kevinpt.github.io/vhdl-extras/rst/packages.html#muxing>`_ -- Decoder and muxing operations

* Memories

    `fifos <http://kevinpt.github.io/vhdl-extras/rst/packages.html#fifos>`_ -- General purpose FIFOs

    `memory <http://kevinpt.github.io/vhdl-extras/rst/packages.html#memory>`_ -- Synthesizable memories

    `reg_file <http://kevinpt.github.io/vhdl-extras/rst/packages.html#reg-file>`_ -- General purpose register file

* Randomization

    `lcar_ops <http://kevinpt.github.io/vhdl-extras/rst/packages.html#lcar-ops>`_ -- Linear Cellular Automata

    `lfsr_ops <http://kevinpt.github.io/vhdl-extras/rst/packages.html#lfsr-ops>`_ -- Linear Feedback Shift Registers

    `random <http://kevinpt.github.io/vhdl-extras/rst/packages.html#random>`_ -- Simulation-only random number generation

* String and character handling

    `characters_handling <http://kevinpt.github.io/vhdl-extras/rst/packages.html#characters-handling>`_ -- Character class identification and case conversions

    `strings_fixed <http://kevinpt.github.io/vhdl-extras/rst/packages.html#strings-fixed>`_ -- Operations on fixed length strings

    `strings_maps <http://kevinpt.github.io/vhdl-extras/rst/packages.html#strings-maps>`_ -- Mapping character sets

    `strings_unbounded <http://kevinpt.github.io/vhdl-extras/rst/packages.html#strings-unbounded>`_ -- Operations on unbounded strings

* Miscellaneous

    `binaryio <http://kevinpt.github.io/vhdl-extras/rst/packages.html#binaryio>`_ -- Binary file I/O

    `text_buffering <http://kevinpt.github.io/vhdl-extras/rst/packages.html#text-buffering>`_ -- Store text files in internal buffers

    `ddfs <http://kevinpt.github.io/vhdl-extras/rst/packages.html#ddfs>`_ -- Direct Digital Frequency Synthesizer

    `glitch_filtering <http://kevinpt.github.io/vhdl-extras/rst/packages.html#glitch-filtering>`_ -- Clean up noisy inputs


Licensing
~~~~~~~~~

   All of the source files distributed as part of VHDL-extras are made freely
   available under the MIT license. The license permits unrestricted use of
   this code for commercial and non-commercial use. You may freely mix
   VHDL-extras code with proprietary code. You may make any modifications
   necessary without any requirement to redistribute your source code. The only
   requirement is to maintain the copyright and licensing information in the
   file headers.

   It is presumed that portions of the VHDL-extras library will be
   translated into circuitry with synthesis software. The resulting hardware
   implementation will be free of any requirements beyond those that apply
   when the code is used as software. The functions provided in VHDL-extras
   are all commonly known in the art and are free of any patent
   restrictions. It would be a nice gesture if the documentation for any
   hardware containing VHDL-extras code included an acknowledgement of that
   code and a pointer to this web site.

MIT License
~~~~~~~~~~~

     Permission is hereby granted, free of charge, to any person obtaining a
     copy of this software and associated documentation files (the "Software"),
     to deal in the Software without restriction, including without limitation
     the rights to use, copy, modify, merge, publish, distribute, sublicense,
     and/or sell copies of the Software, and to permit persons to whom the
     Software is furnished to do so, subject to the following conditions:

     The above copyright notice and this permission notice shall be included in
     all copies or substantial portions of the Software.

     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
     DEALINGS IN THE SOFTWARE.
