--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# common_2008.vhdl - Common data types shared across VHDL-2008 components
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
--#  This is a set of common types defining unconstrained arrays of arrays in
--#  VHDL-2008 syntax. This provides a common set of types and conversion
--#  functions that can be used to interoperate between different library
--#  components that need to make use of fully unconstrained types.
--#
--#  Note, that VHDL-2008 introduced new syntax for resolved subtypes, so now
--#  a resolution function for an element type can be applied to an array of
--#  that type. Thanks to this, std_logic_vector in VHDL-2008 is a resolved
--#  subtype of std_ulogic_vector, and not a separate type, as it used to be in
--#  the previous version of the language. Because of this, slv and sulv can be
--#  assigned to each other freely, and no separate function overloads are
--#  required for them now. The same applies to unresolved_signed and signed,
--#  and to unresolved_unsigned and unsigned.
--#  This package uses the same approach. For example, any function here
--#  defined for sulv_array can take slv_array. The same applies to
--#  u_unsigned_array and unsigned_array, and to u_signed_array and
--#  signed_array.
--#
--#  Also note, that the types defined here are closely related (see 9.3.6 in
--#  LRM). So, one can convert between them using regular VHDL type conversion:
--#   constant c : sulv_array := ("000", "010");
--#   signal s : u_signed_array(c'range)(c'element'range);
--#   ...
--#   s <= u_signed_array(c); -- Regular type conversion
--#  However, not every synthesis tool supports it. Because of this, explicit
--#  type conversion functions are defined in this package (to_sulv_array, ...
--#  to_u_unsigned_array, etc.).
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common is

  --## Array of std_ulogic_vector.
  type sulv_array is array(natural range <>) of std_ulogic_vector;

  --## Array of std_logic_vector.
  subtype slv_array is ((resolved)) sulv_array;

  --## Array of unresolved_unsigned.
  type u_unsigned_array is array(natural range <>) of u_unsigned;

  --## Array of unsigned.
  subtype unsigned_array is ((resolved)) u_unsigned_array;

  --## Array of unresolved_signed.
  type u_signed_array   is array(natural range <>) of u_signed;

  --## Array of signed.
  subtype signed_array is ((resolved)) u_signed_array;



  --## Convert std_ulogic_vector array to unresolved_unsigned array.
  --# Args:
  --#  A: Array to convert
  --# Returns:
  --#  Array with new type.
  function to_u_unsigned_array(A : sulv_array) return u_unsigned_array;

  --## Convert unresolved_unsigned array to std_ulogic_vector array.
  --# Args:
  --#  A: Array to convert
  --# Returns:
  --#  Array with new type.
  function to_sulv_array(A : u_unsigned_array) return sulv_array;

  --## Convert unresolved_signed array to unresolved_unsigned array.
  --# Args:
  --#  A: Array to convert
  --# Returns:
  --#  Array with new type.
  function to_u_unsigned_array(A : u_signed_array) return u_unsigned_array;

  --## Convert unresolved_unsigned array to unresolved_signed array.
  --# Args:
  --#  A: Array to convert
  --# Returns:
  --#  Array with new type.
  function to_u_signed_array(A : u_unsigned_array) return u_signed_array;

  --## Convert std_ulogic_vector array to unresolved_signed array.
  --# Args:
  --#  A: Array to convert
  --# Returns:
  --#  Array with new type.
  function to_u_signed_array(A : sulv_array) return u_signed_array;
  
  --## Convert signed array to std_ulogic_vector array.
  --# Args:
  --#  A: Array to convert
  --# Returns:
  --#  Array with new type.
  function to_sulv_array(A : u_signed_array) return sulv_array;

  --## Aliases without u_* prefix for convenience
  alias to_unsigned_array is to_u_unsigned_array[sulv_array     return u_unsigned_array];
  alias to_unsigned_array is to_u_unsigned_array[u_signed_array return u_unsigned_array];

  alias to_slv_array is to_sulv_array[u_unsigned_array return sulv_array];
  alias to_slv_array is to_sulv_array[u_signed_array   return sulv_array];

  alias to_signed_array is to_u_signed_array[u_unsigned_array return u_signed_array];
  alias to_signed_array is to_u_signed_array[sulv_array       return u_signed_array];



  --## Convert a scaler std_ulogic_vector to a single element std_ulogic_vector array.
  --# Args:
  --#  A: Vector
  --# Returns:
  --#  Array with new type.
  function to_sulv_array(A : std_ulogic_vector) return sulv_array;
  
  --## Convert a scaler unresolved_unsigned to a single element unresolved_unsigned array.
  --# Args:
  --#  A: Vector
  --# Returns:
  --#  Array with new type.
  function to_u_unsigned_array(A : u_unsigned) return u_unsigned_array;

  --## Convert a scaler unresolved_signed to a single element unresolved_signed array.
  --# Args:
  --#  A: Vector
  --# Returns:
  --#  Array with new type.  
  function to_u_signed_array(A : u_signed) return u_signed_array;

  --## Aliases without u_* prefix for convenience
  alias to_slv_array is to_sulv_array[std_ulogic_vector return sulv_array];
  alias to_unsigned_array is to_u_unsigned_array[u_unsigned return u_unsigned_array];
  alias to_signed_array is to_u_signed_array[u_signed return u_signed_array];

end package;

package body common is

  function to_u_unsigned_array(a : sulv_array) return u_unsigned_array is
    variable r : u_unsigned_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := u_unsigned(a(i));
    end loop;
    return r;
  end function;

  function to_sulv_array(a : u_unsigned_array) return sulv_array is
    variable r : sulv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := std_ulogic_vector(a(i));
    end loop;
    return r;
  end function;

  function to_u_unsigned_array(a : u_signed_array) return u_unsigned_array is
    variable r : u_unsigned_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := u_unsigned(a(i));
    end loop;
    return r;
  end function;

  function to_u_signed_array(a : u_unsigned_array) return u_signed_array is
    variable r : u_signed_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := u_signed(a(i));
    end loop;
    return r;
  end function;

  function to_u_signed_array(a : sulv_array) return u_signed_array is
    variable r : u_signed_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := u_signed(a(i));
    end loop;
    return r;
  end function;

  function to_sulv_array(a : u_signed_array) return sulv_array is
    variable r : sulv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := std_ulogic_vector(a(i));
    end loop;
    return r;
  end function;



  function to_sulv_array(a : std_ulogic_vector) return sulv_array is
    variable r : sulv_array(0 downto 0)(a'range);
  begin
    r(0) := a;
    return r;
  end function;

  function to_u_unsigned_array(a : u_unsigned) return u_unsigned_array is
    variable r : u_unsigned_array(0 downto 0)(a'range);
  begin
    r(0) := a;
    return r;
  end function;

  function to_u_signed_array(a : u_signed) return u_signed_array is
    variable r : u_signed_array(0 downto 0)(a'range);
  begin
    r(0) := a;
    return r;
  end function;

end package body;
