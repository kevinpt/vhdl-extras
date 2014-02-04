-- Direct Digital Frequency Synthesizer

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.math_real."**";

library extras;
use extras.sizing.bit_size;


package ddfs_pkg is

  function ddfs_size(sys_freq : real; target_freq : real;
    tolerance : real) return natural;

  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return natural;

  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return unsigned;

  function ddfs_frequency(sys_freq : real; target_freq : real;
    size : natural) return real;

  function ddfs_error(sys_freq : real; target_freq : real;
    size : natural) return real;


  component ddfs is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'
    );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic;
      
      Enable : in std_ulogic := '1';

      Increment : in unsigned;

      Accumulator : out unsigned;
      Synth_clock : out std_ulogic;
      Synth_pulse : out std_ulogic
    );
  end component;

end package;

package body ddfs_pkg is

  function ddfs_size(sys_freq : real; target_freq : real;
    tolerance : real) return natural is

    variable tol_count : real;
    variable size : natural;
  begin
  
    -- Calculate the largest count we need to be able to represent to meet
    -- the desired tolerance.
    tol_count := sys_freq / (target_freq * tolerance);

    -- Round the result up to the nearest integer and get the number of
    -- bits needed to represent it

    -- We can't convert to an integer and call bit_size until the value
    -- is less than 2**31 - 1 (i.e. integer'high). We first get a rough
    -- estimate of how many bits in excess of 30 there are for the floating
    -- point value tol_count. We then divide down by this number of bits to
    -- get an adjusted tol_count that can be converted to an integer.
    -- Dividing tol_count directly by 2.0**30 introduces too much error
    -- and gives the wrong result.
    
    size := 0;
    if tol_count > 2.0**23 then
      size := bit_size(integer(tol_count / 2.0**30));
      tol_count := tol_count / 2.0**size;
    end if;

    return size + bit_size(integer(tol_count + 0.5));

  end function;


--   -- compute 2**n with a floating point result that can exceed the max range
--   -- of integer.
--   function pow2(n : natural) return real is
--     variable val : real;
--     variable pow : natural;
--   begin
--     -- VHDL exponentiation is limited to integers up to +30 for most tools
--     -- We compute a real exponent through repeated multiplication to support
--     -- larger exponents
-- 
--     pow := n;
--     val := 1.0;
--     
--     for i in 30 to 128 loop
--       exit when pow <= 30;
-- 
--       val := val * 2.0;
--       pow := pow - 1;
--     
--     end loop;
--     
--     -- pow is now small enough to use the exponentiation operator    
--     return  val * (2.0 ** pow);
-- 
--   end function;


  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return natural is

    constant ACCUM_MAX : real := 2.0**size; --pow2(size);
    constant INC_R : real := target_freq / sys_freq * ACCUM_MAX;

  begin

    -- Rounding the count to the nearest integer gives the lowest error

    -- The real increment value should be less than 2**31 for all practical
    -- input settings so the direct type conversion is safe.
    
    assert INC_R <= real(integer'high)
      report "Increment too large for integer type"
      severity failure;

    assert INC_R <= (2.0**SIZE) - 1.0
      report "Increment too large for accumulator"
      severity failure;

    return natural(INC_R);

  end function;


  function ddfs_increment(sys_freq : real; target_freq : real;
    size : natural) return unsigned is

    constant ACCUM_MAX : real := 2.0**size;
    constant INC_R : real := target_freq / sys_freq * ACCUM_MAX;

  begin

    -- Rounding the count to the nearest integer gives the lowest error

    -- The real increment value should be less than 2**31 for all practical
    -- input settings so the direct type conversion is safe.
    
    assert INC_R <= real(integer'high)
      report "Increment too large for integer type"
      severity failure;

    assert INC_R <= (2.0**SIZE) - 1.0
      report "Increment too large for accumulator"
      severity failure;

    return to_unsigned(integer(INC_R),SIZE);

  end function;


  -- Compute the actual synthesized frequency for the specified accumulator
  -- size
  function ddfs_frequency(sys_freq : real; target_freq : real;
    size : natural) return real is

    constant INC_N : natural := to_integer(ddfs_increment(sys_freq, target_freq, size));

    constant ACCUM_MAX : real := 2.0**size; --pow2(size);
  begin

    return sys_freq * real(INC_N) / ACCUM_MAX;
  end function;


  -- Compute the error between the requested output frequency and the actual
  -- output frequency
  function ddfs_error(sys_freq : real; target_freq : real;
    size : natural) return real is

  begin
    return abs (ddfs_frequency(sys_freq, target_freq, size)
       / target_freq - 1.0);
  end function;

end package body;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;


entity ddfs is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    Enable : in std_ulogic := '1';
    
    Increment : in unsigned;

    Accumulator : out unsigned;
    Synth_clock : out std_ulogic;
    Synth_pulse : out std_ulogic
  );
end entity;

architecture rtl of ddfs is

  signal accum : unsigned(Increment'range);
  signal prev_msb : std_ulogic;

begin

  inc: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      accum <= (others => '0');
    elsif rising_edge(Clock) then
      if Enable = '1' then
        accum <= accum + Increment;
      end if;
    end if;
  end process;

  Accumulator <= accum;

  -- output the MSB of the accumulator
  Synth_clock <= accum(accum'high);


  -- detect rising edge of synth_clock to make a 1-cycle pulse
  ed: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      prev_msb <= '0';
      Synth_pulse <= '0';
    elsif rising_edge(Clock) then
      prev_msb <= accum(accum'high);

      if accum(accum'high) = '1' and prev_msb = '0' then
        Synth_pulse <= '1';
      else
        Synth_pulse <= '0';
      end if;
    end if;
  end process;

end architecture;
