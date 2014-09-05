--# Copyright © 2014 Kevin Thibedeau

library ieee;
--use ieee.numeric_bit.all;
use ieee.math_real.all;

library extras;
use extras.timing_ops.all;
use extras.random.all;

entity test_timing_ops is
  generic (
    TEST_SEED : positive := 1234
  );
end entity;

architecture test of test_timing_ops is



  -- Adapted from: http://floating-point-gui.de/errors/comparison/
  function relatively_equal(a, b, epsilon : real) return boolean is
  begin
    if a = b then -- Take care of infinities
      return true;
    elsif a * b = 0.0 then -- Either a or b is zero
      return abs(a - b) < epsilon ** 2;
    else -- Relative error
      return abs(a - b) / (abs(a) + abs(b)) < epsilon;
    end if;
  end function;

  function relatively_equal(a, b : time; epsilon : real) return boolean is
  begin
    if a = 0 ms or b = 0 ms then
      return abs(a - b) < to_time(epsilon ** 2);
    else -- Relative error
      return to_real(abs(a - b)) / to_real(abs(a) + abs(b))  < epsilon;
    end if;
  end function;

  function relatively_equal(a, b : frequency; epsilon : real) return boolean is
  begin
    if a = 0 hz or b = 0 hz then
      return abs(a - b) < to_frequency(epsilon ** 2);
    else -- Relative error
      return to_real(abs(a - b)) / to_real(abs(a) + abs(b))  < epsilon;
    end if;
  end function;

begin


  test: process
    variable r, r2 : real;
    variable t, t2 : time;
    variable exp : integer;

    variable c, c2 : natural;
    variable p, p2 : delay_length;
    variable f, f2 : frequency;
  begin
    report "Seed: " & integer'image(TEST_SEED);
    seed(TEST_SEED);


    -- Run random time values through to_real and to_time
    for i in 1 to 100000 loop
      r := random;

      if random then -- Randomly choose negative or positive
        r := -r;
      end if;

      exp := randint(-4, 6);
      --report "### to_real: " & real'image(r) & "  " & real'image(r * 10.0**exp) & "  " & integer'image(exp);
      r := r * 10.0**exp;

      t := to_time(r);
      r2 := to_real(t);
      assert relatively_equal(r, r2, 0.001)
        report "Mismatch in to_real(): " & real'image(r) & " /= " & real'image(r2) & "  (" & time'image(t) & ")"
        severity failure;

      t2 := to_time(r2);
      assert relatively_equal(t, t2, 0.000000001)
        report "Mismatch in to_time(): " & time'image(t) & " /= " & time'image(t2)
        severity failure;
    end loop;



    -- Frequency conversion
    for i in 1 to 10000 loop
      p := randtime(1 ns, 100 us);
      f := to_frequency(p);

      p2 := to_period(f);
      assert relatively_equal(p, p2, 0.001)
        report "Mismatch in to_period[frequency]: " & time'image(p) & " /= " & time'image(p2)
        severity failure;

      p2 := to_period(to_real(f));
      assert relatively_equal(p, p2, 0.0001)
        report "Mismatch in to_period[real]: " & time'image(p) & " /= " & time'image(p2)
        severity failure;

      f2 := to_frequency(to_period(f));
      assert relatively_equal(f, f2, 0.001)
        report "Mismatch in to_frequency[delay_length]: " & frequency'image(f) & " /= " & frequency'image(f2)
        severity failure;

      f2 := to_frequency(to_real(to_period(f)));
      assert relatively_equal(f, f2, 0.001)
        report "Mismatch in to_frequency[real]: " & frequency'image(f) & " /= " & frequency'image(f2)
        severity failure;

    end loop;



    -- Test to_clock_cycles and time_duration functions
    for i in 1 to 10000 loop
      c := randint(1, 100000);
      p := randtime(1 ns, 100 us);
      t := p * c;
      c2 := to_clock_cycles(t, p);

      assert c = c2
        report "Mismatch in to_clock_cycles[delay_length, delay_length]: " & integer'image(c) & " /= " & integer'image(c2) & "  " & time'image(p)
        severity failure;



      f := to_frequency(p);
      c2 := to_clock_cycles(t, f);
      -- The conversion to frequency loses some precision so we will allow an error of 5 cycles
      assert abs(c - c2) <= 5
        report "Mismatch in to_clock_cycles[delay_length, frequency]: " & integer'image(c) & " /= " & integer'image(c2)
        severity failure;

      c2 := to_clock_cycles(t, to_real(f));
      -- The conversion to frequency loses some precision so we will allow an error of 5 cycles
      assert abs(c - c2) <= 5
        report "Mismatch in to_clock_cycles[delay_length, real]: " & integer'image(c) & " /= " & integer'image(c2)
        severity failure;


      r := to_real(t);
      c2 := to_clock_cycles(r, p);
      assert c = c2
        report "Mismatch in to_clock_cycles[real, delay_length]: " & integer'image(c) & " /= " & integer'image(c2) & "  " & time'image(p)
        severity failure;

      c2 := to_clock_cycles(r, f);
      -- The conversion to frequency loses some precision so we will allow an error of 5 cycles
      assert abs(c - c2) <= 5
        report "Mismatch in to_clock_cycles[real, frequency]: " & integer'image(c) & " /= " & integer'image(c2)
        severity failure;

      c2 := to_clock_cycles(r, to_real(f));
      -- The conversion to frequency loses some precision so we will allow an error of 5 cycles
      assert abs(c - c2) <= 5
        report "Mismatch in to_clock_cycles[real, real]: " & integer'image(c) & " /= " & integer'image(c2)
        severity failure;


      t2 := time_duration(c2, p);
      assert relatively_equal(t, t2, 0.0001)
        report "Mismatch in time_duration[clock_cycles, delay_length]: " & time'image(t) & " /= " & time'image(t2)
        severity failure;


      t2 := time_duration(c2, to_real(f));
      assert relatively_equal(t, t2, 0.0001)
        report "Mismatch in time_duration[clock_cycles, real, return delay_length]: " & time'image(t) & " /= " & time'image(t2)
        severity failure;

      r2 := time_duration(c2, to_real(f));
      assert relatively_equal(to_real(t), r2, 0.0001)
        report "Mismatch in time_duration[clock_cycles, real, return real]: " & real'image(to_real(t)) & " /= " & real'image(r2)
        severity failure;


    end loop;    

    wait;
  end process;

  -- Test regression in to_real() that caused an out of range 0 to be returned
  -- from ceil_log_2() when t > integer'high*min_time by a small amount.
  regression1: process
    variable t, t2 : time;
    variable r : real;
    variable min_time : time := resolution_limit;
  begin
    t := integer'high*min_time + 2 ms;
    r := to_real(t);
    t2 := to_time(r);
    assert relatively_equal(t, t2, 0.000000001)
      report "Regression failure: " & time'image(t) & " /= " & time'image(t2)
      severity failure;

    wait;
  end process;
end architecture;
