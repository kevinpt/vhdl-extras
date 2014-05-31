--# Copyright © 2014 Kevin Thibedeau

use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

library extras;
use extras.memory.all;
use extras.timing_ops.all;

entity test_rom is
  generic (
    ROM_FILE : string;
    OUT_ROM_FILE : string;
    FORMAT : rom_format;
    ROM_SIZE : positive := 8;
    ROM_WIDTH : positive := 8
  );
end entity;

architecture test of test_rom is
  signal clock : std_ulogic;

  signal sim_done : boolean := false;
  constant CLOCK_FREQ : frequency := 50 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);

  subtype word is std_ulogic_vector(ROM_WIDTH-1 downto 0);
  type word_vec is array(natural range <>) of word;

  signal re : std_ulogic;
  signal addr : natural;
  signal data : word;
begin

  stim: process
    variable rd_log : word_vec(1 to ROM_SIZE);
    file rom_out : text open write_mode is OUT_ROM_FILE;
    variable l : line;
  begin

    re <= '0';
    addr <= 0;

    -- Read ROM contents
    re <= '1', '0' after CPERIOD * rd_log'length;
    for i in rd_log'range loop
      wait for CPERIOD;
      rd_log(i) := data;
      if addr < ROM_SIZE-1 then
        addr <= addr + 1;
      end if;
    end loop;

    -- Write ROM data
    for i in rd_log'range loop
      write(l, rd_log(i));
      writeline(rom_out, l);
    end loop;

    sim_done <= true;
    wait;
  end process;

  r: rom
    generic map (
      ROM_FILE => ROM_FILE,
      FORMAT => FORMAT,
      MEM_SIZE => ROM_SIZE
    ) port map (
      Clock => clock,
      Re => re,
      Addr => addr,
      Data => data
    );

  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;  
 
end architecture;
