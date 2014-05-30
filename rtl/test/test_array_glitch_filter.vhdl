--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.timing_ops.all;
use extras.random.all;
use extras.glitch_filtering.all;
use extras.sizing.all;

entity test_array_glitch_filter is
end entity;

architecture test of test_array_glitch_filter is
  signal sim_done : boolean := false;
  constant CLOCK_FREQ : frequency := 100 MHz;

  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);
  constant SWITCH_PERIOD : time := 1 us;
  constant NOISE_PERIOD : time := 1.4 ns;
  constant NOISE_TIME : time := 50 ns;

  constant FILTER_TIME : delay_length := 200 ns;
  constant FILTER_CYCLES : clock_cycles := to_clock_cycles(FILTER_TIME, CLOCK_FREQ);
  constant STABLE_CYCLES : unsigned(bit_size(FILTER_CYCLES)-1 downto 0) :=
    to_unsigned(FILTER_CYCLES, bit_size(FILTER_CYCLES));

  signal clock, reset : std_ulogic;
  signal switch, rand : std_ulogic;
  signal noisy, filtered : std_ulogic_vector(3 downto 0);
  signal noise_on : boolean;

begin
  stim: process
  begin
    reset <= '1', '0' after CPERIOD;
    switch <= '0';

    wait until falling_edge(clock);
    wait for CPERIOD * 4;

    for s in 0 to 9 loop
      wait for SWITCH_PERIOD / 2;
      switch <= not switch;
      wait for SWITCH_PERIOD / 2;
      switch <= not switch;
    end loop;

    sim_done <= true;
    wait;
  end process;

  noise_gen: process
  begin
    while sim_done = false loop
      if random then
        rand <= '1';
      else
        rand <= '0';
      end if;
      wait for NOISE_PERIOD;
    end loop;
    wait;
  end process;

  noise_ctrl: process
  begin
    while sim_done = false loop
      wait until rising_edge(switch) or falling_edge(switch);
      noise_on <= true, false after NOISE_TIME;
    end loop;
    wait;
  end process;

  with noise_on select
    noisy <= std_ulogic_vector'(noisy'range => rand) when true,
             std_ulogic_vector'(noisy'range => switch) when false;
  

  gf: dynamic_array_glitch_filter
    port map (
      Clock => clock,
      Reset => reset,
      
      Filter_cycles => STABLE_CYCLES,
      
      Noisy    => noisy,
      Filtered => filtered
    );


  v : for i in filtered'range generate
  begin
    validate: process
      -- The allowable variation in the period of the filtered signal
      constant PERIOD_TOL : time := SWITCH_PERIOD * 0.01;
      variable prev_edge : time;
    begin

      wait until rising_edge(filtered(i));
      prev_edge := now;
      while true loop
        wait until rising_edge(filtered(i));
        assert abs((now - prev_edge) - SWITCH_PERIOD) <= PERIOD_TOL
          report "BAD period: " & time'image(now - prev_edge) & " (" & frequency'image(to_frequency(now - prev_edge)) & ")"
          severity failure;
        prev_edge := now;
      end loop;
    end process;
  end generate;

  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;

end architecture;
