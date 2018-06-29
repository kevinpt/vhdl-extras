.. Generated from ../rtl/extras/glitch_filtering.vhdl on 2018-06-28 23:37:28.660046
.. vhdl:package:: extras.glitch_filtering


Components
----------


glitch_filter
~~~~~~~~~~~~~

.. symbolator::
  :name: glitch_filtering-glitch_filter

  component glitch_filter is
  generic (
    FILTER_CYCLES : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Noisy : in std_ulogic;
    Filtered : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: glitch_filter

  Basic glitch filter with a constant filter delay
  This version filters a single signal of std_ulogic
  
  :generic FILTER_CYCLES: Number of clock cycles to filter
  :gtype FILTER_CYCLES: positive
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Noisy: Noisy input signal
  :ptype Noisy: in std_ulogic
  :port Filtered: Filtered output
  :ptype Filtered: out std_ulogic

dynamic_glitch_filter
~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: glitch_filtering-dynamic_glitch_filter

  component dynamic_glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Filter_cycles : in unsigned;
    --# {{data|}}
    Noisy : in std_ulogic;
    Filtered : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: dynamic_glitch_filter

  Glitch filter with a dynamically alterable filter delay
  This version filters a single signal of std_ulogic  component dynamic_glitch_filter is
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Filter_cycles: Number of clock cycles to filter
  :ptype Filter_cycles: in unsigned
  :port Noisy: Noisy input signal
  :ptype Noisy: in std_ulogic
  :port Filtered: Filtered output
  :ptype Filtered: out std_ulogic

array_glitch_filter
~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: glitch_filtering-array_glitch_filter

  component array_glitch_filter is
  generic (
    FILTER_CYCLES : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Noisy : in std_ulogic_vector;
    Filtered : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: array_glitch_filter

  Basic glitch filter with a constant filter delay
  This version filters an array of std_ulogic
  
  :generic FILTER_CYCLES: Number of clock cycles to filter
  :gtype FILTER_CYCLES: positive
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Noisy: Noisy input signals
  :ptype Noisy: in std_ulogic_vector
  :port Filtered: Filtered output
  :ptype Filtered: out std_ulogic_vector

dynamic_array_glitch_filter
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: glitch_filtering-dynamic_array_glitch_filter

  component dynamic_array_glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Filter_cycles : in unsigned;
    --# {{data|}}
    Noisy : in std_ulogic_vector;
    Filtered : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: dynamic_array_glitch_filter

  Glitch filter with a dynamically alterable filter delay
  This version filters an array of std_ulogic
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Filter_cycles: Number of clock cycles to filter
  :ptype Filter_cycles: in unsigned
  :port Noisy: Noisy input signals
  :ptype Noisy: in std_ulogic_vector
  :port Filtered: Filtered output
  :ptype Filtered: out std_ulogic_vector
