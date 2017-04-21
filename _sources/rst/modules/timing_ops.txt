==========
timing_ops
==========

`extras/timing_ops.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/timing_ops.vhdl>`_

`extras/timing_ops_xilinx.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/timing_ops_xilinx.vhdl>`_

Dependencies
------------

:doc:`sizing <sizing>`

Description
-----------

This is a package of functions to perform calculations on time
and convert between different representations. The clock_gen procedures
can be used to create a clock signal for simulation.

A new physical type ``frequency`` is introduced and conversions between time,
frequency, and real (time and frequency) are provided. Functions to
convert from time in these three forms to integer ``clock_cycles`` are also
included. The conversion from time to real uses an integer intermediate
representation of time. It is designed to compensate for tools that use
64-bit time and 32-bit integers but only 31-bits of precision will be
maintained in such cases.

For all conversion functions, real values of time are expressed in units
of seconds and real frequencies are in 1/sec. e.g. 1 ns = 1.0e-9,
1 MHz = 1.0e6.

User defined physical types are limited to the range of ``integer``. On 32-bit
platforms ``frequency'high`` = (2**31)-1 Hz = 2.14 GHz. Real numbers must be
used to represent higher frequencies.

The ``to_clock_cycles`` functions can introduce rounding errors and produce a
result that is different from what would be expected assuming infinite
precision. The magnitude of any errors will depend on how close the
converted time is to the clock period. To assist in controlling the
errors, a ``rounding_style`` parameter is available on all forms of
``to_clock_cycles`` that use real as an intermediate type for the calculation.
It is set by default to round up toward infinity in anticipation that
these functions will most often be used to compute the minium number of
cycles for a delay. You can override this behavior to either round down or
maintain normal round to nearest for the conversion from ``real`` to
``clock_cycles``.

To help detect the effect of rounding errors the ``time_duration`` and
``report_time_precision`` routines can be used in simulation to indicate
deviation from the requested time span.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  library extras; use extras.sizing.bit_size; use extras.timing_ops.all;

  constant SYS_CLOCK_FREQ : frequency := 50 MHz;
  constant COUNT_1US : clock_cycles
    := to_clock_cycles(1 us, SYS_CLOCK_FREQ);
  signal   counter   : unsigned(bit_size(COUNT_1US)-1 downto 0);
  ...
  counter <= to_unsigned(COUNT_1US, counter'length); -- initialize counter
  report_time_precision("COUNT_1US", COUNT_1US, 1 us,
    time_duration(COUNT_1US, SYS_CLOCK_FREQ));

The value of the ``COUNT_1US`` constant will change to reflect any change in
the system clock frequency and the size of the signal ``counter`` will now
automatically adapt to guarantee it can represent the count for 1 us.

The ``clock_gen`` procedure can be called from a process to generate a clock
in simulation with the requested frequency or period and an optional duty
cycle specification:

.. code-block:: vhdl

  sys_clock_gen: process
  begin
    clock_gen(sys_clock, stop_clock, SYS_CLOCK_FREQ);
    wait;
  end process;


    
.. include:: auto/timing_ops.rst

