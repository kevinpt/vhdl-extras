--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.random.all;
use extras.timing_ops.all;
use extras.interrupt_ctl_pkg.all;


entity test_interrupt_ctl is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_interrupt_ctl is
  constant CLOCK_FREQ : frequency := 100 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);
  signal sim_done : boolean := false;

  signal int_mask, int_request, pending_int, current_int : std_ulogic_vector(7 downto 0);
  signal clock, reset, interrupt, interrupt_ack, clear_pending : std_ulogic;
begin


  stim: process
  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);

    int_request <= (others => '0');
    int_mask <= (others => '1');
    interrupt_ack <= '0';
    clear_pending <= '0';

    reset <= '1', '0' after CPERIOD;

    wait for CPERIOD * 2;
    wait until falling_edge(clock);

    -- Assert single interrupt
    int_request(7) <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;
    assert interrupt = '1' and current_int = "10000000"
      report "Unexpected interrupt 1" severity failure;
    interrupt_ack <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;

    -- Assert simultaneous interrupts
    int_request(6) <= '1', '0' after CPERIOD;
    int_request(5) <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;
    assert interrupt = '1' and current_int = "00100000"
      report "Unexpected interrupt 2" severity failure;
    interrupt_ack <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;

    assert interrupt = '1' and current_int = "01000000"
      report "Unexpected interrupt 3" severity failure;
    interrupt_ack <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;

    assert interrupt = '0' and current_int = "00000000"
      report "Unexpected interrupt 4" severity failure;
    wait for CPERIOD * 2;

    -- Clear all pending interrupts
    int_request(3) <= '1', '0' after CPERIOD;
    int_request(2) <= '1', '0' after CPERIOD;
    int_request(1) <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;
    assert interrupt = '1' and pending_int = "00001110"
      report "Unexpected interrupt 4.5" severity failure;

    clear_pending <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;
    assert interrupt = '0' and pending_int = "00000000"
      report "Unexpected interrupt 4.6" severity failure;
    wait for CPERIOD * 2;


    -- Assert lower priority followed by higher priority
    int_request(4) <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;

    int_request(3) <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;

    assert interrupt = '1' and current_int = "00010000"
      report "Unexpected interrupt 5" severity failure;
    interrupt_ack <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;

    assert interrupt = '1' and current_int = "00001000"
      report "Unexpected interrupt 6" severity failure;
    interrupt_ack <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;

    -- Assert masked interrupt
    int_mask(2) <= '0';
    int_request(2) <= '1', '0' after CPERIOD;
    wait for CPERIOD;
    assert interrupt = '0'
      report "Mask failure" severity failure;
    wait for CPERIOD * 2;

    -- Generate random interrupts
    for i in 1 to 20 loop
      int_request <= to_stdulogicvector(random(int_request'length)),
        (others => '0') after CPERIOD*2;
      wait for CPERIOD;

      assert pending_int = (int_request and int_mask)
        report "Missing interrupts" severity failure;

      wait for CPERIOD;

      while interrupt = '1' loop
        interrupt_ack <= '1', '0' after CPERIOD;
        wait for CPERIOD * 2;
      end loop;
    end loop;

    sim_done <= true;
    wait;

  end process;

  ic: interrupt_ctl
    port map (
      Clock => clock,
      Reset => reset,

      Int_mask    => int_mask,
      Int_request => int_request,
      Pending     => pending_int,
      Current     => current_int,

      Interrupt     => interrupt,
      Acknowledge   => interrupt_ack,
      Clear_pending => clear_pending
    );

  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;

end architecture;
