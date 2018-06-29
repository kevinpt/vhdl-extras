.. Generated from ../rtl/extras/arithmetic.vhdl on 2017-08-02 00:26:38.024403
.. vhdl:package:: extras.arithmetic


Components
----------


coloration_test
~~~~~~~~~~~~~~~

.. symbolator::
  :name: arithmetic-coloration_test

  component coloration_test is
  port (
    --# {{aaa}}
    aaa : in std_ulogic;
    --# {{bbb}}
    bbb : in std_ulogic;
    --# {{ccc}}
    ccc : out std_ulogic;
    --# {{ddd}}
    ddd : out std_ulogic;
    --# {{eee}}
    eee : inout std_ulogic;
    --# {{fff}}
    fff : in std_ulogic
  );
  end component;

|


.. vhdl:entity:: coloration_test

  
  :port aaa: None
  :ptype aaa: in std_ulogic
  :port bbb: None
  :ptype bbb: in std_ulogic
  :port ccc: None
  :ptype ccc: out std_ulogic
  :port ddd: None
  :ptype ddd: out std_ulogic
  :port eee: None
  :ptype eee: inout std_ulogic
  :port fff: None
  :ptype fff: in std_ulogic

pipelined_adder
~~~~~~~~~~~~~~~

.. symbolator::
  :name: arithmetic-pipelined_adder

  component pipelined_adder is
  generic (
    SLICES : positive;
    CONST_B_INPUT : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    A : in unsigned;
    B : in unsigned;
    Sum : out unsigned
  );
  end component;

|


.. vhdl:entity:: pipelined_adder

  Variable size pipelined adder.
  
  :generic SLICES: Number of pipeline stages
  :gtype SLICES: positive
  :generic CONST_B_INPUT: Optimize when the B input is constant
  :gtype CONST_B_INPUT: boolean
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port A: Addend A
  :ptype A: in unsigned
  :port B: Addend B
  :ptype B: in unsigned
  :port Sum: Result sum of A and B
  :ptype Sum: out unsigned
