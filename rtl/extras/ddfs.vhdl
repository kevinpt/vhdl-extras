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
--# $Id$
--# Freely available from VHDL-extras (http://code.google.com/p/vhdl-extras)
--#
--# Copyright © 2014 Kevin Thibedeau
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
--#    -- Wrap ddfs_dynamic_inc in a sequencial process to synthesize a
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

library extras;
use extras.sizing.bit_size;


package ddfs_pkg is

  function ddfs_size(sys_freq : real; target_freq : real;
    tolerance : real) return natural;

  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return natural;

  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return unsigned;


  function min_fraction_bits(sys_freq : real; target_freq : real;
    size : natural; tolerance : real) return natural;

  function ddfs_dynamic_factor(sys_freq : real; size : natural;
    fraction_bits : natural) return natural;

  procedure ddfs_dynamic_inc(dynamic_factor : in natural; fraction_bits : in natural;
    signal target_freq : in unsigned; signal increment : out unsigned);


  function ddfs_frequency(sys_freq : real; target_freq : real;
    size : natural) return real;

  function ddfs_error(sys_freq : real; target_freq : real;
    size : natural) return real;


  component ddfs is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'
    );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic;
      
      Enable : in std_ulogic := '1';

      Increment : in unsigned;      -- Value controlling the synthesized frequency

      Accumulator : out unsigned;   -- Internal accumulator value
      Synth_clock : out std_ulogic; -- Synthesized frequency
      Synth_pulse : out std_ulogic  -- Single cycle pulse for rising edge of synth_clock
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


  --## Compute the increment value needed to generate a target frequency
  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return natural is

    constant ACCUM_MAX : real := 2.0**size; --pow2(size);
    constant INC_R : real := target_freq / sys_freq * ACCUM_MAX;

  begin

    -- Rounding the count to the nearest integer gives the lowest error

    -- The real increment value should be less than 2**31 for all practical
    -- input settings so the direct type conversion is safe.
    
    assert INC_R <= real(integer'high)
      report "Increment too large for integer type"
      severity failure;

    assert INC_R <= (2.0**SIZE) - 1.0
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

    assert INC_R <= (2.0**SIZE) - 1.0
      report "Increment too large for accumulator"
      severity failure;

    return to_unsigned(integer(INC_R),SIZE);

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
    return natural((2.0**size / sys_freq) * 2.0**fraction_bits);
  end function;

  --## This procedure computes dynamic increment values by multiplying
  --#  the result of a previous call to ddfs_dynamic_factor by the
  --#  integral target frequency. The result is an integral value with
  --#  fractional bits removed.
  --#  This can be synthesized by invocation within a synchronous
  --#  process.
  procedure ddfs_dynamic_inc(dynamic_factor : in natural; fraction_bits : in natural;
    signal target_freq : in unsigned; signal increment : out unsigned) is

    variable factor : unsigned(bit_size(dynamic_factor)-1 downto 0);
    variable prod : unsigned(factor'length + target_freq'length - 1 downto 0);
  begin
    factor := to_unsigned(dynamic_factor, factor'length);

    -- Multiply the precomputed dynamic factor by the desired frequency.
    -- The result is a fixed point number whose integer portion can be
    -- used as the increment value for a DDFS component.
    prod := factor * target_freq;

    -- Slice off the fractional part of the fixed point product
    increment <= resize(prod(prod'high downto fraction_bits), increment'length);
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

end package body;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ddfs is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    Enable : in std_ulogic := '1';
    
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
      if Enable = '1' then
        accum <= accum + Increment;
      end if;
    end if;
  end process;

  Accumulator <= accum;

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
