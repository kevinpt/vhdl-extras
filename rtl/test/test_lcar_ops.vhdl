--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.lcar_ops.all;

entity test_lcar_ops is
  generic (
    WIDTH : positive := 4
  );
end entity;

architecture test of test_lcar_ops is
begin

  test: process
    constant rule : std_ulogic_vector(WIDTH-1 downto 0) := lcar_rule(WIDTH);
    variable state : std_ulogic_vector(WIDTH-1 downto 0) := (others => '1');
    variable index : integer;

    type nat_vec is array(natural range <>) of natural;
    variable counts : nat_vec(1 to 2**rule'length-1);
  begin
    for i in counts'range loop
      state := next_wolfram_lcar(state, rule);
      index := to_integer(unsigned(std_logic_vector(state)));

      counts(index) := counts(index) + 1;
    end loop;

    -- We should have completed a full cycle of the maximal length rule.
    -- Each entry in counts should be 1.
    for i in counts'range loop
      assert counts(i) = 1
        report "Mismatch in count: " & integer'image(i) & " = " & integer'image(counts(i))
        severity failure;
    end loop;
    wait;
  end process;
end architecture;
