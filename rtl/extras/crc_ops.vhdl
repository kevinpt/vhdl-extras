--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# crc_ops.vhdl - CRC generation
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2014 Kevin Thibedeau
--# (kevin 'period' thibedeau 'at' gmail 'punto' com)
--#
--# Permission is hereby granted, free of charge, to any person obtaining a
--# copy of this software and associated documentation files (the "Software"),
--# to deal in the Software without restriction, including without limitation
--# the rights to use, copy, modify, merge, publish, distribute, sublicense,
--# and/or sell copies of the Software, and to permit persons to whom the
--# Software is furnished to do so, subject to the following conditions:
--#
--# The above copyright notice and this permission notice shall be included in
--# all copies or substantial portions of the Software.
--#
--# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--# DEALINGS IN THE SOFTWARE.
--#
--# DEPENDENCIES: none
--#
--# DESCRIPTION:
--#  This package provides a general purpose CRC implementation. It consists
--#  of a set of functions that can be used to iteratively process successive
--#  data vectors as well an an entity that combines the functions into a
--#  synthesizable form. The CRC can be readily specified using the Rocksoft
--#  notation described in "A Painless Guide to CRC Error Detection Algorithms",
--#  Williams 1993. A CRC specification consists of the following parameters:
--#
--#    Poly       : The generator polynomial
--#    Xor_in     : The initialization vector "xored" with an all-'0's shift register
--#    Xor_out    : A vector xored with the shift register to produce the final value
--#    Reflect_in : Process data bits from left to right (false) or right to left (true)
--#    Reflect_out: Determine bit order of final crc result
--#
--#  A CRC can be computed using a set of three functions init_crc, next_crc, and end_crc.
--#  All functions are assigned to a common variable/signal that maintans the shift
--#  register state between succesive calls. After initialization with init_crc, data
--#  is processed by repeated calls to next_crc. The width of the data vector is
--#  unconstrained allowing you to process bits in chunks of any desired size. Using
--#  a 1-bit array for data is equivalent to a bit-serial CRC implementation. When
--#  all data has been passed through the CRC it is completed with a call to end_crc to
--#  produce the final CRC value.
--#
--#  EXAMPLE USAGE:
--#    -- CRC-16-USB
--#    constant poly        : bit_vector := X"8005";
--#    constant xor_in      : bit_vector := X"FFFF";
--#    constant xor_out     : bit_vector := X"FFFF";
--#    constant reflect_in  : boolean := true;
--#    constant reflect_out : boolean := true;
--#
--#    subtype word is bit_vector(7 downto 0);
--#    type word_vec is array( natural range <> ) of word;
--#    variable data : word_vec(0 to 9);
--#    variable crc : bit_vector(poly'range);
--#    ...
--#    crc := init_crc(xor_in);
--#    for i in data'range loop
--#      crc := next_crc(crc, poly, reflect_in, data(i));
--#    end loop;
--#    crc := end_crc(crc, reflect_out, xor_out);
--#
--#  A synthesizable component is provided to serve as a guide to using these
--#  functions in practical designs. The input data port has been left unconstrained
--#  to allow variable sized data to be fed into the CRC. Limiting its width to
--#  1-bit will result in a bit-serial implementation. The synthesized logic will be
--#  minimized if all of the CRC configuration parameters are constants.
--#
--#    signal nibble   : std_ulogic_vector(3 downto 0); -- Process 4-bits at a time
--#    signal checksum : std_ulogic_vector(15 downto 0);
--#    ...
--#    crc_16: crc
--#      port map (
--#        Clock => clock,
--#        Reset => reset,
--#
--#        -- CRC configuration parameters
--#        Poly        => poly,
--#        Xor_in      => xor_in,
--#        Xor_out     => xor_out,
--#        Reflect_in  => reflect_in,
--#        Reflect_out => reflect_out,
--#    
--#        Initialize => crc_init, -- Resets CRC register with init_crc function
--#        Enable     => crc_en,   -- Process next nibble
--#    
--#        Data     => nibble,
--#        Checksum => checksum
--#      );    
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package crc_ops is

  --## Initialize CRC state.
  --# Args:
  --#   Xor_in: Apply XOR to initial '0' state
  --# Returns:
  --#   New state of CRC.
  function init_crc(Xor_in : bit_vector) return bit_vector;

  --## Add new data to the CRC.
  --# Args:
  --#   Crc:        Current CRC state
  --#   Poly:       Polynomial for the CRC
  --#   Reflect_in: Reverse bits of Data when true
  --#   Data:       Next data word to add to CRC
  --# Returns:
  --#   New state of CRC.
  function next_crc(Crc : bit_vector; Poly : bit_vector; Reflect_in : boolean;
    Data : bit_vector) return bit_vector;

  --## Finalize the CRC.
  --# Args:
  --#  Crc:         Current CRC state
  --#  Reflect_out: Reverse bits of result when true
  --#  Xor_out:     Apply XOR to final state (inversion)
  --# Returns:
  --#  Final CRC value
  function end_crc(Crc : bit_vector; Reflect_out: boolean; Xor_out : bit_vector)
    return bit_vector;


  --## Calculate a CRC sequentially.
  component crc is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|CRC configuration}}
      Poly        : in std_ulogic_vector; --# Polynomial
      Xor_in      : in std_ulogic_vector; --# Invert (XOR) initial state
      Xor_out     : in std_ulogic_vector; --# Invert (XOR) final state
      Reflect_in  : in boolean;           --# Swap input bit order
      Reflect_out : in boolean;           --# Swap output bit order

      Initialize : in std_ulogic;      --# Reset the CRC state

      --# {{data|}}
      Enable   : in std_ulogic;        --# Indicates data is valid for next CRC update
      Data     : in std_ulogic_vector; --# New data (can be any width needed)
      Checksum : out std_ulogic_vector --# Computed CRC
    );
  end component;

end package;

package body crc_ops is

-- PRIVATE:
-- ========

  --// Reverse the bits in a vector
  function reversed(v: in bit_vector) return bit_vector is
    variable result: bit_vector(v'range);
    alias vr: bit_vector(v'reverse_range) is v;
  begin
    for i in vr'range loop
      result(i) := vr(i);
    end loop;
    return result;
  end function;


-- PUBLIC:
-- =======

  --## Initialize CRC state.
  --# Args:
  --#   Xor_in: Apply XOR to initial '0' state
  --# Returns:
  --#   New state of CRC.
  function init_crc(Xor_in : bit_vector) return bit_vector is
  begin
    return Xor_in;
  end function;

  --## Add new data to the CRC
  function next_crc(Crc : bit_vector; Poly : bit_vector; Reflect_in : boolean;
    Data : bit_vector) return bit_vector is
    variable sreg : bit_vector(Crc'length-1 downto 0) := Crc;
    variable leftbit : bit;
    variable d : bit_vector(Data'range) := Data;
  begin
    assert Crc'length = Poly'length report "Mismatched Polynomial and CRC state size" severity failure;

    if Reflect_in then
      d := reversed(d);
    end if;

    for b in d'range loop
      leftbit := sreg(sreg'left);
      sreg := sreg(sreg'left-1 downto 0) & '0';
      if d(b) /= leftbit then
        sreg := sreg xor Poly;
      end if;
    end loop;

    return sreg;
  end function;

  --## Finalize the CRC
  function end_crc(Crc : bit_vector; Reflect_out: boolean; Xor_out : bit_vector)
    return bit_vector is
    variable sreg : bit_vector(Crc'length-1 downto 0) := Crc;
  begin
    assert Crc'length = Xor_out'length report "Mismatched XOR and CRC state size" severity failure;

    if Reflect_out then
      sreg := reversed(sreg);
    end if;

    sreg := sreg xor Xor_out;

    return sreg;
  end function;

end package body;


library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.crc_ops.all;

entity crc is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    -- CRC configuration parameters
    Poly        : in std_ulogic_vector;
    Xor_in      : in std_ulogic_vector;
    Xor_out     : in std_ulogic_vector;
    Reflect_in  : in boolean;
    Reflect_out : in boolean;

    Initialize : in std_ulogic;      -- Reset the CRC state

    Enable   : in std_ulogic;        -- Indicates data is valid for next CRC update
    Data     : in std_ulogic_vector; -- New data (can be any width needed)
    Checksum : out std_ulogic_vector -- Computed CRC
  );
end entity;


architecture rtl of crc is
  signal crc_reg : bit_vector(Poly'range);
begin

  r: process(Clock, Reset) is
    variable crc_reg_v : bit_vector(crc_reg'range);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      crc_reg <= (others => '0');
      Checksum <= (Checksum'range => '0');
    elsif rising_edge(Clock) then
      crc_reg_v := crc_reg;
      if Initialize = '1' then
        crc_reg_v := init_crc(to_bitvector(Xor_in));
      elsif Enable = '1' then
        crc_reg_v := next_crc(crc_reg, to_bitvector(Poly), Reflect_in, to_bitvector(Data));
      end if;
      crc_reg <= crc_reg_v;
      Checksum <= to_stdulogicvector(end_crc(crc_reg_v, Reflect_out, to_bitvector(Xor_out)));
    end if;
  end process;

end architecture;
