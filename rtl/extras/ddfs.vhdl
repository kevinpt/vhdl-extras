--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# ddfs.vhdl - Direct Digital Frequency Synthesizer
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2014, 2017 Kevin Thibedeau
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
--# DEPENDENCIES: sizing arithmetic
--#
--# DESCRIPTION:
--#  This package provides a set of functions and a component used for
--#  implementing a Direct Digital Frequency Synthesizer (DDFS). The DDFS
--#  component is a simple accumulator that increments by a pre computed value
--#  each cycle. The MSB of the accumulator switches at the requested frequency
--#  established by the ddfs_increment function. The provided functions perform
--#  computations with real values and, as such, are only synthesizable when
--#  used to define constants.
--#
--#  There are two sets of functions for generating the increment values needed
--#  by the DDFS accumulator. One set is used to compute static increments that
--#  are assigned to constants. The other functions work in conjunction with a
--#  procedure to dynamically generate the increment value using a single
--#  inferred multiplier.
--#
--#  It is possible to generate multiple frequencies by computing more than one
--#  increment constant and multiplexing between them. The ddfs_size function
--#  should be called with the smallest target frequency to be used to
--#  guarantee the requested tolerance is met.
--#
--#  EXAMPLE USAGE:
--#  The ddfs_size and ddfs_increment functions are used to compute static
--#  increment values:
--#    constant SYS_FREQ  : real    := 50.0e6; -- 50 MHz
--#    constant TGT_FREQ  : real    := 2600.0; -- 2600 Hz
--#    constant DDFS_TOL  : real    := 0.001;  -- 0.1%
--#    constant SIZE      : natural := ddfs_size(SYS_FREQ, TGT_FREQ, DDFS_TOL);
--#    constant INCREMENT : unsigned(SIZE-1 downto 0) :=
--#                                 ddfs_increment(SYS_FREQ, TGT_FREQ, SIZE);
--#    ...
--#    whistle: ddfs
--#      port map (
--#        Clock => clock,
--#        Reset => reset,
--#      
--#        Increment   => INCREMENT,
--#        Accumulator => accum,
--#        Synth_clock => synth_tone, -- Signal with ~2600 Hz clock
--#        Synth_pulse => open
--#      );
--#    ...
--#    -- Report the DDFS precision (simulation only)
--#    report "True synthesized frequency: "
--#      & real'image(ddfs_frequency(SYS_FREQ, TGT_FREQ, SIZE)
--#    report "DDFS error: " & real'image(ddfs_error(SYS_FREQ, TGT_FREQ, SIZE)
--#
--#  The alternate set of functions are used to precompute a multiplier factor
--#  that is used to dynamically generate an increment value in synthesizable
--#  logic:
--#
--#    constant MIN_TGT_FREQ : natural := 27;
--#    constant MAX_TGT_FREQ : natural := 4200;
--#    constant FRAC_BITS    : natural := min_fraction_bits(SYS_FREQ, 
--#                                          MIN_TGT_FREQ, SIZE, DDFS_TOL);
--#    constant DDFS_FACTOR  : natural := ddfs_dynamic_factor(SYS_FREQ, SIZE,
--#                                                           FRAC_BITS);
--#    signal dyn_freq : unsigned(bit_size(MAX_TGT_FREQ)-1 downto 0);
--#    signal dyn_inc  : unsigned(SIZE-1 downto 0);
--#    ...
--#    dyn_freq <= to_unsigned(261, dyn_freq'length); -- Middle C
--#    ...
--#    dyn_freq <= to_unsigned(440, dyn_freq'length); -- Change to A4
--#    ...
--#    -- Wrap ddfs_dynamic_inc in a sequential process to synthesize a
--#    -- multiplier with registered product.
--#    dyn: process(clock, reset) is
--#    begin
--#      if reset = '1' then
--#        dyn_inc <= (others => '0');
--#      elsif rising_edge(clock) then
--#        ddfs_dynamic_inc(DDFS_FACTOR, FRAC_BITS, dyn_freq, dyn_inc);
--#      end if;
--#    end process;
--#
--#    fsynth: ddfs
--#      port map (
--#        Clock => clock,
--#        Reset => reset,
--#
--#        Increment   => dyn_inc,
--#        Accumulator => accum,
--#        Synth_clock => synth_tone,
--#        Synth_pulse => open
--#      );
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library extras;
use extras.sizing.bit_size;


package ddfs_pkg is

  --## Compute the necessary size of a DDFS accumulator based on system and
  --#  target frequencies with a specified tolerance. The DDFS accumulator
  --#  must be at least as large as the result to achieve the requested tolerance.
  --# Args:
  --#  Sys_freq:    Clock frequency of the system
  --#  Target_freq: Desired frequency to generate
  --#  Tolerance:   Error tolerance
  --# Returns:
  --#  Number of bits needed to generate the target frequency within the allowed tolerance.
  function ddfs_size(Sys_freq : real; Target_freq : real;
    Tolerance : real) return natural;

  --## Compute the effective frequency tolerance for a specific size and target
  --#  frequency.
  --# Args:
  --#  Sys_freq:    Clock frequency of the system
  --#  Target_freq: Desired frequency to generate
  --#  Size:        Size of the DDFS counter
  --# Returns:
  --#  Tolerance for the target frequency with a Size counter.
  function ddfs_tolerance(Sys_freq : real; Target_freq : real; Size : natural)
    return real;

  --## Compute the natural increment value needed to generate a target frequency.
  --# Args:
  --#  Sys_freq:    Clock frequency of the system
  --#  Target_freq: Desired frequency to generate
  --#  Size:        Size of the DDFS counter
  --# Returns:
  --#  Increment value needed to generate the target frequency.
  function ddfs_increment(Sys_freq : real; Target_freq : real;
    Size : natural) return natural;

  --## Compute the unsigned increment value needed to generate a target frequency.
  --# Args:
  --#  Sys_freq:    Clock frequency of the system
  --#  Target_freq: Desired frequency to generate
  --#  Size:        Size of the DDFS counter
  --# Returns:
  --#  Increment value needed to generate the target frequency.
  function ddfs_increment(Sys_freq : real; Target_freq : real;
    Size : natural) return unsigned;

  --## Find the minimum number of fraction bits needed to meet
  --#  the tolerance requirement for a dynamic DDFS. The target
  --#  frequency should be the lowest frequency to ensure proper
  --#  results.
  --# Args:
  --#  Sys_freq:    Clock frequency of the system
  --#  Target_freq: Lowest desired frequency to generate
  --#  Size:        Size of the DDFS counter
  --#  Tolerance:   Error tolerance
  --# Returns:
  --#  Increment value needed to generate the target frequency.
  function min_fraction_bits(Sys_freq : real; Target_freq : real;
    Size : natural; Tolerance : real) return natural;

  --## Compute the factor used to generate dynamic increment values.
  --# Args:
  --#  Sys_freq:      Clock frequency of the system
  --#  Size:          Size of the DDFS counter
  --#  Fraction_bits: Number of fraction bits
  --# Returns:
  --#  Dynamic increment factor passed into ddfs_dynamic_inc().
  function ddfs_dynamic_factor(Sys_freq : real; Size : natural;
    Fraction_bits : natural) return natural;

  --## This procedure computes dynamic increment values by multiplying
  --#  the result of a previous call to ddfs_dynamic_factor by the
  --#  integer target frequency. The result is an integer value with
  --#  fractional bits removed.
  --#  This can be synthesized by invocation within a synchronous
  --#  process.
  --# Args:
  --#  Dynamic_factor: Dynamic factor constant
  --#  Fraction_bits:  Fraction bits for the dynamic DDFS
  --#  Target_freq:    Desired frequency to generate
  --#  Increment:      Increment value needed to generate the target frequency.
  procedure ddfs_dynamic_inc(Dynamic_factor : in natural; Fraction_bits : in natural;
    signal Target_freq : in unsigned; signal Increment : out unsigned);

  --## Compute the actual synthesized frequency for the specified accumulator
  --#  size.
  --# Args:
  --#  Sys_freq:    Clock frequency of the system
  --#  Target_freq: Desired frequency to generate
  --#  Size:        Size of the DDFS counter
  --# Returns:
  --#  Frequency generated with the provided parameters.
  function ddfs_frequency(Sys_freq : real; Target_freq : real;
    Size : natural) return real;

  --## Compute the error between the requested output frequency and the actual
  --#  output frequency.
  --# Args:
  --#  Sys_freq:    Clock frequency of the system
  --#  Target_freq: Desired frequency to generate
  --#  Size:        Size of the DDFS counter
  --# Returns:
  --#  Ratio of generated frequency to target frequency.
  function ddfs_error(Sys_freq : real; Target_freq : real;
    Size : natural) return real;

  --## Resize a vector representing a fractional value with the binary point
  --#  preceeding the MSB.
  --# Args:
  --#  Phase: Phase angle in range 0.0 to 1.0.
  --#  Size:  Number of bits in the result
  --# Returns:
  --#  Resized vector containing phase fraction
  function resize_fractional(Phase : unsigned; Size : positive) return unsigned;

  --## Convert angle in radians to a fractional phase value.
  --# Args:
  --#  Radians: Angle to convert
  --#  Size:    Number of bits in the result
  --# Returns:
  --#  Fraction phase in range 0.0 to 1.0.
  function radians_to_phase(Radians : real; Size : positive) return unsigned;
  
  --## Convert angle in degrees to a fractional phase value.
  --# Args:
  --#  Degrees: Angle to convert
  --#  Size:    Number of bits in the result
  --# Returns:
  --#  Fraction phase in range 0.0 to 1.0.
  function degrees_to_phase(Degrees : real; Size : positive) return unsigned;

  --## Synthesize a frequency using a DDFS.
  component ddfs is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;             --# System clock
      Reset : in std_ulogic;             --# Asynchronous reset
      
      --# {{control|}}
      Enable     : in std_ulogic := '1'; --# Enable the DDFS counter
      Load_phase : in std_ulogic := '0'; --# Load a new phase angle
      New_phase  : in unsigned   := "0"; --# Phase angle to load

      Increment : in unsigned;      --# Value controlling the synthesized frequency

      --# {{data|}}
      Accumulator : out unsigned;   --# Internal accumulator value
      Synth_clock : out std_ulogic; --# Synthesized frequency
      Synth_pulse : out std_ulogic  --# Single cycle pulse for rising edge of synth_clock
    );
  end component;


  --## Synthesize a frequency using a DDFS.
  component ddfs_pipelined is
    generic (
      MAX_CARRY_LENGTH   : positive := 100;
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;             --# System clock
      Reset : in std_ulogic;             --# Asynchronous reset

      --# {{control|}}
      Enable     : in std_ulogic := '1'; --# Enable the DDFS counter
      Load_phase : in std_ulogic := '0'; --# Load a new phase angle
      New_phase  : in unsigned   := "0"; --# Phase angle to load

      Increment  : in unsigned;          --# Value controlling the synthesized frequency

      --# {{data|}}
      Accumulator : out unsigned;   --# Internal accumulator value
      Synth_clock : out std_ulogic; --# Synthesized frequency
      Synth_pulse : out std_ulogic  --# Single cycle pulse for rising edge of synth_clock
    );
  end component;

end package;

package body ddfs_pkg is

  --## Compute the necessary size of a DDFS accumulator based on system and
  --#  target frequencies with a specified tolerance. The DDFS accumulator
  --#  must be at least as large as the result to achieve the requested tolerance.
  function ddfs_size(sys_freq : real; target_freq : real;
    tolerance : real) return natural is

    variable tol_count : real;
    variable size : natural;
  begin
  
    -- Calculate the largest count we need to be able to represent to meet
    -- the desired tolerance.
    tol_count := sys_freq / (target_freq * tolerance);

    -- Round the result up to the nearest integer and get the number of
    -- bits needed to represent it

    -- We can't convert to an integer and call bit_size until the value
    -- is less than 2**31 - 1 (i.e. integer'high). We first get a rough
    -- estimate of how many bits in excess of 30 there are for the floating
    -- point value tol_count. We then divide down by this number of bits to
    -- get an adjusted tol_count that can be converted to an integer.
    -- Dividing tol_count directly by 2.0**30 introduces too much error
    -- and gives the wrong result.
    
    size := 0;
    if tol_count > 2.0**23 then
      size := bit_size(integer(tol_count / 2.0**30));
      tol_count := tol_count / 2.0**size;
    end if;

    return size + bit_size(integer(tol_count + 0.5));

  end function;


  --## Compute the effective frequency tolerance for a specific size and target
  --#  frequency.
  function ddfs_tolerance(sys_freq : real; target_freq : real; size : natural)
    return real is

    variable tolerance : real;
  begin
    tolerance := sys_freq / 2.0**size / target_freq;
    return tolerance;
  end function;


  --## Compute the increment value needed to generate a target frequency
  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return natural is

    constant ACCUM_MAX : real := 2.0**size;
    constant INC_R : real := target_freq / sys_freq * ACCUM_MAX;

  begin

    -- Rounding the count to the nearest integer gives the lowest error

    -- The real increment value should be less than 2**31 for all practical
    -- input settings so the direct type conversion is safe.
    
    assert INC_R <= real(integer'high)
      report "Increment too large for integer type"
      severity failure;

    assert INC_R <= (2.0**size) - 1.0
      report "Increment too large for accumulator"
      severity failure;

    return natural(INC_R);

  end function;

  --## Compute the increment value needed to generate a target frequency
  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return unsigned is

    constant ACCUM_MAX : real := 2.0**size;
    constant INC_R : real := target_freq / sys_freq * ACCUM_MAX;

  begin

    -- Rounding the count to the nearest integer gives the lowest error

    -- The real increment value should be less than 2**31 for all practical
    -- input settings so the direct type conversion is safe.
    
    assert INC_R <= real(integer'high)
      report "Increment too large for integer type"
      severity failure;

    assert INC_R <= (2.0**size) - 1.0
      report "Increment too large for accumulator"
      severity failure;

    return to_unsigned(integer(INC_R), size);

  end function;

  --## Find the minimum number of fraction bits needed to meet
  --#  the tolerance requirement for a dynamic DDFS. The target
  --#  frequency should be the lowest frequency to ensure proper
  --#  results.
  function min_fraction_bits(sys_freq : real; target_freq : real;
    size : natural; tolerance : real) return natural is

    variable factor, inc : natural;
    variable synth_freq, synth_error : real;
  begin
    for s in 1 to Size loop
      factor := natural((2.0**size / sys_freq) * 2.0**s);
      inc := natural(real(factor) * target_freq / 2.0**s);
      synth_freq := sys_freq * real(inc) / 2.0**size;
      synth_error := abs(synth_freq / target_freq - 1.0);
      if synth_error <= tolerance then
        return s;
      end if;
    end loop;

    return size;
  end function;

  --## Compute the factor used to generate dynamic increment values.
  --#  The result is a fixed point integer.
  function ddfs_dynamic_factor(sys_freq : real; size : natural;
    fraction_bits : natural) return natural is
  begin
    assert fraction_bits < size
      report "Fraction bits too large: " & integer'image(fraction_bits) &
        " >= " & integer'image(size)
      severity error;

    return natural((2.0**size / sys_freq) * 2.0**fraction_bits);
  end function;

  --## This procedure computes dynamic increment values by multiplying
  --#  the result of a previous call to ddfs_dynamic_factor by the
  --#  integer target frequency. The result is an integer value with
  --#  fractional bits removed.
  --#  This can be synthesized by invocation within a synchronous
  --#  process.
  procedure ddfs_dynamic_inc(dynamic_factor : in natural; fraction_bits : in natural;
    signal target_freq : in unsigned; signal Increment : out unsigned) is

    variable factor : unsigned(bit_size(dynamic_factor)-1 downto 0);
    variable prod : unsigned(factor'length + target_freq'length - 1 downto 0);
  begin
    factor := to_unsigned(dynamic_factor, factor'length);

    -- Multiply the precomputed dynamic factor by the desired frequency.
    -- The result is a fixed point number whose integer portion can be
    -- used as the increment value for a DDFS component.
    prod := factor * target_freq;

    -- Slice off the fractional part of the fixed point product
    Increment <= resize(prod(prod'high downto fraction_bits), increment'length);
  end procedure;



  --## Compute the actual synthesized frequency for the specified accumulator
  --#  size
  function ddfs_frequency(sys_freq : real; target_freq : real;
    size : natural) return real is

    constant INC_N : natural := ddfs_increment(sys_freq, target_freq, size);

    constant ACCUM_MAX : real := 2.0**size; --pow2(size);
  begin

    return sys_freq * real(INC_N) / ACCUM_MAX;
  end function;


  --## Compute the error between the requested output frequency and the actual
  --#  output frequency
  function ddfs_error(sys_freq : real; target_freq : real;
    size : natural) return real is

  begin
    return abs (ddfs_frequency(sys_freq, target_freq, size)
       / target_freq - 1.0);
  end function;

  --## Resize a vector representing a fractional value with the binary point
  --#  preceeding the MSB.
  function resize_fractional(phase : unsigned; size : positive) return unsigned is
    alias p: unsigned(phase'length-1 downto 0) is phase;
    variable result : unsigned(size-1 downto 0) := (others => '0');
  begin
    if size <= p'length then
      -- Slice off lower bits
      result := p(p'high downto p'high-(size-1));
    else -- Result is larger
      -- Left justify phase in result
      result(result'high downto result'high - p'length + 1) := p;
    end if;

    return result;
  end function;

  function radians_to_phase(radians : real; size : positive) return unsigned is
  begin
    return to_unsigned(integer(((radians / MATH_2_PI) mod 1.0) * 2.0**size), size);
  end function;

  function degrees_to_phase(degrees : real; size : positive) return unsigned is
  begin
    return to_unsigned(integer(((degrees / 360.0) mod 1.0) * 2.0**size), size);
  end function;

end package body;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.ddfs_pkg.resize_fractional;

entity ddfs is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    Enable     : in std_ulogic := '1';
      Load_phase : in std_ulogic := '0';
      New_phase  : in unsigned   := "0";

    Increment : in unsigned;      -- Value controlling the synthesized frequency

    Accumulator : out unsigned;   -- Internal accumulator value
    Synth_clock : out std_ulogic; -- Synthesized frequency
    Synth_pulse : out std_ulogic  -- Single cycle pulse for rising edge of synth_clock
  );
end entity;

architecture rtl of ddfs is

  signal accum : unsigned(Increment'range);
  signal prev_msb : std_ulogic;

begin

  inc: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      accum <= (others => '0');
    elsif rising_edge(Clock) then
      if Load_phase = '1' then
        accum <= resize_fractional(New_phase, accum'length);
      elsif Enable = '1' then
        accum <= accum + Increment;
      end if;
    end if;
  end process;

  Accumulator <= resize(accum, Accumulator'length);

  -- Output the MSB of the accumulator
  Synth_clock <= accum(accum'high);


  -- Detect rising edge of synth_clock to make a 1-cycle pulse
  ed: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      prev_msb <= '0';
      Synth_pulse <= '0';
    elsif rising_edge(Clock) then
      prev_msb <= accum(accum'high);

      if accum(accum'high) = '1' and prev_msb = '0' then
        Synth_pulse <= '1';
      else
        Synth_pulse <= '0';
      end if;
    end if;
  end process;

end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.ddfs_pkg.resize_fractional;
use extras.arithmetic.pipelined_adder;

--## Synthesize a frequency using a DDFS.
entity ddfs_pipelined is
  generic (
    MAX_CARRY_LENGTH   : positive := 100;
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;             --# System clock
    Reset : in std_ulogic;             --# Asynchronous reset

    --# {{control|}}
    Enable     : in std_ulogic := '1'; --# Enable the DDFS counter
    Load_phase : in std_ulogic := '0'; --# Load a new phase angle
    New_phase  : in unsigned   := "0"; --# Phase angle to load

    Increment  : in unsigned;          --# Value controlling the synthesized frequency

    --# {{data|}}
    Accumulator : out unsigned;   --# Internal accumulator value
    Synth_clock : out std_ulogic; --# Synthesized frequency
    Synth_pulse : out std_ulogic  --# Single cycle pulse for rising edge of synth_clock
  );
end entity;

architecture rtl of ddfs_pipelined is

  constant SLICES : natural := (Accumulator'length + MAX_CARRY_LENGTH - 1) / MAX_CARRY_LENGTH;

  subtype inc_word is unsigned(Increment'length-1 downto 0);
  type inc_array is array(natural range <>) of inc_word;

  signal increments : inc_array(0 to SLICES-1);

  subtype incr_range is natural range 0 to SLICES-1;
  signal incr_ix : incr_range;

  signal accum : unsigned(Increment'length downto 0); -- Extra bit for carry out
  signal next_inc : unsigned(accum'length-2 downto 0);
  signal prev_msb : std_ulogic;

begin

  -- Compute increments for each pipeline stage
  increments(0) <= resize(Increment, inc_word'length);

  inc: for i in 1 to SLICES-1 generate
    increments(i) <= increments(i-1) + resize(Increment, inc_word'length);
  end generate;

  next_inc <= resize(increments(incr_ix), accum'length-1);

  pa: pipelined_adder
    generic map (
      SLICES => SLICES,
      CONST_B_INPUT => false,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => clock,
      Reset => reset,

      A => accum(accum'high-1 downto 0),
      B => next_inc,

      Sum => accum
    );

  ctrl: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      incr_ix <= 0;
    elsif rising_edge(Clock) then
      if incr_ix /= SLICES-1 then
        incr_ix <= incr_ix + 1;
      else
        incr_ix <= 0;
      end if;
    end if;
  end process;


--  inc: process(Clock, Reset)
--  begin
--    if Reset = RESET_ACTIVE_LEVEL then
--      accum <= (others => '0');
--    elsif rising_edge(Clock) then
--      if Load_phase = '1' then
--        accum <= resize_fractional(New_phase, accum'length);
--      elsif Enable = '1' then
--        accum <= accum + Increment;
--      end if;
--    end if;
--  end process;

  Accumulator <= resize(accum, Accumulator'length);

  -- Output the MSB of the accumulator (skipping carry_out)
  Synth_clock <= accum(accum'high-1);


  -- Detect rising edge of synth_clock to make a 1-cycle pulse
  ed: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      prev_msb <= '0';
      Synth_pulse <= '0';
    elsif rising_edge(Clock) then
      prev_msb <= accum(accum'high-1);

      if accum(accum'high-1) = '1' and prev_msb = '0' then
        Synth_pulse <= '1';
      else
        Synth_pulse <= '0';
      end if;
    end if;
  end process;

end architecture;
