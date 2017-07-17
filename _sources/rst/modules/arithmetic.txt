==========
arithmetic
==========

`extras/arithmetic.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/arithmetic.vhdl>`_

Dependencies
------------

:doc:`pipelining`

Description
-----------

This is an implementation of general purpose pipelined adder. It can be configured
for any number of stages and bit widths. The adder is divided into a number of slices
each of which is a conventional adder. The maximum carry chain length is reduced to
ceil(bit-length / slices).

.. parsed-literal:: 

  --[]-[]-[Slice]--> Sum_3
  --[]-[Slice]-[]--> Sum_2
  --[Slice]-[]-[]--> Sum_1


Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  -- 16-bit adder partitioned into 4 4-bit slices
  signal A, B, Sum : unsigned(15 downto 0);

  pa: pipelined_adder
    generic map (
      SLICES => 4,
      CONST_B_INPUT => false,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => clock,
      Reset => reset,

      A => A,
      B => B,

      Sum => Sum
    );


.. include:: auto/arithmetic.rst

