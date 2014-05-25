
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

library extras;
use extras.random.all;
use extras.sizing.bit_size;
use extras.timing_ops.all;

entity test_reg_file is
  generic (
    TEST_SEED : positive := 1234;
    NUM_REGS  : positive := 4;

    -- Modelsim is braindead and doesn't allow passing generic composite types
    -- from the command line so we have to flatten them into a bit_vector.
    -- Modelsim also limits command line plain generic strings to 64 chars but
    -- not apparently for bit string literals.
    --STROBE_BIT_MASK : reg_array := (X"0003", X"3000", X"0000", X"0000");
    --DIRECT_READ_BIT_MASK : reg_array := (X"0000", X"0FF0", X"0000", X"0000")
    STROBE_BIT_MASK_BV : bit_vector := (X"0003_3000_0000_0000");
    DIRECT_READ_BIT_MASK_BV : bit_vector := (X"0000_0FF0_0000_0000")
  );
end entity;


library extras_2008;
use extras_2008.reg_file_pkg.all;

architecture test of test_reg_file is

  subtype my_reg_word is std_ulogic_vector(15 downto 0);
  subtype my_reg_array is reg_array(0 to NUM_REGS-1)(my_reg_word'range);

  signal clock, reset : std_ulogic;

  signal sim_done : boolean := false;
  constant CLOCK_FREQ : frequency := 50 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);

  signal reg_sel : unsigned(bit_size(NUM_REGS)-1 downto 0);
  signal we, clear : std_ulogic;
  signal wr_data, rd_data : my_reg_word;
  signal registers, direct_read : my_reg_array;
  signal reg_written : std_ulogic_vector(my_reg_array'range);


  function split_mask(m : bit_vector) return my_reg_array is
    alias m2 : bit_vector(m'length-1 downto 0) is m;
    variable r : my_reg_array;
  begin
    for i in 0 to NUM_REGS-1 loop
      r(i) := to_stdulogicvector(m2((i+1)*my_reg_word'length-1 downto i*my_reg_word'length));
    end loop;
    return r;
  end function;


  constant DRBM : reg_array := split_mask(DIRECT_READ_BIT_MASK_BV);
  constant SBM : reg_array := split_mask(STROBE_BIT_MASK_BV);
begin

  stim: process
    variable expect : my_reg_word;
    variable l : line;

    variable wr_log : my_reg_array;
  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);

    we <= '0';
    clear <= '0';
    wr_data <= (others => '0');
    reg_sel <= (others => '0');
    direct_read <= (others => (others => '0'));

    reset <= '1', '0' after CPERIOD;

    wait for CPERIOD * 2;

    -- Write all '1's to registers and verify all non-strobes are '1'
    -- and all strobes are '0'

    wait until falling_edge(clock);


    for j in 1 to 10 loop

      we <= '1';

      for i in registers'range loop
        reg_sel <= to_unsigned(i, reg_sel'length);
        wr_log(i) := to_stdulogicvector(random(my_reg_word'length));
        wr_data <= wr_log(i);
        direct_read(i) <= to_stdulogicvector(random(my_reg_word'length));
        wait for CPERIOD;
      end loop;

      we <= '0';
      wait for CPERIOD;


      for i in registers'range loop
        reg_sel <= to_unsigned(i, reg_sel'length);
        wait for CPERIOD;

        expect := wr_log(i) and not SBM(i);
        hwrite(l, registers(i));
        write(l, string'(" != "));
        hwrite(l, expect);

        --report "Register: " & integer'image(i) & " = " & l.all;

        assert registers(i) = expect
          report "Register mismatch: " & integer'image(i) & " " & l.all
          severity failure;

        wait for CPERIOD;

        expect := (expect and not DRBM(i))
          or (direct_read(i) and DRBM(i));
        assert rd_data = expect
          report "rd_data mismatch: " & integer'image(i)
          severity failure;

        deallocate(l);

      end loop;


      -- Clear all registers
      clear <= '1', '0' after CPERIOD;
      wait for CPERIOD;

      assert registers = my_reg_array'(others => (others => '0'))
        report "Clear failure"
        severity failure;

    end loop;

    sim_done <= true;
    wait;
  end process;


  rf : reg_file
    generic map (
      DIRECT_READ_BIT_MASK => split_mask(DIRECT_READ_BIT_MASK_BV),
      STROBE_BIT_MASK      => split_mask(STROBE_BIT_MASK_BV)
    )
    port map (
      Clock => clock,
      Reset => reset,

      Clear => clear,

      Reg_sel => reg_sel,
      We      => we,
      Wr_data => wr_data,
      Rd_data => rd_data,

      Registers   => registers,
      Direct_Read => direct_read,
      Reg_written => reg_written
    );

  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process; 

end architecture;


