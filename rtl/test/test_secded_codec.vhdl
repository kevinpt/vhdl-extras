--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.hamming_edac.ecc_vector;
use extras.secded_edac.secded_indices;
use extras.secded_codec_pkg.all;
use extras.timing_ops.all;
use extras.random.all;

entity test_secded_codec is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_secded_codec is
  constant CLOCK_FREQ : frequency := 10 MHz;
  constant CPERIOD : delay_length := to_period(CLOCK_FREQ);
  constant RX_DELAY : real := 3.5;

  signal sim_done : boolean := false;

  constant DATA_SIZE : natural := 16;
  subtype word is std_ulogic_vector(DATA_SIZE-1 downto 0);

  signal clock, reset : std_ulogic;
  signal single_bit_error, double_bit_error : std_ulogic;
  signal insert_error : std_ulogic_vector(1 downto 0);
  signal data, decoded_data : word;
  signal encoded_data, ecc_data : ecc_vector(DATA_SIZE-1 downto secded_indices(DATA_SIZE).right);


  constant WORD_COUNT : natural := 50;
  type word_vec is array(natural range <>) of word;
  signal tx_words, rx_words : word_vec(1 to WORD_COUNT);

  signal rx_sb_err, rx_db_err : std_ulogic_vector(1 to WORD_COUNT);

  signal data_valid : boolean := false;
begin
  stim: process
    variable next_data : word;
  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);

    insert_error <= INSERT_NONE;
    data <= (others => '0');

    reset <= '1', '0' after CPERIOD;
    wait for CPERIOD * 2;
    wait until falling_edge(clock);


    -- Send data without errors
    data_valid <= true after CPERIOD * RX_DELAY;
    for i in tx_words'range loop
      next_data := to_stdulogicvector(random(data'length));
      data <= next_data;
      tx_words(i) <= next_data;

      wait for CPERIOD;
    end loop;

    data_valid <= false after CPERIOD * (RX_DELAY - 1.0);
    wait for CPERIOD * 5;

    for i in tx_words'range loop
      assert tx_words(i) = rx_words(i)
        report "Mismatch in decoded data with no injected errors"
        severity failure;
      assert rx_sb_err(i) = '0' and rx_db_err(i) = '0'
        report "Mismatch unexpected error detected"
        severity failure;
    end loop;


    -- Inject single bit errors
    insert_error <= INSERT_SINGLE;
    data_valid <= true after CPERIOD * RX_DELAY;
    for i in tx_words'range loop
      next_data := to_stdulogicvector(random(data'length));
      data <= next_data;
      tx_words(i) <= next_data;

      wait for CPERIOD;
    end loop;

    data_valid <= false after CPERIOD * (RX_DELAY - 1.0);
    wait for CPERIOD * 5;

    for i in tx_words'range loop
      assert tx_words(i) = rx_words(i)
        report "Mismatch in decoded data with single-bit errors"
        severity failure;
      assert rx_sb_err(i) = '1' and rx_db_err(i) = '0'
        report "Mismatch unexpected error detected"
        severity failure;
    end loop;


    -- Inject double bit errors
    insert_error <= INSERT_DOUBLE;
    data_valid <= true after CPERIOD * RX_DELAY;
    for i in tx_words'range loop
      next_data := to_stdulogicvector(random(data'length));
      data <= next_data;
      tx_words(i) <= next_data;

      wait for CPERIOD;
    end loop;

    data_valid <= false after CPERIOD * (RX_DELAY - 1.0);
    wait for CPERIOD * 5;

    for i in tx_words'range loop
      assert rx_sb_err(i) = '0' and rx_db_err(i) = '1'
        report "Mismatch unexpected error detected"
        severity failure;
    end loop;


    sim_done <= true;
    wait;
  end process;


  rx: process
    variable j : natural;
  begin
    j := 1;
    wait until data_valid = true;
    while data_valid = true loop
      wait until falling_edge(clock);
      rx_words(j) <= decoded_data;
      rx_sb_err(j) <= single_bit_error;
      rx_db_err(j) <= double_bit_error;
      j := j + 1;
    end loop;
  end process;



  encode: secded_codec
    generic map (
      DATA_SIZE => DATA_SIZE
    ) port map (
      Clock => clock,
      Reset => reset,
      Codec_mode => CODEC_ENCODE,
      Insert_error => insert_error,
      Data => data,
      Encoded_data => encoded_data,

      Ecc_data => (others => '0'),
      Decoded_data => open,

      Single_bit_error => open,
      Double_bit_error => open
    );

  ecc_data <= encoded_data;

  decode: secded_codec
    generic map (
      DATA_SIZE => DATA_SIZE
    ) port map (
      Clock => clock,
      Reset => reset,
      Codec_mode => CODEC_DECODE,
      Insert_error => INSERT_NONE,
      Data => (others => '0'),
      Encoded_data => open,

      Ecc_data => ecc_data,
      Decoded_data => decoded_data,

      Single_bit_error => single_bit_error,
      Double_bit_error => double_bit_error
    );


  cgen: process
  begin
    clock_gen(clock, sim_done, CLOCK_FREQ);
    wait;
  end process;
end architecture;

