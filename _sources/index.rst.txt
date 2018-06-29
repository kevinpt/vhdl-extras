.. VHDL-extras documentation master file, created by
   sphinx-quickstart on Sun Apr  6 19:03:10 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

VHDL-extras library documentation
=================================


This library provides some "extra" bits of code that are not found in the standard VHDL libraries. With VHDL-extras you can create designs that will resize to varying data widths, compute with time, frequency, and clock cycles, include error correction, and many more commonly encountered issues in digital logic design. These packages can be used for logic simulations and, in most cases, can be synthesized to hardware with an FPGA or ASIC target. The VHDL-extras library contains 50+ components and many more utility functions that can enhance and simplify many hardware development tasks.

All of the packages are designed to work with VHDL-93. Alternate packages supporting newer VHDL standards are provided where new language features provide enhanced functionality or where forward compatibility is broken. The core code should work in most VHDL-93 compliant tools. In one instance with the :doc:`rst/modules/timing_ops` package, a simplified Xilinx specific implementation is provided because of limitations with the XST synthesizer (fixed in Vivado).

Requirements
============

You can use the VHDL-extras library files piecemeal with no tools other than the simulator or synthesizer you will process them with. If you wish to use the provided Modelsim build scripts you will need Modelsim, Python 2.x, sed, grep, and GNU make. To run the test suite you will need Python 2.7 and Modelsim. See the sections on :ref:`installation` and :ref:`testing` for more information on setting up the VHDL-extras library. You can get optional colorized output from the build and test scripts by installing the Python colorama package.


Library contents
================

The VHDL-extras library contains the following packages:

* Core packages
    These packages provide core functionality that is of general use in a
    wide array of applications.

    :doc:`rst/modules/pipelining` -- Pipeline registers

    :doc:`rst/modules/sizing` -- Generalized integer logarithms and array size computation

    :doc:`rst/modules/synchronizing` -- Clock domain synchronizing components

    :doc:`rst/modules/timing_ops` -- Conversions for time, frequency, and clock cycles

* Arithmetic
    These packages implement arithmetic operations.

    :doc:`rst/modules/arithmetic` -- Pipelined adder
    
    :doc:`rst/modules/bit_ops` -- Bitwise operations
    
    :doc:`rst/modules/cordic` -- CORDIC rotation algorithm and Sine/Cosine generation
    
    :doc:`rst/modules/filtering` -- Digital filters

* Signal processing
    Packages to geenrate and transform sample streams

    :doc:`rst/modules/ddfs` -- Direct Digital Frequency Synthesizer

    :doc:`rst/modules/oscillator` -- Sinusoidal frequency generators

* Error handling
    Packages for performing error detection and correction.

    :doc:`rst/modules/crc_ops` -- Compute CRCs

    :doc:`rst/modules/hamming_edac` -- Generalized Hamming error correction encoding and decoding

    :doc:`rst/modules/parity_ops` -- Basic parity operations

    :doc:`rst/modules/secded_edac` -- Hamming extension with double-error detection

* Encoding
    Packages for encoding data into alternate forms.

    :doc:`rst/modules/bcd_conversion` -- Encode and decode packed Binary Coded Decimal

    :doc:`rst/modules/gray_code` -- Encode and decode Gray code

    :doc:`rst/modules/muxing` -- Decoder and muxing operations

* Memories
    Packages with internal memories.

    :doc:`rst/modules/fifos` -- General purpose FIFOs

    :doc:`rst/modules/memory` -- Synthesizable memories

    :doc:`rst/modules/reg_file` -- General purpose register file

* Randomization
    These packages provide linear feedback shift registers and related
    structures for creating randomized output.

    :doc:`rst/modules/lcar_ops` -- Linear Cellular Automata

    :doc:`rst/modules/lfsr_ops` -- Linear Feedback Shift Registers

    :doc:`rst/modules/random` -- Simulation-only random number generation

* String and character handling
    A set of packages that provide string and character operations adapted
    from the Ada standard library.

    :doc:`rst/modules/characters_handling` -- Character class identification and case conversions
    
    :doc:`rst/modules/characters_latin_1` -- Latin-1 constants
    
    :doc:`rst/modules/strings` -- Common string types

    :doc:`rst/modules/strings_fixed` -- Operations on fixed length strings

    :doc:`rst/modules/strings_unbounded` -- Operations on unbounded strings
    
    :doc:`rst/modules/strings_bounded` -- Operations on bounded strings

    :doc:`rst/modules/strings_maps` -- Mapping character sets
    
    :doc:`rst/modules/strings_maps_constants` -- Predefined mappings


* Miscellaneous
    Additional packages of useful functions.

    :doc:`rst/modules/binaryio` -- Binary file I/O
    
    :doc:`rst/modules/interrupt_ctl` -- General purpose priority interrupt controller.

    :doc:`rst/modules/text_buffering` -- Store text files in internal buffers

    :doc:`rst/modules/glitch_filtering` -- Clean up noisy inputs

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
  "test_2008" maps to directory <VHDL-extras base>/vhdl-extras/build/lib/test_2008.
  "extras_2008" maps to directory <VHDL-extras base>/vhdl-extras/build/lib/extras_2008.

You should see a mapping for the "extras" and "extras_2008" libraries.

After that is complete, start the build process by running GNU make:

.. code-block:: sh

  > make

The makefile prepares a `build` directory with Modelsim libraries and scans the source code for dependency information. The end result is a compiled Modelsim library located in `build/lib/extras` that you can reference from other Modelsim projects. It will also compile the VHDL portions of the test suite located in `build/lib/test`.

.. _testing:

Testing
=======

A unit test suite is provided to verify the library is correct. It depends on the built-in Python 2.7  unittest library with automatic test discovery and Modelsim. After building the library according to the installation instructions you can run the test suite with the following command:

.. code-block:: sh

  > python -m unittest discover

This will run the Python test suite defined in the `test` directory which will launch Modelsim simulations and validate the library. The output of each test case is recorded in `test/test-output`.

Using the library
=================

You will need to be aware of any library mappings required to use the
VHDL-extras packages. Those packages lacking any dependencies may be used
directly without any additional steps necessary. The remaining packages
with dependencies on other portions of the VHDL-extras library need their
dependencies mapped into a new "extras" library rather than the default
"work" library. Consult your tool documentation on how to accomplish
this. The installation scripts take care of this when using Modelsim.

Each file provides a package of publicly accessible types, constants,
subprograms, and components. Once the "extras" library has been mapped
you can access a package with the following code:

.. code-block:: vhdl

   library extras;
   use extras.<package_name>.all;


Unconstrained array parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Most of the packages employ parameterization through the use of unbounded
arrays in subprogram parameter lists and entity ports. You control the
size of the logic with the signals and variables connected to these
interfaces. In some cases there are implied size relationships between
various input and output arrays that must be observed to produce correct
results. These will usually be verified by assertions but may be missed
if no attempt is made to simulate a design before synthesis.

.. code-block:: vhdl

  component fixed_delay_line_signed is
    generic (
      STAGES : natural
      );
    port (
      Clock : in std_ulogic;
      Enable : in std_ulogic;

      Data_in  : in signed;            -- Unconstrained array
      Data_out : out signed            -- Unconstrained output
      );
  end component;

In this example the ``Data_in`` and ``Data_out`` ports of the component are both unconstrained. They implicitly need to be the same size.

Resets
~~~~~~

Almost all components are designed to use asynchronous resets. The only exceptions are those
that will benefit from use of special resources that will only be instantiated after synthesis 
without a reset such as the :vhdl:entity:`~extras.pipelining.fixed_delay_line_signed` component above.

The active level of the reset is controlled with the `RESET_ACTIVE_LEVEL` generic on each
component. It defaults to `'1'` meaning the reset will be active-high. Set
it to `'0'` if you want to use active-low resets in a design. You should ensure
that the asynchronous resets in your design are released synchronously to prevent
spurious setup and hold violations when coming out of reset.

Ideally you should condition the asynchronous reset with a component like :vhdl:entity:`~extras.synchronizing.reset_synchronizer` which guarantees that the reset is released synchronously but can still be activated asynchronously. It should be instantiated for every resettable clock domain in the design. This eliminates the possibility timing volations when coming out of reset when normal static timing constraints are checked. To further guard against timing skew between the clock and reset, the reset net can be forcibly buffered by instantiating a platform specific clock buffer to take advantage of the same delay balanced clock trees used for clock distribution.

If you truly must create a design without a functional reset then you can hardwire the ``Reset`` port signals to the inactive state and let the synthesizer optimize them away. Some architectures such as various Xilinx families may have special power-on-reset components you can instantiate in lieu of an external reset pin when targeting existing hardware. Keeping resets in your designs has immense value in creating improved portability, testability, and removes reliance on default signal values for initialization which is not supported by all synthesizers.

Synthesis
~~~~~~~~~

Most but not all of these packages are usable for synthesis. All of the
code in the ``extras`` library is written in conformance to the VHDL-93 standard.
Various synthesis tools may differ in their support for the language
constructs used within VHDL-extras. For Synopsys Design Compiler you will
need to activate the newer presto VHDL compiler if it isn't set as the
default.

VHDL-2008
~~~~~~~~~

Some of the code is available as enhanced implementations that take
advantage of features provided by newer versions of VHDL. These packages
are provided in the ``extras_2008`` library. Files that are VHDL-2000 compliant
have a "_20xx" suffix while VHDL-2008 specific code has a "_2008" suffix.
The Modelsim build script compiles all of these files in 2008 mode. You will
have to manually build anything you want in 2000 (or 2002) mode.

Unresolved types
~~~~~~~~~~~~~~~~

In this library, the unresolved `std_ulogic` and `std_ulogic_vector` types are
preferentially used in favor of `std_logic` and `std_logic_vector`. Driver
resolution isn't needed in most cases and using the unresolved types adds an
extra level of assurance to a design by preventing accidental connections of
multiple signal drivers. Using these types can require a little extra work with
type conversions and consequently most resources for VHDL avoid demonstrating
their use. Since `std_logic` is a subtype and closely related to `std_ulogic`
you can freely interchange signals of those types but the same is not the case
for the arrays `std_ulogic_vector` and `std_logic_vector`. For these, you will
have to employ explicit type conversions with implementations of the language
before VHDL-2008.

For earlier standards you have to convert in stages as follows:

.. code-block:: vhdl

  -- Convert unsigned to std_ulogic_vector
  sulv <= to_stdulogicvector(std_logic_vector(uns));
  
  -- Convert std_ulogic_vector to unsigned
  uns <= unsigned(to_stdlogicvector(sulv));

The 2008 standard revised the library to define
`std_logic_vector` as a resolved subtype of `std_ulogic_vector` rather than
an independent type. With tools that support VHDL-2008 you will be able
to interchange these array types and related types like `unsigned` and `signed` 
without calling conversion functions. This
library employs `std_ulogic_vector` for non-numeric arrays in anticipation
of wider adoption of the latest standard.

The `std_ulogic_vector` array type is used for generic collections of bits that don't necessarily
have a numeric interpretation. the numeric array types `unsigned` and `signed` are used for
signals that do represent a numeric value.


Licensing
=========

The VHDL-extras library is licensed for free commercial and non-commercial use under the terms of the MIT license.


Contents:

.. toctree::
   :maxdepth: 2
   :hidden:
   :glob:

   rst/packages
   rst/modules/*

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

