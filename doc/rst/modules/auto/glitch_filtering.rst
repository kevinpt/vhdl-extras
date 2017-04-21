.. Generated from ../rtl/extras/glitch_filtering.vhdl on 2017-04-20 23:04:37.082767
.. vhdl:package:: glitch_filtering


Components
----------


glitch_filter
~~~~~~~~~~~~~

.. symbolator::

  component glitch_filter is
  generic (
    FILTER_CYCLES : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Noisy : in std_ulogic;
    Filtered : out std_ulogic
  );
  end component;

|

Basic glitch filter with a constant filter delay
This version filters a single signal of std_ulogic

|


.. vhdl:entity:: glitch_filter

  :generic FILTER_CYCLES: 
  :gtype FILTER_CYCLES: positive
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Noisy: 
  :ptype Noisy: in std_ulogic
  :port Filtered: 
  :ptype Filtered: out std_ulogic

dynamic_glitch_filter
~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component dynamic_glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Filter_cycles : in unsigned;
    Noisy : in std_ulogic;
    Filtered : out std_ulogic
  );
  end component;

|

Glitch filter with a dynamically alterable filter delay
This version filters a single signal of std_ulogic  component dynamic_glitch_filter is

|


.. vhdl:entity:: dynamic_glitch_filter

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Filter_cycles: 
  :ptype Filter_cycles: in unsigned
  :port Noisy: 
  :ptype Noisy: in std_ulogic
  :port Filtered: 
  :ptype Filtered: out std_ulogic

array_glitch_filter
~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component array_glitch_filter is
  generic (
    FILTER_CYCLES : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Foo : inout std_logic;
    Noisy : in std_ulogic_vector;
    Filtered : out std_ulogic_vector;
    Bar : inout unsigned
  );
  end component;

|

Basic glitch filter with a constant filter delay
This version filters an array of std_ulogic

|


.. vhdl:entity:: array_glitch_filter

  :generic FILTER_CYCLES: 
  :gtype FILTER_CYCLES: positive
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Foo: 
  :ptype Foo: inout std_logic
  :port Noisy: 
  :ptype Noisy: in std_ulogic_vector
  :port Filtered: 
  :ptype Filtered: out std_ulogic_vector
  :port Bar: 
  :ptype Bar: inout unsigned

dynamic_array_glitch_filter
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component dynamic_array_glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Filter_cycles : in unsigned;
    Noisy : in std_ulogic_vector;
    Filtered : out std_ulogic_vector
  );
  end component;

|

Glitch filter with a dynamically alterable filter delay
This version filters an array of std_ulogic

|


.. vhdl:entity:: dynamic_array_glitch_filter

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Filter_cycles: 
  :ptype Filter_cycles: in unsigned
  :port Noisy: 
  :ptype Noisy: in std_ulogic_vector
  :port Filtered: 
  :ptype Filtered: out std_ulogic_vector
