--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# secded_edac.vhdl - Synthesizable functions for SECDED error correction
--# $Id$
--# Freely available from VHDL-extras (http://vhdl-extras.org)
--#
--# Copyright © 2010 Kevin Thibedeau
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
--# DEPENDENCIES: sizing hamming_edac parity_ops
--#
--# DESCRIPTION:
--#  This package implements Single Error Correction, Double Error Detection
--#  (SECDED) by extending the Hamming code with an extra overall parity bit.
--#  It is built on top of the functions implemented in hamming_edac.vhdl.
--#  The ecc_vector is extended with an additional parity bit to the right of
--#  the Hamming parity as shown below.
--#
--#  SECDED ecc_vector layout:
--#                               MSb            LSb
--#    [(data'length - 1) <-> 0] [-1 <-> -(parity_size - 1)] [-parity_size]
--#              data               Hamming parity          SECDED parity bit
--#
--#  EXAMPLE USAGE:
--#    signal word, corrected_word : std_ulogic_vector(15 downto 0);
--#    constant WORD_MSG_SIZE : positive := secded_message_size(word'length);
--#    signal secded_word :
--#      ecc_vector(word'high downto -secded_parity_size(WORD_MSG_SIZE));
--#    ...
--#    secded_word <= secded_encode(word, WORD_MSG_SIZE);
--#    ... <SEU or transmission error flips a bit>
--#    corrected_word <= secded_decode(hamming_word);
--#    errors := secded_has_errors(secded_word);
--#    if errors(single_bit) or errors(double_bit) then ... -- check for error
--#
--#  As with hamming_edac, it is possible to share logic between the decoder
--#  and error checker and also between an encoder and decoder that don't
--#  operate simultaneously. Refer to hamming_edac.vhdl and secded_codec.vhdl
--#  for examples of this approach.
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.hamming_edac.all;

package secded_edac is
  type secded_error_kind is (single_bit, double_bit);
  type secded_errors is array( secded_error_kind ) of boolean;

  --## Functions to determine array sizes
  function secded_message_size( Data_size : positive ) return positive;
  function secded_indices( Data_size : positive ) return ecc_range;
  function secded_parity_size( Message_size : positive ) return positive;

  --## SECDED Encode, decode, and error checking functions with and without
  --#  use of shared logic.
  function secded_encode(Data : std_ulogic_vector; Message_size : positive) return ecc_vector;

  function secded_encode( Data : std_ulogic_vector; Parity_bits : unsigned )
    return ecc_vector;

  function secded_decode( Encoded_data : ecc_vector ) return std_ulogic_vector;

  function secded_has_errors( Encoded_data : ecc_vector ) return secded_errors;
  function secded_has_errors( Encoded_data : ecc_vector; Syndrome : unsigned )
    return secded_errors;

end package;

library extras;
use extras.hamming_edac.all;
use extras.parity_ops.all;

package body secded_edac is

  --## Determine the size of a message (data interleaved with parity) given
  --#  the size of data to be protected. Note that this and secded_indices are
  --#  the only functions in the package with a limit on the maximum size of
  --#  data that can be handled. The MESSAGE_SIZE_TABLE constant in
  --#  hamming_edac is currently defined with a max limit of 247 data bits. The
  --#  constant MAX_TBL_PARITY can be increased to expand the table or this
  --#  function can be bypassed with the message size determined without using
  --#  code. The (7,4) code is the smallest practical Hamming code so attempts
  --#  to use less than 4-bits of data will also cause a failure.
  function secded_message_size( Data_size : positive ) return positive is
  begin
    return hamming_message_size(Data_size) + 1;
  end function;

  function secded_parity_size( Message_size : positive ) return positive is
  begin
    return hamming_parity_size(Message_size) + 1;
  end function;


  function secded_indices( Data_size : positive ) return ecc_range is
    variable result : ecc_range;
  begin
    result.left  := Data_size - 1;
    result.right := -secded_parity_size(hamming_message_size(Data_size));

    return result;
  end function;


  function secded_encode(Data : std_ulogic_vector; Message_size : positive)
    return ecc_vector is

    variable result : ecc_vector(Data'length-1 downto -secded_parity_size(Message_size));
  begin
    result(result'high downto result'low+1) := hamming_encode(Data, Message_size);
    result(result'low) := parity(even, to_sulv(result(result'high downto result'low+1)));

    return result;
  end function;

  function secded_encode( Data : std_ulogic_vector; Parity_bits : unsigned )
    return ecc_vector is

    variable result : ecc_vector(Data'length-1 downto -(Parity_bits'length + 1));
  begin

    result(result'high downto result'low+1) := to_ecc_vec(Data) &
      to_ecc_vec(to_stdulogicvector(std_logic_vector(Parity_bits)));
    result(result'low) := parity(even, to_sulv(result(result'high downto result'low+1)));

    return result;
  end function;


  function secded_decode( Encoded_data : ecc_vector ) return std_ulogic_vector is
  begin
    return hamming_decode(Encoded_data(Encoded_data'high downto Encoded_data'low+1));
  end function;


  function secded_has_errors( Encoded_data : ecc_vector ) return secded_errors is
    variable errors : secded_errors;
  begin
    errors(single_bit) := parity(even, to_sulv(Encoded_data)) = '1';
    errors(double_bit) := (errors(single_bit) = false)
      and hamming_has_error(Encoded_data(Encoded_data'high downto Encoded_data'low+1));

    return errors;
  end function;

  function secded_has_errors( Encoded_data : ecc_vector; Syndrome : unsigned )
    return secded_errors is

    variable errors : secded_errors;
  begin
    errors(single_bit) := parity(even, to_sulv(Encoded_data)) = '1';
    errors(double_bit) := (errors(single_bit) = false)
      and hamming_has_error(Syndrome);

    return errors;
  end function;

end package body;

