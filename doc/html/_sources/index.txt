.. VHDL-extras documentation master file, created by
   sphinx-quickstart on Sun Apr  6 19:03:10 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

VHDL-extras library documentation
=================================


This library provides some "extra" bits of code that are not found in the standard VHDL libraries. With VHDL-extras you can create designs that will resize to varying data widths, compute with time, frequency, and clock cycles, include error correction, and many more commonly encountered issues in digital logic design. These packages can be used for logic simulations and, in most cases, can be synthesized to hardware with an FPGA or ASIC target.

All of the packages are designed to work with VHDL-93. In cases where forward compatibility is broken in newer VHDL standards an alternate package is provided. The code should work in most VHDL-93 compliant tools. In one instance with the :ref:`timing_ops` package, a simplified Xilinx specific implementation is provided because of limitations with the XST synthesizer.

Requirements
============

You can use the VHDL-extras library files piecemeal with no tools other than the simulator or synthesizer you will process them with. If you wish to use the provided Modelsim build scripts you will need Modelsim, Python 2.x, and GNU make. To run the test suite you will need Python 2.7 and Modelsim. See the sections on :ref:`installation` and :ref:`testing` for more information on setting up the VHDL-extras library. You can get optional colorized output from the build and test scripts by installing the Python colorama package.


The Code
========

The VHDL-extras library contains the following packages:

* Core packages

    :ref:`pipelining` -- Pipeline registers

    :ref:`sizing` -- Generalized integer logarithms and array size computation

    :ref:`synchronizing` -- Clock domain synchronizing components

    :ref:`timing_ops` -- Conversions for time, frequency, and clock cycles

* Error handling
    :ref:`crc_ops` -- Compute CRCs

    :ref:`hamming_edac` -- Generalized Hamming error correction encoding and decoding

    :ref:`parity_ops` -- Basic parity operations

    :ref:`secded_edac` -- Hamming extension with double-error detection

* Encoding
    :ref:`bcd_conversion` -- Encode and decode packed Binary Coded Decimal

    :ref:`gray_code` -- Encode and decode Gray code

    :ref:`muxing` -- Decoder and muxing operations

* Memories
    :ref:`fifo_pkg` -- General purpose FIFOs

    :ref:`memory_pkg` -- Synthesizable memories

* Randomization
    :ref:`lcar_ops` -- Linear Cellular Automata

    :ref:`lfsr_ops` -- Linear Feedback Shift Registers

    :ref:`random` -- Simulation-only random umber generation

* String and character handling
    :ref:`characters_handling` -- Character class identification and case conversions

    :ref:`strings_fixed` -- Operations on fixed length strings

    :ref:`strings_maps` -- Mapping character sets

    :ref:`strings_unbounded` -- Operations on unbounded strings

* Miscellaneous

    :ref:`binaryio` -- Binary file I/O

    :ref:`text_buffering` -- Store text files in internal buffers

    :ref:`ddfs` -- Direct Digital Frequency Synthesizer

    :ref:`glitch_filtering` -- Clean up noisy inputs

.. _installation:

Installation
============

The library consists of a number of VHDL files and associated test code. No special installation is necessary. It is possible to simply take the portions of the library needed in a design and compile or synthesize them as necessary with your development tools.

Some packages are dependent on other parts of the library and expect to find them mapped onto the "extras" logical library. How you define such a library is tool dependent. In general if you have issues with library mapping check to make sure that the VHDL-extras packages are *not* mapped to the default "work" library.

A makefile and Python scripted build system has been included to facilitate use with Modelsim. The build scripts will create a standalone Modelsim library that can be referenced from other designs without needing recompilation.

To run the build scripts you must first ensure that the `MGC_WD` environment variable is set to the current path where you extracted the root of the VHDL-extras distribution. You will also need to ensure that the Modelsim binaries (`vmap`, `vlib`, and `vcom`) are in your `PATH` environment variable. A Bourne shell script (`start_proj.sh <http://code.google.com/p/vhdl-extras/source/browse/start_proj.sh>`_) is provided to perform this setup. You can source it into the current shell with the following:

.. code-block:: sh

  > . start_proj.sh

This will take care of setting MGC_WD, generate a default `modelsim.ini` file, and run a Python script to alter its default library mapping.

You can verify Modelsim is setup correctly by running the `vmap` command:

.. code-block:: sh

  > vmap
  Reading <VHDL-extras base>/modelsim.ini
  "std" maps to directory <modelsim base>/../std.
  "ieee" maps to directory <modelsim base>/../ieee.
  "vital2000" maps to directory <modelsim base>/../vital2000.
  "modelsim_lib" maps to directory <modelsim base>/../modelsim_lib.
  Reading <VHDL-extras base>/modelsim.map
  "test" maps to directory <VHDL-extras base>/build/lib/test.
  "extras" maps to directory <VHDL-extras base>/vhdl-extras/build/lib/extras.

You should see a mapping for the "extras" library.

After that is complete, start the build process by running GNU make:

.. code-block:: sh

  > make

The makefile prepares a `build` directory with Modelsim libraries and scans the source code for dependency information. The end result is a compiled Modelsim library located in `build/lib/extras` that you can reference from other Modelsim projects. It will also compile the VHDL portions of the test suite located in `build/lib/test`.

.. _testing:

Testing
=======

A unit test suite is provided to verify the library is correct. It depends on the built-in Python 2.7  unittest library with automatic test discovery. After building the library according to the installation instructions you can run the test suite with the following command:

.. code-block:: sh

  > python -m unittest discover

This will run the Python test suite defined in the `test` directory which will launch Modelsim simulations and validate the library. The output of each test case is recorded in `test/test-output`.

Licensing
=========

The VHDL-extras library is licensed for free commercial and non-commercial use under the terms of the MIT license. One exception is the `strings_maps_constants.vhdl` package which contains code adapted
from the GPLv2 licensed Ada library distributed with GNAT 3.15p. The license for this version of GNAT includes an exception clause that prevents the normal extension of the GPL terms to code that "links" or
instantiates code from the package. This exception permits proprietary code to be combined with this file without imposing the requirement to redistribute the proprietary portions of the code.



Contents:

.. toctree::
   :maxdepth: 2

   rst/packages

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

