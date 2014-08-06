--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.ddfs_pkg.all;
use extras.timing_ops.all;


entity test_ddfs is
  generic (
    TGT_FREQ :real := 26000.0 -- 26000 Hz
  );
end entity;

architecture tb of test_ddfs is
  signal clock, reset : std_ulogic;

  signal sim_done : boolean := false;
  constant CLOCK_FREQ : frequency := 50 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);

  --constant TGT_FREQ  : real    := 26000.0; -- 26000 Hz
  constant TGT_PERIOD : delay_length := to_period(TGT_FREQ);
  constant DDFS_TOL  : real    := 0.001;  -- 0.1%
  constant SIZE      : natural := ddfs_size(to_real(CLOCK_FREQ), TGT_FREQ, DDFS_TOL);
  constant INCREMENT : unsigned(SIZE-1 downto 0) := ddfs_increment(to_real(CLOCK_FREQ), TGT_FREQ, SIZE);

  signal accum      : unsigned(INCREMENT'range);
  signal synth_tone : std_ulogic;
  
begin

  stim: process
  begin
    reset <= '1', '0' after CPERIOD;

    wait for TGT_PERIOD * 4;

    sim_done <= true;
    wait;
  end process;

  validate: process
    -- The allowable variation in the period of the synthesized signal
    constant PERIOD_TOL : time := to_time(DDFS_TOL * 10.0 / TGT_FREQ);
    variable prev_edge : time;
  begin
    report "Target freq: " & real'image(TGT_FREQ);
    report "Min period: " & time'image(TGT_PERIOD - PERIOD_TOL) & " (" & frequency'image(to_frequency(TGT_PERIOD - PERIOD_TOL)) & ")";
    report "Max period: " & time'image(TGT_PERIOD + PERIOD_TOL) & " (" & frequency'image(to_frequency(TGT_PERIOD + PERIOD_TOL)) & ")";

    wait until rising_edge(synth_tone);
    prev_edge := now;
    while true loop
      wait until rising_edge(synth_tone);
      assert abs((now - prev_edge) - TGT_PERIOD) <= PERIOD_TOL
        report "BAD period: " & time'image(now - prev_edge) & " (" & frequency'image(to_frequency(now - prev_edge)) & ")"
        severity failure;
      prev_edge := now;
      --wait until synth_tone'event;

      --assert synth_tone'delayed'stable((TGT_PERIOD - PERIOD_TOL) / 2)
      --  report "Half-period too short: " & time'image(synth_tone'delayed'last_event) severity failure;

      --assert synth_tone'delayed'last_event < (TGT_PERIOD + PERIOD_TOL) / 2 
      --  report "Half-period too long: " & time'image(synth_tone'delayed'last_event) severity failure;
    end loop;
  end process;

  whistle: ddfs
    port map (
      Clock => clock,
      Reset => reset,
      Load_phase => '0',
      New_phase => "0",
      Increment   => INCREMENT,
      Accumulator => accum,
      Synth_clock => synth_tone,
      Synth_pulse => open
    );

  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;  
end architecture;
