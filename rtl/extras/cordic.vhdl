library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cordic is
  component cordic_pipelined is
    generic (
      SIZE : positive;
      ITERATIONS : positive;
      RESET_ACTIVE_LEVEL : std_ulogic := '1'
    );
    port (
      Clock : in std_ulogic;
      Reset : in std_ulogic;

      X : in signed(SIZE-1 downto 0);
      Y : in signed(SIZE-1 downto 0);
      Z : in signed(SIZE-1 downto 0);

      X_result : out signed(SIZE-1 downto 0);
      Y_result : out signed(SIZE-1 downto 0);
      Z_result : out signed(SIZE-1 downto 0)
    );
  end component;

  function cordic_gain(iterations : positive) return real;
  procedure adjust_angle(signal x, y, z : in signed; signal xp, yp, zp : out signed);
  procedure rotate(n : in integer; x, y, z : in signed; signal xr, yr, zr : out signed);
end package;

library ieee;
use ieee.math_real.all;

package body cordic is

  function cordic_gain(iterations : positive) return real is
    variable a : real := 1.0;
  begin
    for i in 0 to iterations loop
      a := a * sqrt(1.0 + 2.0**(-2*i));
    end loop;
    return a;
  end function;

  procedure OLD_adjust_angle(signal x, y, z : in signed; signal xp, yp, zp : out signed) is
    variable quad : unsigned(1 downto 0);
    variable xa : signed(x'range) := x;
    variable ya : signed(y'range) := y;
    variable za : signed(z'range) := z;
  begin
    quad := unsigned(z(z'high downto z'high-1));

    if quad = 1 or quad = 2 then
      null;
      xa := -xa;
      ya := -ya;

      --za := za + integer(MATH_PI * 2.0**(z'length-2));
      za := za + 2**(z'length-1);
    end if;

    xp <= xa;
    yp <= ya;
    zp <= za;
    
  end procedure;


  procedure adjust_angle(signal x, y, z : in signed; signal xp, yp, zp : out signed) is
    variable quad : unsigned(1 downto 0);  
    variable za : signed(z'range) := z;
    variable ya : signed(y'range) := y;
    variable xa : signed(x'range) := x;
  begin
    --za := to_integer(z) mod 2**16;
    --quad := za / 2**14;
    quad := unsigned(za(za'high downto za'high-1));

    if quad = 1 or quad = 2 then
      xa := -xa;
      ya := -ya;
      za := za + 2**(za'length-1);
    end if;

    xp <= xa;
    yp <= ya;
    zp <= za;
  end procedure;

  procedure rotate(n : in integer; x, y, z : in signed; signal xr, yr, zr : out signed) is
    variable power : real;
    variable xp, yp, xp2, yp2 : signed(x'range);
    variable zp, zp2 : signed(z'range);
    variable z_inc : integer;
  begin
    --xp := real(to_integer(x)) / 2.0**14;
    --yp := real(to_integer(y)) / 2.0 ** 14;
    xp := x; yp := y;
    zp := z;

    for i in 0 to n-1 loop
      power := 2.0 ** (-i);

      z_inc := integer(arctan(power) * 2.0**16 / MATH_2_PI);

      --if zp >= 2**15 then
      if zp(zp'high) = '1' then
        --xp2 := xp + yp * power;
        --yp2 := yp - xp * power;
        xp2 := xp + yp / 2**i;
        yp2 := yp - xp / 2**i;
        zp2 := zp + z_inc;
      else
        --xp2 := xp - yp * power;
        --yp2 := yp + xp * power;
        xp2 := xp - yp / 2**i;
        yp2 := yp + xp / 2**i;
        zp2 := zp - z_inc;
      end if;

      xp := xp2; yp := yp2; zp := zp2;
    end loop;

    xr <= xp; yr <= yp;
    zr <= zp;
  end procedure;

end package body;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library extras;
use extras.cordic.rotate;

entity cordic_pipelined is
  generic (
    SIZE : positive;
    ITERATIONS : positive;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    X : in signed(SIZE-1 downto 0);
    Y : in signed(SIZE-1 downto 0);
    Z : in signed(SIZE-1 downto 0);

    X_result : out signed(SIZE-1 downto 0);
    Y_result : out signed(SIZE-1 downto 0);
    Z_result : out signed(SIZE-1 downto 0)
  );
end entity;

architecture rtl of cordic_pipelined is
  type signed_pipeline is array (natural range <>) of signed(SIZE-1 downto 0);

  signal x_pl, y_pl, z_pl : signed_pipeline(1 to ITERATIONS);
  signal x_array, y_array, z_array : signed_pipeline(0 to ITERATIONS);

  function gen_atan_table(size : positive; iterations : positive) return signed_pipeline is
    variable table : signed_pipeline(0 to ITERATIONS-1);
  begin
    for i in table'range loop
      --table(i) := to_signed(integer(arctan(2.0**(-i)) * 2.0**size), size);
      --z_inc := integer(arctan(2.0**(1-i)) * 2.0**z'length / MATH_2_PI);
      table(i) := to_signed(integer(arctan(2.0**(-i)) * 2.0**size / MATH_2_PI), size);
    end loop;

    return table;
  end function;

  constant ATAN_TABLE : signed_pipeline(0 to ITERATIONS-1) := gen_atan_table(SIZE, ITERATIONS);
begin

  x_array <= X & x_pl;
  y_array <= Y & y_pl;
  z_array <= Z & z_pl;

  cordic: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      x_pl <= (others => (others => '0'));
      y_pl <= (others => (others => '0'));
      z_pl <= (others => (others => '0'));

    elsif rising_edge(Clock) then
      for i in 1 to ITERATIONS loop
        if z_array(i-1)(z'high) = '1' then -- z is negative
          x_pl(i) <= x_array(i-1) + (y_array(i-1) / 2**(i-1));
          y_pl(i) <= y_array(i-1) - (x_array(i-1) / 2**(i-1));
          z_pl(i) <= z_array(i-1) + ATAN_TABLE(i-1);
        else -- z is positive
          x_pl(i) <= x_array(i-1) - (y_array(i-1) / 2**(i-1));
          y_pl(i) <= y_array(i-1) + (x_array(i-1) / 2**(i-1));
          z_pl(i) <= z_array(i-1) - ATAN_TABLE(i-1);
        end if;
      end loop;
    end if;
  end process;

  X_result <= x_array(x_array'high);
  Y_result <= y_array(y_array'high);
  Z_result <= z_array(z_array'high);

end architecture;
