.. Generated from ../rtl/extras/hamming_edac.vhdl on 2017-04-02 22:57:53.103965
.. vhdl:package:: hamming_edac

Types
-----

.. vhdl:type:: ecc_vector

.. vhdl:type:: ecc_range

Subprograms
-----------


.. vhdl:function:: function to_ecc_vec(Arg : std_ulogic_vector; Parity_size : natural) return ecc_vector;

  :param Arg: 
  :type Arg: std_ulogic_vector
  :param Parity_size: 
  :type Parity_size: natural

  ecc_vector conversion and manipulation

.. vhdl:function:: function to_sulv(Arg : ecc_vector) return std_ulogic_vector;

  :param Arg: 
  :type Arg: ecc_vector


.. vhdl:function:: function get_data(Encoded_data : ecc_vector) return std_ulogic_vector;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector


.. vhdl:function:: function get_parity(Encoded_data : ecc_vector) return unsigned;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector


.. vhdl:function:: function hamming_message_size(Data_size : positive) return positive;

  :param Data_size: 
  :type Data_size: positive

  Functions to determine array sizes

.. vhdl:function:: function hamming_parity_size(Message_size : positive) return positive;

  :param Message_size: 
  :type Message_size: positive


.. vhdl:function:: function hamming_data_size(Message_size : positive) return positive;

  :param Message_size: 
  :type Message_size: positive


.. vhdl:function:: function hamming_indices(Data_size : positive) return ecc_range;

  :param Data_size: 
  :type Data_size: positive


.. vhdl:function:: function hamming_interleave(Data : std_ulogic_vector; Parity_bits : unsigned) return std_ulogic_vector;

  :param Data: 
  :type Data: std_ulogic_vector
  :param Parity_bits: 
  :type Parity_bits: unsigned

  "Internal" encoding functions used for resource sharing

.. vhdl:function:: function hamming_interleave(Encoded_data : ecc_vector) return std_ulogic_vector;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector


.. vhdl:function:: function hamming_parity(Message : std_ulogic_vector) return unsigned;

  :param Message: 
  :type Message: std_ulogic_vector


.. vhdl:function:: function hamming_encode(Data : std_ulogic_vector) return ecc_vector;

  :param Data: 
  :type Data: std_ulogic_vector

  Hamming Encode, decode, and error checking functions with and without
  use of shared logic.

.. vhdl:function:: function hamming_encode(Data : std_ulogic_vector; Parity_bits : unsigned) return ecc_vector;

  :param Data: 
  :type Data: std_ulogic_vector
  :param Parity_bits: 
  :type Parity_bits: unsigned


.. vhdl:function:: function hamming_decode(Encoded_data : ecc_vector) return std_ulogic_vector;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector


.. vhdl:function:: function hamming_decode(Message : std_ulogic_vector; Syndrome : unsigned) return std_ulogic_vector;

  :param Message: 
  :type Message: std_ulogic_vector
  :param Syndrome: 
  :type Syndrome: unsigned


.. vhdl:function:: function hamming_has_error(Encoded_data : ecc_vector) return boolean;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector


.. vhdl:function:: function hamming_has_error(Syndrome : unsigned) return boolean;

  :param Syndrome: 
  :type Syndrome: unsigned

