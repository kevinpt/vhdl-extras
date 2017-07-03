================
glitch_filtering
================

`extras/glitch_filtering.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/glitch_filtering.vhdl>`_


Dependencies
------------

:doc:`sizing`

Description
-----------

This package provides glitch filter components that can be used to remove
noise from digital input signals. This can be useful for debouncing
switches directly connected to a device.
The :vhdl:entity:`~extras.glitch_filtering.glitch_filter` component works
with a single ``std_ulogic`` signal while
:vhdl:entity:`~extras.glitch_filtering.array_glitch_filter` provides
filtering for a ``std_ulogic_vector``. These components include synchronizing
flip-flops and can be directly tied to input pads.

It is assumed that the signal being recovered changes relatively slowly
compared to the clock period. These filters come in two forms. One is
controlled by a generic ``FILTER_CYCLES`` and the other dynamic versions (:vhdl:entity:`~extras.glitch_filtering.dynamic_glitch_filter` and
:vhdl:entity:`~extras.glitch_filtering.dynamic_array_glitch_filter`) have
a port signal ``Filter_cycles``. These controls indicate the number of clock cycles
the input(s) must remain stable before the filtered output register(s) are
updated. The filtered output will lag the inputs by ``Filter_cycles`` + 3 clock
cycles. The dynamic versions can have their filter delay changed at any
time if their ``Filter_cycles`` input is connected to a signal. The minimum
pulse width that will pass through the filter will be ``Filter_cycles`` + 1
clock cycles wide.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  library extras;
  use extras.glitch_filtering.all; use extras.timing_ops.all;
  ...
  constant CLOCK_FREQ    : frequency    := 100 MHz;
  constant FILTER_TIME   : delay_length := 200 ns;
  constant FILTER_CYCLES : clock_cycles :=
    to_clock_cycles(FILTER_TIME, CLOCK_FREQ);
  ...
  gf: glitch_filter
    generic map (
      FILTER_CYCLES => FILTER_CYCLES
    ) port map (
      Clock    => clock,
      Reset    => reset,
      Noisy    => noisy,
      Filtered => filtered
    );

Xilinx XST doesn't support user defined physical types so the :vhdl:type:`~extras.timing_ops.frequency`
type from timing_ops.vhdl can't be used with that synthesizer. An alternate
solution using XST-compatible :doc:`timing_ops_xilinx.vhdl <timing_ops>` follows:

.. code-block:: vhdl

  constant CLOCK_FREQ    : real         := 100.0e6; -- Using real in place of frequency
  constant FILTER_TIME   : delay_length := 200 ns;
  constant FILTER_CYCLES : clock_cycles :=
    to_clock_cycles(FILTER_TIME, CLOCK_FREQ)
  ...

    
.. include:: auto/glitch_filtering.rst

