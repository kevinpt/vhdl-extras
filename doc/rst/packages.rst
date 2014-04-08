====================
VHDL-extras packages
====================

The following is a detailed description of the packages provided in VHDL-extras.

Core Packages
-------------

These packages provide core functionality that is of general use in a
wide array of applications.

.. _pipelining:

pipelining
~~~~~~~~~~

`pipelining.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/pipelining.vhdl>`_

Configurable pipeline registers for
use with automated retiming during
synthesis.

.. _sizing:

sizing
~~~~~~

`sizing.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/sizing.vhdl>`_

A set of functions for computing integer logarithms and for determing the size of binary numbers and encodings. Generalized functions for computing floor(log(n, b)) and ceil(log(n, b)) for any base b are provided as well as special purpose convenience functions like bit_size and encoding_size. See the :ref:`bcd_conversion` implementation for a practical example of computing integer logs in base-10 using this package.

.. code-block:: vhdl

    constant MAX_COUNT  : natural := 1000;
    constant COUNT_SIZE : natural := bit_size(MAX_COUNT);
    signal counter : unsigned(COUNT_SIZE-1 downto 0);
    ...
    counter <= to_unsigned(MAX_COUNT, COUNT_SIZE);
    -- counter will resize itself as MAX_COUNT is changed

.. _synchronizing:

synchronizing
~~~~~~~~~~~~~

`synchronizing.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/synchronizing.vhdl>`_

Synchronizer entities for transferring signals between clock domains. There are three entities provided:

* bit_synchronizer -- Suitable for synchronizing individual bit-wide signals
* reset_synchronizer -- A special synchronizer for generating asyncronous resets that are synchronously released
* handshake_synchronizer -- A synchronizer using the four-phase protocol to transfer vectors between domains

bit_synchronizer and reset_synchronizer have a configurable number of stages with a default of 2.

.. _timing_ops:

timing_ops
~~~~~~~~~~

`timing_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/timing_ops.vhdl>`_

`timing_ops_xilinx.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/timing_ops_xilinx.vhdl>`_

Functions for conversions between time, frequency, and clock cycles. Also includes a flexible,
simulation-only clock generation procedure. A variant of timing_ops is provided for use with Xilinx XST. It is stripped of the frequency physical type which XST cannot support. You can perform computations and conversions on time and frequency using real, integers, and physical types. This provides a powerful mechanism to generate synthesizable time related constants without manual precomputation.

.. code-block:: vhdl

    library extras; use extras.sizing.bit_size; use extras.timing_ops.all;
    ...
    constant SYS_CLOCK_FREQ : frequency := 50 MHz;
    constant COUNT_1US : clock_cycles := to_clock_cycles(1 us, SYS_CLOCK_FREQ);
    signal   counter   : unsigned(bit_size(COUNT_1US)-1 downto 0);
    ...
    counter <= to_unsigned(COUNT_1US, counter'length); -- initialize counter
    report_time_precision("COUNT_1US", COUNT_1US, 1 us, time_duration(COUNT_1US, SYS_CLOCK_FREQ));

    -- The value of the "COUNT_1US" constant will change to reflect any change in
    -- the system clock frequency and the size of the signal "counter" will now
    -- automatically adapt to guarantee it can represent the count for 1 us.

    -- The clock_gen procedure can be called from a process to generate a clock
    -- in simulation with the requested frequency or period and an optional duty
    -- cycle specification:

    sys_clock_gen: process
    begin
      clock_gen(sys_clock, stop_clock, SYS_CLOCK_FREQ);
      wait;
    end process;

Error handling
--------------

Packages for performing error detection and correction.

.. _crc_ops:

crc_ops
~~~~~~~

`crc_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/crc_ops.vhdl>`_

A general purpose set of functions
and component for generating
CRCs.

.. _hamming_edac:

hamming_edac
~~~~~~~~~~~~

`hamming_edac.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/hamming_edac.vhdl>`_

A flexible implementation of the
Hamming code for any data size of
4-bits or greater.

.. _parity_ops:

parity_ops
~~~~~~~~~~

`parity_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/parity_ops.vhdl>`_

Basic parity operations.

.. _secded_edac:

secded_edac
~~~~~~~~~~~

`secded_edac.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/secded_edac.vhdl>`_

Single Error Correction, Double
Error Detection implemented with
extended Hamming code.

.. _secded_codec:

secded_codec
~~~~~~~~~~~~

`secded_codec.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/secded_codec.vhdl>`_

An entity providing a combined
SECDED encoder and decoder with
added error injection for system
verification. Optional pipelining
is provided.

Encoding
--------

Packages for encoding data into alternate forms.

.. _bcd_conversion:

bcd_conversion
~~~~~~~~~~~~~~

`bcd_conversion.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/bcd_conversion.vhdl>`_

Conversion to and from packed Binary
Coded Decimal. Supports any data size.

.. _gray_code:

gray_code
~~~~~~~~~

`gray_code.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/gray_code.vhdl>`_

Conversion between binary and Gray code.

.. _muxing:

muxing
~~~~~~

`muxing.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/muxing.vhdl>`_

Parameterized multiplexers,
decoders, and demultiplexers.


Memories
--------

Packages with internal memories


.. _fifo_pkg:

fifo_pkg
~~~~~~~~

`fifo_pkg.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/fifo_pkg.vhdl>`_


A set of general purpose single and dual
clock domain FIFOs.

.. _memory_pkg:

memory_pkg
~~~~~~~~~~

`memory_pkg.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/memory_pkg.vhdl>`_

Generic dual ported RAM and synthesizable
ROM with file I/O.


Randomization
-------------

These packages provide linear feedback shift registers and related
structures for creating randomized output.

.. _lcar_ops:

lcar_ops
~~~~~~~~

`lcar_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/lcar_ops.vhdl>`_

An implementation of the Wolfram Linear
Cellular Automata. This is useful for
generating pseudo-random numbers with low
correlation between bits. Adaptable to any
number of cells. Constants are provided for
maximal length sequences of up to 100 bits.

.. _lfsr_ops:

lfsr_ops
~~~~~~~~

`lfsr_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/lfsr_ops.vhdl>`_

Various implementations of Galois and
Fibonacci Linear Feedback Shift Registers.
These adapt to any size register. Coefficients
are provided for maximal length sequences up
to 100 bits.

.. _random:

random
~~~~~~

`random.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/random.vhdl>`_

`random_20xx.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/random_20xx.vhdl>`_


String and character handling
-----------------------------

A set of packages that provide string and character operations adapted
from the Ada standard library.

.. _characters_handling:

characters_handling
~~~~~~~~~~~~~~~~~~~

`characters_habdling.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/characters_handling.vhdl>`_

Functions for
identifying character
classification.

.. characters_latin_1:

characters_latin_1
~~~~~~~~~~~~~~~~~~

`characters_latin_1.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/characters_latin_1.vhdl>`_

Constants for the
Latin-1 character
names.

.. _strings:

strings
~~~~~~~

`strings.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings.vhdl>`_

Shared types for the
string packages.

.. _strings_fixed:

strings_fixed
~~~~~~~~~~~~~

`strings_fixed.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_fixed.vhdl>`_

Operations for fixed
length strings using
the built in string
type.

.. _strings_maps:

strings_maps
~~~~~~~~~~~~

`strings_maps.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_maps.vhdl>`_

Functions for mapping
character sets.

.. _strings_maps_constants:

strings_maps_constants
~~~~~~~~~~~~~~~~~~~~~~

`strings_maps_constants.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_maps_constants.vhdl>`_

Constants for basic
character sets.

.. _strings_unbounded:

strings_unbounded
~~~~~~~~~~~~~~~~~

`strings_unbounded.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_unbounded.vhdl>`_


Operations for
dynamically allocated
strings.

Miscellaneous
-------------

Additional packages of useful functions.


.. _binaryio:

binaryio
~~~~~~~~

`binaryio.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/binaryio.vhdl>`_

Procedures for general binary file
IO. Support is provided for reading
and writing vectors of any size
with big and little-endian byte
order.

.. _text_buffering:

text_buffering
~~~~~~~~~~~~~~

`text_buffering.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/text_buffering.vhdl>`_

Procedures for storing text files
in an internal buffer and for
accumulating text log information
before writing to a file.


.. _ddfs:

ddfs
~~~~

`ddfs.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/ddfs.vhdl>`_

A set of functions for implementing
Direct Digital Frequency Synthesizers.

.. _glitch_filtering:

glitch_filtering
~~~~~~~~~~~~~~~~

`glitch_filtering.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/glitch_filtering.vhdl>`_

A configurable filter for removing
spurious transitions from noisy inputs.





