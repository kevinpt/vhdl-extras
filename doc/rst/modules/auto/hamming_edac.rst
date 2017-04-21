.. Generated from ../rtl/extras/hamming_edac.vhdl on 2017-04-20 23:04:37.187338
.. vhdl:package:: hamming_edac


Types
-----


.. vhdl:type:: ecc_vector

  Representation of a message with data and parity segments.

.. vhdl:type:: ecc_range

  Range information for a message.

Subprograms
-----------


.. vhdl:function:: function to_ecc_vec(Arg : std_ulogic_vector; Parity_size : natural) return ecc_vector;

  :param Arg: Vector to convert
  :type Arg: std_ulogic_vector
  :param Parity_size: Number of parity bits
  :type Parity_size: natural
  :returns:   Arg vector reindexed with a negative parity segment.

  Convert a plain vector into ecc_vector.

.. vhdl:function:: function to_sulv(Arg : ecc_vector) return std_ulogic_vector;

  :param Arg: Vector to convert
  :type Arg: ecc_vector
  :returns:   Vector reindexed with 0 as rightmost bit.

  Convert an ecc_vector to a plain vector.

.. vhdl:function:: function get_data(Encoded_data : ecc_vector) return std_ulogic_vector;

  :param Encoded_data: Vector to convert
  :type Encoded_data: ecc_vector
  :returns:   Data portion of Encoded_data.

  Extract data portion from encoded ecc_vector.

.. vhdl:function:: function get_parity(Encoded_data : ecc_vector) return unsigned;

  :param Encoded_data: Vector to convert
  :type Encoded_data: ecc_vector
  :returns:   Parity portion of Encoded_data.

  Extract parity portion from encoded ecc_vector.

.. vhdl:function:: function hamming_message_size(Data_size : positive) return positive;

  :param Data_size: Number of data bits
  :type Data_size: positive
  :returns:   Message size.

  Determine the size of a message (data interleaved with parity) given
  the size of data to be protected.

.. vhdl:function:: function hamming_parity_size(Message_size : positive) return positive;

  :param Message_size: Number of bits in complete message
  :type Message_size: positive
  :returns:   Parity size.

  Determine the number of parity bits for a given message size.

.. vhdl:function:: function hamming_data_size(Message_size : positive) return positive;

  :param Message_size: Number of bits in complete message
  :type Message_size: positive
  :returns:   Data size.

  Determine the number of data bits for a given message size.

.. vhdl:function:: function hamming_indices(Data_size : positive) return ecc_range;

  :param Data_size: Number of data bits
  :type Data_size: positive
  :returns:   Range with left and right.

  Return the left and right indices needed to declare an ecc_vector for the
  requested data size.

.. vhdl:function:: function hamming_interleave(Data : std_ulogic_vector; Parity_bits : unsigned) return std_ulogic_vector;

  :param Data: Unencoded data
  :type Data: std_ulogic_vector
  :param Parity_bits: Parity
  :type Parity_bits: unsigned
  :returns:   Message with interleaved parity.

  Combine separate data and parity bits into a message with
  interleaved parity.

.. vhdl:function:: function hamming_interleave(Encoded_data : ecc_vector) return std_ulogic_vector;

  :param Encoded_data: Unencoded data and parity
  :type Encoded_data: ecc_vector
  :returns:   Message with interleaved parity.

  Reorder data and parity bits from an ecc_vector into a message with
  interleaved parity.

.. vhdl:function:: function hamming_parity(Message : std_ulogic_vector) return unsigned;

  :param Message: Interleaved message
  :type Message: std_ulogic_vector
  :returns:   Parity or syndrome.

  Generate Hamming parity bits from an interleaved message
  This is the core routine of the package that determines which bits of a
  message to XOR together. It is employed for both encoding and decoding
  When encoding, the message should have all zeroes interleaved for the
  parity bits. The result is the parity to be used by a decoder.
  When decoding, the previously generated parity bits are interleaved and
  the result is a syndrome that can be used for error detection and
  correction.

.. vhdl:function:: function hamming_encode(Data : std_ulogic_vector) return ecc_vector;

  :param Data: Raw data
  :type Data: std_ulogic_vector
  :returns:   Encoded data with parity.

  Encode the supplied data into an ecc_vector using Hamming code for
  the parity. This version uses self contained logic.

.. vhdl:function:: function hamming_encode(Data : std_ulogic_vector; Parity_bits : unsigned) return ecc_vector;

  :param Data: Raw data
  :type Data: std_ulogic_vector
  :param Parity_bits: Number of parity bits
  :type Parity_bits: unsigned
  :returns:   Encoded data with parity.

  Encode the supplied data into an ecc_vector using Hamming code for
  the parity. This version depends on external logic to generate the
  parity bits.

.. vhdl:function:: function hamming_decode(Encoded_data : ecc_vector) return std_ulogic_vector;

  :param Encoded_data: Encoded (uninterleaved) message
  :type Encoded_data: ecc_vector
  :returns:   Decoded data.

  Decode an ecc_vector into the plain data bits, potentially correcting
  a single-bit error if a bit has flipped. This version uses self
  contained logic.

.. vhdl:function:: function hamming_decode(Message : std_ulogic_vector; Syndrome : unsigned) return std_ulogic_vector;

  :param Message: Interleaved message
  :type Message: std_ulogic_vector
  :param Syndrome: 
  :type Syndrome: unsigned
  :returns:   Decoded data.

  Decode an interleaved message into the plain data bits, potentially
  correcting a single-bit error if a bit has flipped. This version depends
  on external logic to interleave the message and generate a syndrome.

.. vhdl:function:: function hamming_has_error(Encoded_data : ecc_vector) return boolean;

  :param Encoded_data: Encoded (uninterleaved) message
  :type Encoded_data: ecc_vector
  :returns:   true if message has a parity error.

  Test for a single-bit error in an ecc_vector. Returns true for an error.

.. vhdl:function:: function hamming_has_error(Syndrome : unsigned) return boolean;

  :param Syndrome: Syndrome generated by hamming_parity()
  :type Syndrome: unsigned
  :returns:   true if message has a parity error.

  Test for a single-bit error in an ecc_vector. Returns true for an error.
  This version depends on external logic to generate a syndrome.
