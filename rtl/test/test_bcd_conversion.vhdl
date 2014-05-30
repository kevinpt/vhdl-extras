--# Copyright © 2014 Kevin Thibedeau

entity test_bcd_conversion is
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;
use extras.bcd_conversion.all;
use extras.timing_ops.all;

architecture test of test_bcd_conversion is
  signal num : unsigned(7 downto 0);
  
  constant DIGITS : natural := decimal_size(2**num'length - 1);
  signal bcd : unsigned(DIGITS*4-1 downto 0);
  signal binary : unsigned(bit_size(10**DIGITS-1)-1 downto 0);
  
  
  constant CLOCK_FREQ : frequency := 100 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);
  signal sim_done : boolean := false;
  
  signal clock, reset : std_ulogic;
  signal convert, done : std_ulogic;
  signal bin2bcd_in : unsigned(7 downto 0);
  signal bin2bcd_out : unsigned(decimal_size(2**bin2bcd_in'length-1)*4-1 downto 0);

  signal convert_bcd, done_bcd : std_ulogic;
  signal bcd2bin_in : unsigned(decimal_size(255)*4-1 downto 0);
  signal bcd2bin_out : unsigned(bit_size(10**decimal_size(255)-1)-1 downto 0);
begin

  func_test: process
    variable b : unsigned(num'range);

  begin
    for i in 0 to 255 loop
      b := to_unsigned(i, b'length);
      num <= b;
      bcd <= to_bcd(b);
      binary <= to_binary(to_bcd(b));
      
      wait for 1 ns;
      
      assert binary = num report "Binary mismatch" severity failure;
    end loop;
  
    wait;
  end process;
  
  bin2bcd_stim: process
  begin
  
    reset <= '1', '0' after CPERIOD * 2;
    convert <= '0';

    wait until rising_edge(Clock);
    wait for CPERIOD * 4;
  
    for i in 95 to 105 loop
      bin2bcd_in <= to_unsigned(i,bin2bcd_in'length);
      convert <= '1';
      wait for CPERIOD * 2;
      convert <= '0';
      wait until done = '1';
      wait for CPERIOD;
    end loop;
    
    wait;  
  end process;

  bin2bcd: binary_to_bcd
    port map (
      Clock => clock,
      Reset => reset,
      
      Convert => convert,
      Done => done,
      
      Binary => bin2bcd_in,
      BCD => bin2bcd_out
    );

  bin2bcd_validate: process
  begin
    wait until falling_edge(reset);
    loop
      wait until rising_edge(done);
      wait for CPERIOD / 2;
      assert bin2bcd_in = to_binary(bin2bcd_out) report "bin2bcd mismatch" severity failure;
    end loop;
  end process;



  bcd2bin_stim: process
  begin
    convert_bcd <= '0';
    
    wait until reset = '0';
    wait for CPERIOD * 2;
    
    for i in 95 to 105 loop
      bcd2bin_in <= to_bcd(to_unsigned(i, 8));
      convert_bcd <= '1';
      wait for CPERIOD * 2;
      convert_bcd <= '0';
      
      wait until done_bcd = '1';
      wait for CPERIOD;
    end loop;

    wait for CPERIOD;
  
    sim_done <= true;
    
    wait;
  end process;

  bcd2bin: bcd_to_binary
    port map (
      Clock   => clock,
      Reset => reset,
      
      Convert => convert_bcd,
      Done    => done_bcd,
      
      BCD    => bcd2bin_in,
      Binary => bcd2bin_out
    );

  bcd2bin_validate: process
  begin
    wait until falling_edge(reset);
    loop
      wait until rising_edge(done_bcd);
      wait for CPERIOD / 2;
      assert bcd2bin_in = to_bcd(bcd2bin_out) report "bcd2bin mismatch" severity failure;
    end loop;
  end process;

  
  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;
  
end architecture;
