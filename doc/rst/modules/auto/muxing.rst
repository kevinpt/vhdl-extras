.. Generated from ../rtl/extras/muxing.vhdl on 2017-04-02 22:57:53.300315
.. vhdl:package:: muxing

Subprograms
-----------


.. vhdl:function:: function decode(Sel : unsigned) return std_ulogic_vector;

  :param Sel: 
  :type Sel: unsigned

  Decoder with variable sized output (power of 2)

.. vhdl:function:: function decode(Sel : unsigned; Size : positive) return std_ulogic_vector;

  :param Sel: 
  :type Sel: unsigned
  :param Size: 
  :type Size: positive

  Decoder with variable sized output (user specified)

.. vhdl:function:: function mux(Inputs : std_ulogic_vector; Sel : unsigned) return std_ulogic;

  :param Inputs: 
  :type Inputs: std_ulogic_vector
  :param Sel: 
  :type Sel: unsigned

  Multiplexer with variable sized inputs

.. vhdl:function:: function mux(Inputs : std_ulogic_vector; One_hot_sel : std_ulogic_vector) return std_ulogic;

  :param Inputs: 
  :type Inputs: std_ulogic_vector
  :param One_hot_sel: 
  :type One_hot_sel: std_ulogic_vector

  Multiplexer with variable sized inputs using external decoder

.. vhdl:function:: function demux(Input : std_ulogic; Sel : unsigned; Size : positive) return std_ulogic_vector;

  :param Input: 
  :type Input: std_ulogic
  :param Sel: 
  :type Sel: unsigned
  :param Size: 
  :type Size: positive

  Demultiplexer with variable sized inputs
