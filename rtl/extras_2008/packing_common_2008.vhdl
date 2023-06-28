--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# packing_common_2008.vhdl - Pack arrays into sulv and unpack them back
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010, 2017 Kevin Thibedeau
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
--# DEPENDENCIES: common_2008
--#
--# DESCRIPTION:
--#  This package provides functions allowing one to convert an array into a
--#  single std_ulogic_vector. It may be convinient, for example, when
--#  interoperating with code written in Verilog or SystemVerilog, IP cores or
--#  other libraries.
--#
--#  The functions pack elements of an array with higher number into left
--#  bits of the resulting sulv. For instance, if one wants to pack
--#  an array of type sulv_array(0 to 2)(1 downto 0), element 0 will be
--#  packed into bits 1..0, element 1 - into bits 3..2, and element 2 - into
--#  bits 5..4. The same rule applies to unpacking. For example, if one unpacks
--#  std_ulogic_vector(0 to 5), bits 4..5 will be unpacked into element 0, bits
--#  2..3 - into element 1, and bits 0..1 - into element 2.
--#  As one can see from the examples, to_sulv always returns a sulv with
--#  descending bits direction (downto), but from_sulv works with vectors of
--#  any direction.
--# 
--#  Functions presented here are defined for unresolved arrays types only.
--#  However, due to the fact that common package defines arrays with resolved
--#  elements types as subtypes of arrays with unresolved elements types, you
--#  can use functions from this package for any type of array defined in
--#  common package without explicit type conversions.
--#  Also remember, that std_logic_vector is a subtype of std_ulogic_vector. So
--#  you can safely put sulv's resulted from this package into slv's, or to
--#  pass into function defined here slv's instead of sulv's.

--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras_2008;
use extras_2008.common.all;

package packing_common is

  --## Pack an std_ulogic_vector array into a single std_ulogic_vector.
  --#
  --# Args:
  --#   a: Array to be packed.
  --# Returns:
  --#   Vector with array bits.
  function to_sulv(a : sulv_array) return std_ulogic_vector;

  --## Pack an unsigned array into a single std_ulogic_vector.
  --#
  --# Args:
  --#   a: Array to be packed.
  --# Returns:
  --#   Vector with array bits.
  function to_sulv(a : u_unsigned_array) return std_ulogic_vector;

  --## Pack a signed array into a single std_ulogic_vector.
  --#
  --# Args:
  --#   a: Array to be packed.
  --# Returns:
  --#   Vector with array bits.
  function to_sulv(a : u_signed_array) return std_ulogic_vector;


  --## Unpack an std_ulogic_vector array from a signle std_ulogic_vector.
  --#
  --# Args:
  --#   s: Vector to be unpacked
  --#   n: Number of array elements in the vector
  --# Returns:
  --#   Unpacked array.
  function from_sulv(s : std_ulogic_vector;
                     n : positive) return sulv_array;

  --## Unpack an unsigned array from a signle std_ulogic_vector.
  --#
  --# Args:
  --#   s: Vector to be unpacked
  --#   n: Number of array elements in the vector
  --# Returns:
  --#   Unpacked array.
  function from_sulv(s : std_ulogic_vector;
                     n : positive) return u_unsigned_array;

  --## Unpack a signed array from a signle std_ulogic_vector.
  --#
  --# Args:
  --#   s: Vector to be unpacked
  --#   n: Number of array elements in the vector
  --# Returns:
  --#   Unpacked array.
  function from_sulv(s : std_ulogic_vector;
                     n : positive) return u_signed_array;

  --## Compute the size of a packed std_ulogic_vector array.
  --#
  --# Args:
  --#   a: Array to be packed.
  --# Returns:
  --#   Number of bits in a vector yielded by the packing function.
  function packed_length(a : sulv_array) return natural;

  --## Compute the size of a packed unsigned array.
  --#
  --# Args:
  --#   a: Array to be packed.
  --# Returns:
  --#   Number of bits in a vector yielded by the packing function.
  function packed_length(a : u_unsigned_array) return natural;

  --## Compute the size of a packed signed array.
  --#
  --# Args:
  --#   a: Array to be packed.
  --# Returns:
  --#   Number of bits in a vector yielded by the packing function.
  function packed_length(a : u_signed_array) return natural;

end package;

package body packing_common is

  function packed_length(a : sulv_array) return natural is
  begin
    return (a'length)*(a'element'length);
  end function;

  function to_sulv(a : sulv_array) return std_ulogic_vector is
    constant ELEM_LENGTH : natural := a'element'length;
    constant PCKD_LENGTH : natural := packed_length(a);
    variable sulv : std_ulogic_vector(PCKD_LENGTH-1 downto 0);
  begin
    for i in a'range loop
      sulv((i+1)*ELEM_LENGTH-1 downto i*ELEM_LENGTH) := a(i);
    end loop;
    return sulv;
  end function;

  function from_sulv(s : std_ulogic_vector;
                     n : positive) return sulv_array is
    constant ELEM_LENGTH : natural := s'length/n;
    variable a : sulv_array(0 to n-1)(ELEM_LENGTH-1 downto 0);
  begin
    for i in a'range loop
      if s'ascending then
        a(i) := s(s'right - (i+1)*ELEM_LENGTH+1 to s'right - i*ELEM_LENGTH);
      else
        a(i) := s(s'right + (i+1)*ELEM_LENGTH-1 downto s'right + i*ELEM_LENGTH);
      end if;
    end loop;
    return a;
  end function;


  function packed_length(a : u_unsigned_array) return natural is
  begin
    return packed_length(to_sulv_array(a));
  end function;

  function packed_length(a : u_signed_array) return natural is
  begin
    return packed_length(to_sulv_array(a));
  end function;


  function to_sulv(a : u_unsigned_array) return std_ulogic_vector is
  begin
    return to_sulv(to_sulv_array(a));
  end function;

  function to_sulv(a : u_signed_array) return std_ulogic_vector is
  begin
    return to_sulv(to_sulv_array(a));
  end function;

  function from_sulv(s : std_ulogic_vector;
                     n : positive) return u_unsigned_array is
    constant a : sulv_array := from_sulv(s,n);
  begin
    return to_u_unsigned_array(a);
  end function;

  function from_sulv(s : std_ulogic_vector;
                     n : positive) return u_signed_array is
    constant a : sulv_array := from_sulv(s,n);
  begin
    return to_u_signed_array(a);
  end function;

end package body;
