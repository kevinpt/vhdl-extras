--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# muxing.vhdl - Routines for variable size muxes, decoders, and demuxes
--# $Id$
--# Freely available from VHDL-extras (http://code.google.com/p/vhdl-extras)
--#
--# Copyright © 2010 Kevin Thibedeau
--# (kevin 'dot' thibedeau 'at' gmail 'punto' com)
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
--#  A set of routines for creating parameterized multiplexers, decoders,
--#  and demultiplexers
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package muxing is

  --## Decoder with variable sized output (power of 2)
  function decode( Sel : unsigned ) return std_ulogic_vector;

  --## Decoder with variable sized output (user specified)
  function decode( Sel : unsigned; Size : positive)
    return std_ulogic_vector;


  --## Multiplexer with variable sized inputs
  function mux( Inputs : std_ulogic_vector; Sel : unsigned)
    return std_ulogic;

  --## Multiplexer with variable sized inputs using external decoder
  function mux( Inputs      : std_ulogic_vector;
                One_hot_sel : std_ulogic_vector)
    return std_ulogic;


  --## Demultiplexer with variable sized inputs
  function demux( Input : std_ulogic; Sel : unsigned; Size : positive)
    return std_ulogic_vector;

end package;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package body muxing is

  -- ## Decoder with variable sized output (power of 2)
  function decode( Sel : unsigned ) return std_ulogic_vector is

    variable result : std_ulogic_vector(0 to (2 ** Sel'length) - 1);
  begin

    -- generate the one-hot vector from binary encoded Sel
    result := (others => '0');
    result(to_integer(Sel)) := '1';
    return result;
  end function;


  --## Decoder with variable sized output (user specified)
  function decode( Sel : unsigned; Size : positive)
    return std_ulogic_vector is

    variable full_result : std_ulogic_vector(0 to (2 ** Sel'length) - 1);
  begin
    assert Size <= 2 ** Sel'length
      report "Decoder output size: " & integer'image(Size)
        & " is too big for the selection vector"
      severity failure;

    full_result := decode(Sel);
    return full_result(0 to Size-1);
  end function;


  --## Multiplexer with variable sized inputs
  --#  The Inputs vector should have an ascending range to ensure the Sel value
  --#  corresponds to the proper array index.
  function mux( Inputs : std_ulogic_vector; Sel : unsigned )
    return std_ulogic is

    alias inputs_asc : std_ulogic_vector(0 to Inputs'length-1) is Inputs;
    variable pad_inputs : std_ulogic_vector(0 to (2 ** Sel'length) - 1);
    variable result     : std_ulogic;
  begin

    assert inputs_asc'length <= 2 ** Sel'length
      report "Inputs vector size: " & integer'image(Inputs'length)
        & " is too big for the selection vector"
      severity failure;

    pad_inputs := (others => '0');
    pad_inputs(inputs_asc'range) := inputs_asc;
    result := pad_inputs(to_integer(Sel));

    return result;
  end function;


  --## Multiplexer with variable sized inputs using external decoder
  -- Example usage: multiple N-to-1 muxes
  --   one_hot_sel := decode(Sel, N);
  --   mux1 <= mux(Inputs1, one_hot_sel);
  --   ...
  --   muxm <= mux(Inputsm, one_hot_sel);
  function mux( Inputs      : std_ulogic_vector;
                One_hot_sel : std_ulogic_vector)
    return std_ulogic is

    constant SIZE : positive := Inputs'length;

    alias inputs_asc  : std_ulogic_vector(0 to SIZE-1) is Inputs;
    alias one_hot_asc : std_ulogic_vector(0 to SIZE-1) is One_hot_sel;

    variable and_stage : std_ulogic_vector(0 to SIZE-1);

    function or_reduce( v : std_ulogic_vector ) return std_ulogic is
      variable result : std_ulogic := '0';
    begin

      assert One_hot_sel'length = SIZE
        report "One_hot_sel does not match Inputs vector length"
        severity failure;


      for i in v'range loop
        result := result or v(i);
      end loop;

      return result;
    end function;

  begin

    -- perform AND operation
    and_stage := inputs_asc and one_hot_asc;

    -- OR stage
    return or_reduce(and_stage);
  end function;


  --## Demultiplexer with variable sized output (power of 2)
  function demux( Input : std_ulogic; Sel : unsigned )
    return std_ulogic_vector is

    variable result : std_ulogic_vector(0 to (2 ** Sel'length) - 1);
  begin

    -- generate the decoded vector from binary encoded Sel
    result := (others => '0');
    result(to_integer(Sel)) := Input;
    return result;
  end function;


  --## Demultiplexer with variable sized output (user specified)
  function demux( Input : std_ulogic; Sel : unsigned; Size : positive )
    return std_ulogic_vector is

    variable full_result : std_ulogic_vector(0 to (2 ** Sel'length) - 1);
  begin
    assert Size <= 2 ** Sel'length
      report "Demultiplexer output size: " & integer'image(Size)
        & " is too big for the selection vector"
      severity failure;

    full_result := demux(Input, Sel);
    return full_result(0 to Size-1);
  end function;


end package body;
