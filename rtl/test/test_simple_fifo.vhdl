--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.fifos.all;
use extras.timing_ops.all;
use extras.random.all;

entity test_simple_fifo is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture tb of test_simple_fifo is
  signal clock, reset : std_ulogic;

  signal sim_done : boolean := false;
  constant CLOCK_FREQ : frequency := 50 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);

  constant FIFO_SIZE : natural := 64;

  signal we, re, empty, full, almost_empty, almost_full : std_ulogic;
  signal almost_empty_thresh, almost_full_thresh : natural;

  subtype word is std_ulogic_vector(7 downto 0);
  type word_vec is array(natural range <>) of word;
  signal wr_data, rd_data : word;

begin

  stim: process
    variable wr_log, rd_log : word_vec(0 to FIFO_SIZE*5);
    variable exp_ae, exp_af : std_ulogic;

    constant RD_DELAY : natural := 10;
  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);

    reset <= '1', '0' after CPERIOD;
    we <= '0';
    re <= '0';
    wr_data <= (others => '0');
    almost_empty_thresh <= 10;
    almost_full_thresh <= 4;

    wait until falling_edge(clock);
    wait for CPERIOD * 2;

    -- Generate random data
    for i in 0 to FIFO_SIZE-1 loop
      wr_log(i) := std_ulogic_vector(to_stdlogicvector(random(word'length)));
    end loop;

    -- Fill up the FIFO and monitor the flags to ensure they toggle at the correct time
    assert empty = '1' and full = '0' and almost_empty = '0' and almost_full = '0'
      report "Bad flags when empty" severity failure;

    for i in 0 to FIFO_SIZE-1 loop
      wr_data <= wr_log(i);
      we <= '1';
      wait for CPERIOD;

      assert empty = '0' report "Bad empty flag:" & integer'image(i) severity failure;

      if i < FIFO_SIZE - 1 then
        assert full = '0' report "Bad full flag:" & integer'image(i) severity failure;
      end if;

      if i < almost_empty_thresh then
        exp_ae := '1';
      else
        exp_ae := '0';
      end if;
      assert almost_empty = exp_ae report "Bad almost empty flag:" & integer'image(i) severity failure;

      if i >= FIFO_SIZE - 1 - almost_full_thresh and i < FIFO_SIZE-1 then
        exp_af := '1';
      else
        exp_af := '0';
      end if;
      assert almost_full = exp_af report "Bad almost full flag:" & integer'image(i) severity failure;

    end loop;
    we <= '0';
    wait for CPERIOD;

    assert empty = '0' and full = '1' and almost_empty = '0' and almost_full = '0'
      report "Bad flags when full" severity failure;

    -- Read back FIFO
    for i in 0 to FIFO_SIZE-1 loop
      re <= '1';
      wait for CPERIOD;

      rd_log(i) := rd_data;

    -- Verify read matches write
      assert rd_log(i) = wr_log(i) report "Read mismatch: " & integer'image(i) severity failure;
    end loop;
    re <= '0';
    wait for CPERIOD;

    assert empty = '1' and full = '0' and almost_empty = '0' and almost_full = '0'
      report "Bad flags when empty after read" severity failure;


    -- Continuous write and delayed read across wraparound boundary
    for i in wr_log'range loop
      wr_log(i) := std_ulogic_vector(to_stdlogicvector(random(word'length)));
      wr_data <= wr_log(i);
      we <= '1';
      re <= '1' after CPERIOD * RD_DELAY;
      wait for CPERIOD;

      if i >= RD_DELAY then
        rd_log(i-RD_DELAY) := rd_data;
      end if;
      
    end loop;
    we <= '0';

    -- Finish off delayed reads
    for i in rd_log'high - RD_DELAY + 1 to rd_log'high loop
      wait for CPERIOD;
      rd_log(i) := rd_data;
    end loop;
    re <= '0';

    wait for CPERIOD;

    for i in rd_log'range loop
      assert rd_log(i) = wr_log(i) report "Continuous read mismatch: " & integer'image(i)
        severity failure;
    end loop;


    sim_done <= true;
    wait;
  end process;


  fifo: simple_fifo
    generic map (
      MEM_SIZE => FIFO_SIZE
    )
    port map (
      Clock  => clock,
      Reset  => reset,
      We     => we,
      Wr_data => wr_data,

      Re      => re,
      Rd_data => rd_data,

      Empty => empty,
      Full  => full,

      Almost_empty_thresh => almost_empty_thresh,
      Almost_full_thresh  => almost_full_thresh,
      Almost_empty        => almost_empty,
      Almost_full         => almost_full
    );



  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;  
end architecture;
