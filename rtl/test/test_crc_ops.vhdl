--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.numeric_bit.all;

library extras;
use extras.crc_ops.all;
use extras.random.all;

entity test_crc_ops is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_crc_ops is
  subtype word is bit_vector(7 downto 0);

begin
  test: process
    constant XORIN  : word    := X"FF";
    constant XOROUT : word    := X"FF";

    variable data1_size, data2_size : natural;
    variable refin, refout          : boolean;

    variable poly   : word;
    variable crc1, crc2, crca, crcb, crc1a, crc2b : word;
  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);

    for p in 1 to 2**word'length-1 loop -- Try all possible polynomials
      poly := bit_vector(to_unsigned(p, word'length));

      -- Randomly select the size of two random data sets
      data1_size := randint(10, 20);
      data2_size := randint(10, 20);

      refin  := random;
      refout := refin;

      report "data1: " & integer'image(data1_size) & ", data2: " & integer'image(data2_size);

      crc1 := init_crc(XORIN);
      for i in 1 to data1_size loop
        crc1 := next_crc(crc1, poly, refin, random(word'length));
      end loop;
      crca := end_crc(crc1, refout, XOROUT);

      crc2 := init_crc(XORIN);
      for i in 1 to data2_size loop
        crc2 := next_crc(crc2, poly, refin, random(word'length));
      end loop;
      crcb := end_crc(crc2, refout, XOROUT);


      -- Adding the CRC to a data set and recomputing the CRC on the total
      -- results in a constant value for a set of CRC parameters.
      crc1a := next_crc(crc1, poly, refin, crca); -- Add crca to the original crc1
      crc1a := end_crc(crc1a, refout, XOROUT);

      crc2b := next_crc(crc2, poly, refin, crcb); -- Add crcb to the original crc2
      crc2b := end_crc(crc2b, refout, XOROUT);

      assert crc1a = crc2b report "CRC error: poly=" & integer'image(p) severity failure;

    end loop;

    wait;
  end process;
end architecture;
