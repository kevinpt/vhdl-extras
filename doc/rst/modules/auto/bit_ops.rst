.. Generated from ../rtl/extras/bit_ops.vhdl on 2018-06-28 23:37:29.004041
.. vhdl:package:: extras.bit_ops


Types
-----


.. vhdl:type:: natural_vector

  Vector of natural numbers.

Components
----------


count_ones
~~~~~~~~~~

.. symbolator::
  :name: bit_ops-count_ones

  component count_ones is
  port (
    --# {{data|}}
    Value : in unsigned;
    Ones_count : out unsigned
  );
  end component;

|


.. vhdl:entity:: count_ones

  Count the number of set bits in a vector.
  
  :port Value: Vector to count set bits
  :ptype Value: in unsigned
  :port Ones_count: Number of set bits in ``Value``
  :ptype Ones_count: out unsigned

count_ones_chunked
~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: bit_ops-count_ones_chunked

  component count_ones_chunked is
  generic (
    TABLE_BITS : positive
  );
  port (
    --# {{data|}}
    Value : in unsigned;
    Ones_count : out unsigned
  );
  end component;

|


.. vhdl:entity:: count_ones_chunked

  Count the number of set bits in a vector with a reduced constant table.
  
  :generic TABLE_BITS: Number of bits for constant table
  :gtype TABLE_BITS: positive
  
  :port Value: Vector to count set bits
  :ptype Value: in unsigned
  :port Ones_count: Number of set bits in ``Value``
  :ptype Ones_count: out unsigned

count_ones_sequential
~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: bit_ops-count_ones_sequential

  component count_ones_sequential is
  generic (
    TABLE_BITS : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Start : in std_ulogic;
    Busy : out std_ulogic;
    Done : out std_ulogic;
    --# {{data|}}
    Value : in unsigned;
    Ones_count : out unsigned
  );
  end component;

|


.. vhdl:entity:: count_ones_sequential

  Count the number of set bits in a vector with a reduced constant table.
  
  :generic TABLE_BITS: Number of bits for constant table
  :gtype TABLE_BITS: positive
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Start: Start counting
  :ptype Start: in std_ulogic
  :port Busy: Count is in progress
  :ptype Busy: out std_ulogic
  :port Done: Count is done
  :ptype Done: out std_ulogic
  :port Value: Vector to count set bits
  :ptype Value: in unsigned
  :port Ones_count: Number of set bits in ``Value``
  :ptype Ones_count: out unsigned

Subprograms
-----------


.. vhdl:function:: function gen_count_ones_table(Size : positive) return natural_vector;

   Create a precomputed table of bit counts.
  
  :param Size: Number of bits in vector
  :type Size: positive
  :returns: Array of bit count values with 2**Size entries.
  

