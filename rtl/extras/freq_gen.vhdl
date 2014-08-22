--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# freq_gen.vhdl - Sinusoidal frequency generator
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
--# DEPENDENCIES: ddfs_pkg, cordic, sizing
--#
--# DESCRIPTION:
--#  This package provides a set of components that implement an arbitrary
--#  sinusoidal frequency generator.
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package freq_gen_pkg is

  component freq_gen is
    generic (
      SYS_FREQ     : real;
      DDFS_TOL     : real;
      SIZE         : natural;
      MIN_TGT_FREQ : natural;
      MAX_TGT_FREQ : natural;
      FREQ_SCALE   : natural := 1;
      MAGNITUDE    : real := 1.0;
      ITERATIONS   : positive
    );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic;

      Load_phase : in std_ulogic;
      New_phase  : in unsigned;

      Dyn_freq : in unsigned;
      Sin      : out signed(SIZE-1 downto 0);
      Cos      : out signed(SIZE-1 downto 0);
      Angle    : out signed(SIZE-1 downto 0)
    );  
  end component;

  component freq_gen_pipelined is
    generic (
      SYS_FREQ     : real;
      DDFS_TOL     : real;
      SIZE         : natural;
      MIN_TGT_FREQ : natural;
      MAX_TGT_FREQ : natural;
      FREQ_SCALE   : natural := 1;
      MAGNITUDE    : real := 1.0;
      ITERATIONS   : positive
    );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic;

      Load_phase : in std_ulogic;
      New_phase  : in unsigned;

      Dyn_freq : in unsigned;
      Sin      : out signed(SIZE-1 downto 0);
      Cos      : out signed(SIZE-1 downto 0);
      Angle    : out signed(SIZE-1 downto 0)
    );  
  end component;

end package;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_gen is
  generic (
    SYS_FREQ     : real;
    DDFS_TOL     : real;
    SIZE         : natural;
    MIN_TGT_FREQ : natural;
    MAX_TGT_FREQ : natural;
    FREQ_SCALE   : natural := 1;
    MAGNITUDE    : real := 1.0;
    ITERATIONS   : positive
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Load_phase : in std_ulogic;
    New_phase  : in unsigned;

    Dyn_freq : in unsigned;
    Sin      : out signed(SIZE-1 downto 0);
    Cos      : out signed(SIZE-1 downto 0);
    Angle    : out signed(SIZE-1 downto 0)
  );  
end entity;


library extras;
use extras.ddfs_pkg.all;
use extras.cordic.all;
use extras.sizing.bit_size;

architecture rtl of freq_gen is

  constant DDFS_LEN    : natural := ddfs_size(SYS_FREQ, real(MIN_TGT_FREQ), DDFS_TOL);
  constant FRAC_BITS   : natural := min_fraction_bits(SYS_FREQ, 
                                        real(MIN_TGT_FREQ), DDFS_LEN, DDFS_TOL);
  constant DDFS_FACTOR : natural := ddfs_dynamic_factor(SYS_FREQ, DDFS_LEN,
                                                         FRAC_BITS) * FREQ_SCALE;

  signal dyn_inc, accum  : unsigned(DDFS_LEN-1 downto 0);
  signal angle_loc : signed(SIZE-1 downto 0);

  signal load, done : std_ulogic;
  signal sin_seq, cos_seq : signed(SIZE-1 downto 0);

begin

  dyn: process(Clock, Reset) is
  begin
    if Reset = '1' then
      dyn_inc <= (others => '0');
    elsif rising_edge(Clock) then
      ddfs_dynamic_inc(DDFS_FACTOR, FRAC_BITS, dyn_freq, dyn_inc);
    end if;
  end process;

  phase_accum: ddfs
    port map (
      Clock => Clock,
      Reset => Reset,
      Enable => '1',
      Load_phase => Load_phase,
      New_phase  => New_phase,
      Increment => dyn_inc,
      Accumulator => accum,
      Synth_clock => open,
      Synth_pulse => open
    );

  angle_loc <= signed(resize_fractional(accum, SIZE));
  Angle <= angle_loc;

  gen: sincos_sequential
    generic map (
      SIZE => SIZE,
      MAGNITUDE => MAGNITUDE,
      ITERATIONS => ITERATIONS,
      FRAC_BITS => SIZE-2
    ) port map (
      Clock => Clock,
      Reset => Reset,

      Load => load,
      Done => done,

      Angle => angle_loc,
      Sin => sin_seq,
      Cos => cos_seq
    );

  ctrl: process(Clock, Reset) is
  begin
    if Reset = '1' then
      Sin <= (others => '0');
      Cos <= (others => '0');
    elsif rising_edge(Clock) then
      if done = '1' then
        Sin <= sin_seq;
        Cos <= cos_seq;
      else
      end if;
    end if;
  end process;

  load <= done;

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_gen_pipelined is
  generic (
    SYS_FREQ     : real;
    DDFS_TOL     : real;
    SIZE         : natural;
    MIN_TGT_FREQ : natural;
    MAX_TGT_FREQ : natural;
    FREQ_SCALE   : natural := 1;
    MAGNITUDE    : real := 1.0;
    ITERATIONS   : positive
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Load_phase : in std_ulogic;
    New_phase  : in unsigned;

    Dyn_freq : in unsigned;
    Sin      : out signed(SIZE-1 downto 0);
    Cos      : out signed(SIZE-1 downto 0);
    Angle    : out signed(SIZE-1 downto 0)
  );  
end entity;


library extras;
use extras.ddfs_pkg.all;
use extras.cordic.all;
use extras.sizing.bit_size;

architecture rtl of freq_gen_pipelined is

  constant DDFS_LEN    : natural := ddfs_size(SYS_FREQ, real(MIN_TGT_FREQ), DDFS_TOL);
  constant FRAC_BITS   : natural := min_fraction_bits(SYS_FREQ, 
                                        real(MIN_TGT_FREQ), DDFS_LEN, DDFS_TOL);
  constant DDFS_FACTOR : natural := ddfs_dynamic_factor(SYS_FREQ, DDFS_LEN,
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
    port map (
      Clock => Clock,
      Reset => Reset,
      Enable => '1',
      Load_phase => Load_phase,
      New_phase  => New_phase,
      Increment => dyn_inc,
      Accumulator => accum,
      Synth_clock => open,
      Synth_pulse => open
    );

  angle_loc <= signed(resize_fractional(accum, SIZE));
  Angle <= angle_loc;

  gen: sincos_pipelined
    generic map (
      SIZE => SIZE,
      ITERATIONS => ITERATIONS,
      MAGNITUDE => MAGNITUDE,
      FRAC_BITS => SIZE-2
    ) port map (
      Clock => Clock,
      Reset => Reset,

      Angle => angle_loc,
      Sin => Sin,
      Cos => Cos
    );

end architecture;
