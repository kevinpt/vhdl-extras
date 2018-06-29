--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# oscillator.vhdl - Sinusoidal frequency generators
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2017 Kevin Thibedeau
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
--# DEPENDENCIES: ddfs_pkg, cordic, sizing, timing_ops
--#
--# DESCRIPTION:
--#  This package provides a set of components that implement arbitrary
--#  sinusoidal frequency generators. They come in two variants. One generates
--#  a fixed frequency that is specified at elaboration time as a generic
--#  parameter. The other generates a dynamic frequency that can be altered
--#  at run time. Each of these oscillator variants comes in two versions. One
--#  is based around a pipelined CORDIC unit that produces new valid output on
--#  every clock cycle. The other uses a more compact sequential CORDIC
--#  implementation that takes multiple clock cycles to produce each output.
--#
--#  All oscillators output sine, cosine, the current phase angle, and a generated
--#  clock at the target frequency.
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.timing_ops.all;

package oscillator is

  --## Oscillator with a fixed frequency output.
  --#  Samples are generated on every clock cycle.
  component fixed_oscillator is
    generic (
      SYS_CLOCK_FREQ     : frequency;        --# System clock frequency
      OUTPUT_FREQ        : frequency;        --# Generated frequency
      TOLERANCE          : real := 0.05;     --# Error tolerance
      SIZE               : positive;         --# Width of operands
      ITERATIONS         : positive;         --# Number of iterations for CORDIC algorithm
      MAGNITUDE          : real := 1.0;      --# Scale factor for Sin and Cos
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;  --# System clock
      Reset : in std_ulogic;  --# Asynchronous reset
      
      --# {{control|}}
      Load_phase : in std_ulogic := '0'; --# Load a new phase angle
      New_phase  : in unsigned   := "0"; --# Phase angle to load
      
      --# {{data|}}
      Sin         : out signed(SIZE-1 downto 0); --# Sine output
      Cos         : out signed(SIZE-1 downto 0); --# Cosine output
      Angle       : out signed(SIZE-1 downto 0); --# Phase angle in brads
      Synth_clock : out std_ulogic               --# Generated clock
    );
  end component;

  --## Oscillator with a fixed frequency output.
  --#  Samples are generated on after every ITERATIONS clock cycles.
  component fixed_oscillator_sequential is
    generic (
      SYS_CLOCK_FREQ     : frequency;        --# System clock frequency
      OUTPUT_FREQ        : frequency;        --# Generated frequency
      TOLERANCE          : real := 0.05;     --# Error tolerance
      SIZE               : positive;         --# Width of operands
      ITERATIONS         : positive;         --# Number of iterations for CORDIC algorithm
      MAGNITUDE          : real := 1.0;      --# Scale factor for Sin and Cos
      CAPTURE_RESULT     : boolean := false; --# Register outputs when valid
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;  --# System clock
      Reset : in std_ulogic;  --# Asynchronous reset
      
      --# {{control|}}
      Load_phase : in std_ulogic := '0'; --# Load a new phase angle
      New_phase  : in unsigned   := "0"; --# Phase angle to load
      Result_valid : out std_ulogic;     --# New samples are ready

      --# {{data|}}
      Sin         : out signed(SIZE-1 downto 0); --# Sine output
      Cos         : out signed(SIZE-1 downto 0); --# Cosine output
      Angle       : out signed(SIZE-1 downto 0); --# Phase angle in brads
      Synth_clock : out std_ulogic               --# Generated clock
    );
  end component;

  component dynamic_oscillator is
    generic (
      SYS_CLOCK_FREQ     : real;             --# System clock frequency
      MIN_TGT_FREQ       : natural;          --# Lowest supported output frequency
      TOLERANCE          : real := 0.05;     --# Error tolerance
      SIZE               : natural;          --# Width of operands
      ITERATIONS         : positive;         --# Number of iterations for CORDIC algorithm
      MAGNITUDE          : real := 1.0;      --# Scale factor for Sin and Cos magnitude
      FREQ_SCALE         : natural := 1;     --# Scale factor for target frequency
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;  --# System clock
      Reset : in std_ulogic;  --# Asynchronous reset

      --# {{control|}}
      Load_phase : in std_ulogic := '0'; --# Load a new phase angle
      New_phase  : in unsigned   := "0"; --# Phase angle to load
      Dyn_freq   : in unsigned;          --# Dynamic frequency in FIXME

      --# {{data|}}
      Sin         : out signed(SIZE-1 downto 0); --# Sine output
      Cos         : out signed(SIZE-1 downto 0); --# Cosine output
      Angle       : out signed(SIZE-1 downto 0); --# Phase angle in brads
      Synth_clock : out std_ulogic               --# Generated clock
    );  
  end component;


  component dynamic_oscillator_sequential is
    generic (
      SYS_CLOCK_FREQ     : real;             --# System clock frequency
      MIN_TGT_FREQ       : natural;          --# Lowest supported output frequency
      TOLERANCE          : real := 0.05;     --# Error tolerance
      SIZE               : natural;          --# Width of operands
      ITERATIONS         : positive;         --# Number of iterations for CORDIC algorithm
      MAGNITUDE          : real := 1.0;      --# Scale factor for Sin and Cos magnitude
      FREQ_SCALE         : natural := 1;     --# Scale factor for target frequency
      CAPTURE_RESULT     : boolean := false; --# Register outputs when valid
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;  --# System clock
      Reset : in std_ulogic;  --# Asynchronous reset

      --# {{control|}}
      Load_phase : in std_ulogic := '0'; --# Load a new phase angle
      New_phase  : in unsigned   := "0"; --# Phase angle to load
      Dyn_freq   : in unsigned;          --# Dynamic frequency in FIXME

      --# {{data|}}
      Sin         : out signed(SIZE-1 downto 0); --# Sine output
      Cos         : out signed(SIZE-1 downto 0); --# Cosine output
      Angle       : out signed(SIZE-1 downto 0); --# Phase angle in brads
      Synth_clock : out std_ulogic               --# Generated clock
    );  
  end component;

end package;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.cordic.all;
use extras.timing_ops.all;
use extras.ddfs_pkg.all;

entity fixed_oscillator is
  generic (
    SYS_CLOCK_FREQ     : frequency;
    OUTPUT_FREQ        : frequency;
    TOLERANCE          : real := 0.05;
    SIZE               : positive;
    ITERATIONS         : positive;
    MAGNITUDE          : real := 1.0;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    -- {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    -- {{control|}}
    Load_phase : in std_ulogic := '0'; --# Load a new phase angle
    New_phase  : in unsigned   := "0"; --# Phase angle to load
    
    -- {{data|}}
    Sin         : out signed(SIZE-1 downto 0);
    Cos         : out signed(SIZE-1 downto 0);
    Angle       : out signed(SIZE-1 downto 0);      
    Synth_clock : out std_ulogic
  );
end entity;

architecture rtl of fixed_oscillator is
  constant ACCUM_SIZE : natural := ddfs_size(to_real(SYS_CLOCK_FREQ),
                                            to_real(OUTPUT_FREQ), TOLERANCE);

  constant INCR   : unsigned(ACCUM_SIZE-1 downto 0) := ddfs_increment(to_real(SYS_CLOCK_FREQ), to_real(OUTPUT_FREQ), ACCUM_SIZE);

  signal accum : unsigned(ACCUM_SIZE-1 downto 0);
  signal angle_loc : signed(SIZE-1 downto 0);
begin


  ddfs1: ddfs
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => Clock,
      Reset => Reset,
      
      Enable     => '1',
      Load_phase => Load_phase,
      New_phase  => New_phase,
      
      Increment => INCR,
      
      Accumulator => accum,
      Synth_clock => Synth_clock,
      Synth_pulse => open 
    );

  angle_loc <= signed(resize_fractional(accum, SIZE));
  Angle <= angle_loc;


  sc1: sincos_pipelined
    generic map (
      SIZE => SIZE,
      MAGNITUDE => MAGNITUDE,
      ITERATIONS => ITERATIONS,
      FRAC_BITS => SIZE-2, -- Reserve one bit for sign and another for a ones place bit
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => Clock,
      Reset => Reset,
      
      Angle => angle_loc,
      Sin => Sin,
      Cos => Cos
    );

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.cordic.all;
use extras.timing_ops.all;
use extras.ddfs_pkg.all;

entity fixed_oscillator_sequential is
  generic (
    SYS_CLOCK_FREQ     : frequency;
    OUTPUT_FREQ        : frequency;
    TOLERANCE          : real := 0.05;
    SIZE               : positive;
    ITERATIONS         : positive;
    MAGNITUDE          : real := 1.0;
    CAPTURE_RESULT     : boolean := false;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    -- {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    -- {{control|}}
    Load_phase : in std_ulogic := '0'; --# Load a new phase angle
    New_phase  : in unsigned   := "0"; --# Phase angle to load

    Result_valid : out std_ulogic;

    -- {{data|}}      
    Sin         : out signed(SIZE-1 downto 0);
    Cos         : out signed(SIZE-1 downto 0);
    Angle       : out signed(SIZE-1 downto 0);      
    Synth_clock : out std_ulogic
  );
end entity;

architecture rtl of fixed_oscillator_sequential is
  constant ACCUM_SIZE : natural := ddfs_size(to_real(SYS_CLOCK_FREQ),
                                            to_real(OUTPUT_FREQ), TOLERANCE) + 1;

  constant INCR   : unsigned(ACCUM_SIZE-1 downto 0) := ddfs_increment(to_real(SYS_CLOCK_FREQ), to_real(OUTPUT_FREQ), ACCUM_SIZE);

  signal accum : unsigned(ACCUM_SIZE-1 downto 0);
  signal sin_seq, cos_seq, angle_loc : signed(SIZE-1 downto 0);
  signal result_valid_loc : std_ulogic;
begin

  ddfs1: ddfs
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => Clock,
      Reset => Reset,
      
      Enable => '1',
      Load_phase => Load_phase,
      New_phase => New_phase,
      
      Increment => INCR,
      
      Accumulator => accum,
      Synth_clock => Synth_clock,
      Synth_pulse => open 
    );

  angle_loc <= signed(resize_fractional(accum, SIZE));
  Angle <= angle_loc;

  sc1: sincos_sequential
    generic map (
      SIZE => SIZE,
      ITERATIONS => ITERATIONS,
      FRAC_BITS => SIZE-2 -- Reserve one bit for sign and another for a ones place bit
    )
    port map (
      Clock => Clock,
      Reset => Reset,
      
      Data_valid => result_valid_loc,
      Busy => open,
      Result_valid => result_valid_loc,
      
      Angle => angle_loc,
      Sin => sin_seq,
      Cos => cos_seq
    );
    
  Result_valid <= result_valid_loc;

  -- Optionally capture sequential result or pass it out directly  
  c: if CAPTURE_RESULT = true generate
    capture: process(Clock, Reset) is
    begin
      if Reset = RESET_ACTIVE_LEVEL then
        Sin <= (others => '0');
        Cos <= (others => '0');
      elsif rising_edge(Clock) then
        if result_valid_loc = '1' then
          Sin <= sin_seq;
          Cos <= cos_seq;
        else
        end if;
      end if;
    end process;
  end generate;

  nc: if CAPTURE_RESULT = false generate
    Sin <= sin_seq;
    Cos <= cos_seq;
  end generate;

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dynamic_oscillator is
  generic (
    SYS_CLOCK_FREQ     : real;
    MIN_TGT_FREQ       : natural;
    TOLERANCE          : real := 0.05;
    SIZE               : natural;
    ITERATIONS         : positive;
    MAGNITUDE          : real := 1.0;
    FREQ_SCALE         : natural := 1;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    -- {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    -- {{control|}}
    Load_phase : in std_ulogic := '0'; --# Load a new phase angle
    New_phase  : in unsigned   := "0"; --# Phase angle to load
    Dyn_freq   : in unsigned;

    -- {{data|}}
    Sin         : out signed(SIZE-1 downto 0);
    Cos         : out signed(SIZE-1 downto 0);
    Angle       : out signed(SIZE-1 downto 0);
    Synth_clock : out std_ulogic
  );  
end entity;


library extras;
use extras.ddfs_pkg.all;
use extras.cordic.all;
use extras.sizing.bit_size;

architecture rtl of dynamic_oscillator is

  constant DDFS_LEN    : natural := ddfs_size(SYS_CLOCK_FREQ, real(MIN_TGT_FREQ), TOLERANCE);
  constant FRAC_BITS   : natural := min_fraction_bits(SYS_CLOCK_FREQ, 
                                        real(MIN_TGT_FREQ), DDFS_LEN, TOLERANCE);
  constant DDFS_FACTOR : natural := ddfs_dynamic_factor(SYS_CLOCK_FREQ, DDFS_LEN,
                                                         FRAC_BITS) * FREQ_SCALE;

  signal dyn_inc, accum  : unsigned(DDFS_LEN-1 downto 0);
  signal angle_loc : signed(SIZE-1 downto 0);

begin

  -- Implement a synchronous multiplier to generate the dynamic
  -- increment value for the phase accumulator.
  -- No reset implemented for better synthesis on platforms that don't
  -- support async. reset on hardware multipliers.
  dyn: process(Clock) is
  begin
    if rising_edge(Clock) then
      ddfs_dynamic_inc(DDFS_FACTOR, FRAC_BITS, dyn_freq, dyn_inc);
    end if;
  end process;

  phase_accum: ddfs
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => Clock,
      Reset => Reset,

      Enable => '1',
      Load_phase => Load_phase,
      New_phase  => New_phase,

      Increment => dyn_inc,

      Accumulator => accum,
      Synth_clock => Synth_clock,
      Synth_pulse => open
    );

  angle_loc <= signed(resize_fractional(accum, SIZE));
  Angle <= angle_loc;

  gen: sincos_pipelined
    generic map (
      SIZE => SIZE,
      MAGNITUDE => MAGNITUDE,
      ITERATIONS => ITERATIONS,
      FRAC_BITS => SIZE-2, -- Reserve one bit for sign and another for a ones place bit
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => Clock,
      Reset => Reset,

      Angle => angle_loc,
      Sin => Sin,
      Cos => Cos
    );
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dynamic_oscillator_sequential is
  generic (
    SYS_CLOCK_FREQ     : real;
    MIN_TGT_FREQ       : natural;
    TOLERANCE          : real := 0.05;
    SIZE               : natural;
    ITERATIONS         : positive;
    MAGNITUDE          : real := 1.0;
    FREQ_SCALE         : natural := 1;
    CAPTURE_RESULT     : boolean := false;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    -- {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    -- {{control|}}
    Load_phase : in std_ulogic := '0'; --# Load a new phase angle
    New_phase  : in unsigned   := "0"; --# Phase angle to load
    Dyn_freq   : in unsigned;

    -- {{data|}}
    Sin         : out signed(SIZE-1 downto 0);
    Cos         : out signed(SIZE-1 downto 0);
    Angle       : out signed(SIZE-1 downto 0);
    Synth_clock : out std_ulogic
  );  
end entity;


library extras;
use extras.ddfs_pkg.all;
use extras.cordic.all;
use extras.sizing.bit_size;

architecture rtl of dynamic_oscillator_sequential is

  constant DDFS_LEN    : natural := ddfs_size(SYS_CLOCK_FREQ, real(MIN_TGT_FREQ), TOLERANCE);
  constant FRAC_BITS   : natural := min_fraction_bits(SYS_CLOCK_FREQ, 
                                        real(MIN_TGT_FREQ), DDFS_LEN, TOLERANCE);
  constant DDFS_FACTOR : natural := ddfs_dynamic_factor(SYS_CLOCK_FREQ, DDFS_LEN,
                                                         FRAC_BITS) * FREQ_SCALE;

  signal dyn_inc, accum  : unsigned(DDFS_LEN-1 downto 0);
  signal angle_loc : signed(SIZE-1 downto 0);

  signal result_valid : std_ulogic;
  signal sin_seq, cos_seq : signed(SIZE-1 downto 0);

begin

  -- Implement a synchronous multiplier to generate the dynamic
  -- increment value for the phase accumulator.
  -- No reset implemented for better synthesis on platforms that don't
  -- support async. reset on hardware multipliers.
  dyn: process(Clock) is
  begin
    if rising_edge(Clock) then
      ddfs_dynamic_inc(DDFS_FACTOR, FRAC_BITS, dyn_freq, dyn_inc);
    end if;
  end process;

  phase_accum: ddfs
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => Clock,
      Reset => Reset,

      Enable => '1',
      Load_phase => Load_phase,
      New_phase  => New_phase,

      Increment => dyn_inc,

      Accumulator => accum,
      Synth_clock => Synth_clock,
      Synth_pulse => open
    );

  angle_loc <= signed(resize_fractional(accum, SIZE));
  Angle <= angle_loc;

  gen: sincos_sequential
    generic map (
      SIZE => SIZE,
      MAGNITUDE => MAGNITUDE,
      ITERATIONS => ITERATIONS,
      FRAC_BITS => SIZE-2, -- Reserve one bit for sign and another for a ones place bit
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    )
    port map (
      Clock => Clock,
      Reset => Reset,

      Data_valid => result_valid,
      Busy => open,
      Result_valid => result_valid,

      Angle => angle_loc,
      Sin => sin_seq,
      Cos => cos_seq
    );

  -- Optionally capture sequential result or pass it out directly  
  c: if CAPTURE_RESULT = true generate
    capture: process(Clock, Reset) is
    begin
      if Reset = RESET_ACTIVE_LEVEL then
        Sin <= (others => '0');
        Cos <= (others => '0');
      elsif rising_edge(Clock) then
        if result_valid = '1' then
          Sin <= sin_seq;
          Cos <= cos_seq;
        else
        end if;
      end if;
    end process;
  end generate;

  nc: if CAPTURE_RESULT = false generate
    Sin <= sin_seq;
    Cos <= cos_seq;
  end generate;

end architecture;

