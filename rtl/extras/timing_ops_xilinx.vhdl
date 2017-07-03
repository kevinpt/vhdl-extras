--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# timing_ops_xilinx.vhdl - Routines for time calculations; Xilinx version
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010 Kevin Thibedeau
--# (kevin 'period' thibedeau 'at' gmail 'punto' com)
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
--#  Conversions between time and real (time and frequency) are provided.
--#  Functions to convert from time in these three forms to integer
--#  clock_cycles are also included. The conversion from time to real uses an
--#  integer intermediate representation of time. It is designed to compensate
--#  for tools that use 64-bit time and 32-bit integers but only 31-bits of
--#  precision will be maintained in such cases.
--#
--#  For all conversion functions, real values of time are expressed in units
--#  of seconds and real frequencies are in 1/sec. e.g. 1 ns = 1.0e-9,
--#  1 MHz = 1.0e6.
--#
--#  The to_clock_cycles functions can introduce rounding errors and produce a
--#  result that is different from what would be expected assuming infinite
--#  precision. The magnitude of any errors will depend on how close the
--#  converted time is to the clock period. To assist in controlling the
--#  errors, a time_rounding parameter is available on all forms of
--#  to_clock_cycles that use real as an intermediate type for the calculation.
--#  It is set by default to round up toward infinity in anticipation that
--#  these functions will most often be used to compute the minium number of
--#  cycles for a delay. You can override this behavior to either round down or
--#  maintain normal round to nearest for the conversion from real to
--#  clock_cycles.
--#
--#  To help detect the effect of rounding errors the time_duration and
--#  report_time_precision routines can be used in simulation to indicate
--#  deviation from the requested time span.
--#
--#  XILINX NOTE: This version of timing_ops is needed for synthesis with
--#  Xilinx XST. The physical type 'frequency' and any associated functions have
--#  been removed. The standard timing_ops package will work with Xilinx Vivado
--#  and most third party synthesizers so consider using it instead if XST is
--#  not being used.
--#
--# EXAMPLE USAGE:
--#  library extras; use extras.sizing.bit_size; use extras.timing_ops.all;
--#
--#    constant SYS_CLOCK_FREQ : real := 50.0e6 -- 50 MHz;
--#    constant COUNT_1US : clock_cycles
--#      := to_clock_cycles(1 us, SYS_CLOCK_FREQ);
--#    signal   counter   : unsigned(bit_size(COUNT_1US)-1 downto 0);
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
--#      clock_gen(sys_clock, stop_clock, SYS_CLOCK_PERIOD);
--#      wait;
--#    end process;
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package timing_ops is
  subtype clock_cycles is natural;

  type time_rounding is (
    round_nearest, -- normal floating point round to nearest integer
    round_inf,     -- round up to +infinity
    round_neginf   -- round down to -infinity
  );

  constant TIME_ROUND_STYLE : time_rounding := round_nearest;

  --## Get the current simulation time resolution
  function resolution_limit return delay_length;

  --## Convert time to real time
  function to_real( Tval : time ) return real;


  --## Convert real time to time
  function to_time( Rval : real ) return time;

  --## Convert real frequency to period
  function to_period( Freq : real ) return delay_length;


  --## Compute clock cycles for the specified number of seconds using a clock
  --#  frequency as the time base
  function to_clock_cycles( Secs : delay_length; Clock_freq : real;
    round_style : time_rounding := TIME_ROUND_STYLE ) return clock_cycles;

  function to_clock_cycles( Secs : real; Clock_freq : real;
    round_style : time_rounding := TIME_ROUND_STYLE ) return clock_cycles;

  --## Compute clock cycles for the specified number of seconds using a clock
  --#  period as the time base
  function to_clock_cycles( Secs : delay_length; Clock_period : delay_length )
    return clock_cycles;

  function to_clock_cycles( Secs : real; Clock_period : delay_length;
    round_style : time_rounding := TIME_ROUND_STYLE ) return clock_cycles;

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
    constant Clock_period : in delay_length; constant Duty : duty_cycle := 0.5 );

end package;


library extras;
use extras.sizing.ceil_log2;

package body timing_ops is

-- PRIVATE functions:
-- ==================

  type time_resolution is record
    tval : time;
    rval : real;
  end record;

  type time_resolution_array is array( natural range <>) of time_resolution;

  constant BASE_TIME_ARRAY : time_resolution_array := (
     (1 fs, 1.0e-15),  (10 fs, 1.0e-14),  (100 fs, 1.0e-13),
     (1 ps, 1.0e-12),  (10 ps, 1.0e-11),  (100 ps, 1.0e-10),
     (1 ns, 1.0e-9),   (10 ns, 1.0e-8),   (100 ns, 1.0e-7),
     (1 us, 1.0e-6),   (10 us, 1.0e-5),   (100 us, 1.0e-4),
     (1 ms, 1.0e-3),   (10 ms, 1.0e-2),   (100 ms, 1.0e-1),
     (1 sec, 1.0),     (10 sec, 1.0e1),   (100 sec, 1.0e2),
     (1 min, 60.0),    (10 min, 60.0e1),  (100 min, 60.0e2),
     (1 hr, 3600.0)  -- XST only handles time up to 1 hr
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

  type tr_vector is array(time_rounding) of real;
  constant ROUND_ADJ : tr_vector := (
    round_nearest =>  0.0,
    round_inf     =>  0.5,
    round_neginf  => -0.5
  );

-- PUBLIC functions:
-- =================

  --## Get the current simulation time resolution
  function resolution_limit return delay_length is
    variable tr : time_resolution;
  begin
    tr := resolution_limit;
    return tr.tval;
  end function;


  --## Convert time to real time
  function to_real( Tval : time ) return real is
    variable t : time := Tval;
    variable min_time : time_resolution := resolution_limit;
    variable scale    : positive;
    variable large_time_adj : real := 1.0;

    variable lost_bits : time;
    variable lost_real : real := 0.0;
  begin

    -- We need to work with positive time values.
    if t < 0 sec then
      t := -t;
      large_time_adj := -1.0; -- This will restore the sign later.
    end if;

    -- Make adjustment to min_time values to avoid overflow upon conversion
    -- from time to integer. This takes care of simulators with 64-bit time and
    -- 32-bit integers.
    if t > (integer'high * min_time.tval) then -- Too large for direct conversion

      -- We need to keep the output of ceil_log2 at or below 30 to get working
      -- integer exponentiation on 32-bit platforms. This requires t to be no
      -- greater than time'high / 4  ((63 - log2(4)) - 31 = 30).
      while t > time'high / 4 loop
        t := t / 2;
        large_time_adj := large_time_adj * 2.0;
      end loop;

      -- Note: scale must be at least 1 so we add 1 to guarantee we never call
      -- ceil_log_2(1) when t > [max int time] and t < 2*[max int time].
      scale := ceil_log2(t / (integer'high * min_time.tval) + 1);

      -- The scaling operation drops the least significant bits. IEEE 64-bit
      -- float has 53-bits of significand. That leaves 53-31 = 22-bits that
      -- are left to be filled after converting the scaled integer to real. We
      -- capture the truncated bits now so that they can be added in the final
      -- conversion.
      lost_bits := t - ((t / 2**scale) * 2**scale);
      lost_real := real(lost_bits / min_time.tval) * min_time.rval;

      -- Adjust the time scale
      min_time := (min_time.tval * 2**scale, min_time.rval * 2.0**scale);
    end if;

    return real(t / min_time.tval) * min_time.rval * large_time_adj + lost_real;
  end function;

  --## Convert real time to time
  function to_time( Rval : real ) return time is
  begin
    return Rval * 1 sec;
  end function;

  --## Convert real frequency to period
  function to_period( Freq : real ) return delay_length is
  begin
    return 1 sec / Freq;
  end function;


  --## Compute clock cycles for the specified number of seconds using a clock
  --#  frequency as the time base
  function to_clock_cycles( Secs : delay_length; Clock_freq : real;
    round_style : time_rounding := TIME_ROUND_STYLE ) return clock_cycles is
  begin
    return clock_cycles(to_real(Secs) * Clock_freq + ROUND_ADJ(round_style));
  end function;

  function to_clock_cycles( Secs : real; Clock_freq : real;
    round_style : time_rounding := TIME_ROUND_STYLE ) return clock_cycles is  
  begin
    return natural(Secs * Clock_freq + ROUND_ADJ(round_style));
  end function;


  --## Compute clock cycles for the specified number of seconds using a clock
  --#  period as the time base
  function to_clock_cycles( Secs : delay_length; Clock_period : delay_length )
    return clock_cycles is
  begin
    return clock_cycles(Secs / Clock_period);
  end function;

  function to_clock_cycles( Secs : real; Clock_period : delay_length;
    round_style : time_rounding := TIME_ROUND_STYLE ) return clock_cycles is
  begin
    return clock_cycles(Secs / to_real(Clock_period) + ROUND_ADJ(round_style));
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
  --#  Clock        - the generated clock
  --#  Stop_clock   - control signal that terminates the procedure when true
  --#  Clock_period - the period of the clock
  --#  Duty         - duty cycle of the generated clock from 0.0 to 1.0
 procedure clock_gen( signal Clock : out std_ulogic; signal Stop_clock : in boolean;
    constant Clock_period : in delay_length; constant Duty : duty_cycle := 0.5 ) is

    constant HIGH_TIME : delay_length := Clock_period * Duty;
    constant LOW_TIME  : delay_length := Clock_period - HIGH_TIME;
  begin
    -- synthesis translate_off
    Clock <= '0';

    while not Stop_clock loop
      wait for LOW_TIME;
      Clock <= '1';
      wait for HIGH_TIME;
      Clock <= '0';
    end loop;
    -- synthesis translate_on
  end procedure;

end package body;
