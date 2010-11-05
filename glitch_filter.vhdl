--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# glitch_filter.vhdl - Components for glitch filtering noisy signals
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
--# DEPENDENCIES: none
--#
--# DESCRIPTION:
--#  This package provides two glitch filter components that can be used to
--#  remove noise from digital input signals. This can be useful for debouncing
--#  switches directly connected to a device. The glitch_filter component works
--#  with a single std_ulogic signal while array_glitch_filter provides
--#  filtering for a std_ulogic_vector. These components include synchronizing
--#  flip-flops and can be directly tied to input pads. It is assumed that the
--#  signal being recovered changes relatively slowly compared to the clock
--#  period. The filters are controlled with an input Stable_cycles that
--#  indicates the number of clock cycles the input(s) must remain stable
--#  before the filtered output register(s) are updated. The filtered output
--#  will lag the inputs by Stable_cycles+3 clock cycles.
--#
--# EXAMPLE USAGE:
--#  library extras;
--#  use extras.glitch_filter_pkg.all; use extras.timing_ops.all;
--#  use extras.sizing.bit_size;
--#  ...
--#  constant CLOCK_FREQ  : frequency := 100 MHz;
--#  constant FILTER_TIME : delay_length := 200 ns;
--#  constant FILTER_CYCLES : clock_cycles :=
--#    to_clock_cycles(FILTER_TIME, CLOCK_FREQ);
--#  constant STABLE_CYCLES : unsigned(bit_size(FILTER_CYCLES)-1 downto 0) :=
--#    to_unsigned(FILTER_CYCLES, bit_size(FILTER_CYCLES));
--#  ...
--#  gf: glitch_filter
--#    port map (
--#      Clock         => clock,
--#      Reset         => reset,
--#      Stable_cycles => STABLE_CYCLES,
--#      Noisy         => noisy,
--#      Filtered      => filtered
--#    );
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package glitch_filter_pkg is

  component glitch_filter is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'
    );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic; -- Asynchronous reset

      Stable_cycles : in unsigned; -- Number of clock cycles to filter

      Noisy    : in std_ulogic; -- Noisy input signal
      Filtered : out std_ulogic -- Filtered output
    );
  end component;

  component array_glitch_filter is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'
    );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic; -- Asynchronous reset

      Stable_cycles : in unsigned; -- Number of clock cycles to filter

      Noisy    : in std_ulogic_vector; -- Noisy input signals
      Filtered : out std_ulogic_vector -- Filtered output
    );
  end component;

end package;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Stable_cycles : in unsigned; -- Number of clock cycles to filter

    Noisy    : in std_ulogic; -- Noisy input signal
    Filtered : out std_ulogic -- Filtered output
  );
end entity;

architecture rtl of glitch_filter is
  signal samples : std_ulogic_vector(1 to 3);

  signal state_change : std_ulogic;

  signal count : unsigned(Stable_cycles'range);
  signal timer_done : std_ulogic;

begin

  -- synchronize the noisy input and detect changes in state
  sync: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      samples <= (others => '0');
    elsif rising_edge(Clock) then
      samples <= Noisy & samples(1 to 2);
    end if;
  end process;

  state_change <= '1' when to_x01(samples(3)) /= to_x01(samples(2)) else '0';

  timer: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      count <= Stable_cycles;
    elsif rising_edge(Clock) then
      if state_change = '1' then -- unstable, initialize timer
        count <= Stable_cycles;
      else -- counting
        count <= count - 1;
      end if;
    end if;
  end process;

  timer_done <= '1' when count = (count'range => '0') else '0';


  capture: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      Filtered <= '0';
    elsif rising_edge(Clock) then

      if timer_done = '1' then
        Filtered <= samples(3);
      end if;
    end if;
  end process;

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity array_glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Stable_cycles : in unsigned; -- Number of clock cycles to filter

    Noisy    : in std_ulogic_vector; -- Noisy input signals
    Filtered : out std_ulogic_vector -- Filtered output
  );
end entity;

architecture rtl of array_glitch_filter is
  type sample_reg is array (1 to 3) of std_ulogic_vector(Noisy'range);
  signal samples : sample_reg;

  signal state_change : std_ulogic;

  signal count : unsigned(Stable_cycles'range);
  signal timer_done : std_ulogic;

  function or_reduce( v : std_ulogic_vector ) return std_ulogic is
    variable result : std_ulogic := '0';
  begin
    for i in v'range loop
      result := result or v(i);
    end loop;

    return result;
  end function;
begin

  -- Synchronize the noisy input and detect changes in state

  -- This would normally be an inappropriate way to synchronize an array but
  -- since the filter logic is waiting for all inputs to become stable, the
  -- usual issues with skewed inputs will not appear at the filtered output.
  sync: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      samples <= (others => (others => '0'));
    elsif rising_edge(Clock) then
      samples <= Noisy & samples(1 to 2);
    end if;
  end process;

  state_change <= '1' when
    or_reduce(to_x01(samples(3)) xor to_x01(samples(2))) = '1' else '0';

  timer: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      count <= Stable_cycles;
    elsif rising_edge(Clock) then
      if state_change = '1' then -- unstable, initialize timer
        count <= Stable_cycles;
      else -- counting
        count <= count - 1;
      end if;
    end if;
  end process;

  timer_done <= '1' when count = (count'range => '0') else '0';


  capture: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      Filtered <= (Filtered'range => '0');
    elsif rising_edge(Clock) then

      if timer_done = '1' then
        Filtered <= samples(3);
      end if;
    end if;
  end process;

end architecture;
