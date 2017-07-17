=======
bit_ops
=======

`extras/bit_ops.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/bit_ops.vhdl>`_


Dependencies
------------

:doc:`sizing <sizing>`

Description
-----------

This package provides components that count the number of set bits in a
vector. Multiple implementations are available with different performance
characteristics. 

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  signal value : unsigned(11 downto 0);
  signal ones_count : unsigned(bit_size(value'length)-1 downto 0);

  -- Basic combinational circuit:
  basic: count_ones
    port map (
      Value => value,
      Ones_count => ones_count
    );

  -- Chunked combinational circuit:
  basic: count_ones_chunked
    generic map (
      TABLE_BITS => 4 -- Constant table with 16 entries
    )
    port map (
      Value => value,
      Ones_count => ones_count
    );

  -- Chunked sequential circuit:
  basic: count_ones_chunked
    generic map (
      TABLE_BITS => 4 -- Constant table with 16 entries
    )
    port map (
      Clock => clock,
      Reset => reset,

      Start => start,
      Busy => busy,
      Done  => done,

      Value => value,
      Ones_count => ones_count
    );


.. include:: auto/bit_ops.rst

