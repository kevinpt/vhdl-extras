--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.memory.all;
use extras.timing_ops.all;
use extras.random.all;

entity test_dual_port_ram is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_dual_port_ram is
  constant MEM_SIZE : natural := 64;

  signal clock : std_ulogic;

  signal sim_done : boolean := false;
  constant CLOCK_FREQ : frequency := 50 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);

  subtype word is std_ulogic_vector(7 downto 0);
  type word_vec is array(natural range <>) of word;

  signal we, re : std_ulogic;
  signal wr_addr, rd_addr : natural;
  signal wr_data, rd_data : word;
begin

  stim: process
    variable wr_log, rd_log : word_vec(1 to MEM_SIZE);
  begin
    seed(TEST_SEED);

    we <= '0';
    re <= '0';
    wr_addr <= 0;
    wr_data <= (others => '0');
    rd_addr <= 0;

    -- Generate random data
    for i in wr_log'range loop
      wr_log(i) := std_ulogic_vector(to_stdlogicvector(random(word'length)));
    end loop;

    wait until falling_edge(clock);

    -- Fill memory
    we <= '1', '0' after CPERIOD * wr_log'length;
    for i in wr_log'range loop
      wr_data <= wr_log(i);
      wait for CPERIOD;
      if wr_addr < MEM_SIZE-1 then
        wr_addr <= wr_addr + 1;
      end if;
    end loop;
    wait for CPERIOD;

    -- Read back contents
    re <= '1', '0' after CPERIOD * rd_log'length;
    for i in rd_log'range loop
      wait for CPERIOD;
      rd_log(i) := rd_data;
      if rd_addr < MEM_SIZE-1 then
        rd_addr <= rd_addr + 1;
      end if;
    end loop;

    -- Compare
    for i in wr_log'range loop
      assert wr_log(i) = rd_log(i) report "Read mismatch: " & integer'image(i) severity failure;
    end loop;

    sim_done <= true;
    wait;
  end process;

  dpr: dual_port_ram
    generic map (
      MEM_SIZE => MEM_SIZE
    ) port map (
      Wr_clock => clock,
      We => we,
      Wr_addr => wr_addr,
      Wr_data => wr_data,

      Rd_clock => clock,
      Re => re,
      Rd_addr => rd_addr,
      Rd_data => rd_data
    );

  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;  
 
end architecture;
