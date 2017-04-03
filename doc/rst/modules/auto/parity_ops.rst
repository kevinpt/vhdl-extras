.. Generated from ../rtl/extras/parity_ops.vhdl on 2017-04-02 22:57:52.880070
.. vhdl:package:: parity_ops

Types
-----

.. vhdl:type:: parity_kind

Subprograms
-----------


.. vhdl:function:: function parity(ptype : parity_kind; val : std_ulogic_vector) return std_ulogic;

  :param ptype: 
  :type ptype: parity_kind
  :param val: 
  :type val: std_ulogic_vector


.. vhdl:function:: function check_parity(ptype : parity_kind; val : std_ulogic_vector; parity_bit : std_ulogic) return boolean;

  :param ptype: 
  :type ptype: parity_kind
  :param val: 
  :type val: std_ulogic_vector
  :param parity_bit: 
  :type parity_bit: std_ulogic

