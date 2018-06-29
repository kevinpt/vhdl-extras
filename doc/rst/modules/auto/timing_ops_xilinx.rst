.. Generated from ../rtl/extras/timing_ops_xilinx.vhdl on 2018-06-28 23:37:28.823301
.. vhdl:package:: extras.timing_ops


Types
-----


.. vhdl:type:: time_rounding


Subtypes
--------


.. vhdl:subtype:: clock_cycles


.. vhdl:subtype:: duty_cycle


Constants
---------


.. vhdl:constant:: TIME_ROUND_STYLE


Subprograms
-----------


.. vhdl:function:: function resolution_limit return delay_length;

  Get the current simulation time resolution


.. vhdl:function:: function to_real(Tval : time) return real;

  Convert time to real time


.. vhdl:function:: function to_time(Rval : real) return time;

  Convert real time to time


.. vhdl:function:: function to_period(Freq : real) return delay_length;

  Convert real frequency to period


.. vhdl:function:: function to_clock_cycles(Secs : delay_length; Clock_freq : real; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;

  Compute clock cycles for the specified number of seconds using a clock
  frequency as the time base


.. vhdl:function:: function to_clock_cycles(Secs : real; Clock_freq : real; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;



.. vhdl:function:: function to_clock_cycles(Secs : delay_length; Clock_period : delay_length) return clock_cycles;

  Compute clock cycles for the specified number of seconds using a clock
  period as the time base


.. vhdl:function:: function to_clock_cycles(Secs : real; Clock_period : delay_length; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;



.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_freq : real) return delay_length;

  Calculate the time span represented by a number of clock cycles


.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_period : delay_length) return delay_length;



.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_freq : real) return real;



.. vhdl:procedure:: procedure report_time_precision(Identifier : in string; Cycles : in clock_cycles; Requested_secs : in real; Actual_secs : in real);

  Report statement for checking difference between requested time value
  and the output of to_clock_cycles


.. vhdl:procedure:: procedure report_time_precision(Identifier : in string; Cycles : in clock_cycles; Requested_secs : in time; Actual_secs : in time);



.. vhdl:procedure:: procedure clock_gen(Clock : out std_ulogic; Stop_clock : in boolean; Clock_period : in delay_length; Duty : duty_cycle := 0.5);

  Generate clock waveform for simulation only

