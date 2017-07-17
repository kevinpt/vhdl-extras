====================
VHDL-extras packages
====================

The following is a summary of the packages provided in VHDL-extras.

Core Packages
-------------

These packages provide core functionality that is of general use in a
wide array of applications.

.. _pipelining:

:doc:`pipelining <modules/pipelining>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: pipelining-pipeline_ul

  component pipeline_ul is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Sig_in : in std_ulogic;
    Sig_out : out std_ulogic
  );
  end component;

|

Configurable pipeline registers for use with automated retiming during synthesis. This provides a variable length chain of registers that can be placed after a section of combinational logic. When your synthesis tool is configured to enable retiming, these registers will be dispersed throughout the combinational logic to reduce the worst case delay. You can tweak the pipeline stages with a simple change in a generic to tune your results.

.. _sizing:

:doc:`sizing <modules/sizing>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


A set of functions for computing integer logarithms and for determining the size of binary numbers and encodings. Generalized functions for computing floor(log(n, b)) and ceil(log(n, b)) for any base b are provided as well as special purpose convenience functions like bit_size and encoding_size. See the :ref:`bcd_conversion` implementation for a practical example of computing integer logs in base-10 using this package.

.. code-block:: vhdl

    constant MAX_COUNT  : natural := 1000;
    constant COUNT_SIZE : natural := bit_size(MAX_COUNT);
    signal counter : unsigned(COUNT_SIZE-1 downto 0);
    ...
    counter <= to_unsigned(MAX_COUNT, COUNT_SIZE);
    -- counter will resize itself as MAX_COUNT is changed

.. _synchronizing:

:doc:`synchronizing <modules/synchronizing>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: synchronising-handshake_synchronizer

  component handshake_synchronizer is
  generic (
    STAGES : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock_tx : in std_ulogic;
    Reset_tx : in std_ulogic;
    Clock_rx : in std_ulogic;
    Reset_rx : in std_ulogic;
    --# {{data|Send port}}
    Tx_data : in std_ulogic_vector;
    Send_data : in std_ulogic;
    Sending : out std_ulogic;
    Data_sent : out std_ulogic;
    --# {{Receive port}}
    Rx_data : out std_ulogic_vector;
    New_data : out std_ulogic
  );
  end component;

|


Synchronizer entities for transferring signals between clock domains. There are three entities provided:

* bit_synchronizer -- Suitable for synchronizing individual bit-wide signals
* reset_synchronizer -- A special synchronizer for generating asyncronous resets that are synchronously released
* handshake_synchronizer -- A synchronizer using the four-phase protocol to transfer vectors between domains

bit_synchronizer and reset_synchronizer have a configurable number of stages with a default of 2.

.. _timing_ops:

:doc:`timing_ops <modules/timing_ops>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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


Arithmetic
----------

These packages implement arithmetic operations.

.. _arithmetic:

:doc:`arithmetic <modules/arithmetic>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

General purpose pipelined adder.


.. _bit_ops:

:doc:`bit_ops <modules/bit_ops>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Bitwise operations.


.. _cordic:

:doc:`cordic <modules/cordic>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CORDIC rotation algorithm with specializations for computing Sine and Cosine.

.. _filtering:

:doc:`filtering <modules/filtering>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Digital filters.


Error handling
--------------

Packages for performing error detection and correction.

.. _crc_ops:

:doc:`crc_ops <modules/crc_ops>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: crc_ops-crc

  component crc is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|CRC configuration}}
    Poly : in std_ulogic_vector;
    Xor_in : in std_ulogic_vector;
    Xor_out : in std_ulogic_vector;
    Reflect_in : in boolean;
    Reflect_out : in boolean;
    Initialize : in std_ulogic;
    --# {{data|}}
    Enable : in std_ulogic;
    Data : in std_ulogic_vector;
    Checksum : out std_ulogic_vector
  );
  end component;

|

This package provides a general purpose CRC implementation. It consists
of a set of functions that can be used to iteratively process successive
data vectors as well an an entity that combines the functions into a
easily instantiated form. The CRC can be readily specified using the Rocksoft
notation described in "A Painless Guide to CRC Error Detection Algorithms",
*Williams 1993*.

A CRC specification consists of the following parameters:

  | Poly       : The generator polynomial
  | Xor_in     : The initialization vector "xored" with an all-'0's shift register
  | Xor_out    : A vector xored with the shift register to produce the final value
  | Reflect_in : Process data bits from left to right (false) or right to left (true)
  | Reflect_out: Determine bit order of final crc result

A CRC can be computed using a set of three functions `init_crc`, `next_crc`, and `end_crc`.
All functions are assigned to a common variable/signal that maintains the shift
register state between successive calls. After initialization with `init_crc`, data
is processed by repeated calls to `next_crc`. The width of the data vector is
unconstrained, allowing you to process bits in chunks of any desired size. Using
a 1-bit array for data is equivalent to a bit-serial CRC implementation. When
all data has been passed through the CRC it is completed with a call to `end_crc` to
produce the final CRC value.

Implementing a CRC without depending on an external generator tool is easy and flexible:

.. code-block:: vhdl

    -- CRC-16-USB
    constant poly        : bit_vector := X"8005";
    constant xor_in      : bit_vector := X"FFFF";
    constant xor_out     : bit_vector := X"FFFF";
    constant reflect_in  : boolean := true;
    constant reflect_out : boolean := true;

    -- Implement CRC-16 with byte-wide inputs:
    subtype word is bit_vector(7 downto 0);
    type word_vec is array( natural range <> ) of word;
    variable data : word_vec(0 to 9);
    variable crc  : bit_vector(poly'range);
    ...
    crc := init_crc(xor_in);
    for i in data'range loop
      crc := next_crc(crc, poly, reflect_in, data(i));
    end loop;
    crc := end_crc(crc, reflect_out, xor_out);

    -- Implement CRC-16 with nibble-wide inputs:
    subtype nibble is bit_vector(3 downto 0);
    type nibble_vec is array( natural range <> ) of nibble;
    variable data : nibble_vec(0 to 9);
    variable crc  : bit_vector(poly'range);
    ...
    crc := init_crc(xor_in);
    for i in data'range loop
      crc := next_crc(crc, poly, reflect_in, data(i));
    end loop;
    crc := end_crc(crc, reflect_out, xor_out);



.. _hamming_edac:

:doc:`hamming_edac <modules/hamming_edac>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A flexible implementation of the Hamming code for any data size of 4-bits or greater.

.. _parity_ops:

:doc:`parity_ops <modules/parity_ops>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Basic parity operations.

.. _secded_edac:

:doc:`secded_edac <modules/secded_edac>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Single Error Correction, Double Error Detection implemented with extended Hamming code.

.. _secded_codec:

:doc:`secded_codec <modules/secded_codec>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


.. symbolator::
  :name: secded_codec-secded_codec

  component secded_codec is
  generic (
    DATA_SIZE : positive;
    PIPELINE_STAGES : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Codec_mode : in std_ulogic;
    Insert_error : in std_ulogic_vector(1 downto 0);
    --# {{data|Encoding port}}
    Data : in std_ulogic_vector(DATA_SIZE-1 downto 0);
    Encoded_data : out ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right);
    --# {{Decoding port}}
    Ecc_data : in ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right);
    Decoded_data : out std_ulogic_vector(DATA_SIZE-1 downto 0);
    --# {{Error flags}}
    Single_bit_error : out std_ulogic;
    Double_bit_error : out std_ulogic
  );
  end component;

|


An entity providing a combined SECDED encoder and decoder with added error injection for system verification. Optional pipelining is provided.

Encoding
--------

Packages for encoding data into alternate forms.

.. _bcd_conversion:

:doc:`bcd_conversion <modules/bcd_conversion>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: bcd_conversion-binary_to_bcd

  component binary_to_bcd is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Convert : in std_ulogic;
    Done : out std_ulogic;
    --# {{data|}}
    Binary : in unsigned;
    BCD : out unsigned
  );
  end component;

|

This package provides functions and components for performing conversion
between binary and packed Binary Coded Decimal (BCD). The functions
to_bcd and to_binary can be used to create synthesizable combinational
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

:doc:`gray_code <modules/gray_code>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: gray_code-gray_counter

  component gray_counter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Load : in std_ulogic;
    Enable : in std_ulogic;
    --# {{data|}}
    Binary_load : in unsigned;
    Binary : out unsigned;
    Gray : out unsigned
  );
  end component;

|

This package provides functions to convert between Gray code and binary. An example
implementation of a Gray code counter is also included.

.. code-block:: vhdl

  signal bin, gray, bin2 : std_ulogic_vector(7 downto 0);
  ...
  bin  <= X"C5";
  gray <= to_gray(bin);
  bin2 <= to_binary(gray);


.. _muxing:

:doc:`muxing <modules/muxing>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Parameterized multiplexers, decoders, and demultiplexers. A VHDL-2008 variant is available that
implements a fully generic multi-bit mux.

.. code-block:: vhdl

    signal sel : unsigned(3 downto 0);
    signal d, data : std_ulogic_vector(0 to 2**sel'length-1);
    signal d2  : std_ulogic_vector(0 to 10);
    signal m   : std_ulogic;
    ...
    d <= decode(sel);             -- Full binary decode
    d2 <= decode(sel, d2'length); -- Partial decode

    m <= mux(data, sel);          -- Mux with internal decoder
    m <= mux(data, d);            -- Mux with external decoder

    -- Demultiplex
    d2 <= demux(m, sel, d2'length);


    -- Muxing multi-bit inputs with VHDL-2008:
    library extras_2008; use extras_2008.common.sulv_array;
    signal data : sulv_array(0 to 3)(7 downto 0);
    signal sel  : unsigned(1 downto 0);
    signal m    : std_ulogic_vector(7 downto 0);

    m <= mux(data, sel);

Memories
--------

Packages with internal memories


.. _fifos:

:doc:`fifos <modules/fifos>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: fifos-fifo

  component fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    --# {{data|Write port}}
    Wr_clock : in std_ulogic;
    Wr_reset : in std_ulogic;
    We : in std_ulogic;
    Wr_data : in std_ulogic_vector;
    --# {{Read port}}
    Rd_clock : in std_ulogic;
    Rd_reset : in std_ulogic;
    Re : in std_ulogic;
    Rd_data : out std_ulogic_vector;
    --# {{Status}}
    Empty : out std_ulogic;
    Full : out std_ulogic;
    Almost_empty_thresh : in natural;
    Almost_full_thresh : in natural;
    Almost_empty : out std_ulogic;
    Almost_full : out std_ulogic
  );
  end component;

|


This package implements a set of generic FIFO components. There are three
variants. All use the same basic interface for the read/write ports and
status flags. The FIFOs have the following differences:


* simple_fifo -- Basic minimal FIFO for use in a single clock domain. This component lacks the synchronizing logic needed for the other two FIFOs and will synthesize more compactly.
* fifo        -- General FIFO with separate domains for read and write ports.
* packet_fifo -- Extension of fifo component with ability to discard written data before it is read. Useful for managing packetized protocols with error detection at the end.

.. _memory:

:doc:`memory <modules/memory>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: memory-dual_port_ram

  component dual_port_ram is
  generic (
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    --# {{data|Write port}}
    Wr_clock : in std_ulogic;
    We : in std_ulogic;
    Wr_addr : in natural;
    Wr_data : in std_ulogic_vector;
    --# {{Read port}}
    Rd_clock : in std_ulogic;
    Re : in std_ulogic;
    Rd_addr : in natural;
    Rd_data : out std_ulogic_vector
  );
  end component;

|

This package provides general purpose components for inferred dual-ported RAM and ROM.

.. _reg_file:

:doc:`reg_file <modules/reg_file>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: reg_file-reg_file

  component reg_file is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    DIRECT_READ_BIT_MASK : reg_array;
    STROBE_BIT_MASK : reg_array;
    REGISTER_INPUTS : boolean
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Clear : in std_ulogic;
    --# {{data|Addressed port}}
    Reg_sel : in unsigned;
    We : in std_ulogic;
    Wr_data : in reg_word;
    Rd_data : out reg_word;
    --# {{Registers}}
    Registers : out reg_array;
    Direct_read : in reg_array;
    Reg_written : out std_ulogic_vector
  );
  end component;

|


This is an implementation of a general purpose register file. The VHDL-93 version must be manually customized to set the size of the registers internally. The VHDL-2008 version is fully generic by employing an unconstrained array of unconstrained arrays to implement the registers. In addition to simple read/write registers you can configure individual bits to act as self clearing strobes when written and to read back directly from internal signals rather than from the register contents.

Randomization
-------------

These packages provide linear feedback shift registers and related
structures for creating randomized output.

.. _lcar_ops:

:doc:`lcar_ops <modules/lcar_ops>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: lcar_ops-wolfram_lcar

  component wolfram_lcar is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    --# {{control|}}
    Rule_map : in std_ulogic_vector;
    --# {{data|}}
    Left_in : in std_ulogic;
    Right_in : in std_ulogic;
    State : out std_ulogic_vector
  );
  end component;

|

An implementation of the Wolfram Linear Cellular Automata. This is useful for generating pseudo-random numbers with low correlation between bits. Adaptable to any number of cells. Constants are provided for
maximal length sequences of up to 100 bits.

.. _lfsr_ops:

:doc:`lfsr_ops <modules/lfsr_ops>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: lfsr_ops-fibonacci_lfsr

  component fibonacci_lfsr is
  generic (
    INIT_ZERO : boolean;
    FULL_CYCLE : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    --# {{control|}}
    Tap_map : in std_ulogic_vector;
    --# {{data|}}
    State : out std_ulogic_vector
  );
  end component;

|

Various implementations of Galois and Fibonacci Linear Feedback Shift Registers. These adapt to any size register. Coefficients are provided for maximal length sequences up to 100 bits.

.. _random:

:doc:`random <modules/random>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This package provides a general set of pseudo-random number functions.
It is implemented as a wrapper around the ieee.math_real.uniform
procedure and is only suitable for simulation not synthesis. See the
LCAR and LFSR packages for synthesizable random generators.

This package makes use of shared variables to keep track of the PRNG
state more conveniently than calling uniform directly. Because
VHDL-2002 broke forward compatibility of shared variables there are
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

:doc:`characters_handling <modules/characters_handling>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is a package of functions that replicate the behavior of the Ada
standard library package ada.characters.handling. Included are functions
to test for different character classifications and perform conversion
of characters and strings to upper and lower case.

.. characters_latin_1:

:doc:`characters_latin_1 <modules/characters_latin_1>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This package provides Latin-1 character constants. These constants are
adapted from the definitions in the Ada'95 ARM for the package
Ada.Characters.Latin_1.

.. _strings:

:doc:`strings <modules/strings>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Shared types for the string packages.

.. _strings_fixed:

:doc:`strings_fixed <modules/strings_fixed>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This package provides a string library for operating on fixed length
strings. This is a clone of the Ada'95 library ``Ada.Strings.Fixed``. It is a
nearly complete implementation with only the procedures taking character
mapping functions omitted because of VHDL limitations.

.. _strings_maps:

:doc:`strings_maps <modules/strings_maps>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This package provides types and functions for manipulating character sets.
It is a clone of the Ada'95 package ``Ada.Strings.Maps``.

.. _strings_maps_constants:

:doc:`strings_maps_constants <modules/strings_maps_constants>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Constants for various character sets from the range
of Latin-1 and mappings for upper case, lower case, and basic (unaccented)
characters. It is a clone of the Ada'95 package
``Ada.Strings.Maps.Constants``.

.. _strings_unbounded:

:doc:`strings_unbounded <modules/strings_unbounded>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This package provides a string library for operating on unbounded length
strings. This is a clone of the Ada'95 library ``Ada.Strings.Unbounded``. Due
to the VHDL restriction on using access types as function parameters only
a limited subset of the Ada library is reproduced. The unbounded strings
are represented by the subtype string_acc which is derived from line to
ease interoperability with std.textio. line and string_acc are of type
access to string. Their contents are dynamically allocated. Because
operators cannot be provided, a new set of "copy" procedures are included
to simplify duplication of an existing unbounded string.

.. _strings_bounded:

:doc:`strings_bounded <modules/strings_bounded>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This package is a string library for bounded length strings. It is a clone of the Ada'95 library ``Ada.Strings.Bounded``.


Miscellaneous
-------------

Additional packages of useful functions.


.. _binaryio:

:doc:`binaryio <modules/binaryio>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Procedures for general binary file IO. Support is provided for reading and writing vectors of any size
with big and little-endian byte order.

.. _interrupt_ctl:

:doc:`interrupt_ctl <modules/interrupt_ctl>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

General purpose priority interrupt controller.

.. _text_buffering:

:doc:`text_buffering <modules/text_buffering>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This package provides a facility for storing buffered text. It can be used
to represent the contents of a text file as a linked list of dynamically
allocated strings for each line. A text file can be read into a buffer and
the resulting data structure can be incorporated into records passable
to procedures without having to maintain a separate file handle.


.. _ddfs:

:doc:`ddfs <modules/ddfs>`
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: ddfs-ddfs

  component ddfs is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Increment : in unsigned;
    --# {{data|}}
    Accumulator : out unsigned;
    Synth_clock : out std_ulogic;
    Synth_pulse : out std_ulogic
  );
  end component;

|

A set of functions for implementing Direct Digital Frequency Synthesizers.

.. _glitch_filtering:

:doc:`glitch_filtering <modules/glitch_filtering>`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: glitch_filtering-glitch_filter

  component glitch_filter is
  generic (
    FILTER_CYCLES : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Noisy : in std_ulogic;
    Filtered : out std_ulogic
  );
  end component;

|

Glitch filter components that can be used to remove
noise from digital input signals. This can be useful for debouncing
switches directly connected to a device. The glitch_filter component works
with a single std_ulogic signal while array_glitch_filter provides
filtering for a std_ulogic_vector. These components include synchronizing
flip-flops and can be directly tied to input pads.





