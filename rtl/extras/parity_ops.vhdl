--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# parity_ops.vhdl - Parity operations
--# $Id:$
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
--#  Functions for calculating and checking parity
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package parity_ops is

  --## Identify the type of parity
  type parity_kind is ( even, odd );

  --## Compute parity.
  --# Args:
  --#   Ptype: Type of parity; odd or even
  --#   Val: Value to generate parity for
  --# Returns:
  --#   Parity bit for Val.
  function parity( Ptype : parity_kind; Val : std_ulogic_vector ) return std_ulogic;

  --## Check parity for an error.
  --# Args:
  --#   Ptype: Type of parity; odd or even
  --#   Val: Value to test parity for
  --#   Parity_bit: Parity bit to check
  --# Returns:
  --#   true if Parity_bit is correct.
  function check_parity( Ptype : parity_kind; Val : std_ulogic_vector;
    Parity_bit : std_ulogic ) return boolean;

end package;

package body parity_ops is

  --## Calculate parity
  function parity( Ptype : parity_kind; Val : std_ulogic_vector) return std_ulogic is
    variable xr : std_ulogic;

    function xor_reduce( Val : std_ulogic_vector ) return std_ulogic is
      variable result : std_ulogic := '0';
    begin
      for i in Val'range loop
        result := result xor Val(i);
      end loop;

      return result;
    end function;

  begin
    xr := xor_reduce(Val);

    if Ptype = even then
      return xr;
    else -- odd
      return not xr;
    end if;
  end function;


  --## Verify parity. Returns true when parity matches, false for a mismatch.
  function check_parity( Ptype : parity_kind; Val : std_ulogic_vector;
    Parity_bit : std_ulogic ) return boolean is
  begin
    return parity(Ptype, Val) = Parity_bit;
  end function;

end package body;
