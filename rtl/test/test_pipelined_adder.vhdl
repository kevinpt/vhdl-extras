
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.arithmetic.all;
use extras.timing_ops.all;
use extras.sizing.bit_size;

entity test_pipelined_adder is
end entity;

architecture sim of test_pipelined_adder is
  constant SYS_CLOCK_FREQ : frequency := 50 MHz;
  constant SYS_CLOCK_PERIOD : delay_length := to_period(SYS_CLOCK_FREQ);
  
  signal clock, reset : std_ulogic;
  signal done : boolean := false;

  constant WORD_SIZE : positive := 13;
  signal a, const : unsigned(WORD_SIZE-1 downto 0);
  signal sum : unsigned(WORD_SIZE downto 0);
  
  constant SLICES : positive := 1;
begin

  stim: process
  begin
    a <= (others => '0');
    const <= (others => '0');
  
    reset <= '1', '0' after SYS_CLOCK_PERIOD * 4;
    
    wait until reset = '0';
    wait until falling_edge(clock);
    
    a <= to_unsigned(33, a'length);
    const <= to_unsigned(10, const'length);
    
    wait for SYS_CLOCK_PERIOD * SLICES;
    a <= to_unsigned(254, a'length);
    const <= to_unsigned(1, const'length);

    wait for SYS_CLOCK_PERIOD * SLICES;
    a <= to_unsigned(255, a'length);
    --const <= to_unsigned(1, const'length);

    wait for SYS_CLOCK_PERIOD;
    a <= to_unsigned(15, a'length);
    --const <= to_unsigned(1, const'length);
    
    wait for SYS_CLOCK_PERIOD;
    a <= to_unsigned(2**WORD_SIZE - 10, a'length);

    wait for SYS_CLOCK_PERIOD;
    a <= to_unsigned(200, a'length);
    const <= to_unsigned(300, a'length);

    
    wait for SYS_CLOCK_PERIOD * 30;
    
    done <= true;
  end process;
  
  pa: pipelined_adder
    generic map (
      SLICES => SLICES,
      CONST_B_INPUT => false
    )
    port map (
      Clock => clock,
      Reset => reset,
      
      A => a,
      B => const,
      
      Sum => sum
    );

  sys_clock_gen: process
  begin
    clock_gen(clock, done, SYS_CLOCK_FREQ);
    wait;
  end process;
  
end architecture;
