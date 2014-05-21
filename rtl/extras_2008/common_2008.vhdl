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
--# $Id$
--# Freely available from VHDL-extras (http://code.google.com/p/vhdl-extras)
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
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common is

  type sulv_array is array(natural range <>) of std_ulogic_vector;
  type slv_array  is array(natural range <>) of std_logic_vector;

  type unsigned_array is array(natural range <>) of unsigned;
  type signed_array   is array(natural range <>) of signed;


  function to_slv_array(a : sulv_array) return slv_array;
  function to_sulv_array(a : slv_array) return sulv_array;

  function to_unsigned_array(a : sulv_array) return unsigned_array;
  function to_sulv_array(a : unsigned_array) return sulv_array;

  function to_signed_array(a : sulv_array) return signed_array;
  function to_sulv_array(a : signed_array) return sulv_array;


  function to_unsigned_array(a : slv_array) return unsigned_array;
  function to_slv_array(a : unsigned_array) return slv_array;

  function to_signed_array(a : slv_array) return signed_array;
  function to_slv_array(a : signed_array) return slv_array;

  function to_signed_array(a : unsigned_array) return signed_array;
  function to_unsigned_array(a : signed_array) return unsigned_array;

end package;

package body common is

  function to_slv_array(a : sulv_array) return slv_array is
    variable r : slv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := a(i);
    end loop;
    return r;
  end function;

  function to_sulv_array(a : slv_array) return sulv_array is
    variable r : sulv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := a(i);
    end loop;
    return r;
  end function;



  function to_unsigned_array(a : sulv_array) return unsigned_array is
    variable r : unsigned_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := unsigned(a(i));
    end loop;
    return r;
  end function;

  function to_sulv_array(a : unsigned_array) return sulv_array is
    variable r : sulv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := std_ulogic_vector(a(i));
    end loop;
    return r;
  end function;



  function to_signed_array(a : sulv_array) return signed_array is
    variable r : signed_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := signed(a(i));
    end loop;
    return r;
  end function;

  function to_sulv_array(a : signed_array) return sulv_array is
    variable r : sulv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := std_ulogic_vector(a(i));
    end loop;
    return r;
  end function;



  function to_unsigned_array(a : slv_array) return unsigned_array is
    variable r : unsigned_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := unsigned(a(i));
    end loop;
    return r;
  end function;

  function to_slv_array(a : unsigned_array) return slv_array is
    variable r : slv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := std_logic_vector(a(i));
    end loop;
    return r;
  end function;



  function to_signed_array(a : slv_array) return signed_array is
    variable r : signed_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := signed(a(i));
    end loop;
    return r;
  end function;

  function to_slv_array(a : signed_array) return slv_array is
    variable r : slv_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := std_logic_vector(a(i));
    end loop;
    return r;
  end function;



  function to_signed_array(a : unsigned_array) return signed_array is
    variable r : signed_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := signed(a(i));
    end loop;
    return r;
  end function;

  function to_unsigned_array(a : signed_array) return unsigned_array is
    variable r : unsigned_array(a'range)(a'element'range);
  begin
    for i in a'range loop
      r(i) := unsigned(a(i));
    end loop;
    return r;
  end function;


end package body;


