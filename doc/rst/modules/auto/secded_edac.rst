.. Generated from ../rtl/extras/secded_edac.vhdl on 2017-04-02 22:57:53.023214
.. vhdl:package:: secded_edac

Types
-----

.. vhdl:type:: secded_error_kind

.. vhdl:type:: secded_errors

Subprograms
-----------


.. vhdl:function:: function secded_message_size(Data_size : positive) return positive;

  :param Data_size: 
  :type Data_size: positive

  Functions to determine array sizes

.. vhdl:function:: function secded_indices(Data_size : positive) return ecc_range;

  :param Data_size: 
  :type Data_size: positive


.. vhdl:function:: function secded_parity_size(Message_size : positive) return positive;

  :param Message_size: 
  :type Message_size: positive


.. vhdl:function:: function secded_data_size(Message_size : positive) return positive;

  :param Message_size: 
  :type Message_size: positive


.. vhdl:function:: function secded_encode(Data : std_ulogic_vector) return ecc_vector;

  :param Data: 
  :type Data: std_ulogic_vector

  SECDED Encode, decode, and error checking functions with and without
  use of shared logic.

.. vhdl:function:: function secded_encode(Data : std_ulogic_vector; Parity_bits : unsigned) return ecc_vector;

  :param Data: 
  :type Data: std_ulogic_vector
  :param Parity_bits: 
  :type Parity_bits: unsigned


.. vhdl:function:: function secded_decode(Encoded_data : ecc_vector) return std_ulogic_vector;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector


.. vhdl:function:: function secded_has_errors(Encoded_data : ecc_vector) return secded_errors;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector


.. vhdl:function:: function secded_has_errors(Encoded_data : ecc_vector; Syndrome : unsigned) return secded_errors;

  :param Encoded_data: 
  :type Encoded_data: ecc_vector
  :param Syndrome: 
  :type Syndrome: unsigned

