.. Generated from ../rtl/extras/lfsr_ops.vhdl on 2017-04-20 23:04:37.233455
.. vhdl:package:: lfsr_ops


Types
-----


.. vhdl:type:: lfsr_coefficients


.. vhdl:type:: lfsr_kind


Components
----------


galois_lfsr
~~~~~~~~~~~

.. symbolator::

  component galois_lfsr is
  generic (
    INIT_ZERO : boolean;
    FULL_CYCLE : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    Tap_map : in std_ulogic_vector;
    State : out std_ulogic_vector
  );
  end component;

|

Galois LFSR. With Maximal length coefficients it will cycle through
(2**n)-1 states when FULL_CYCLE = false, 2**n when true.

|


.. vhdl:entity:: galois_lfsr

  :generic INIT_ZERO: 
  :gtype INIT_ZERO: boolean
  :generic FULL_CYCLE: 
  :gtype FULL_CYCLE: boolean
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Enable: 
  :ptype Enable: in std_ulogic
  :port Tap_map: 
  :ptype Tap_map: in std_ulogic_vector
  :port State: 
  :ptype State: out std_ulogic_vector

fibonacci_lfsr
~~~~~~~~~~~~~~

.. symbolator::

  component fibonacci_lfsr is
  generic (
    INIT_ZERO : boolean;
    FULL_CYCLE : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    Tap_map : in std_ulogic_vector;
    State : out std_ulogic_vector
  );
  end component;

|

Fibonacci LFSR. With Maximal length coefficients it will cycle through
(2**n)-1 states when FULL_CYCLE = false, 2**n states when true.

|


.. vhdl:entity:: fibonacci_lfsr

  :generic INIT_ZERO: 
  :gtype INIT_ZERO: boolean
  :generic FULL_CYCLE: 
  :gtype FULL_CYCLE: boolean
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Enable: 
  :ptype Enable: in std_ulogic
  :port Tap_map: 
  :ptype Tap_map: in std_ulogic_vector
  :port State: 
  :ptype State: out std_ulogic_vector

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

