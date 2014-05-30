--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.hamming_edac.all;
use extras.random.all;

entity test_hamming_edac is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_hamming_edac is
begin

  s: process
  begin
    seed(TEST_SEED);
    wait;
  end process;

  w: for width in 4 to 64 generate
    decode: process
      subtype word is std_ulogic_vector(width-1 downto 0);
      constant WORD_ECC : ecc_range := hamming_indices(word'length);
      variable hamming_word : ecc_vector(WORD_ECC.left downto WORD_ECC.right);
      variable data, corrected_data : word;
      variable inject_error, error_detected : boolean;
      variable flipped_bit : integer;

      variable message  : std_ulogic_vector(hamming_word'length downto 1);
      variable syndrome : unsigned(-hamming_word'low downto 1);
    begin

      for i in 1 to 50 loop
        data := std_ulogic_vector(to_stdlogicvector(random(word'length)));

        hamming_word := hamming_encode(data);

        inject_error := random;
        if inject_error then -- Flip a bit
          flipped_bit := randint(hamming_word'low, hamming_word'high);
          hamming_word(flipped_bit) := not hamming_word(flipped_bit);
        end if;

        error_detected := hamming_has_error(hamming_word);
        corrected_data := hamming_decode(hamming_word);

        assert error_detected = inject_error report "Undetected error" severity failure;
        assert corrected_data = data report "Mismatch decoded data" severity failure;

        -- Check interleaved decode variant
        message := hamming_interleave(hamming_word);
        syndrome := hamming_parity(message);
        error_detected := hamming_has_error(syndrome);
        corrected_data := hamming_decode(message, syndrome);

        assert error_detected = inject_error report "Interleave, undetected error" severity failure;
        assert corrected_data = data report "Interleave, mismatch decoded data" severity failure;

      end loop;

      wait;
    end process;
  end generate;

end architecture;


library extras;
use extras.hamming_edac.all;

entity test_hamming_size is
end entity;

architecture test of test_hamming_size is
begin
  s: process
    variable msg_size, parity_size, data_size : positive;
  begin
    for bits in 4 to 5000 loop
      msg_size    := hamming_message_size(bits);
      parity_size := hamming_parity_size(msg_size);
      data_size   := hamming_data_size(msg_size);

      assert data_size = bits report "data_size mismatch" severity failure;
      assert msg_size = data_size + parity_size report "msg_size mismatch" severity failure;
    end loop;

    wait;
  end process;
end architecture;


