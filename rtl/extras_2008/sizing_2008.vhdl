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
--#  Additionally the package provides functions for vectors resizing with
--#  interfaces which show clearly, how resizing should be performed (extending
--#  or truncating, most significant bits or least significant bits).
--#
--#  This implementation excludes the overload of change_size for resolved
--#  std_logic_vector, because it breaks VHDL-2008 compiler (slv and sulv are
--#  basically the same type in VHDL-2008). Unsigned and signed are replaced here
--#  with their unresolved versions.
--#
--# EXAMPLE USAGE:
--#  constant MAX_COUNT  : natural := 1000;
--#  constant COUNT_SIZE : natural := bit_size(MAX_COUNT);
--#  signal counter : unsigned(COUNT_SIZE-1 downto 0);
--#  ...
--#  counter <= to_unsigned(MAX_COUNT, COUNT_SIZE);
--#  -- counter will resize itself as MAX_COUNT is changed
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
  
  type resize_method is (truncate_LSBs, truncate_MSBs, extend_LSBs, extend_MSBs);
  --## Resizizng function for std_ulogic_vector clearly stating how exactly the 
  --# resizing will be done.
  --#
  --# Args:
  --#   s: Vector to  resize
  --#   new_size: New vector size
  --#   method: Resizizng method
  --#   extension: Bit used for extension
  --# Returns:
  --#   Resized vector.
  function change_size (s : std_ulogic_vector; new_size : positive; method : resize_method;
    extension : std_ulogic := '0' ) return std_ulogic_vector;
    
  --## Resizizng function for unsigned number clearly stating how exactly the 
  --# resizing will be done. Extends numbers with zeros.
  --#
  --# Args:
  --#   s: Vector to  resize
  --#   new_size: New vector size
  --#   method: Resizizng method
  --# Returns:
  --#   Resized number.
  function change_size (s : u_unsigned; new_size : positive; method : resize_method)
    return u_unsigned;
    
  --## Resizizng function for signed number clearly stating how exactly the 
  --# resizing will be done. Extends most significant bits with a sign bit,
  --# and least significant bits with zeros.
  --#
  --# Args:
  --#   s: Vector to  resize
  --#   new_size: New vector size
  --#   method: Resizizng method
  --# Returns:
  --#   Resized number.
  function change_size (s : u_signed; new_size : positive; method : resize_method)
    return u_signed;

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
  
  
  --## Resizizng function for std_ulogic_vector clearly stating how exactly the 
  --# resizing will be done.
  function change_size (s : std_ulogic_vector; new_size : positive; method : resize_method;
      extension : std_ulogic := '0' ) return std_ulogic_vector is
    
    variable v : std_ulogic_vector(new_size-1 downto 0);
  begin
  
    case method is
      when truncate_LSBs =>
        return s( s'high downto (s'length - new_size) );
      when truncate_MSBs =>
        return s(new_size-1 downto 0);
      when extend_LSBs   =>
        v(v'high downto new_size - s'length) := s;
        v(new_size - s'length - 1 downto 0) := (others => extension);
        return v;
      when extend_MSBs   =>
        v(new_size-1 downto s'high+1) := (others => extension);
        v(s'high downto 0) := s;
        return v;
    end case;
  
  end function;
  
  --## Resizizng function for unsigned number clearly stating how exactly the 
  --# resizing will be done. Extends numbers with zeros.
  function change_size (s : u_unsigned; new_size : positive; method : resize_method)
    return u_unsigned is
  begin
    return u_unsigned(
      change_size(std_ulogic_vector(s), new_size, method, '0'));
  end function;
  
  --## Resizizng function for signed number clearly stating how exactly the 
  --# resizing will be done. Extends most significant bits with a sign bit,
  --# and least significant bits with zeros.
  function change_size (s : u_signed; new_size : positive; method : resize_method)
    return u_signed is
  begin
  
    case method is
      when extend_MSBs   =>
        return u_signed(
          change_size(std_ulogic_vector(s), new_size, method, s(s'high)));
      when others =>
        return u_signed(
          change_size(std_ulogic_vector(s), new_size, method, '0'));
    end case;
  
  end function;
    
end package body;
