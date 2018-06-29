.. Generated from ../rtl/extras/lfsr_ops.vhdl on 2018-06-28 23:37:28.970293
.. vhdl:package:: extras.lfsr_ops


Types
-----


.. vhdl:type:: lfsr_coefficients

  Array of LFSR coefficients. Passed as an argument to
  :vhdl:func:`~extras.lfsr_ops.to_tap_map`.

.. vhdl:type:: lfsr_kind

  Type of LFSR: normal (init to 0's) or inverted (init to 1's).

Components
----------


galois_lfsr
~~~~~~~~~~~

.. symbolator::
  :name: lfsr_ops-galois_lfsr

  component galois_lfsr is
  generic (
    INIT_ZERO : boolean;
    FULL_CYCLE : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    --# {{control|}}
    Tap_map : in std_ulogic_vector;
    --# {{data|}}
    State : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: galois_lfsr

  Galois LFSR. With Maximal length coefficients it will cycle through
  (2**n)-1 states when FULL_CYCLE = false, 2**n when true.
  
  :generic INIT_ZERO: Initialize register to zeroes when true
  :gtype INIT_ZERO: boolean
  :generic FULL_CYCLE: Implement a full 2**n cycle
  :gtype FULL_CYCLE: boolean
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Tap_map: '1' for taps that receive feedback
  :ptype Tap_map: in std_ulogic_vector
  :port State: The LFSR state register
  :ptype State: out std_ulogic_vector

fibonacci_lfsr
~~~~~~~~~~~~~~

.. symbolator::
  :name: lfsr_ops-fibonacci_lfsr

  component fibonacci_lfsr is
  generic (
    INIT_ZERO : boolean;
    FULL_CYCLE : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    --# {{control|}}
    Tap_map : in std_ulogic_vector;
    --# {{data|}}
    State : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: fibonacci_lfsr

  Fibonacci LFSR. With Maximal length coefficients it will cycle through
  (2**n)-1 states when FULL_CYCLE = false, 2**n states when true.
  
  :generic INIT_ZERO: Initialize register to zeroes when true
  :gtype INIT_ZERO: boolean
  :generic FULL_CYCLE: Implement a full 2**n cycle
  :gtype FULL_CYCLE: boolean
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Tap_map: '1' for taps that receive feedback
  :ptype Tap_map: in std_ulogic_vector
  :port State: The LFSR state register
  :ptype State: out std_ulogic_vector

Subprograms
-----------


.. vhdl:function:: function to_tap_map(C : lfsr_coefficients; Map_length : positive; Reverse : boolean := false) return std_ulogic_vector;

   Convert a coefficient list to an expanded vector with a '1' in the place.
   of each coefficient.
  
  :param C: Coefficient definition list
  :type C: lfsr_coefficients
  :param Map_length: Size of the coefficient vector
  :type Map_length: positive
  :param Reverse: Reverse order of coefficients
  :type Reverse: boolean
  :returns: Vector of coefficients.
  


.. vhdl:function:: function lfsr_taps(Size : positive) return std_ulogic_vector;

   Lookup a predefined tap coefficients from the table.
  
  :param Size: Size of the coefficient vector
  :type Size: positive
  :returns: Vector of coefficients.
  


.. vhdl:function:: function next_galois_lfsr(State : std_ulogic_vector; Tap_map : std_ulogic_vector; Kind : lfsr_kind := normal; Full_cycle : boolean := false) return std_ulogic_vector;

   Iterate the next state in a Galois LFSR.
  
  :param State: Current state of the LFSR
  :type State: std_ulogic_vector
  :param Tap_map: Coefficient vector
  :type Tap_map: std_ulogic_vector
  :param Kind: Normal or inverted. Normal initializes with all ones.
  :type Kind: lfsr_kind
  :param Full_cycle: Generate a full 2**n cycle when true
  :type Full_cycle: boolean
  :returns: New state for the LFSR.
  


.. vhdl:function:: function next_fibonacci_lfsr(State : std_ulogic_vector; Tap_map : std_ulogic_vector; Kind : lfsr_kind := normal; Full_cycle : boolean := false) return std_ulogic_vector;

   Iterate the next state in a Fibonacci LFSR.
  
  :param State: Current state of the LFSR
  :type State: std_ulogic_vector
  :param Tap_map: Coefficient vector
  :type Tap_map: std_ulogic_vector
  :param Kind: Normal or inverted. Normal initializes with all ones.
  :type Kind: lfsr_kind
  :param Full_cycle: Generate a full 2**n cycle when true
  :type Full_cycle: boolean
  :returns: New state for the LFSR.
  

