--# Copyright © 2014 Kevin Thibedeau

library extras;
use extras.sizing.all;

entity test_sizing is
end entity;

architecture test of test_sizing is
  type pair is record
    num  : natural;
    size : natural;
  end record;
  type pair_vec is array(natural range <>) of pair;

begin
  log: process
    constant bit_sizes : pair_vec := ((0, 1), (1, 1), (2, 2), (3, 2), (4, 3), (5, 3), (6, 3), (7, 3), (8, 4));
    constant enc_sizes : pair_vec := ((1, 1), (2, 1), (3, 2), (4, 2), (5, 3), (6, 3), (7, 3), (8, 3), (9, 4));
  begin
    for b in 2 to 10 loop
      for n in 1 to 9 loop
        assert floor_log(b**n, b) = n
          report "floor_log error: b=" & integer'image(b) & ", n=" & integer'image(n)
          severity failure;

        assert ceil_log(b**n, b) = n
          report "ceil_log error: b=" & integer'image(b) & ", n=" & integer'image(n)
          severity failure;
      end loop;
    end loop;

    for n in 1 to 300 loop
      if floor_log2(n) /= ceil_log2(n) then
        assert floor_log2(n) = ceil_log2(n) - 1 report "log2 error i=" & integer'image(n)
          severity failure;
      end if;
    end loop;

    for i in bit_sizes'range loop
      assert bit_size(bit_sizes(i).num) = bit_sizes(i).size report "bit_size error i=" & integer'image(i)
        severity failure;
    end loop;

    for i in enc_sizes'range loop
      assert encoding_size(enc_sizes(i).num) = enc_sizes(i).size report "encoding_size error i=" & integer'image(i)
        severity failure;
    end loop;

    wait;
  end process;
end architecture;
