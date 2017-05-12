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
--#    secded_word <= secded_encode(word);
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

  --## Type of SECDED errors.
  type secded_error_kind is (single_bit, double_bit);
  
  --## Boolean bitfield for SECDED errors.
  type secded_errors is array( secded_error_kind ) of boolean;

  --%% Functions to determine array sizes
  
  --## Determine the size of a message (data interleaved with parity) given
  --#  the size of data to be protected.
  --# Args:
  --#   Data_size: Number of data bits
  --# Returns:
  --#   Message size.
  function secded_message_size( Data_size : positive ) return positive;

  --## Return the left and right indices needed to declare an ecc_vector for the
  --#  requested data size.
  --# Args:
  --#   Data_size: Number of data bits
  --# Returns:
  --#   Range with left and right.
  function secded_indices( Data_size : positive ) return ecc_range;
  
  --## Determine the number of parity bits for a given message size.
  --# Args:
  --#   Message_size: Number of bits in complete message
  --# Returns:
  --#   Parity size.  
  function secded_parity_size( Message_size : positive ) return positive;
  
  --## Determine the number of data bits for a given message size.
  --# Args:
  --#   Message_size: Number of bits in complete message
  --# Returns:
  --#   Data size.
  function secded_data_size( Message_size : positive ) return positive;


  --%% SECDED Encode, decode, and error checking functions with and without
  --%  use of shared logic.

  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity and an additional overall parity for SECDED. This version
  --#  uses self contained logic.
  --# Args:
  --#   Data: Raw data
  --# Returns:
  --#   Encoded data with parity.
  function secded_encode(Data : std_ulogic_vector ) return ecc_vector;

  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity and an additional overall parity for SECDED. This version
  --#  depends on external logic to generate the Hamming parity bits.
  --# Args:
  --#   Data: Raw data
  --#   Parity_bits: Number of parity bits
  --# Returns:
  --#   Encoded data with parity.
  function secded_encode( Data : std_ulogic_vector; Parity_bits : unsigned )
    return ecc_vector;

  --## Decode an ecc_vector into the plain data bits, potentially correcting
  --#  a single-bit error if a bit has flipped. This version uses self
  --#  contained logic.
  --# Args:
  --#   Encoded_data: Encoded (uninterleaved) message
  --# Returns:
  --#   Decoded data.
  function secded_decode( Encoded_data : ecc_vector ) return std_ulogic_vector;

  --## Test for a single-bit and double-bit errors in an ecc_vector. Returns
  --#  true for each error type.
  --# Args:
  --#   Encoded_data: Encoded (uninterleaved) message
  --# Returns:
  --#   true if message has a single or double-bit error.
  function secded_has_errors( Encoded_data : ecc_vector ) return secded_errors;

  --## Test for a single-bit and double-bit errors in an ecc_vector. Returns
  --#  true for each error type. This version depends on external logic to
  --#  generate a syndrome.
  --# Args:
  --#   Encoded_data: Encoded (uninterleaved) message
  --#   Syndrome: Syndrome generated by hamming_parity()
  --# Returns:
  --#   true if message has a single or double-bit error.
  function secded_has_errors( Encoded_data : ecc_vector; Syndrome : unsigned )
    return secded_errors;

end package;

library extras;
use extras.hamming_edac.all;
use extras.parity_ops.all;

package body secded_edac is

  --## Determine the size of a message (data interleaved with parity) given
  --#  the size of data to be protected.
  function secded_message_size( Data_size : positive ) return positive is
  begin
    return hamming_message_size(Data_size) + 1;
  end function;

  --## Determine the number of parity bits for a given message size
  function secded_parity_size( Message_size : positive ) return positive is
  begin
    return hamming_parity_size(Message_size-1) + 1;
  end function;

  --## Determine the number of data bits for a given message size
  function secded_data_size( Message_size : positive ) return positive is
  begin
    return Message_size - secded_parity_size(Message_size);
  end function;

  --## Return the left and right indices needed to declare an ecc_vector for the
  --#  requested data size.
  function secded_indices( Data_size : positive ) return ecc_range is
    variable result : ecc_range;
  begin
    result.left  := Data_size - 1;
    result.right := -secded_parity_size(secded_message_size(Data_size));

    return result;
  end function;

  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity and an additional overall parity for SECDED. This version
  --#  uses self contained logic.
  function secded_encode(Data : std_ulogic_vector) return ecc_vector is
    constant MSG_SIZE : positive := secded_message_size(Data'length);
    variable result : ecc_vector(Data'length-1 downto -secded_parity_size(MSG_SIZE));
  begin
    result(result'high downto result'low+1) := hamming_encode(Data);
    result(result'low) := parity(even, to_sulv(result(result'high downto result'low+1)));

    return result;
  end function;

  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity and an additional overall parity for SECDED. This version
  --#  depends on external logic to generate the Hamming parity bits.
  function secded_encode( Data : std_ulogic_vector; Parity_bits : unsigned )
    return ecc_vector is

    variable result : ecc_vector(Data'length-1 downto -(Parity_bits'length + 1));
  begin

    result(result'high downto result'low+1) := to_ecc_vec(Data) &
      to_ecc_vec(to_stdulogicvector(std_logic_vector(Parity_bits)));
    result(result'low) := parity(even, to_sulv(result(result'high downto result'low+1)));

    return result;
  end function;

  --## Decode an ecc_vector into the plain data bits, potentially correcting
  --#  a single-bit error if a bit has flipped. This version uses self
  --#  contained logic.
  function secded_decode( Encoded_data : ecc_vector ) return std_ulogic_vector is
  begin
    return hamming_decode(Encoded_data(Encoded_data'high downto Encoded_data'low+1));
  end function;

  --## Test for a single-bit and double-bit errors in an ecc_vector. Returns
  --#  true for each error type.
  function secded_has_errors( Encoded_data : ecc_vector ) return secded_errors is
    variable errors : secded_errors;
  begin
    errors(single_bit) := parity(even, to_sulv(Encoded_data)) = '1';
    errors(double_bit) := (errors(single_bit) = false)
      and hamming_has_error(Encoded_data(Encoded_data'high downto Encoded_data'low+1));

    return errors;
  end function;

  --## Test for a single-bit and double-bit errors in an ecc_vector. Returns
  --#  true for each error type. This version depends on external logic to
  --#  generate a syndrome.
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

