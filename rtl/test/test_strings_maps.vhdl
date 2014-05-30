--# Copyright © 2014 Kevin Thibedeau

library extras;
use extras.strings_maps.all;
use extras.random.all;


entity test_strings_maps is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_strings_maps is
begin
  test: process
    variable cr : character_range;
    variable cs, cs2, cs3 : character_set;
    variable l, h, n : natural;
    variable x : character;

    variable cr1 : character_ranges(1 to 1);

    variable cm : character_mapping;

  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);


    cr := character_range'('a', 'a');
    cs := to_set(cr);
    for c in character'left to character'right loop
      if c = 'a' then
        assert is_in(c, cs) = true
          report "to_set[character_range] 1 (expected true)" severity failure;
      else
        assert is_in(c, cs) = false
          report "to_set[character_range] 1 (expected false)" severity failure;
      end if;
    end loop;


    cr := character_range'('a', 'c');
    cs := to_set(cr);
    for c in character'left to character'right loop
      if c = 'a' or c = 'b' or c = 'c' then
        assert is_in(c, cs) = true
          report "to_set[character_range] 2 (expected true)" severity failure;
      else
        assert is_in(c, cs) = false
          report "to_set[character_range] 2 (expected false)" severity failure;
      end if;
    end loop;


    for i in 1 to 1000 loop
      -- Create a random range
      l := randint(0, 255);
      h := randint(l, 255);
      cr := character_range'(character'val(l), character'val(h));

      cr1 := to_ranges(to_set(cr));

      assert cr1(1).low = cr.low and cr1(1).high = cr.high
        report "to_set[character_range] 3 bad range" severity failure;
      
    end loop;

    
    for i in 1 to 1000 loop
      -- Create a random character set
      for c in cs'range loop
        cs(c) := random;
      end loop;

      cs2 := to_set(to_ranges(cs));

      -- Make sure the converted set matches the original
      assert cs = cs2 report "to_ranges mismatch" severity failure;
    end loop;


    for i in 1 to 1000 loop
      -- Create random character sets
      for c in cs'range loop
        cs(c) := random;
        cs2(c) := random;
      end loop;

      cs3 := cs - cs2;
      -- cs3 must be a subset of cs
      assert is_subset(cs3, cs) report "is_subset mismatch 1" severity failure;

      cs3 := cs2 - cs;
      -- cs3 must be a subset of cs2
      assert is_subset(cs3, cs2) report "is_subset mismatch 2" severity failure;

    end loop;



    for i in 1 to 100 loop
      -- Create a random character set
      for c in cs'range loop
        cs(c) := random;
      end loop;

      cs2 := to_set(to_sequence(cs));
      assert cs2 = cs report "to_sequence mismatch" severity failure;
    end loop;


    for i in 1 to 100 loop
      -- Create a random mapping
      n := randint(1, 50);
      cs := (others => false);

      for j in 1 to n loop
        x := random;
        while cs(x) = true loop
          x := random;
        end loop;

        cs(x) := true;
      end loop;

      cs2 := (others => false);
      for j in 1 to n loop
        x := random;
        while cs(x) = true or cs2(x) = true loop
          x := random;
        end loop;

        cs2(x) := true;
      end loop;

      -- We have two disjoint character sets with the same number of characters

      cm := to_mapping(to_sequence(cs), to_sequence(cs2));

      cs3 := to_set(to_domain(cm));
      assert cs3 = cs report "to_domain mismatch" severity failure;

      cs3 := to_set(to_range(cm));
      assert cs3 = cs2 report "to_range mismatch" severity failure;

      for c in cs'range loop
        if cs(c) then
          assert cs2(value(cm, c)) = true report "value mismatch" severity failure;
        end if;
      end loop;

    end loop;

    wait;
  end process;
end architecture;

