.. Generated from ../rtl/extras/crc_ops.vhdl on 2018-06-28 23:37:29.176993
.. vhdl:package:: extras.crc_ops


Components
----------


crc
~~~

.. symbolator::
  :name: crc_ops-crc

  component crc is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|CRC configuration}}
    Poly : in std_ulogic_vector;
    Xor_in : in std_ulogic_vector;
    Xor_out : in std_ulogic_vector;
    Reflect_in : in boolean;
    Reflect_out : in boolean;
    Initialize : in std_ulogic;
    --# {{data|}}
    Enable : in std_ulogic;
    Data : in std_ulogic_vector;
    Checksum : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: crc

  Calculate a CRC sequentially.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Poly: Polynomial
  :ptype Poly: in std_ulogic_vector
  :port Xor_in: Invert (XOR) initial state
  :ptype Xor_in: in std_ulogic_vector
  :port Xor_out: Invert (XOR) final state
  :ptype Xor_out: in std_ulogic_vector
  :port Reflect_in: Swap input bit order
  :ptype Reflect_in: in boolean
  :port Reflect_out: Swap output bit order
  :ptype Reflect_out: in boolean
  :port Initialize: Reset the CRC state
  :ptype Initialize: in std_ulogic
  :port Enable: Indicates data is valid for next CRC update
  :ptype Enable: in std_ulogic
  :port Data: New data (can be any width needed)
  :ptype Data: in std_ulogic_vector
  :port Checksum: Computed CRC
  :ptype Checksum: out std_ulogic_vector

Subprograms
-----------


.. vhdl:function:: function init_crc(Xor_in : bit_vector) return bit_vector;

   Initialize CRC state.
  
  :param Xor_in: Apply XOR to initial '0' state
  :type Xor_in: bit_vector
  :returns: New state of CRC.
  


.. vhdl:function:: function next_crc(Crc : bit_vector; Poly : bit_vector; Reflect_in : boolean; Data : bit_vector) return bit_vector;

   Add new data to the CRC.
  
  :param Crc: Current CRC state
  :type Crc: bit_vector
  :param Poly: Polynomial for the CRC
  :type Poly: bit_vector
  :param Reflect_in: Reverse bits of Data when true
  :type Reflect_in: boolean
  :param Data: Next data word to add to CRC
  :type Data: bit_vector
  :returns: New state of CRC.
  


.. vhdl:function:: function end_crc(Crc : bit_vector; Reflect_out : boolean; Xor_out : bit_vector) return bit_vector;

   Finalize the CRC.
  
  :param Crc: Current CRC state
  :type Crc: bit_vector
  :param Reflect_out: Reverse bits of result when true
  :type Reflect_out: boolean
  :param Xor_out: Apply XOR to final state (inversion)
  :type Xor_out: bit_vector
  :returns: Final CRC value
  

