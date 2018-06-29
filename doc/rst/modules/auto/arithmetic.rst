.. Generated from ../rtl/extras/arithmetic.vhdl on 2018-06-28 23:37:28.806720
.. vhdl:package:: extras.arithmetic


Components
----------


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
