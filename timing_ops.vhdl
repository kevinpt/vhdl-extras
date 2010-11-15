--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# timing_ops.vhdl - Routines for time calculations
--# $Id$
--# Freely available from VHDL-extras (http://vhdl-extras.org)
--#
--# Copyright © 2010 Kevin Thibedeau
--#
--# Permission is hereby granted, free of charge, to any person obtaining a
--# copy of this software and associated documentation files (the "Software"),
--# to deal in the Software without restriction, including without limitation
--# the rights to use, copy, modify, merge, publish, distribute, sublicense,
--# and/or sell copies of the Software, and to permit persons to whom the
--# Software is furnished to do so, subject to the following conditions:
--#
--# The above copyright notice and this permission notice shall be included in
--# all copies or substantial portions of the Software.
--#
--# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--# DEALINGS IN THE SOFTWARE.
--#
--# DEPENDENCIES: sizing
--#
--# DESCRIPTION:
--#  This is a package of functions to perform calculations on time
--#  and convert between different representations. The clock_gen procedures
--#  can be used to create a clock signal for simulation.
--#
--#  NOTE: The to_clock_cycles functions can introduce rounding errors
--#  and produce a result that is slightly different from what would be
--#  expected assuming infinite precision. The magnitude of any errors
--#  will be small but they can accumulate over time if the results are
--#  used repetitively as in a delay counter. To help detect this situation
--#  the time_duration and report_time_precision routines can be used in
--#  simulation to indicate deviation from the requested time span.
--#
--# EXAMPLE USAGE:
--#  library extras; use extras.sizing.bit_size; use extras.timing_ops.all;
--#
--#    constant : SYS_CLOCK_FREQ : frequency := 50 MHz;
--#    constant : COUNT_1US : clock_cycles
--#      := to_clock_cycles(1 us, SYS_CLOCK_FREQ);
--#    signal   : counter   : unsigned(bit_size(COUNT_1US)-1 downto 0);
--#    ...
--#    counter <= to_unsigned(COUNT_1US, counter'length); -- initialize counter
--#    report_time_precision("COUNT_1US", COUNT_1US, 1 us,
--#      time_duration(COUNT_1US, SYS_CLOCK_FREQ));
--#
--#  The value of the "COUNT_1US" constant will change to reflect any change in
--#  the system clock frequency and the size of the signal "counter" will now
--#  automatically adapt to guarantee it can represent the count for 1 us.
--#
--#  The clock_gen procedure can be called from a process to generate a clock
--#  in simulation with the requested frequency or period and an optional duty
--#  cycle specification:
--#
--#    sys_clock_gen: process
--#    begin
--#      clock_gen(sys_clock, stop_clock, SYS_CLOCK_FREQ);
--#      wait;
--#    end process;
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package timing_ops is
  subtype clock_cycles is natural;

  type frequency is range 0 to integer'high units
    Hz;
    kHz = 1000 Hz;
    MHz = 1000 kHz;
    GHz = 1000 MHz;
  end units;

  --## Convert time to real
  function to_real( Tval : time ) return real;
  
  --## Convert frequency to real
  function to_real( Freq : frequency ) return real;

  --## Convert period to frequency
  function to_frequency( Period : delay_length ) return frequency;

  --## Convert frequency to period
  function to_period( Freq : frequency ) return delay_length;

  --## Convert frequency to period
  function to_period( Freq : real ) return delay_length;

  --## Compute clock cycles for the specified number of seconds using a clock
  --#  frequency as the time base
  function to_clock_cycles( Secs : delay_length; Clock_freq : frequency )
    return clock_cycles;
  function to_clock_cycles( Secs : delay_length; Clock_freq : real ) return clock_cycles;
  function to_clock_cycles( Secs : real; Clock_freq : real ) return clock_cycles;
  function to_clock_cycles( Secs : real; Clock_freq : frequency ) return clock_cycles;

  --## Compute clock cycles for the specified number of seconds using a clock
  --#  period as the time base
  function to_clock_cycles( Secs : delay_length; Clock_period : delay_length )
    return clock_cycles;
  function to_clock_cycles( Secs : real; Clock_period : delay_length )
    return clock_cycles;

  --## Calculate the time span represented by a number of clock cycles
  function time_duration( Cycles : clock_cycles; Clock_freq : real )
    return delay_length;
  function time_duration( Cycles : clock_cycles; Clock_period : delay_length )
    return delay_length;
  function time_duration( Cycles : clock_cycles; Clock_freq : real )
    return real;

  --## Report statement for checking difference between requested time value
  --#  and the output of to_clock_cycles
  procedure report_time_precision( Identifier : in string; Cycles : in clock_cycles;
    Requested_secs : in real; Actual_secs : in real );

  procedure report_time_precision( Identifier : in string; Cycles : in clock_cycles;
    Requested_secs : in time; Actual_secs : in time );


  subtype duty_cycle is real range 0.0 to 1.0;

  --## Generate clock waveform for simulation only
  procedure clock_gen( signal Clock : out std_ulogic; signal Stop_clock : in boolean;
    constant Clock_freq : in frequency; constant Duty : duty_cycle := 0.5 );

  procedure clock_gen( signal Clock : out std_ulogic; signal Stop_clock : in boolean;
    constant Clock_period : in delay_length; constant Duty : duty_cycle := 0.5 );
end package;


library extras;
use extras.sizing.ceil_log;

package body timing_ops is

-- PRIVATE functions:
-- ==================

  type time_resolution is record
    tval : time;
    rval : real;
  end record;

  type time_vector is array( natural range <>) of time_resolution;

  constant BASE_TIME_ARRAY : time_vector := (
     (1 fs, 1.0e-15),  (10 fs, 1.0e-14),  (100 fs, 1.0e-13),
     (1 ps, 1.0e-12),  (10 ps, 1.0e-11),  (100 ps, 1.0e-10),
     (1 ns, 1.0e-9),   (10 ns, 1.0e-8),   (100 ns, 1.0e-7),
     (1 us, 1.0e-6),   (10 us, 1.0e-5),   (100 us, 1.0e-4),
     (1 ms, 1.0e-3),   (10 ms, 1.0e-2),   (100 ms, 1.0e-1),
     (1 sec, 1.0),     (10 sec, 1.0e1),   (100 sec, 1.0e2),
     (1 min, 60.0),    (10 min, 60.0e1),  (100 min, 60.0e2),
     (1 hr, 3600.0),   (10 hr, 3600.0e1), (100 hr, 3600.0e2)
  );

  --// Determine the resolution for time
  --/   (Adapted from VHDL-2008 std.env package)
  function resolution_limit return time_resolution is
  begin
    for i in BASE_TIME_ARRAY'range loop
      if BASE_TIME_ARRAY(i).tval > 0 hr then
        return BASE_TIME_ARRAY(i);
      end if;
    end loop;

    report "Simulator resolution is no less than 100 hr"
      severity failure;

    return time_resolution'(1 ns, 1.0e-9);
  end function;


-- PUBLIC functions:
-- =================

  --## Convert time to real
  function to_real( Tval : time ) return real is
    variable min_time : time_resolution := resolution_limit;
    variable scale    : positive;
  begin
    -- Make adjustment to min_time values to avoid overflow upon conversion
    -- from time to integer. This takes care of simulators with 64-bit time and
    -- 32-bit integers.
    if Tval > (integer'high * min_time.tval) then
      scale := ceil_log(Tval / (integer'high * min_time.tval), 10);
      min_time := (min_time.tval * 10**scale, min_time.rval * 10.0**scale);
    end if;

    return real(Tval / min_time.tval) * min_time.rval;
  end function;

  --## Convert frequency to real
  function to_real( Freq : frequency ) return real is
  begin
    return real(Freq / Hz);
  end function;


  --## Convert period to frequency
  function to_frequency( Period : delay_length ) return frequency is
  begin
    return 1 Hz / to_real(Period);
  end function;


  --## Convert frequency to period
  function to_period( Freq : frequency ) return delay_length is
  begin
    return 1 sec / (Freq / Hz);
  end function;

  --## Convert frequency to period
  function to_period( Freq : real ) return delay_length is
  begin
    return 1 sec / natural(Freq);
  end function;


  --## Compute clock cycles for the specified number of seconds using a clock
  --#  frequency as the time base
  function to_clock_cycles( Secs : delay_length; Clock_freq : frequency )
    return clock_cycles is
  begin
    return clock_cycles(to_real(Secs) * real(Clock_freq / Hz));
  end function;

  function to_clock_cycles( Secs : delay_length; Clock_freq : real )
    return clock_cycles is
  begin
    return clock_cycles(to_real(Secs) * Clock_freq);
  end function;

  function to_clock_cycles( Secs : real; Clock_freq : real ) return clock_cycles is
  begin
    return clock_cycles(Secs * Clock_freq);
  end function;

  function to_clock_cycles( Secs : real; Clock_freq : frequency ) return clock_cycles is
  begin
    return clock_cycles(Secs * real(Clock_freq / Hz));
  end function;


  --## Compute clock cycles for the specified number of seconds using a clock
  --#  period as the time base
  function to_clock_cycles( Secs : delay_length; Clock_period : delay_length )
    return clock_cycles is
  begin
    return clock_cycles(Secs / Clock_period);
  end function;

  function to_clock_cycles( Secs : real; Clock_period : delay_length )
    return clock_cycles is
  begin
    return clock_cycles(Secs / to_real(Clock_period));
  end function;


  --## Calculate the time span represented by a number of clock cycles
  function time_duration( Cycles : clock_cycles; Clock_freq : real )
    return delay_length is
  begin
    return (real(Cycles) / Clock_freq) * 1 sec;
  end function;

  function time_duration( Cycles : clock_cycles; Clock_period : delay_length )
    return delay_length is
  begin
    return Cycles * Clock_period;
  end function;

  function time_duration( Cycles : clock_cycles; Clock_freq : real ) return real is
  begin
    return real(Cycles) / Clock_freq;
  end function;


  --## Report statement for checking difference between requested time value
  --#  and the output of to_clock_cycles
  procedure report_time_precision( Identifier : in string; Cycles : in clock_cycles;
    Requested_secs : in real; Actual_secs : in real ) is
  begin
    report "Timing precision for: " & Identifier & lf &
      "  Clock cycles:   " & clock_cycles'image(Cycles) & lf &
      "  Requested time: " & real'image(Requested_secs) & " seconds" & lf &
      "  Actual time:    " & real'image(Actual_secs) & " seconds";
  end procedure;

  procedure report_time_precision( Identifier : in string; Cycles : in clock_cycles;
    Requested_secs : in time; Actual_secs : in time ) is
  begin
    report "Timing precision for: " & Identifier & lf &
      "  Clock cycles:   " & clock_cycles'image(Cycles) & lf &
      "  Requested time: " & time'image(Requested_secs) & lf &
      "  Actual time:    " & time'image(Actual_secs);
  end procedure;



  --## Generate clock waveform for simulation only
  --#  Clock      - the generated clock
  --#  Stop_clock - control signal that terminates the procedure when true
  --#  Clock_freq - the frequency of the clock
  --#  Duty       - duty cycle of the generated clock from 0.0 to 1.0
  procedure clock_gen( signal Clock : out std_ulogic; signal Stop_clock : in boolean;
    constant Clock_freq : in frequency; constant Duty : duty_cycle := 0.5 ) is

    constant PERIOD : delay_length := to_period(Clock_freq);
    constant HIGH_TIME : delay_length := PERIOD * Duty;
    constant LOW_TIME  : delay_length := PERIOD - HIGH_TIME;
  begin
    Clock <= '0';

    while not Stop_clock loop
      wait for LOW_TIME;
      Clock <= '1';
      wait for HIGH_TIME;
      Clock <= '0';
    end loop;
  end procedure;

  --## Same as above with Clock_period replacing Clock_freq
  procedure clock_gen( signal Clock : out std_ulogic; signal Stop_clock : in boolean;
    constant Clock_period : in delay_length; constant Duty : duty_cycle := 0.5 ) is

    constant HIGH_TIME : delay_length := Clock_period * Duty;
    constant LOW_TIME  : delay_length := Clock_period - HIGH_TIME;
  begin
    Clock <= '0';

    while not Stop_clock loop
      wait for LOW_TIME;
      Clock <= '1';
      wait for HIGH_TIME;
      Clock <= '0';
    end loop;
  end procedure;

end package body;
