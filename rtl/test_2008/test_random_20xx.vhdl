
library extras_2008;
use extras_2008.random.all;

entity test_random_20xx is
end entity;

architecture test of test_random_20xx is
  signal bv : bit_vector(29 downto 0);
begin
  test: process
    variable r : real;
    variable i : integer;
    variable b : boolean;
  begin
    seed(42, 12);

    r := random;
    report "Random: " & real'image(r);

    r := random;
    report "Random: " & real'image(r);

    r := random;
    report "Random: " & real'image(r);

    for j in 1 to 20 loop
      i := randint(0, 5);
      report "Randint: " & integer'image(i);
    end loop;

    for j in 1 to 20 loop
      b := random;
      report "Randbool: " & boolean'image(b);
    end loop;

    wait;
  end process;

  bv_rand: process
  begin
    for i in 0 to 20 loop
      bv <= random(bv'length);
      wait for 1 ns;
    end loop;

    wait;
  end process;
end architecture;
