--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# hamming_edac.vhdl - Synthesizable functions for Hamming error correction
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
--# DEPENDENCIES: sizing
--#
--# DESCRIPTION:
--#  This package provides functions that perform single-bit error detection
--#  and correction using Hamming code. Encoded data is represented in the
--#  ecc_vector type with the data preserved in normal sequence using array
--#  indices from data'length-1 downto 0. The Hamming parity bits p are
--#  represented in the encoded array as negative indices from -1 downto -p.
--#  The parity bits are sequenced with the most significant on the left (-1)
--#  and the least significant on the right (-p). This arrangement provides for
--#  easy removal of the parity bits by slicing the data portion out of the
--#  encoded array. These functions have no upper limit in the size of data
--#  they can handle. For practical reasons, these functions should not be used
--#  with less than four data bits.
--#
--#  The layout of an ecc_vector is determined by its range. All objects of
--#  this type must use a descending range with a positive upper bound and a
--#  negative lower bound. Note that the conversion function to_ecc_vec() does
--#  not produce a result that meets this requirement so it should not be
--#  invoked directly as a parameter to a function expecting a proper
--#  ecc_vector.
--#
--#  Hamming ecc_vector layout:
--#                               MSb         LSb
--#    [(data'length - 1) <-> 0] [-1 <-> -parity_size]
--#              data               Hamming parity
--#
--#  The output from hamming_encode produces an ecc_vector with this layout.
--#  Depending on the hardware implementation it may be desirable to interleave
--#  the parity bits with the data to protect against certain failures that may
--#  go undetected when encoded data is distributed across multiple memory
--#  devices. Use hamming_interleave to perform this reordering of bits.
--#
--#  BACKGROUND: The Hamming code is developed by interleaving the parity bits
--#  and data together such that the parity bits occupy the powers of 2 in the
--#  array indices. This interleaved array is known as the message. In
--#  decoding, the parity bits form a vector that represents an unsigned
--#  integer indicating the position of any erroneous bit in the message. The
--#  non-error condition is reserved as an all zeroes coding of the parity
--#  bits. This means that for p parity bits, the message length m can't be
--#  longer than (2**p)-1. The number of data bits k is m - p. Any particular
--#  Hamming code is referred to using the nomenclature (m, k) to identify the
--#  message and data sizes. Here are the maximum data sizes for the set of
--#  messages that are perfectly coded (m = (2**p)-1):
--#    (3,1) (7,4) (15,11) (31,26) (63,57) (127,120) ...
--#  Minimum message sizes for power of 2 data sizes:
--#    (5,2) (7,4) (12,8) (21,16) (38,32) (71,64) ...
--#
--#  When the data size k is a power of 2 greater than or equal to 4, the
--#  minimum message size m = ceil(log2(k)) + 1 + k. For other values of k
--#  greater than 4 this relation is a, possibly minimal, upper bound for the
--#  message size.
--#
--#  SYNTHESIS: The XOR operations for the parity bits are iteratively
--#  generated and form long chains of gates. To achieve minimal delay you
--#  should ensure that your synthesizer rearranges these chains into minimal
--#  depth trees of XOR gates. The synthesized logic is purely combinational.
--#  In most cases registers should be added to remove glitches on the outputs.
--#
--#  EXAMPLE USAGE:
--#    signal word, corrected_word : std_ulogic_vector(15 downto 0);
--#    constant WORD_MSG_SIZE : positive := hamming_message_size(word'length);
--#    signal hamming_word :
--#      ecc_vector(word'high downto -hamming_parity_size(WORD_MSG_SIZE));
--#    ...
--#    hamming_word <= hamming_encode(word);
--#    ... <SEU or transmission error flips a bit>
--#    corrected_word <= hamming_decode(hamming_word);
--#    if hamming_has_error(hamming_word) then ... -- check for error
--#
--#  Note that hamming_decode and hamming_has_error will synthesize with some
--#  common logic. Use the alternate versions in conjunction with
--#  hamming_interleave and hamming_parity to conserve logic when both are used:
--#    variable message : std_ulogic_vector(hamming_word'length downto 1);
--#    variable syndrome : unsigned(-hamming_word'low downto 1);
--#    ...
--#    message  := hamming_interleave(hamming_word);
--#    syndrome := hamming_parity(message);
--#    corrected_word <= hamming_decode(message, syndrome);
--#    if hamming_has_error(syndrome) then ... -- check for error
--#
--#  Similary, it is possible to share logic between the encoder and decoder if
--#  they are co-located and not used simultaneously:
--#    if encoding then
--#      txrx_data   := word;
--#      txrx_parity := (others => '0');
--#    else -- decoding
--#      txrx_data   := get_data(received_word);
--#      txrx_parity := get_parity(received_word);
--#    end if;
--#    message        := hamming_interleave(txrx_data, txrx_parity);
--#    parity_bits    := hamming_parity(message); -- also acts as the syndrome
--#    hamming_word   <= hamming_encode(word, parity_bits);
--#    corrected_word <= hamming_decode(message, parity_bits);
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package hamming_edac is

  --## Representation of a message with data and parity segments.
  type ecc_vector is array( integer range <> ) of std_ulogic;

  --## Range information for a message.
  type ecc_range is record
    left  : integer;
    right : integer;
  end record;

  --## Convert a plain vector into ecc_vector.
  --# Args:
  --#   Arg: Vector to convert
  --#   Parity_size: Number of parity bits
  --# Returns:
  --#   Arg vector reindexed with a negative parity segment.
  function to_ecc_vec( Arg : std_ulogic_vector; Parity_size : natural := 0 ) return ecc_vector;

  --## Convert an ecc_vector to a plain vector.
  --# Args:
  --#   Arg: Vector to convert
  --# Returns:
  --#   Vector reindexed with 0 as rightmost bit.
  function to_sulv( Arg : ecc_vector ) return std_ulogic_vector;

  --## Extract data portion from encoded ecc_vector.
  --# Args:
  --#   Encoded_data: Vector to convert
  --# Returns:
  --#   Data portion of Encoded_data.
  function get_data( Encoded_data : ecc_vector ) return std_ulogic_vector;

  --## Extract parity portion from encoded ecc_vector.
  --# Args:
  --#   Encoded_data: Vector to convert
  --# Returns:
  --#   Parity portion of Encoded_data.
  function get_parity( Encoded_data : ecc_vector ) return unsigned;

  --%% Functions to determine array sizes
  
  --## Determine the size of a message (data interleaved with parity) given
  --#  the size of data to be protected.
  --# Args:
  --#   Data_size: Number of data bits
  --# Returns:
  --#   Message size.
  function hamming_message_size( Data_size : positive ) return positive;

  --## Determine the number of parity bits for a given message size.
  --# Args:
  --#   Message_size: Number of bits in complete message
  --# Returns:
  --#   Parity size.
  function hamming_parity_size( Message_size : positive ) return positive;

  --## Determine the number of data bits for a given message size.
  --# Args:
  --#   Message_size: Number of bits in complete message
  --# Returns:
  --#   Data size.
  function hamming_data_size( Message_size : positive ) return positive;

  --## Return the left and right indices needed to declare an ecc_vector for the
  --#  requested data size.
  --# Args:
  --#   Data_size: Number of data bits
  --# Returns:
  --#   Range with left and right.
  function hamming_indices( Data_size : positive ) return ecc_range;

  --%% "Internal" encoding functions used for resource sharing

  --## Combine separate data and parity bits into a message with
  --#  interleaved parity.
  --# Args:
  --#   Data: Unencoded data
  --#   Parity_bits: Parity
  --# Returns:
  --#   Message with interleaved parity.
  function hamming_interleave( Data : std_ulogic_vector; Parity_bits : unsigned )
    return std_ulogic_vector;

  --## Reorder data and parity bits from an ecc_vector into a message with
  --#  interleaved parity.
  --# Args:
  --#   Encoded_data: Unencoded data and parity
  --# Returns:
  --#   Message with interleaved parity.
  function hamming_interleave( Encoded_data : ecc_vector ) return std_ulogic_vector;

  --## Generate Hamming parity bits from an interleaved message
  --#  This is the core routine of the package that determines which bits of a
  --#  message to XOR together. It is employed for both encoding and decoding
  --#  When encoding, the message should have all zeroes interleaved for the
  --#  parity bits. The result is the parity to be used by a decoder.
  --#  When decoding, the previously generated parity bits are interleaved and
  --#  the result is a syndrome that can be used for error detection and
  --#  correction.
  --# Args:
  --#   Message: Interleaved message
  --# Returns:
  --#   Parity or syndrome.
  function hamming_parity( Message : std_ulogic_vector ) return unsigned;

  --%% Hamming Encode, decode, and error checking functions with and without
  --%  use of shared logic.
  
  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity. This version uses self contained logic.
  --# Args:
  --#   Data: Raw data
  --# Returns:
  --#   Encoded data with parity.
  function hamming_encode( Data : std_ulogic_vector ) return ecc_vector;
  
  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity. This version depends on external logic to generate the
  --#  parity bits.
  --# Args:
  --#   Data: Raw data
  --#   Parity_bits: Number of parity bits
  --# Returns:
  --#   Encoded data with parity.
  function hamming_encode( Data : std_ulogic_vector; Parity_bits : unsigned )
    return ecc_vector;

  --## Decode an ecc_vector into the plain data bits, potentially correcting
  --#  a single-bit error if a bit has flipped. This version uses self
  --#  contained logic.
  --# Args:
  --#   Encoded_data: Encoded (uninterleaved) message
  --# Returns:
  --#   Decoded data.
  function hamming_decode( Encoded_data : ecc_vector ) return std_ulogic_vector;
  
  --## Decode an interleaved message into the plain data bits, potentially
  --#  correcting a single-bit error if a bit has flipped. This version depends
  --#  on external logic to interleave the message and generate a syndrome.
  --# Args:
  --#   Message: Interleaved message
  --# Returns:
  --#   Decoded data.
  function hamming_decode( Message : std_ulogic_vector; Syndrome : unsigned )
    return std_ulogic_vector;

  --## Test for a single-bit error in an ecc_vector. Returns true for an error.
  --# Args:
  --#   Encoded_data: Encoded (uninterleaved) message
  --# Returns:
  --#   true if message has a parity error.
  function hamming_has_error( Encoded_data : ecc_vector ) return boolean;
  
  --## Test for a single-bit error in an ecc_vector. Returns true for an error.
  --#  This version depends on external logic to generate a syndrome.
  --# Args:
  --#   Syndrome: Syndrome generated by hamming_parity()
  --# Returns:
  --#   true if message has a parity error.
  function hamming_has_error( Syndrome : unsigned ) return boolean;

end package;


library extras;
use extras.sizing.all;

package body hamming_edac is

-- PRIVATE:
-- ========

  --// Extract the data bits from an interleaved message
  function hamming_deinterleave( Message : std_ulogic_vector )
    return std_ulogic_vector is

    variable data : std_ulogic_vector(hamming_data_size(Message'length)-1 downto 0);
    variable data_ix : natural := 0;
  begin
    for i in Message'reverse_range loop
      if 2**ceil_log2(i) /= i then -- not power of 2, this is a data bit
        data(data_ix) := Message(i);
        data_ix := data_ix + 1;
      end if;
    end loop;

    return data;
  end function;


-- PUBLIC:
-- =======

  --## Convert std_ulogic_vector to ecc_vector. Note that if Parity_size is
  --#  not specified the indices of the result are incorrect and must be
  --#  fixed by assigning the result to an object with the proper positive and
  --#  negative indices.
  function to_ecc_vec( Arg : std_ulogic_vector; Parity_size : natural := 0 ) return ecc_vector is
    subtype t is ecc_vector(Arg'length-1 - Parity_size downto -Parity_size);
    variable ev : t;
  begin
    ev := t(Arg);
    return ev;
  end function;

  --## Convert ecc_vector to std_ulogic_vector. This is of use when extracting
  --#  the data and parity from slices of an ecc_vector and preparing for
  --#  sending encoded data out through top-level I/Os where negative indices
  --#  should be avoided.
  function to_sulv( Arg : ecc_vector ) return std_ulogic_vector is
    subtype t is std_ulogic_vector(Arg'length-1 downto 0);
    variable sulv : t;
  begin
    sulv := t(Arg);
    return sulv;
  end function;


  --## Extract data portion from encoded ecc_vector
  function get_data( Encoded_data : ecc_vector ) return std_ulogic_vector is
    variable result : std_ulogic_vector(Encoded_data'high downto 0);
  begin
    result := to_sulv(Encoded_data(Encoded_data'high downto 0));
    return result;
  end function;

  --## Extract parity portion from encoded ecc_vector
  function get_parity( Encoded_data : ecc_vector ) return unsigned is
    variable result : unsigned(-Encoded_data'low downto 1);
  begin
    result := unsigned(to_stdlogicvector(to_sulv(Encoded_data(-1 downto Encoded_data'low))));
    return result;
  end function;


  --## Determine the size of a message (data interleaved with parity) given
  --#  the size of data to be protected.
  function hamming_message_size( Data_size : positive ) return positive is
    variable psize : natural;
  begin
    psize := floor_log2(Data_size) + 1;
    
    if (2**psize - 1) - psize < Data_size then -- not enough parity bits
      psize := psize + 1;
    end if;
    
    return Data_size + psize;
  end function;

  --## Determine the number of parity bits for a given message size
  function hamming_parity_size( Message_size : positive ) return positive is
  begin
    return ceil_log2(Message_size + 1);
  end function;

  --## Determine the number of data bits for a given message size
  function hamming_data_size( Message_size : positive ) return positive is
  begin
    return Message_size - hamming_parity_size(Message_size);
  end function;

  --## Return the left and right indices needed to declare an ecc_vector for the
  --#  requested data size.
  function hamming_indices( Data_size : positive ) return ecc_range is
    variable result : ecc_range;
  begin
    result.left  := Data_size-1;
    result.right := -hamming_parity_size(hamming_message_size(Data_size));

    return result;
  end function;

  --## Combine separate data and parity bits into a message with
  --#  interleaved parity.
  function hamming_interleave( Data : std_ulogic_vector; Parity_bits : unsigned )
    return std_ulogic_vector is
    constant MESSAGE_SIZE : positive := Data'length + Parity_bits'length;
    alias data_desc   : std_ulogic_vector(Data'length-1 downto 0) is Data;
    alias parity_desc : unsigned(Parity_bits'length downto 1) is Parity_bits;

    variable msg       : std_ulogic_vector(MESSAGE_SIZE downto 1);
    variable data_ix   : natural := 0;
    variable parity_ix : positive := 1;
  begin
    assert data_desc'length = hamming_data_size(MESSAGE_SIZE)
      report "Data and message size mismatch"
      severity failure;

    for i in msg'reverse_range loop
      if 2**ceil_log2(i) = i then -- power of 2, this is a parity bit
        msg(i) := parity_desc(parity_ix); -- add the current parity bit
        parity_ix := parity_ix + 1;
      else
        msg(i) := data_desc(data_ix); -- add the current data bit
        data_ix := data_ix + 1;
      end if;
    end loop;

    return msg;
  end function;

  --## Reorder data and parity bits from an ecc_vector into a message with
  --#  interleaved parity.
  function hamming_interleave( Encoded_data : ecc_vector ) return std_ulogic_vector is
    constant DATA : std_ulogic_vector(Encoded_data'high downto 0)
      := get_data(Encoded_data);

    constant PARITY_BITS : unsigned(-Encoded_data'low downto 1)
      := get_parity(Encoded_data);

  begin
    return hamming_interleave(DATA, PARITY_BITS);
  end function;


  --## Generate Hamming parity bits from an interleaved message
  --#  This is the core routine of the package that determines which bits of a
  --#  message to XOR together. It is employed for both encoding and decoding
  --#  When encoding, the message should have all zeroes interleaved for the
  --#  parity bits. The result is the parity to be used by a decoder.
  --#  When decoding, the previously generated parity bits are interleaved and
  --#  the result is a syndrome that can be used for error detection and
  --#  correction.
  function hamming_parity( Message : std_ulogic_vector ) return unsigned is

    alias msg : std_ulogic_vector(Message'length downto 1) is Message;
    variable result : unsigned(hamming_parity_size(Message'length) downto 1);

    variable result_ix  : natural := 1;
    variable count      : integer;
    variable parity_bit : std_ulogic;
  begin
    for i in msg'reverse_range loop
      if 2**ceil_log2(i) = i then -- power of 2, this is a parity bit
        -- XOR the next i bits then skip the following i bits and repeat
        count := i;
        parity_bit := '0';
        -- While count is > 0 XOR the current bit
        -- Reset count when it has been <= 0 for i bits
        for d in i to msg'high loop
          if count > 0 then
            parity_bit := parity_bit xor msg(d);
          elsif count = 1 - i then
            count := i + 1; -- reset count
          end if;

          count := count - 1;
        end loop;

        result(result_ix) := parity_bit;
        result_ix := result_ix + 1;

      end if;
    end loop;

    return result;
  end function;


  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity. This version uses self contained logic.
  function hamming_encode( Data : std_ulogic_vector ) return ecc_vector is
    alias data_desc : std_ulogic_vector(data'length-1 downto 0) is Data;
    
    constant MSG_SIZE : positive := hamming_message_size(Data'length);
    variable parity_bits : unsigned(hamming_parity_size(MSG_SIZE) downto 1);

    variable result : ecc_vector(Data'length-1 downto -parity_bits'length);
  begin

    parity_bits := hamming_parity(hamming_interleave(data_desc, (parity_bits'range => '0')));

    result := to_ecc_vec(data_desc) &
      to_ecc_vec(to_stdulogicvector(std_logic_vector(parity_bits)));
    return result;
  end function;


  --## Encode the supplied data into an ecc_vector using Hamming code for
  --#  the parity. This version depends on external logic to generate the
  --#  parity bits.
  function hamming_encode( Data : std_ulogic_vector; Parity_bits : unsigned )
    return ecc_vector is

    variable result : ecc_vector(Data'length-1 downto -Parity_bits'length);
  begin

    result := to_ecc_vec(Data) &
      to_ecc_vec(to_stdulogicvector(std_logic_vector(Parity_bits)));
    return result;
  end function;


  --## Decode an ecc_vector into the plain data bits, potentially correcting
  --#  a single-bit error if a bit has flipped. This version uses self
  --#  contained logic.
  function hamming_decode( Encoded_data : ecc_vector ) return std_ulogic_vector is
    constant DATA : std_ulogic_vector(Encoded_data'high downto 0)
      := get_data(Encoded_data);

    constant PARITY_BITS : unsigned(-Encoded_data'low downto 1)
      := get_parity(Encoded_data);

    variable msg         : std_ulogic_vector(Encoded_data'length downto 1);
    variable syndrome    : unsigned(PARITY_BITS'range);
    variable perfect_msg : std_ulogic_vector(2**syndrome'length-1 downto 0);
  begin

    msg      := hamming_interleave(DATA, PARITY_BITS);
    syndrome := hamming_parity(msg);

    -- Expand message to perfect size plus one dummy bit in index 0 that we can flip
    -- for the no-error case. All extra bits optimize away in synthesis.
    perfect_msg := to_stdulogicvector(std_logic_vector(
        resize(unsigned(to_stdlogicvector(msg)), perfect_msg'length - 1)
      )) & '0';

    -- If a single bit has flipped the syndrome indicates which one it is
    -- otherwise it indicates 0 which is our dummy.
    perfect_msg(to_integer(syndrome)) := not perfect_msg(to_integer(syndrome));

    -- Slice off the extra bits and deinterleave.
    return hamming_deinterleave(perfect_msg(msg'range));
  end function;

  --## Decode an interleaved message into the plain data bits, potentially
  --#  correcting a single-bit error if a bit has flipped. This version depends
  --#  on external logic to interleave the message and generate a syndrome.
  function hamming_decode( Message : std_ulogic_vector; Syndrome : unsigned )
    return std_ulogic_vector is

    variable msg : std_ulogic_vector(Message'length downto 1) := Message;
    variable perfect_msg : std_ulogic_vector(2**syndrome'length-1 downto 0);
  begin

    -- Expand message to perfect size plus one dummy bit in index 0 that we can flip
    -- for the no-error case. All extra bits optimize away in synthesis.
    perfect_msg := to_stdulogicvector(std_logic_vector(
        resize(unsigned(to_stdlogicvector(msg)), perfect_msg'length - 1)
      )) & '0';

    -- If a single bit has flipped the syndrome indicates which one it is
    -- otherwise it indicates 0 which is our dummy.
    perfect_msg(to_integer(syndrome)) := not perfect_msg(to_integer(syndrome));

    -- Slice off the extra bits and deinterleave.
    return hamming_deinterleave(perfect_msg(msg'range));
  end function;


  --## Test for a single-bit error in an ecc_vector. Returns true for an error.
  function hamming_has_error( encoded_data : ecc_vector ) return boolean is
    constant DATA : std_ulogic_vector(Encoded_data'high downto 0)
      := get_data(Encoded_data);

    constant PARITY_BITS : unsigned(-Encoded_data'low downto 1)
      := get_parity(Encoded_data);

    variable syndrome : unsigned(PARITY_BITS'range);
  begin
    syndrome := hamming_parity(hamming_interleave(DATA, PARITY_BITS));

    return syndrome /= 0;
  end function;

  --## Test for a single-bit error in an ecc_vector. Returns true for an error.
  --#  This version depends on external logic to generate a syndrome.
  function hamming_has_error( Syndrome : unsigned ) return boolean is
  begin
    return Syndrome /= 0;
  end function;

end package body;
