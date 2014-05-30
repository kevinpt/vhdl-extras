--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.synchronizing.all;
use extras.random.all;
use extras.timing_ops.all;

entity test_handshake_synchronizer is
  generic (
    TEST_SEED : positive := 1234;
    TX_FREQ : frequency := 10 MHz;
    RX_FREQ : frequency := 3 MHz
  );
end entity;

architecture test of test_handshake_synchronizer is
  constant CPERIOD : delay_length := to_period(TX_FREQ);

  signal tx_clock, rx_clock, reset, tx_reset, rx_reset, send_data, sending, data_sent, new_data : std_ulogic;

  subtype word is std_ulogic_vector(15 downto 0);
  signal tx_data, rx_data : word;

  signal sim_done : boolean := false;

  constant WORD_COUNT : natural := 10;
  type word_vec is array(natural range <>) of word;
  signal tx_words, rx_words : word_vec(1 to WORD_COUNT);
begin
  stim: process
    variable next_data : word;
  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);

    tx_data <= (others => '0');
    send_data <= '0';

    reset <= '1', '0' after CPERIOD;
    wait for CPERIOD / 2;
    wait until tx_reset = '0' and rx_reset = '0';

    for i in tx_words'range loop
      wait until falling_edge(tx_clock);
      next_data := to_stdulogicvector(random(word'length));
      tx_data <= next_data;
      tx_words(i) <= next_data;

      send_data <= '1', '0' after CPERIOD;

      wait until sending = '1';
      wait until sending = '0';
    end loop;

    -- Verify rx matches tx

    for i in tx_words'range loop
      assert tx_words(i) = rx_words(i)
        report "Mismatch in rx word " & integer'image(i)
        severity failure;
    end loop;

    sim_done <= true;
    wait;
  end process;

  rx: process
    variable j : natural := rx_words'low;
  begin
    wait until new_data = '1';
    wait until falling_edge(rx_clock);
    rx_words(j) <= rx_data;
    j := j + 1;
  end process;


  hs: handshake_synchronizer
  port map (
    Clock_tx => tx_clock,
    Reset_tx => tx_reset,
    Clock_rx => rx_clock,
    Reset_rx => rx_reset,

    Tx_data => tx_data,
    Send_data => send_data,
    Sending => sending,
    Data_sent => data_sent,

    Rx_data => rx_data,
    New_data => new_data
  );

  tx_r: reset_synchronizer
    port map (
      Clock => tx_clock,
      Reset => reset,
      Sync_reset => tx_reset
    );

  rx_r: reset_synchronizer
    port map (
      Clock => rx_clock,
      Reset => reset,
      Sync_reset => rx_reset
    );


  txcgen: process
  begin
    clock_gen(tx_clock, sim_done, TX_FREQ);
    wait;
  end process;

  rxcgen: process
  begin
    clock_gen(rx_clock, sim_done, RX_FREQ);
    wait;
  end process;

end architecture;

