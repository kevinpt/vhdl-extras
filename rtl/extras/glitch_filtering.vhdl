--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# glitch_filtering.vhdl - Components for glitch filtering noisy signals
--# $Id:$
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
--#  This package provides glitch filter components that can be used to remove
--#  noise from digital input signals. This can be useful for debouncing
--#  switches directly connected to a device. The glitch_filter component works
--#  with a single std_ulogic signal while array_glitch_filter provides
--#  filtering for a std_ulogic_vector. These components include synchronizing
--#  flip-flops and can be directly tied to input pads.
--#
--#  It is assumed that the signal being recovered changes relatively slowly
--#  compared to the clock period. These filters come in two forms. One is
--#  controlled by a generic FILTER_CYCLES and the other, dynamic versions have
--#  a signal Filter_cycles. These controls indicate the number of clock cycles
--#  the input(s) must remain stable before the filtered output register(s) are
--#  updated. The filtered output will lag the inputs by Filter_cycles+3 clock
--#  cycles. The dynamic versions can have their filter delay changed at any
--#  time if their Filter_cycles input is connected to a signal. The minimum
--#  pulse width that will pass through the filter will be Filter_cycles + 1
--#  clock cycles wide.
--#
--# EXAMPLE USAGE:
--#  library extras;
--#  use extras.glitch_filtering.all; use extras.timing_ops.all;
--#  ...
--#  constant CLOCK_FREQ    : frequency    := 100 MHz;
--#  constant FILTER_TIME   : delay_length := 200 ns;
--#  constant FILTER_CYCLES : clock_cycles :=
--#    to_clock_cycles(FILTER_TIME, CLOCK_FREQ);
--#  ...
--#  gf: glitch_filter
--#    generic map (
--#      FILTER_CYCLES => FILTER_CYCLES
--#    ) port map (
--#      Clock    => clock,
--#      Reset    => reset,
--#      Noisy    => noisy,
--#      Filtered => filtered
--#    );
--#
--#  Xilinx XST doesn't support user defined physical types so the frequency
--#  type from timing_ops.vhdl can't be used with that synthesizer. An alternate
--#  solution using XST-compatible timing_ops_xilinx.vhdl follows:
--#
--#  constant CLOCK_FREQ    : real         := 100.0e6; -- Using real in place of frequency
--#  constant FILTER_TIME   : delay_length := 200 ns;
--#  constant FILTER_CYCLES : clock_cycles :=
--#    to_clock_cycles(FILTER_TIME, CLOCK_FREQ)
--#  ...
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package glitch_filtering is
  --## Basic glitch filter with a constant filter delay
  --#  This version filters a single signal of std_ulogic
  component glitch_filter is
    generic (
      FILTER_CYCLES : positive; --# Number of clock cycles to filter
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{data|}}
      Noisy    : in std_ulogic; --# Noisy input signal
      Filtered : out std_ulogic --# Filtered output
    );
  end component;

  --## Glitch filter with a dynamically alterable filter delay
  --#  This version filters a single signal of std_ulogic  component dynamic_glitch_filter is
  component dynamic_glitch_filter is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Filter_cycles : in unsigned; --# Number of clock cycles to filter

      --# {{data|}}
      Noisy    : in std_ulogic; --# Noisy input signal
      Filtered : out std_ulogic --# Filtered output
    );
  end component;


  --## Basic glitch filter with a constant filter delay
  --#  This version filters an array of std_ulogic
  component array_glitch_filter is
    generic (
      FILTER_CYCLES : positive; --# Number of clock cycles to filter
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{data|}}
      Noisy    : in std_ulogic_vector;  --# Noisy input signals
      Filtered : out std_ulogic_vector  --# Filtered output
    );
  end component;

  --## Glitch filter with a dynamically alterable filter delay
  --#  This version filters an array of std_ulogic
  component dynamic_array_glitch_filter is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Filter_cycles : in unsigned; --# Number of clock cycles to filter

      --# {{data|}}
      Noisy    : in std_ulogic_vector; --# Noisy input signals
      Filtered : out std_ulogic_vector --# Filtered output
    );
  end component;

end package;


library ieee;
use ieee.std_logic_1164.all;

entity glitch_filter is
  generic (
    FILTER_CYCLES : positive; -- Number of clock cycles to filter
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Noisy    : in std_ulogic; -- Noisy input signal
    Filtered : out std_ulogic -- Filtered output
  );
end entity;

library ieee;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;
use extras.glitch_filtering.dynamic_glitch_filter;

--## Basic glitch filter with a constant filter delay
--#  This version filters a single signal of std_ulogic
architecture rtl of glitch_filter is
  constant TIMER_SIZE : positive := bit_size(FILTER_CYCLES);
  constant FILTER_CYCLES_UNS : unsigned(TIMER_SIZE-1 downto 0) :=
    to_unsigned(FILTER_CYCLES, TIMER_SIZE);
begin

  dgf: dynamic_glitch_filter
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    ) port map (
      Clock => Clock,
      Reset => Reset,

      Filter_cycles => FILTER_CYCLES_UNS,

      Noisy    => Noisy,
      Filtered => Filtered
    );
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--## Glitch filter with a dynamically alterable filter delay
--#  This version filters a single signal of std_ulogic
entity dynamic_glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Filter_cycles : in unsigned; -- Number of clock cycles to filter

    Noisy    : in std_ulogic; -- Noisy input signal
    Filtered : out std_ulogic -- Filtered output
  );
end entity;

architecture rtl of dynamic_glitch_filter is
  signal samples : std_ulogic_vector(1 to 3); -- shift register of sampled inputs

  signal state_change : std_ulogic; -- flag for a change in the input state

  signal count : unsigned(Filter_cycles'range); -- timer count
  signal timer_done : std_ulogic; -- timer flag

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

  -- Run count down continuously. Reset count whenever a state change occurs.
  -- If the count reaches 0 then the input has been stable for the requested
  -- length of time.
  timer: process(Clock, Reset, Filter_cycles) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      count <= Filter_cycles;
    elsif rising_edge(Clock) then
      if state_change = '1' then -- unstable, initialize timer
        count <= Filter_cycles;
      else -- counting
        count <= count - 1;
      end if;
    end if;
  end process;

  timer_done <= '1' when count = (count'range => '0') else '0';


  -- Update the filtered output whenever the input has been stable for enough
  -- cycles.
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

--## Basic glitch filter with a constant filter delay
--#  This version filters an array of std_ulogic
entity array_glitch_filter is
  generic (
    FILTER_CYCLES : positive; -- Number of clock cycles to filter
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Noisy    : in std_ulogic_vector; -- Noisy input signal
    Filtered : out std_ulogic_vector -- Filtered output
  );
end entity;

library ieee;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;
use extras.glitch_filtering.dynamic_array_glitch_filter;

architecture rtl of array_glitch_filter is
  constant TIMER_SIZE : positive := bit_size(FILTER_CYCLES);
  constant FILTER_CYCLES_UNS : unsigned(TIMER_SIZE-1 downto 0) :=
    to_unsigned(FILTER_CYCLES, TIMER_SIZE);
begin

  dagf: dynamic_array_glitch_filter
    generic map (
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    ) port map (
      Clock => Clock,
      Reset => Reset,

      Filter_cycles => FILTER_CYCLES_UNS,

      Noisy    => Noisy,
      Filtered => Filtered
    );
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--## Glitch filter with a dynamically alterable filter delay
--#  This version filters an array of std_ulogic
entity dynamic_array_glitch_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic; -- Asynchronous reset

    Filter_cycles : in unsigned; -- Number of clock cycles to filter

    Noisy    : in std_ulogic_vector; -- Noisy input signals
    Filtered : out std_ulogic_vector -- Filtered output
  );
end entity;

architecture rtl of dynamic_array_glitch_filter is
  type sample_reg is array (1 to 3) of std_ulogic_vector(Noisy'range);
  signal samples : sample_reg; -- shift register of sampled inputs

  signal state_change : std_ulogic; -- flag for a change in the input state

  signal count : unsigned(Filter_cycles'range); -- timer count
  signal timer_done : std_ulogic; -- timer flag

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
      samples <= (samples'range => (samples(1)'range => '0'));
    elsif rising_edge(Clock) then
      samples <= Noisy & samples(1 to 2);
    end if;
  end process;

  state_change <= '1' when
    or_reduce(to_x01(samples(3)) xor to_x01(samples(2))) = '1' else '0';

  -- Run count down continuously. Reset count whenever a state change occurs.
  -- If the count reaches 0 then the input has been stable for the requested
  -- length of time.
  timer: process(Clock, Reset, Filter_cycles) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      count <= Filter_cycles;
    elsif rising_edge(Clock) then
      if state_change = '1' then -- unstable, initialize timer
        count <= Filter_cycles;
      else -- counting
        count <= count - 1;
      end if;
    end if;
  end process;

  timer_done <= '1' when count = (count'range => '0') else '0';

  -- Update the filtered output whenever the input has been stable for enough
  -- cycles.
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
