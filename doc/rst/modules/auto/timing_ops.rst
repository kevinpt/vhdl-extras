.. Generated from ../rtl/extras/timing_ops.vhdl on 2018-06-28 23:37:28.795715
.. vhdl:package:: extras.timing_ops


Types
-----


.. vhdl:type:: frequency

  Frequency physical type.

.. vhdl:type:: time_rounding

  Rounding modes.

Subtypes
--------


.. vhdl:subtype:: clock_cycles

  Clock cycle count.

.. vhdl:subtype:: duty_cycle

  Duty cycle ranging from 0 to 1.0.

Constants
---------


.. vhdl:constant:: TIME_ROUND_STYLE

  Default rounding mode. Round to nearest.

Subprograms
-----------


.. vhdl:function:: function resolution_limit return delay_length;

   Get the current simulation time resolution.
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable min_time : time := resolution_limit;
     ...
     wait for min_time;
  


.. vhdl:function:: function to_real(Tval : time) return real;

   Convert time to real time.
  
  :param Tval: Time to convert
  :type Tval: time
  :returns: Time converted to a real in units of seconds.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable rtime : real;
     rtime := to_real(now);
  


.. vhdl:function:: function to_time(Rval : real) return time;

   Convert real time to time.
  
  :param Rval: Time to convert
  :type Rval: real
  :returns: Real converted to time.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable itime : time;
     itime := to_time(1.0e-6);
  


.. vhdl:function:: function to_period(Freq : frequency) return delay_length;

   Convert frequency to period.
  
  :param Freq: Frequency to convert
  :type Freq: frequency
  :returns: Inverse of the frequency.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable period : delay_length;
     period := to_period(10 MHz);
  


.. vhdl:function:: function to_period(Freq : real) return delay_length;

   Convert real frequency to period.
  
  :param Freq: Frequency to convert
  :type Freq: real
  :returns: Inverse of the frequency.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable period : delay_length;
     period := to_period(10.0e6);
  


.. vhdl:function:: function to_real(Freq : frequency) return real;

   Convert frequency to real frequency.
  
  :param Freq: Frequency to convert
  :type Freq: frequency
  :returns: Real frequency.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable rfreq : real;
     rfreq := to_real(10 MHz);
  


.. vhdl:function:: function to_frequency(Period : delay_length) return frequency;

   Convert period to frequency.
  
  :param Period: Period to convert
  :type Period: delay_length
  :returns: Inverse of the period.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable freq : frequency;
     freq := to_frequency(1 us);
  


.. vhdl:function:: function to_frequency(Period : real) return frequency;

   Convert real period to frequency.
  
  :param Period: Period to convert
  :type Period: real
  :returns: Inverse of the period.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     variable freq : frequency;
     freq := to_frequency(1.0e-6);
  


.. vhdl:function:: function to_clock_cycles(Secs : delay_length; Clock_freq : frequency; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;

   Compute clock cycles for the specified number of seconds using a clock
   frequency as the time base.
  
  :param Secs: Time to convert to cycles
  :type Secs: delay_length
  :param Clock_freq: Frequency of the clock
  :type Clock_freq: frequency
  :param round_style: Optional rounding mode
  :type round_style: time_rounding
  :returns: Time converted into integral cycles.
  


.. vhdl:function:: function to_clock_cycles(Secs : delay_length; Clock_freq : real; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;

   Compute clock cycles for the specified number of seconds using a real clock
   frequency as the time base.
  
  :param Secs: Time to convert to cycles
  :type Secs: delay_length
  :param Clock_freq: Frequency of the clock
  :type Clock_freq: real
  :param round_style: Optional rounding mode
  :type round_style: time_rounding
  :returns: Time converted into integral cycles.
  


.. vhdl:function:: function to_clock_cycles(Secs : real; Clock_freq : real; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;

   Compute clock cycles for the specified number of real seconds using a real clock
   frequency as the time base.
  
  :param Secs: Time to convert to cycles
  :type Secs: real
  :param Clock_freq: Frequency of the clock
  :type Clock_freq: real
  :param round_style: Optional rounding mode
  :type round_style: time_rounding
  :returns: Time converted into integral cycles.
  


.. vhdl:function:: function to_clock_cycles(Secs : real; Clock_freq : frequency; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;

   Compute clock cycles for the specified number of real seconds using a clock
   frequency as the time base.
  
  :param Secs: Time to convert to cycles
  :type Secs: real
  :param Clock_freq: Frequency of the clock
  :type Clock_freq: frequency
  :param round_style: Optional rounding mode
  :type round_style: time_rounding
  :returns: Time converted into integral cycles.
  


.. vhdl:function:: function to_clock_cycles(Secs : delay_length; Clock_period : delay_length) return clock_cycles;

   Compute clock cycles for the specified number of seconds using a clock
   period as the time base.
  
  :param Secs: Time to convert to cycles
  :type Secs: delay_length
  :param Clock_period: Period of the clock
  :type Clock_period: delay_length
  :returns: Time converted into integral cycles.
  


.. vhdl:function:: function to_clock_cycles(Secs : real; Clock_period : delay_length; round_style : time_rounding := TIME_ROUND_STYLE) return clock_cycles;

   Compute clock cycles for the specified number of real seconds using a clock
   period as the time base.
  
  :param Secs: Time to convert to cycles
  :type Secs: real
  :param Clock_period: Period of the clock
  :type Clock_period: delay_length
  :returns: Time converted into integral cycles.
  


.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_freq : real) return delay_length;

   Calculate the time span represented by a number of clock cycles.
  
  :param Cycles: Number of cycles to convert
  :type Cycles: clock_cycles
  :param Clock_freq: Frequency of the clock
  :type Clock_freq: real
  :returns: Cycles converted into time.
  


.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_period : delay_length) return delay_length;

   Calculate the time span represented by a number of clock cycles.
  
  :param Cycles: Number of cycles to convert
  :type Cycles: clock_cycles
  :param Clock_period: Period of the clock
  :type Clock_period: delay_length
  :returns: Cycles converted into time.
  


.. vhdl:function:: function time_duration(Cycles : clock_cycles; Clock_freq : real) return real;

   Calculate the real time span represented by a number of clock cycles.
  
  :param Cycles: Number of cycles to convert
  :type Cycles: clock_cycles
  :param Clock_freq: Frequency of the clock
  :type Clock_freq: real
  :returns: Cycles converted into real time.
  


.. vhdl:procedure:: procedure report_time_precision(Identifier : in string; Cycles : in clock_cycles; Requested_secs : in real; Actual_secs : in real);

   Report statement for checking difference between requested time value
   and the output of to_clock_cycles().
  
  :param Identifier: User specified name included in report
  :type Identifier: in string
  :param Cycles: Output of to_clock_cycles()
  :type Cycles: in clock_cycles
  :param Requested_secs: Input passed to to_clock_cycles()
  :type Requested_secs: in real
  :param Actual_secs: Output from time_duration()
  :type Actual_secs: in real


.. vhdl:procedure:: procedure report_time_precision(Identifier : in string; Cycles : in clock_cycles; Requested_secs : in time; Actual_secs : in time);

   Report statement for checking difference between requested time value
   and the output of to_clock_cycles().
  
  :param Identifier: User specified name included in report
  :type Identifier: in string
  :param Cycles: Output of to_clock_cycles()
  :type Cycles: in clock_cycles
  :param Requested_secs: Input passed to to_clock_cycles()
  :type Requested_secs: in time
  :param Actual_secs: Output from time_duration()
  :type Actual_secs: in time


.. vhdl:procedure:: procedure clock_gen(Clock : out std_ulogic; Stop_clock : in boolean; Clock_freq : in frequency; Duty : in duty_cycle := 0.5);

   Generate clock waveform for simulation only.
  
  :param Clock: Generated clock signal
  :type Clock: out std_ulogic
  :param Stop_clock: Control signal that exits procedure when true
  :type Stop_clock: in boolean
  :param Clock_freq: Frequency of the generated clock
  :type Clock_freq: in frequency
  :param Duty: Optional duty cycle of the generated clock (0.0 to 1.0)
  :type Duty: in duty_cycle


.. vhdl:procedure:: procedure clock_gen(Clock : out std_ulogic; Stop_clock : in boolean; Clock_period : in delay_length; Duty : in duty_cycle := 0.5);

   Generate clock waveform for simulation only.
  
  :param Clock: Generated clock signal
  :type Clock: out std_ulogic
  :param Stop_clock: Control signal that exits procedure when true
  :type Stop_clock: in boolean
  :param Clock_period: Period of the generated clock
  :type Clock_period: in delay_length
  :param Duty: Optional duty cycle of the generated clock (0.0 to 1.0)
  :type Duty: in duty_cycle

