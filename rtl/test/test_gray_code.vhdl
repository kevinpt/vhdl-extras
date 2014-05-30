
--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.gray_code.all;


entity test_gray_code is
end entity;

architecture tb of test_gray_code is
begin
  stim: process
    variable bin, num, gray : std_ulogic_vector(3 downto 0);
  begin
    for i in 0 to 2**num'length - 1 loop
      num  := to_stdulogicvector(std_logic_vector(to_unsigned(i, num'length)));
      gray := to_gray(num);
      bin  := to_binary(gray);
      assert bin = num report "Mismatched conversion: " & integer'image(i) severity failure;
    end loop;
    
    wait;
  end process;
end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.gray_code.all;
use extras.timing_ops.all;

entity test_gray_counter is
end entity;

architecture tb of test_gray_counter is
  signal sim_done : boolean := false;
  constant CLOCK_FREQ : frequency := 100 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);
  
  signal clock, reset : std_ulogic;
  
  signal binary_count, gray_count : unsigned(3 downto 0);
begin

  stim: process
  begin
    reset <= '1', '0' after CPERIOD*2;
    
    wait for CPERIOD * 18;
    
    sim_done <= true;
    wait;
  end process;

  gc: gray_counter
    port map (
      Clock => clock,
      Reset => reset,
			Load  => '0',
      Enable => '1',
			Binary_load => (binary_count'range => '0'),
      Binary => binary_count,
      Gray   => gray_count
    );

  validate: process
  begin
    wait until falling_edge(reset);
    loop
      wait until gray_count'event;
      wait for CPERIOD / 2;
      assert binary_count = to_binary(gray_count) report "Gray count mismatch" severity failure;
    end loop;
  end process;

  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;

end architecture;
