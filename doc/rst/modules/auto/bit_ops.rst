.. Generated from ../rtl/extras/bit_ops.vhdl on 2017-04-30 17:19:09.451734
.. vhdl:package:: bit_ops


Types
-----


.. vhdl:type:: natural_vector


Components
----------


count_ones
~~~~~~~~~~

.. symbolator::

  component count_ones is
  port (
    Value : in unsigned;
    Ones_count : out unsigned
  );
  end component;

|


.. vhdl:entity:: count_ones



  :port Value: 
  :ptype Value: in unsigned
  :port Ones_count: 
  :ptype Ones_count: out unsigned

count_ones_chunked
~~~~~~~~~~~~~~~~~~

.. symbolator::

  component count_ones_chunked is
  generic (
    TABLE_BITS : positive
  );
  port (
    Value : in unsigned;
    Ones_count : out unsigned
  );
  end component;

|


.. vhdl:entity:: count_ones_chunked



  :generic TABLE_BITS: 
  :gtype TABLE_BITS: positive
  :port Value: 
  :ptype Value: in unsigned
  :port Ones_count: 
  :ptype Ones_count: out unsigned

count_ones_sequential
~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component count_ones_sequential is
  generic (
    TABLE_BITS : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Start : in std_ulogic;
    Busy : out std_ulogic;
    Done : out std_ulogic;
    Value : in unsigned;
    Ones_count : out unsigned
  );
  end component;

|


.. vhdl:entity:: count_ones_sequential



  :generic TABLE_BITS: 
  :gtype TABLE_BITS: positive
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Start: 
  :ptype Start: in std_ulogic
  :port Busy: 
  :ptype Busy: out std_ulogic
  :port Done: 
  :ptype Done: out std_ulogic
  :port Value: 
  :ptype Value: in unsigned
  :port Ones_count: 
  :ptype Ones_count: out unsigned

Subprograms
-----------


.. vhdl:function:: function gen_count_ones_table(Size : positive) return natural_vector;



  :param Size: 
  :type Size: positive

