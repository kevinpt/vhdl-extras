.. Generated from ../rtl/extras/parity_ops.vhdl on 2018-06-28 23:37:28.450478
.. vhdl:package:: extras.parity_ops


Types
-----


.. vhdl:type:: parity_kind

  Identify the type of parity

Subprograms
-----------


.. vhdl:function:: function parity(Ptype : parity_kind; Val : std_ulogic_vector) return std_ulogic;

   Compute parity.
  
  :param Ptype: Type of parity; odd or even
  :type Ptype: parity_kind
  :param Val: Value to generate parity for
  :type Val: std_ulogic_vector
  :returns: Parity bit for Val.
  


.. vhdl:function:: function check_parity(Ptype : parity_kind; Val : std_ulogic_vector; Parity_bit : std_ulogic) return boolean;

   Check parity for an error.
  
  :param Ptype: Type of parity; odd or even
  :type Ptype: parity_kind
  :param Val: Value to test parity for
  :type Val: std_ulogic_vector
  :param Parity_bit: Parity bit to check
  :type Parity_bit: std_ulogic
  :returns: true if Parity_bit is correct.
  

