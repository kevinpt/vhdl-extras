========
reg_file
========

`extras/reg_file.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/reg_file.vhdl>`_

`extras_2008/reg_file_2008.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras_2008/reg_file_2008.vhdl>`_

Dependencies
------------

:doc:`muxing <muxing>`

Description
-----------

This package provides a general purpose register file. This version is
implemented in VHDL-93 syntax and the register width is fixed at 16-bits
by default. This source must be modified to alter the size of the
reg_word type if a register size other than 16-bits is needed. The
implementation in `reg_file_2008 <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras_2008/reg_file_2008.vhdl>`_ uses a generic package to avoid this if
tool support for VHDL-2008 is available.

The register file provides an addressable read write port for external
access as well as a set of signals that allow simultaneous access to
registers for internal logic. The register file has a number of special
behaviors controlled by generics.

``DIRECT_READ_BIT_MASK`` is an array of masks that establish which bits of each
register are read directly from internal signals rather than registered
bits. When set to '1' a bit is accessed from the ``Direct_read`` port input
rather than the register file on a read operation. The masks permit mixing
these bits with registered bits within the same register. Direct-read
register bits can still be written but their contents can't be read back.

``STROBE_BIT_MASK`` is an array of masks that establish which bits of each
register are considered "strobe" bits. Strobe bits are self clearing
when a '1' is written to them. There is no effect when '0' is written. They
are used to initiate control actions from a momentary pulsed signal.

The ``REGISTER_INPUTS`` generic provides optional registration of the
inputs on the external control port.

Synthesis note
~~~~~~~~~~~~~~

This component creates a wide decoder and mux for
accessing the register file from the external control port. Large register
files will see significant combinational delay from these elements and
care should be taken when using this component in high speed designs.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  -- Create a register with 4 16-bit words:
  --    0: strobe bits in bit 0 & 1
  --    1: normal
  --    2: normal
  --    3: direct read in bits 7-0

  library extras; use extras.reg_file_pkg.all;
  use extras.sizing.bit_size;

  constant NUM_REGS : natural := 4;
  subtype my_reg_array is reg_array(0 to NUM_REGS-1);

  constant STROBE_BIT_MASK : my_reg_array := (
     0      => X"0003",
     1 to 3 => (others => '0')
   );

  constant DIRECT_READ_BIT_MASK : my_reg_array := (
     0|1|2  => (others => '0'), -- Alternate selection of elements with |
     3      => X"00FF"
   );

  signal reg_sel : unsigned(bit_size(NUM_REGS)-1 downto 0);
  signal we      : std_ulogic;
  signal wr_data, rd_data : reg_word;
  signal registers, direct_read : my_reg_array;
  signal reg_written : std_ulogic_vector(my_reg_array'range);
  ...

  rf : reg_file
   generic map (
     DIRECT_READ_BIT_MASK => DIRECT_READ_BIT_MASK,
     STROBE_BIT_MASK      => STROBE_BIT_MASK
   )
   port map (
     Clock => clock,
     Reset => reset,

     Clear => '0', -- No need to clear the registers

     Reg_sel => reg_sel,
     We      => we,
     Wr_data => wr_data,
     Rd_data => rd_data,

     Registers   => registers,
     Direct_Read => direct_read,
     Reg_written => reg_written
   );

  ...

  pulse_control <= registers(0)(0); -- Access strobe bit-0

  -- direct_read must be fully assigned (unused parts will optimize away
  -- in synthesis)
  direct_read(0 to 2) <= (others => (others => '0'));
  direct_read(3)(7 downto 0) <= internal_byte; -- Connect internal signal
  direct_read(3)(15 downto 8) <= (others => '0');

    
.. include:: auto/reg_file.rst

VHDL-2008 Variant
-----------------

.. include:: auto/reg_file_2008.rst

