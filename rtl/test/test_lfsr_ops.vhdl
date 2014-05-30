--# Copyright © 2014 Kevin Thibedeau

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.lfsr_ops.all;

entity test_lfsr_ops is
  generic (
    WIDTH : positive := 4;
    KIND : lfsr_kind := normal;
    FULL_CYCLE : boolean := false
  );
end entity;

architecture test of test_lfsr_ops is
begin

  test: process
    constant tap_map : std_ulogic_vector(1 to WIDTH-1) := lfsr_taps(WIDTH);
    variable gstate, fstate : std_ulogic_vector(1 to WIDTH);
    variable index : integer;

    type nat_vec is array(natural range <>) of natural;
    variable gcounts, fcounts : nat_vec(0 to 2**gstate'length-1);
    variable startc, endc : natural;
  begin
    if KIND = normal then
      gstate := (others => '1');
      fstate := (others => '1');
      startc := 1;
      endc   := gcounts'high;
    else -- Inverted
      gstate := (others => '0');
      fstate := (others => '0');
      startc := 0;
      endc   := gcounts'high - 1;
    end if;

    if FULL_CYCLE then
      startc := 0;
      endc   := gcounts'high;
    end if;

    for i in startc to endc loop
      -- Run Galois LFSR
      gstate := next_galois_lfsr(gstate, tap_map, KIND, FULL_CYCLE);
      index := to_integer(unsigned(std_logic_vector(gstate)));

      gcounts(index) := gcounts(index) + 1;

      -- Run Fibonacci LFSR
      fstate := next_fibonacci_lfsr(fstate, tap_map, KIND, FULL_CYCLE);
      index := to_integer(unsigned(std_logic_vector(fstate)));

      fcounts(index) := fcounts(index) + 1;

    end loop;

    -- We should have completed a full cycle of the maximal length taps.
    -- Each entry in counts should be 1.
    for i in startc to endc loop
      assert gcounts(i) = 1
        report "Mismatch in Galois count: " & integer'image(i) & " = " & integer'image(gcounts(i))
        severity failure;

      assert fcounts(i) = 1
        report "Mismatch in Fibonacci count: " & integer'image(i) & " = " & integer'image(fcounts(i))
        severity failure;

    end loop;
    wait;
  end process;
end architecture;
