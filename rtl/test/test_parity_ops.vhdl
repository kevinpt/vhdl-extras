--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.parity_ops.all;
use extras.random.all;

entity test_parity_ops is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_parity_ops is
begin
  test: process
    variable vec : std_ulogic_vector(29 downto 0);
    variable set_bits : natural;
    variable p, expect_p : std_ulogic;

  begin

    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);

    for i in 1 to 100 loop
      vec := to_stdulogicvector(random(vec'length));

      set_bits := 0;
      for j in vec'range loop
        if vec(j) = '1' then
          set_bits := set_bits + 1;
        end if;
      end loop;

      for pk in parity_kind loop
        p := parity(pk, vec);

        if pk = even then
          if set_bits mod 2 = 0 then -- Even number of '1's
            expect_p := '0';
          else -- Odd number of '1's
            expect_p := '1';
          end if;
        else -- Odd parity
          if set_bits mod 2 = 0 then -- Even number of '1's
            expect_p := '1';
          else -- Odd number of '1's
            expect_p := '0';
          end if;
        end if;

        
        assert p = expect_p
          report "Mismatch in parity (" & parity_kind'image(pk) & "):" & std_ulogic'image(p) & "  expect: " & std_ulogic'image(expect_p)
            & "  set bits: " & integer'image(set_bits)
          severity failure;

        assert check_parity(pk, vec, p)
          report "Mismatch in check_parity"
          severity failure;
      end loop;

    end loop;

    wait;
  end process;
end architecture;
