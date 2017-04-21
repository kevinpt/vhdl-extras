.. Generated from ../rtl/extras/parity_ops.vhdl on 2017-04-20 23:04:36.919037
.. vhdl:package:: parity_ops


Types
-----


.. vhdl:type:: parity_kind

  Identify the type of parity

Subprograms
-----------


.. vhdl:function:: function parity(Ptype : parity_kind; Val : std_ulogic_vector) return std_ulogic;

  :param Ptype: Type of parity; odd or even
  :type Ptype: parity_kind
  :param Val: Value to generate parity for
  :type Val: std_ulogic_vector
  :returns:   Parity bit for Val.

  Compute parity.

.. vhdl:function:: function check_parity(Ptype : parity_kind; Val : std_ulogic_vector; Parity_bit : std_ulogic) return boolean;

  :param Ptype: Type of parity; odd or even
  :type Ptype: parity_kind
  :param Val: Value to test parity for
  :type Val: std_ulogic_vector
  :param Parity_bit: Parity bit to check
  :type Parity_bit: std_ulogic
  :returns:   true if Parity_bit is correct.

  Check parity for an error.
