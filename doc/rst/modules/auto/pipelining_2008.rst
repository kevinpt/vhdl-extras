.. Generated from ../rtl/extras_2008/pipelining_2008.vhdl on 2018-06-28 23:37:30.074654
.. vhdl:package:: extras_2008.pipelining


Components
----------


tapped_delay_line
~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: pipelining-tapped_delay_line

  component tapped_delay_line is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    REGISTER_FIRST_STAGE : boolean
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    --# {{data|}}
    Data : in std_ulogic_vector;
    Taps : out sulv_array
  );
  end component;

|


.. vhdl:entity:: tapped_delay_line

  Vector delay line with an output for each stage.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic REGISTER_FIRST_STAGE: Register or pass through the first stage
  :gtype REGISTER_FIRST_STAGE: boolean
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: Enable delay line
  :ptype Enable: in std_ulogic
  :port Data: Input to the delay line
  :ptype Data: in std_ulogic_vector
  :port Taps: Taps from each stage
  :ptype Taps: out sulv_array
