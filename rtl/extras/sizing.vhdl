--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# sizing.vhdl - Functions to compute array sizes
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
--# DEPENDENCIES: none
--#
--# DESCRIPTION:
--#  This package provides functions used to compute integer approximations
--#  of logarithms. The primary use of these functions is to determine the
--#  size of arrays using the bit_size and encoding_size functions. When put to
--#  maximal use it is possible to create designs that eliminate hardcoded
--#  ranges and automatically resize their signals and variables by changing a
--#  few key constants or generics.
--#
--#  These functions can be used in most synthesizers to compute ranges for
--#  arrays. The core functionality is provided in the ceil_log and
--#  floor_log subprograms. These compute the logarithm in any integer base.
--#  For convenenience, base-2 functions are also provided along with the array
--#  sizing functions.
--#
--# EXAMPLE USAGE:
--#  constant MAX_COUNT  : natural := 1000;
--#  constant COUNT_SIZE : natural := bit_size(MAX_COUNT);
--#  signal counter : unsigned(COUNT_SIZE-1 downto 0);
--#  ...
--#  counter <= to_unsigned(MAX_COUNT, COUNT_SIZE);
--#  -- counter will resize itself as MAX_COUNT is changed
--------------------------------------------------------------------

package sizing is
  --## Compute the integer result of the function floor(log(n)).
  --#
  --# Args:
  --#   n: Number to take logarithm of
  --#   b: Base for the logarithm
  --# Returns:
  --#   Approximate logarithm of n rounded down.
  --# Example:
  --#  size := floor_log(20, 2);
  function floor_log(n, b : positive) return natural;

  --## Compute the integer result of the function ceil(log(n)) where b is the base.
  --#
  --# Args:
  --#   n: Number to take logarithm of
  --#   b: Base for the logarithm
  --# Returns:
  --#   Approximate logarithm of n rounded up.
  --# Example:
  --#  size := ceil_log(20, 2);
  function ceil_log(n, b : positive) return natural;


  --## Compute the integer result of the function floor(log2(n)).
  --#
  --# Args:
  --#   n: Number to take logarithm of
  --# Returns:
  --#   Approximate base-2 logarithm of n rounded down.
  function floor_log2(n : positive) return natural;

  --## Compute the integer result of the function ceil(log2(n)).
  --#
  --# Args:
  --#   n: Number to take logarithm of
  --# Returns:
  --#   Approximate base-2 logarithm of n rounded up.
  function ceil_log2(n : positive) return natural;

  --## Compute the total number of bits needed to represent a number in binary.
  --#
  --# Args:
  --#   n: Number to compute size from
  --# Returns:
  --#   Number of bits.
  function bit_size(n : natural) return natural;

  --## Compute the number of bits needed to encode n items.
  --#
  --# Args:
  --#   n: Number to compute size from
  --# Returns:
  --#   Number of bits.
  function encoding_size(n : positive) return natural;

  -- synthesis translate_off
  -- Needed to keep Xilinx ISE 12.1 happy
  alias unsigned_size is bit_size[natural return natural];
  -- synthesis translate_on

  --## Compute the total number of bits to represent a 2's complement signed
  --#  integer in binary.
  --#
  --# Args:
  --#   n: Number to compute size from
  --# Returns:
  --#   Number of bits.
  function signed_size(n : integer) return natural;

end package;


package body sizing is

  --## Compute the integer result of the function floor(log(n)) where b is the base.
  function floor_log(n, b : positive) return natural is
    variable log, residual : natural;
  begin
    residual := n;
    log := 0;

    while residual > (b - 1) loop
      residual := residual / b;
      log := log + 1;
    end loop;

    return log;
  end function;

  --## Compute the integer result of the function ceil(log(n)) where b is the base.
  function ceil_log(n, b : positive) return natural is
    variable log, residual : natural;
  begin

    residual := n - 1;
    log := 0;

    while residual > 0 loop
      residual := residual / b;
      log := log + 1;
    end loop;

    return log;
  end function;


  --## Compute the integer result of the function floor(log2(n)).
  function floor_log2(n : positive) return natural is
  begin
    return floor_log(n, 2);
  end function;

  --## Compute the integer result of the function ceil(log2(n)).
  function ceil_log2(n : positive) return natural is
  begin
    return ceil_log(n, 2);
  end function;


  --## Compute the total number of bits needed to represent a number in binary.
  function bit_size(n : natural) return natural is
  begin
    if n = 0 then
      return 1;
    else
      return floor_log2(n) + 1;
    end if;
  end function;


  --## Compute the number of bits needed to encode n items.
  function encoding_size(n : positive) return natural is
  begin
    if n = 1 then
      return 1;
    else
      return ceil_log2(n);
    end if;
  end function;


  --## Compute the total number of bits to represent a 2's complement signed
  --#  integer in binary.
  function signed_size(n : integer) return natural is
  begin
    if n = 0 then
      return 2; -- sign bit plus single numeric bit
    elsif n > 0 then
      return bit_size(n) + 1;
    else -- n < 0
      return bit_size(-1 - n) + 1;
    end if;
  end function;

end package body;
