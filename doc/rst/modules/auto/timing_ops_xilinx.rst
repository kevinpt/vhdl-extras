.. Generated from ../rtl/extras/timing_ops_xilinx.vhdl on 2017-04-30 17:19:09.327234
.. vhdl:package:: timing_ops


Types
-----


.. vhdl:type:: time_rounding


Subtypes
--------


.. vhdl:subtype:: clock_cycles


.. vhdl:subtype:: duty_cycle


Subprograms
-----------


.. vhdl:function:: function resolution_limit return delay_length;

  Get the current simulation time resolution




.. vhdl:function:: function to_real(Tval : time) return real;

  Convert time to real time


  :param Tval: 
  :type Tval: time


.. vhdl:function:: function to_time(Rval : real) return time;

  Convert real time to time


  :param Rval: 
  :type Rval: real


.. vhdl:function:: function to_period(Freq : real) return delay_length;

  Convert real frequency to period


  :param Freq: 
  :type Freq: real


.. vhdl:function:: function to_clock_cycles(Secs : delay_length; Clock_freq : real; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;

  Compute clock cycles for the specified number of seconds using a clock
  frequency as the time base


  :param Secs: 
  :type Secs: delay_length
  :param Clock_freq: 
  :type Clock_freq: real
  :param round_style: 
  :type round_style: time_rounding


.. vhdl:function:: function to_clock_cycles(Secs : real; Clock_freq : real; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;



  :param Secs: 
  :type Secs: real
  :param Clock_freq: 
  :type Clock_freq: real
  :param round_style: 
  :type round_style: time_rounding


.. vhdl:function:: function to_clock_cycles(Secs : delay_length; Clock_period : delay_length) return clock_cycles;

  Compute clock cycles for the specified number of seconds using a clock
  period as the time base


  :param Secs: 
  :type Secs: delay_length
  :param Clock_period: 
  :type Clock_period: delay_length


.. vhdl:function:: function to_clock_cycles(Secs : real; Clock_period : delay_length; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;



  :param Secs: 
  :type Secs: real
  :param Clock_period: 
  :type Clock_period: delay_length
  :param round_style: 
  :type round_style: time_rounding


.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_freq : real) return delay_length;

  Calculate the time span represented by a number of clock cycles


  :param Cycles: 
  :type Cycles: clock_cycles
  :param Clock_freq: 
  :type Clock_freq: real


.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_period : delay_length) return delay_length;



  :param Cycles: 
  :type Cycles: clock_cycles
  :param Clock_period: 
  :type Clock_period: delay_length


.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_freq : real) return real;



  :param Cycles: 
  :type Cycles: clock_cycles
  :param Clock_freq: 
  :type Clock_freq: real


.. vhdl:procedure:: procedure report_time_precision(Identifier : in string; Cycles : in clock_cycles; Requested_secs : in real; Actual_secs : in real);

  Report statement for checking difference between requested time value
  and the output of to_clock_cycles


  :param Identifier: 
  :type Identifier: in string
  :param Cycles: 
  :type Cycles: in clock_cycles
  :param Requested_secs: 
  :type Requested_secs: in real
  :param Actual_secs: 
  :type Actual_secs: in real


.. vhdl:procedure:: procedure report_time_precision(Identifier : in string; Cycles : in clock_cycles; Requested_secs : in time; Actual_secs : in time);



  :param Identifier: 
  :type Identifier: in string
  :param Cycles: 
  :type Cycles: in clock_cycles
  :param Requested_secs: 
  :type Requested_secs: in time
  :param Actual_secs: 
  :type Actual_secs: in time


.. vhdl:procedure:: procedure clock_gen(Clock : out std_ulogic; Stop_clock : in boolean; Clock_period : in delay_length; Duty : duty_cycle := 0.5);

  Generate clock waveform for simulation only


  :param Clock: 
  :type Clock: out std_ulogic
  :param Stop_clock: 
  :type Stop_clock: in boolean
  :param Clock_period: 
  :type Clock_period: in delay_length
  :param Duty: 
  :type Duty: None duty_cycle

