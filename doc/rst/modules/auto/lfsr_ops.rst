.. Generated from ../rtl/extras/lfsr_ops.vhdl on 2017-04-02 22:57:53.141460
.. vhdl:package:: lfsr_ops

Types
-----

.. vhdl:type:: lfsr_coefficients

.. vhdl:type:: lfsr_kind

Subprograms
-----------


.. vhdl:function:: function to_tap_map(C : lfsr_coefficients; Map_length : positive; Reverse : boolean) return std_ulogic_vector;

  :param C: 
  :type C: lfsr_coefficients
  :param Map_length: 
  :type Map_length: positive
  :param Reverse: 
  :type Reverse: boolean

  Convert a coefficient list to an expanded vector with a '1' in the place
  of each coefficient.

.. vhdl:function:: function lfsr_taps(Size : positive) return std_ulogic_vector;

  :param Size: 
  :type Size: positive

  Lookup a predefined tap coefficients from the table

.. vhdl:function:: function next_galois_lfsr(State : std_ulogic_vector; Tap_map : std_ulogic_vector; Kind : lfsr_kind; Full_cycle : boolean) return std_ulogic_vector;

  :param State: 
  :type State: std_ulogic_vector
  :param Tap_map: 
  :type Tap_map: std_ulogic_vector
  :param Kind: 
  :type Kind: lfsr_kind
  :param Full_cycle: 
  :type Full_cycle: boolean


.. vhdl:function:: function next_fibonacci_lfsr(State : std_ulogic_vector; Tap_map : std_ulogic_vector; Kind : lfsr_kind; Full_cycle : boolean) return std_ulogic_vector;

  :param State: 
  :type State: std_ulogic_vector
  :param Tap_map: 
  :type Tap_map: std_ulogic_vector
  :param Kind: 
  :type Kind: lfsr_kind
  :param Full_cycle: 
  :type Full_cycle: boolean

