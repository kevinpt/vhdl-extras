--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# bcd_conversion.vhdl - Functions for Binary Coded Decimal conversions
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010 Kevin Thibedeau
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
--# DEPENDENCIES: sizing
--#
--# DESCRIPTION:
--#  This package provides functions and components for performing conversion
--#  between binary and packed Binary Coded Decimal (BCD). The functions
--#  to_bcd and to_binary can be used to create synthesizable combinational
--#  logic for performing a conversion. In synthesized code they are best used
--#  with shorter arrays comprising only a few digits. For larger numbers, the
--#  components binary_to_bcd and bcd_to_binary can be used to perform a
--#  conversion over multiple clock cycles. The utility function decimal_size
--#  can be used to determine the number of decimal digits in a BCD array. Its
--#  result must be multiplied by 4 to get the length of a packed BCD array.
--#
--# EXAMPLE USAGE:
--#  signal binary  : unsigned(7 downto 0);
--#  constant DSIZE : natural := decimal_size(2**binary'length - 1);
--#  signal bcd : unsigned(DSIZE*4-1 downto 0);
--#  ...
--#  bcd <= to_bcd(binary);
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bcd_conversion is

  --## Calculate the number of decimal digits needed to represent a number n.
  --# Args:
  --#   n: Value to calculate digits for
  --# Returns:
  --#   Decimal digits for n.
  function decimal_size(n : natural) return natural;

  --%% Conversion functions
  
  --## Convert binary number to BCD encoding
  --#  This uses the double-dabble algorithm to perform the BCD conversion. It
  --#  will operate with any size binary array and return a BCD array whose
  --#  length is 4 times the value returned by the decimal_size function.
  --# Args:
  --#   Binary: Binary encoded value
  --# Returns:
  --#   BCD encoded result.
  function to_bcd(Binary : unsigned) return unsigned;

  --## Convert a BCD number to binary encoding
  --#  This uses the double-dabble algorithm in reverse. The length of the
  --#  input must be a multiple of four. The returned binary array will be
  --#  large enough to hold the maximum decimal value of the BCD input. Its
  --#  length will be bit_size(10**(Bcd'length/4) - 1).
  --# Args:
  --#   Bcd: BCD encoded value
  --# Returns:
  --#   Binary encoded result.
  function to_binary(Bcd : unsigned) return unsigned;

  --%% Components that perform the conversions in synchronous steps

  --# Convert a binary input to BCD encoding. A conversion by asserting ``Convert``.
  --# The ``BCD`` output is valid when the ``Done`` signal goes high.
  --#
  --# This component will operate with any size binary array of 4 bits or larger
  --# and produces a BCD array whose length is 4 times the value returned by the
  --# :vhdl:func:`~bcd_conversion.decimal_size` function.
  --# The conversion of an n-bit binary number will take n cycles to complete.
  
  component binary_to_bcd is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Convert : in std_ulogic;  --# Start conversion when high
      Done    : out std_ulogic; --# Indicates completed conversion

      --# {{data|}}
      Binary : in unsigned; --# Binary data to convert
      BCD    : out unsigned --# Converted output. Retained until next conversion
    );
  end component;
  
  
  --# Convert a BCD encoded input to binary. A conversion by asserting ``Convert``.
  --# The ``Binary`` output is valid when the ``Done`` signal goes high.
  --#
  --# The length of the input must be a multiple of four. The binary array produced will be
  --# large enough to hold the maximum decimal value of the BCD input. Its
  --# length will be ``bit_size(10**(Bcd'length/4) - 1)``. The conversion of a BCD
  --# number to an n-bit binary number will take n+3 cycles to complete.

  component bcd_to_binary is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Convert : in std_ulogic;  --# Start conversion when high
      Done    : out std_ulogic; --# Indicates completed conversion

      --# {{data|}}
      BCD    : in unsigned; --# BCD data to convert
      Binary : out unsigned --# Converted output. Retained until next conversion
    );
  end component;

end package;


library extras;
use extras.sizing.all;

package body bcd_conversion is

  --## Calculate the number of decimal digits needed to represent a number n
  function decimal_size(n : natural) return natural is
  begin
    if n = 0 then
      return 1;
    else
      return floor_log(n, 10) + 1;
    end if;
  end function;


  --## Convert binary number to BCD encoding
  --#  This uses the double-dabble algorithm to perform the BCD conversion. It
  --#  will operate with any size binary array and return a BCD array whose
  --#  length is 4 times the value returned by the decimal_size function.
  function to_bcd(Binary : unsigned) return unsigned is
    variable b : unsigned(Binary'length-1 downto 0) := Binary;

    constant DIGITS : natural := decimal_size(2**Binary'length - 1);
    variable bcd : unsigned(DIGITS*4-1 downto 0) := (others => '0');
  begin

    for i in b'range loop

      -- iterate over each group of 4 bits that comprise a digit
      for d in 0 to DIGITS-1 loop
        if bcd(d*4+3 downto d*4) >= 5 then -- will be 10 to 18 on next shift
          -- add 3 to make it carry over to next digit on next shift
          -- (5+3)*2 = 16 = 2#1_0000#
          bcd(d*4+3 downto d*4) := bcd(d*4+3 downto d*4) + 3;
        end if;
      end loop;

      -- shift left -> multiply by 2
      bcd := bcd(bcd'left-1 downto 0) & b(b'left);
      b := b(b'left-1 downto 0) & '0';

    end loop;

    return bcd;
  end function;


  --## Convert a BCD number to binary encoding
  --#  This uses the double-dabble algorithm in reverse. The length of the
  --#  input must be a multiple of four. The returned binary array will be
  --#  large enough to hold the maximum decimal value of the BCD input. Its
  --#  length will be bit_size(10**(Bcd'length/4) - 1).
  function to_binary(Bcd : unsigned) return unsigned is
    constant DIGITS : natural := Bcd'length / 4;
    constant BITS   : natural := bit_size(10**DIGITS - 1);

    variable bcd_sr : unsigned(Bcd'length-1 downto 0) := Bcd;
    variable binary : unsigned(BITS-1 downto 0);
  begin

    for i in binary'range loop
      -- shift right
      binary := bcd_sr(0) & binary(binary'left downto 1);
      bcd_sr := '0' & bcd_sr(bcd_sr'high downto 1);

      -- dabble the digits
      for d in 0 to DIGITS-1 loop
        if bcd_sr(d*4+3 downto d*4) >= 8 then
          bcd_sr(d*4+3 downto d*4) := bcd_sr(d*4+3 downto d*4) - 3;
        end if;
      end loop;

    end loop;

    return binary;
  end function;

end package body;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;
use extras.bcd_conversion.decimal_size;

--## Convert binary number to BCD encoding
--#  This uses the double-dabble algorithm to perform the BCD conversion. It
--#  will operate with any size binary array of 4 bits or larger and produce a
--#  BCD array whose length is 4 times the value returned by the decimal_size
--#  function. The conversion of an n-bit binary number will take n cycles to
--#  complete.
entity binary_to_bcd is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Convert : in std_ulogic;  -- Start conversion when high
    Done    : out std_ulogic; -- Indicates completed conversion

    Binary : in unsigned; -- Binary data to convert
    BCD    : out unsigned -- Converted output. Retained until next conversion
  );
end entity;

architecture rtl of binary_to_bcd is
    alias b : unsigned(Binary'length-1 downto 0) is Binary;
    signal binary_sr : unsigned(Binary'length-4 downto 0);

    constant DIGITS : natural := decimal_size(2**Binary'length - 1);
    signal bcd_sr   : unsigned(DIGITS*4-1 downto 0);

    signal sr_load, sr_shift : std_ulogic;

    constant MAX_COUNT    : natural := Binary'length - 1 - 3;
    constant COUNTER_SIZE : natural := bit_size(MAX_COUNT);
    signal   bit_count    : unsigned(COUNTER_SIZE-1 downto 0);
    constant INIT_COUNT   : unsigned(COUNTER_SIZE-1 downto 0) :=
      to_unsigned(MAX_COUNT, COUNTER_SIZE);

    signal conversion_complete : std_ulogic;
begin

  sr: process(Clock, Reset)
    variable next_bcd : unsigned(bcd_sr'range);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      bcd_sr <= (others => '0');
      binary_sr <= (others => '0');
    elsif rising_edge(Clock) then
      if sr_load = '1' then
        -- Initialize the shift registers with the upper three binary bits
        -- loaded into the BCD shift reg. This is the first point at which an
        -- adjustment can be made for a decimal carry so the first three shifts
        -- can be skipped to reduce the total conversion time.
        bcd_sr(bcd_sr'high downto 3) <= (others => '0');
        bcd_sr(2 downto 0) <= (b(b'high downto b'high-2));

        binary_sr <= b(b'high-3 downto 0);

      elsif sr_shift = '1' then -- shift left
        -- iterate over each group of 4 bits that comprise a digit
        for d in 0 to DIGITS-1 loop
          if bcd_sr(d*4+3 downto d*4) >= 5 then -- will be 10 to 18 on next shift
            -- add 3 to make it carry over to next digit on next shift
            -- (5+3)*2 = 16 = 2#1_0000#
            next_bcd(d*4+3 downto d*4) := bcd_sr(d*4+3 downto d*4) + 3;
          else
            next_bcd(d*4+3 downto d*4) := bcd_sr(d*4+3 downto d*4);
          end if;
        end loop;

        -- perform the shift
        bcd_sr <= next_bcd(bcd_sr'left-1 downto 0) & binary_sr(binary_sr'left);
        binary_sr <= binary_sr(binary_sr'left-1 downto 0) & '0';
      end if;
    end if;
  end process;

  BCD <= bcd_sr;

  fsm: block
    type state is (IDLE, LOAD_SR, CONVERTING, CONV_DONE);

    signal cur_state : state;
  begin
    s: process(Clock, Reset)
      variable next_state : state;
    begin
      if Reset = RESET_ACTIVE_LEVEL then
        cur_state <= IDLE;
        sr_load <= '0';
        sr_shift <= '0';
        Done <= '0';
      elsif rising_edge(Clock) then
        next_state := cur_state;

        case cur_state is
          when IDLE =>
            if Convert = '1' then
              next_state := LOAD_SR;
            end if;

          when LOAD_SR =>
            next_state := CONVERTING;

          when CONVERTING =>
            if conversion_complete = '1' then
              next_state := CONV_DONE;
            end if;

          when CONV_DONE =>
            if Convert = '1' then
              next_state := LOAD_SR;
            end if;

          when others =>
            next_state := IDLE;
        end case;

        cur_state <= next_state;

        sr_load <= '0';
        sr_shift <= '0';
        Done <= '0';

        case next_state is
          when IDLE =>
            null;

          when LOAD_SR => -- load the shift registers
            sr_load <= '1';

          when CONVERTING => -- shift left each cycle
            sr_shift <= '1';

          when CONV_DONE => -- indicate completion
            Done <= '1';

          when others =>
            null;

        end case;

      end if;
    end process;
  end block;


  bit_counter: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      bit_count <= INIT_COUNT;
    elsif rising_edge(Clock) then
      if sr_shift = '0' then
        bit_count <= INIT_COUNT;
      else
        bit_count <= bit_count - 1;
      end if;
    end if;
  end process;

  conversion_complete <= '1' when bit_count = (bit_count'range => '0') else '0';

end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;

--## Convert a BCD number to binary encoding
--#  This uses the double-dabble algorithm in reverse. The length of the
--#  input must be a multiple of four. The binary array produced will be
--#  large enough to hold the maximum decimal value of the BCD input. Its
--#  length will be bit_size(10**(Bcd'length/4) - 1). The conversion of a BCD
--#  number to an n-bit binary number will take n+3 cycles to complete.
entity bcd_to_binary is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Convert : in std_ulogic;  -- Start conversion when high
    Done    : out std_ulogic; -- Indicates completed conversion

    BCD    : in unsigned; -- BCD data to convert
    Binary : out unsigned -- Converted output. Retained until next conversion
  );
end entity;

architecture rtl of bcd_to_binary is

    constant DIGITS : natural := BCD'length / 4;
    constant BITS   : natural := bit_size(10**DIGITS - 1);

    signal bcd_sr    : unsigned(DIGITS*4-1 downto 0);
    signal binary_sr : unsigned(BITS-1 downto 0);

    signal sr_load, sr_shift : std_ulogic;

    constant MAX_COUNT    : natural := binary_sr'length - 1;
    constant COUNTER_SIZE : natural := bit_size(MAX_COUNT);
    signal   bit_count    : unsigned(COUNTER_SIZE-1 downto 0);
    constant INIT_COUNT   : unsigned(COUNTER_SIZE-1 downto 0) :=
      to_unsigned(MAX_COUNT, COUNTER_SIZE);

    signal conversion_complete : std_ulogic;
begin
  sr: process(Clock, Reset)
    variable next_bcd : unsigned(bcd_sr'range);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      bcd_sr <= (others => '0');
      binary_sr <= (others => '0');
    elsif rising_edge(Clock) then
      if sr_load = '1' then
        bcd_sr <= BCD;
        binary_sr <= (others => '0');
      elsif sr_shift = '1' then
        -- shift right
        binary_sr <= bcd_sr(0) & binary_sr(binary_sr'left downto 1);
        next_bcd := '0' & bcd_sr(bcd_sr'high downto 1);

        -- dabble the digits
        for d in 0 to DIGITS-1 loop
          if next_bcd(d*4+3 downto d*4) >= 8 then
            next_bcd(d*4+3 downto d*4) := next_bcd(d*4+3 downto d*4) - 3;
          end if;
        end loop;

        bcd_sr <= next_bcd;
      end if;
    end if;
  end process;

  Binary <= binary_sr;

  fsm: block
    type state is (IDLE, LOAD_SR, CONVERTING, CONV_DONE);

    signal cur_state : state;
  begin
    s: process(Clock, Reset)
      variable next_state : state;
    begin
      if Reset = RESET_ACTIVE_LEVEL then
        cur_state <= IDLE;
        sr_load <= '0';
        sr_shift <= '0';
        Done <= '0';
      elsif rising_edge(Clock) then
        next_state := cur_state;

        case cur_state is
          when IDLE =>
            if Convert = '1' then
              next_state := LOAD_SR;
            end if;

          when LOAD_SR =>
            next_state := CONVERTING;

          when CONVERTING =>
            if conversion_complete = '1' then
              next_state := CONV_DONE;
            end if;

          when CONV_DONE =>
            if Convert = '1' then
              next_state := LOAD_SR;
            end if;

          when others =>
            next_state := IDLE;
        end case;

        cur_state <= next_state;

        sr_load <= '0';
        sr_shift <= '0';
        Done <= '0';

        case next_state is
          when IDLE =>
            null;

          when LOAD_SR => -- load the shift registers
            sr_load <= '1';

          when CONVERTING => -- shift right each cycle
            sr_shift <= '1';

          when CONV_DONE => -- indicate completion
            Done <= '1';

          when others =>
            null;

        end case;

      end if;
    end process;
  end block;


  bit_counter: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      bit_count <= INIT_COUNT;
    elsif rising_edge(Clock) then
      if sr_shift = '0' then
        bit_count <= INIT_COUNT;
      else
        bit_count <= bit_count - 1;
      end if;
    end if;
  end process;

  conversion_complete <= '1' when bit_count = (bit_count'range => '0') else '0';

end architecture;
