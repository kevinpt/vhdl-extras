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

This package provides a general purpose CRC implementation. It consists
of a set of functions that can be used to iteratively process successive
data vectors as well an an entity that combines the functions into a
synthesizable form. The CRC can be readily specified using the Rocksoft
notation described in "A Painless Guide to CRC Error Detection Algorithms",
*Williams 1993*. A CRC specification consists of the following parameters:

  | Poly       : The generator polynomial
  | Xor_in     : The initialization vector "xored" with an all-'0's shift register
  | Xor_out    : A vector xored with the shift register to produce the final value
  | Reflect_in : Process data bits from left to right (false) or right to left (true)
  | Reflect_out: Determine bit order of final crc result

A CRC can be computed using a set of three functions `init_crc`, `next_crc`, and `end_crc`.
All functions are assigned to a common variable/signal that maintans the shift
register state between succesive calls. After initialization with `init_crc`, data
is processed by repeated calls to `next_crc`. The width of the data vector is
unconstrained allowing you to process bits in chunks of any desired size. Using
a 1-bit array for data is equivalent to a bit-serial CRC implementation. When
all data has been passed through the CRC it is completed with a call to `end_crc` to
produce the final CRC value.

.. _hamming_edac:

hamming_edac
~~~~~~~~~~~~

`hamming_edac.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/hamming_edac.vhdl>`_

A flexible implementation of the Hamming code for any data size of 4-bits or greater.

.. _parity_ops:

parity_ops
~~~~~~~~~~

`parity_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/parity_ops.vhdl>`_

Basic parity operations.

.. _secded_edac:

secded_edac
~~~~~~~~~~~

`secded_edac.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/secded_edac.vhdl>`_

Single Error Correction, Double Error Detection implemented with extended Hamming code.

.. _secded_codec:

secded_codec
~~~~~~~~~~~~

`secded_codec.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/secded_codec.vhdl>`_

An entity providing a combined SECDED encoder and decoder with added error injection for system verification. Optional pipelining is provided.

Encoding
--------

Packages for encoding data into alternate forms.

.. _bcd_conversion:

bcd_conversion
~~~~~~~~~~~~~~

`bcd_conversion.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/bcd_conversion.vhdl>`_

This package provides functions and components for performing conversion
between binary and packed Binary Coded Decimal (BCD). The functions
to_bcd and to_binary can be used to create synthesizable combinatinal
logic for performing a conversion. In synthesized code they are best used
with shorter arrays comprising only a few digits. For larger numbers, the
components binary_to_bcd and bcd_to_binary can be used to perform a
conversion over multiple clock cycles. The utility function decimal_size
can be used to determine the number of decimal digits in a BCD array. Its
result must be multiplied by 4 to get the length of a packed BCD array.

.. code-block:: vhdl

    signal binary  : unsigned(7 downto 0);
    constant DSIZE : natural := decimal_size(2**binary'length - 1);
    signal bcd : unsigned(DSIZE*4-1 downto 0);
    ...
    bcd <= to_bcd(binary);

.. _gray_code:

gray_code
~~~~~~~~~

`gray_code.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/gray_code.vhdl>`_

This package provides functions to convert between Gray code and binary. An example implementation of a Gray code counter is also included.

.. code-block:: vhdl

  signal bin, gray, bin2 : std_ulogic_vector(7 downto 0);
  ...
  bin  <= X"C5";
  gray <= to_gray(bin);
  bin2 <= to_binary(gray);


.. _muxing:

muxing
~~~~~~

`muxing.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/muxing.vhdl>`_

`muxing_2008.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras_2008/muxing_2008.vhdl>`_

Parameterized multiplexers, decoders, and demultiplexers. A VHDL-2008 variant is available that
implements a fully generic multi-bit mux.


Memories
--------

Packages with internal memories


.. _fifos:

fifos
~~~~~

`fifos.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/fifos.vhdl>`_

This package implements a set of generic FIFO components. There are three
variants. All use the same basic interface for the read/write ports and
status flags. The FIFOs have the following differences:


* simple_fifo -- Basic minimal FIFO for use in a single clock domain. This component lacks the synchronizing logic needed for the other two FIFOs and will synthesize more compactly.
* fifo        -- General FIFO with separate domains for read and write ports.
* packet_fifo -- Extension of fifo component with ability to discard written data before it is read. Useful for managing packetized protocols with error detection at the end.

.. _memory:

memory
~~~~~~

`memory.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/memory.vhdl>`_

This package provides general purpose components for inferred dual-ported RAM and ROM.

.. _reg_file:

reg_file
~~~~~~~~

`reg_file.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/reg_file.vhdl>`_

`reg_file_2008.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras_2008/reg_file_2008.vhdl>`_

This is an implementaiton of a general purpose register file. The VHDL-93 version must be manually customised to set the size of the registers internally. The VHDL-2008 version is fully generic by employing an unconstrained array of unconstrained arrays to implement the registers. In addition to simple read/write registers you can configure individual bits to act as self clearing strobes when written and to read back directly from internal signals rather than from the register contents.

Randomization
-------------

These packages provide linear feedback shift registers and related
structures for creating randomized output.

.. _lcar_ops:

lcar_ops
~~~~~~~~

`lcar_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/lcar_ops.vhdl>`_

An implementation of the Wolfram Linear Cellular Automata. This is useful for generating pseudo-random numbers with low correlation between bits. Adaptable to any number of cells. Constants are provided for
maximal length sequences of up to 100 bits.

.. _lfsr_ops:

lfsr_ops
~~~~~~~~

`lfsr_ops.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/lfsr_ops.vhdl>`_

Various implementations of Galois and Fibonacci Linear Feedback Shift Registers. These adapt to any size register. Coefficients are provided for maximal length sequences up to 100 bits.

.. _random:

random
~~~~~~

`random.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/random.vhdl>`_

`random_20xx.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras_2008/random_20xx.vhdl>`_

This package provides a general set of pseudo-random number functions.
It is implemented as a wrapper around the ieee.math_real.uniform
procedure and is only suitable for simulation not synthesis. See the
LCAR and LFSR packages for synthesizable random generators.

This package makes use of shared variables to keep track of the PRNG
state more conveniently than calling uniform directly. Because
VHDL-2002 broke forward compatability of shared variables there are
two versions of this package. One (random.vhdl) is for VHDL-93 using
the classic shared variable mechanism. The other (random_20xx.vhdl)
is for VHDL-2002 and later using a protected type to manage the
PRNG state. Both files define a package named "random" and only one
can be in use at any time. The user visible subprograms are the same
in both implementations.


String and character handling
-----------------------------

A set of packages that provide string and character operations adapted
from the Ada standard library.

.. _characters_handling:

characters_handling
~~~~~~~~~~~~~~~~~~~

`characters_handling.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/characters_handling.vhdl>`_

This is a package of functions that replicate the behavior of the Ada
standard library package ada.characters.handling. Included are functions
to test for different character classifications and perform conversion
of characters and strings to upper and lower case.

.. characters_latin_1:

characters_latin_1
~~~~~~~~~~~~~~~~~~

`characters_latin_1.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/characters_latin_1.vhdl>`_

This package provides Latin-1 character constants. These constants are
adapted from the definitions in the Ada'95 ARM for the package
Ada.Characters.Latin_1.

.. _strings:

strings
~~~~~~~

`strings.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings.vhdl>`_

Shared types for the string packages.

.. _strings_fixed:

strings_fixed
~~~~~~~~~~~~~

`strings_fixed.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_fixed.vhdl>`_

This package provides a string library for operating on fixed length
strings. This is a clone of the Ada'95 library Ada.Strings.Fixed. It is a
nearly complete implementation with only the procedures taking character
mapping functions omitted because of VHDL limitations.

.. _strings_maps:

strings_maps
~~~~~~~~~~~~

`strings_maps.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_maps.vhdl>`_

This package provides types and functions for manipulating character sets.
It is a clone of the Ada'95 package Ada.Strings.Maps.

.. _strings_maps_constants:

strings_maps_constants
~~~~~~~~~~~~~~~~~~~~~~

`strings_maps_constants.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_maps_constants.vhdl>`_

Constants for various character sets from the range
of Latin-1 and mappings for upper case, lower case, and basic (unaccented)
characters. It is a clone of the Ada'95 package
Ada.Strings.Maps.Constants.

.. _strings_unbounded:

strings_unbounded
~~~~~~~~~~~~~~~~~

`strings_unbounded.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/strings_unbounded.vhdl>`_

This package provides a string library for operating on unbounded length
strings. This is a clone of the Ada'95 library Ada.Strings.Unbounded. Due
to the VHDL restriction on using access types as function parameters only
a limited subset of the Ada library is reproduced. The unbounded strings
are represented by the subtype string_acc which is derived from line to
ease interoperability with std.textio. line and string_acc are of type
access to string. Their contents are dynamically allocated. Because
operators cannot be provided, a new set of "copy" procedures are included
to simplify duplication of an existing unbounded string.

Miscellaneous
-------------

Additional packages of useful functions.


.. _binaryio:

binaryio
~~~~~~~~

`binaryio.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/binaryio.vhdl>`_

Procedures for general binary file IO. Support is provided for reading and writing vectors of any size
with big and little-endian byte order.

.. _text_buffering:

text_buffering
~~~~~~~~~~~~~~

`text_buffering.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/text_buffering.vhdl>`_

This package provides a facility for storing buffered text. It can be used
to represent the contents of a text file as a linked list of dynamically
allocated strings for each line. A text file can be read into a buffer and
the resulting data structure can be incorporated into records passable
to procedures without having to maintain a separate file handle.


.. _ddfs:

ddfs
~~~~

`ddfs.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/ddfs.vhdl>`_

A set of functions for implementing Direct Digital Frequency Synthesizers.

.. _glitch_filtering:

glitch_filtering
~~~~~~~~~~~~~~~~

`glitch_filtering.vhdl <http://code.google.com/p/vhdl-extras/source/browse/rtl/extras/glitch_filtering.vhdl>`_

Glitch filter components that can be used to remove
noise from digital input signals. This can be useful for debouncing
switches directly connected to a device. The glitch_filter component works
with a single std_ulogic signal while array_glitch_filter provides
filtering for a std_ulogic_vector. These components include synchronizing
flip-flops and can be directly tied to input pads.





