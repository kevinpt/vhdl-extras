--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.hamming_edac.all;
use extras.secded_edac.all;
use extras.random.all;

entity test_secded_edac is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_secded_edac is
begin

  s: process
  begin
    seed(TEST_SEED);
    wait;
  end process;

  w: for width in 4 to 64 generate
    decode: process
      subtype word is std_ulogic_vector(width-1 downto 0);
      constant WORD_ECC : ecc_range := secded_indices(word'length);
      variable secded_word : ecc_vector(WORD_ECC.left downto WORD_ECC.right);
      variable data, corrected_data : word;
      variable inject_error, error_detected : boolean;
      variable flipped_bit : integer;
      variable secded_error : secded_errors;

      variable message  : std_ulogic_vector(secded_word'length-1 downto 1);
      variable syndrome : unsigned(-(secded_word'low+1) downto 1);
    begin

      for i in 1 to 50 loop
        data := std_ulogic_vector(to_stdlogicvector(random(word'length)));

        secded_word := secded_encode(data);

        inject_error := random;
        if inject_error then -- Flip a bit
          flipped_bit := randint(secded_word'low, secded_word'high);
          secded_word(flipped_bit) := not secded_word(flipped_bit);
        end if;

        secded_error := secded_has_errors(secded_word);
        corrected_data := secded_decode(secded_word);

        error_detected := secded_error(single_bit) or secded_error(double_bit);

        assert error_detected = inject_error report "Undetected error" severity failure;
        assert corrected_data = data report "Mismatch decoded data" severity failure;

        -- Check interleaved decode variant
        message := hamming_interleave(secded_word(secded_word'high downto secded_word'low+1));
        syndrome := hamming_parity(message);
        secded_error := secded_has_errors(secded_word, syndrome);
        corrected_data := hamming_decode(message, syndrome);

        assert secded_error(single_bit) = inject_error and secded_error(double_bit) = false
          report "Interleave, undetected error" severity failure;
        assert corrected_data = data report "Interleave, mismatch decoded data" severity failure;

      end loop;

      wait;
    end process;
  end generate;

end architecture;



library extras;
use extras.hamming_edac.all;
use extras.secded_edac.all;

entity test_secded_size is
end entity;

architecture test of test_secded_size is
begin
  s: process
    variable msg_size, parity_size, data_size : positive;
  begin
    for bits in 4 to 5000 loop
      msg_size    := secded_message_size(bits);
      parity_size := secded_parity_size(msg_size);
      data_size   := secded_data_size(msg_size);

      assert data_size = bits report "data_size mismatch" severity failure;
      assert msg_size = data_size + parity_size report "msg_size mismatch" severity failure;
    end loop;

    wait;
  end process;
end architecture;


