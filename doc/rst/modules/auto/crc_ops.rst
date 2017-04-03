.. Generated from ../rtl/extras/crc_ops.vhdl on 2017-04-02 22:57:53.294665
.. vhdl:package:: crc_ops

Subprograms
-----------


.. vhdl:function:: function init_crc(Xor_in : bit_vector) return bit_vector;

  :param Xor_in: 
  :type Xor_in: bit_vector

  Initialize CRC state

.. vhdl:function:: function next_crc(Crc : bit_vector; Poly : bit_vector; Reflect_in : boolean; Data : bit_vector) return bit_vector;

  :param Crc: 
  :type Crc: bit_vector
  :param Poly: 
  :type Poly: bit_vector
  :param Reflect_in: 
  :type Reflect_in: boolean
  :param Data: 
  :type Data: bit_vector

  Add new data to the CRC

.. vhdl:function:: function end_crc(Crc : bit_vector; Reflect_out : boolean; Xor_out : bit_vector) return bit_vector;

  :param Crc: 
  :type Crc: bit_vector
  :param Reflect_out: 
  :type Reflect_out: boolean
  :param Xor_out: 
  :type Xor_out: bit_vector

  Finalize the CRC
