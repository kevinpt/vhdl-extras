==========
oscillator
==========

`extras/oscillator.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/oscillator.vhdl>`_


Dependencies
------------

:doc:`ddfs`,
:doc:`cordic`,
:doc:`sizing`,
:doc:`timing_ops`

Description
-----------

This package provides a set of components that implement arbitrary
sinusoidal frequency generators. They come in two variants. One generates
a fixed frequency that is specified at elaboration time as a generic
parameter. The other generates a dynamic frequency that can be altered
at run time. Each of these oscillator variants comes in two versions. One
is based around a pipelined CORDIC unit that produces new valid output on
every clock cycle. The other uses a more compact sequential CORDIC
implementation that takes multiple clock cycles to produce each output.

All oscillators output sine, cosine, the current phase angle, and a generated
clock at the target frequency.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  TODO

.. include:: auto/oscillator.rst

