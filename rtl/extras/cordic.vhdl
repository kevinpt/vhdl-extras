--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# cordic.vhdl - CORDIC operations for vector rotation and sin/cos generation
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2014 Kevin Thibedeau
--# (kevin 'period' thibedeau 'at' gmail 'punto' com)
--#
--# Permission is hereby granted, free of charge, to any person obtaining a
--# copy of this software and associated documentation files (the "Software"),
--# to deal in the Software without restriction, including without limitation
--# the rights to use, copy, modify, merge, publish, distribute, sublicense,
--# and/or sell copies of the Software, and to permit persons to whom the
--# Software is furnished to do so, subject to the following conditions:
--#
--# The above copyright notice and this permission notice shall be included in
--# all copies or substantial portions of the Software.
--#
--# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--# DEALINGS IN THE SOFTWARE.
--#
--# DEPENDENCIES: pipelining
--#
--# DESCRIPTION:
--#  This package provides components and procedures used to implement the CORDIC
--#  algorithm. A variety of implementations are provided to meet different design
--#  requirements. These implementations are flexible in all parameters and are not
--#  constrained by a fixed arctan table.
--#
--#  A pair of procedures provide pure combinational CORDIC implementations:
--#  * rotate procedure - Combinational CORDIC in rotation mode
--#  * vector procedure - Combinational CORDIC in vectoring mode
--#
--#  The CORDIC components provide both rotation or vectoring mode based on
--#  a Mode input:
--#  * cordic_sequential     - Iterative algorithm with minimal hardware
--#  * cordic_pipelined      - One pipeline stage per iteration
--#  * cordic_flex_pipelined - Selectable pipeline stages independent of
--#                            the number of iterations
--#  A set of wrapper components are provided to conveniently generate
--#  sin and cos:
--#  * sincos_sequential - Iterative algorithm with minimal hardware
--#  * sincos_pipelined  - One pipeline stage per iteration
--#

--#  These CORDIC implementations take a common set of parameters. There are
--#  X, Y, and Z inputs defining the initial vector and angle value. The result
--#  is produced in a set of X, Y, and Z outputs. Depending on which CORDIC
--#  operation you are using, some inputs may be constants and some outputs
--#  may be ignored.

--#  The CORDIC algorithm performs pseudo-rotations that cause an unwanted growth
--#  in the length of the result vector. This growth is a gain parameter that
--#  approaches 1.647 but is dependent on the number of iterations performed. The
--#  cordic_gain() function produces a real-valued gain for a specified number of
--#  iterations. This can be converted to a synthesizable integer constant with
--#  the following:
--#    gain := integer(cordic_gain(ITERATIONS) * 2.0 ** FRAC_BITS)
--#  With some operations you can adjust the input vector by dividing by the gain
--#  ahead of time. In other cases you have to correct for the gain after the
--#  CORDIC operation. The gain from pseudo-rotation never affects the Z
--#  parameter.

--#  The following are some of the operations that can be performed with the
--#  CORDIC algorithm:
--#
--#  sin and cos:
--#    X0 = 1/gain, Y0 = 0, Z0 = angle; rotate --> sin(Z0) in Y, cos(Z0) in X
--#
--#  polar to rectangular:
--#    X0 = magnitude, Y0 = 0, Z0 = angle; rotate --> gain*X in X, gain*Y in Y
--#
--#  arctan:
--#    Y0 = y, X0 = x, Z0 = 0; vector --> arctan(Y0/X0) in Z
--#
--#  rectangular to polar:
--#    Y0 = y, X0 = x, Z0 = 0; vector --> gain*magnitude in X, angle in Z

--#  The X and Y parameters are represented as unconstrained signed vectors. You
--#  establish the precision of a CORDIC implementation by selecting the width of
--#  these vectors. The interpretation of these numbers does not affect the
--#  internal CORDIC implementation but most implementations will need them to be
--#  fixed point integers with the maximum number of fractional bits possible.
--#  When calculating sin and cos, the output is constrained to the range +/-1.0.
--#  Thus we only need to reserve two bits for the sign and integral portion of
--#  the numbers. The remaining bits can be fractional. Operations that work on
--#  larger vectors outside of the unit circle need to ensure that a sufficient
--#  number of integer bits are present to prevent overflow of X and Y.

--#  The angle parameter Z should be provided in units of binary-radians or brads.
--#  2*PI radians = 2**size brads for "size" number of bits. This maps the entire
--#  binary range of Z to the unit circle. The Z parameter is represented by the
--#  signed type in all of these CORDIC implementations but it can be viewed as
--#  an unsigned value. Because of the circular mapping, signed and unsigned
--#  angles are equivalent. It is easiest to think of the angle Z as an integer
--#  without fractional bits like X and Y. There is no risk of overflowing Z
--#  becuase of the circular mapping.

--#  The circular CORDIC algorithm only converges between angles of +/- 99.7
--#  degrees. If you want to use angles covering all four quadrants you must
--#  condition the inputs to the CORDIC algorithm using the adjust_angle()
--#  procedure. This will perform conditional negation on X and Y and flip the
--#  sign bit on Z to bring vectors in quadrants 2 and 3 (1-based) into quadrants
--#  1 and 4.

--#  EXAMPLE USAGE:
--#  
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cordic is

  --# Rotation or vector mode selection.
  type cordic_mode is (cordic_rotate, cordic_vector);

  --## CORDIC with pipeline registers between each stage.
  component cordic_pipelined is
    generic (
      SIZE               : positive; --# Width of operands
      ITERATIONS         : positive; --# Number of iterations for CORDIC algorithm
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Mode  : in cordic_mode; --# Rotation or vector mode selection

      --# {{data|}}
      X : in signed(SIZE-1 downto 0); --# X coordinate
      Y : in signed(SIZE-1 downto 0); --# Y coordinate
      Z : in signed(SIZE-1 downto 0); --# Z coordinate (angle in brads)

      X_result : out signed(SIZE-1 downto 0); --# X result
      Y_result : out signed(SIZE-1 downto 0); --# Y result
      Z_result : out signed(SIZE-1 downto 0)  --# Z result
    );
  end component;

  --## CORDIC with a single stage applied iteratively.
  component cordic_sequential is
    generic (
      SIZE               : positive; --# Width of operands
      ITERATIONS         : positive; --# Number of iterations for CORDIC algorithm
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Data_valid   : in std_ulogic;  --# Load new input data
      Busy         : out std_ulogic; --# Generating new result
      Result_valid : out std_ulogic; --# Flag when result is valid
      Mode         : in cordic_mode; --# Rotation or vector mode selection

      --# {{data|}}
      X : in signed(SIZE-1 downto 0); --# X coordinate
      Y : in signed(SIZE-1 downto 0); --# Y coordinate
      Z : in signed(SIZE-1 downto 0); --# Z coordinate (angle in brads)

      X_result : out signed(SIZE-1 downto 0); --# X result
      Y_result : out signed(SIZE-1 downto 0); --# Y result
      Z_result : out signed(SIZE-1 downto 0)  --# Z result
    );
  end component;

      
  --## CORDIC with pipelining implemented with register retiming.
  --#  This variant can be used to have more or fewer pipeline stages than
  --#  the number of iterations to fine tune performance and resource usage.
  component cordic_flex_pipelined is
    generic (
      SIZE               : positive; --# Width of operands
      ITERATIONS         : positive; --# Number of iterations for CORDIC algorithm
      PIPELINE_STAGES    : natural;  --# Number of register stages
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Mode  : in cordic_mode; --# Rotation or vector mode selection

      --# {{data|}}
      X : in signed(SIZE-1 downto 0); --# X coordinate
      Y : in signed(SIZE-1 downto 0); --# Y coordinate
      Z : in signed(SIZE-1 downto 0); --# Z coordinate (angle in brads)

      X_result : out signed(SIZE-1 downto 0); --# X result
      Y_result : out signed(SIZE-1 downto 0); --# Y result
      Z_result : out signed(SIZE-1 downto 0)  --# Z result
    );
  end component;

  --## Compute Sine and Cosine with a pipelined CORDIC implementation.
  component sincos_pipelined is
    generic (
      SIZE       : positive;    --# Width of operands
      ITERATIONS : positive;    --# Number of iterations for CORDIC algorithm
      FRAC_BITS  : positive;    --# Total fractional bits
      MAGNITUDE  : real := 1.0; --# Scale factor for vector length
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Angle : in signed(SIZE-1 downto 0); --# Angle in brads (2**SIZE brads = 2*pi radians)

      --# {{data|}}
      Sin   : out signed(SIZE-1 downto 0);  --# Sine of Angle
      Cos   : out signed(SIZE-1 downto 0)   --# Cosine of Angle
    );
  end component;

  --## Compute Sine and Cosine with a sequential CORDIC implementation.
  component sincos_sequential is
    generic (
      SIZE       : positive;    --# Width of operands
      ITERATIONS : positive;    --# Number of iterations for CORDIC algorithm
      FRAC_BITS  : positive;    --# Total fractional bits
      MAGNITUDE  : real := 1.0; --# Scale factor for vector length
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{control|}}
      Data_valid   : in std_ulogic;  --# Load new input data
      Busy         : out std_ulogic; --# Generating new result
      Result_valid : out std_ulogic; --# Flag when result is valid

      Angle : in signed(SIZE-1 downto 0); --# Angle in brads (2**SIZE brads = 2*pi radians)

      --# {{data|}}
      Sin : out signed(SIZE-1 downto 0); --# Sine of Angle
      Cos : out signed(SIZE-1 downto 0)  --# Cosine of Angle
    );
  end component;

  --## Compute vector length gain after applying CORDIC.
  --# Args:
  --#  Iterations : Number of iterations
  --# Returns:
  --#  Gain factor.
  function cordic_gain(Iterations : positive) return real;


  --## Correct angle so that it lies in quadrant 1 or 4.
  --# Args:
  --#  X : X coordinate
  --#  Y : Y coordinate
  --#  Z : Z coordinate (angle)
  --#  Xa : Adjusted X coordinate
  --#  Ya : Adjusted Y coordinate
  --#  Za : Adjusted Z coordinate (angle)
  procedure adjust_angle(X, Y, Z : in signed; signal Xa, Ya, Za : out signed);

  --## Apply a single iteration of CORDIC rotation mode.
  --# Args:
  --#  X : X coordinate
  --#  Y : Y coordinate
  --#  Z : Z coordinate (angle)
  --#  Xr : Rotated X coordinate
  --#  Yr : Rotated Y coordinate
  --#  Zr : Rotated Z coordinate (angle)
  procedure rotate(iterations : in integer; X, Y, Z : in signed; signal Xr, Yr, Zr : out signed);

  --## Apply a single iteration of CORDIC vector mode.
  --# Args:
  --#  X : X coordinate
  --#  Y : Y coordinate
  --#  Z : Z coordinate (angle)
  --#  Xr : Vectored X coordinate
  --#  Yr : Vectored Y coordinate
  --#  Zr : Vectored Z coordinate (angle)
  procedure vector(iterations : in integer; X, Y, Z : in signed; signal Xr, Yr, Zr : out signed);

  --## Compute the number of usable fractional bits in CORDIC result.
  --# Args:
  --#  Iterations: Number of CORDIC iterations
  --#  Frac_bits:  Fractional bits in the input coordinates
  --# Returns:
  --#  Effective number of fractional bits.
  function effective_fractional_bits(Iterations, Frac_bits : positive) return real;
end package;

library ieee;
use ieee.math_real.all;

package body cordic is

  --## Compute gain from CORDIC pseudo-rotations
  function cordic_gain(iterations : positive) return real is
    variable g : real := 1.0;
  begin
    for i in 0 to iterations-1 loop
      g := g * sqrt(1.0 + 2.0**(-2*i));
    end loop;
    return g;
  end function;
  

  --## Adjust points in the left half of the X-Y plane so that they will
  --#  lie within the +/-99.7 degree convergence zone of CORDIC on the right
  --#  half of the plane. Input vector and angle in x,y,z. Adjusted result
  --#  in xa,ya,za.
  procedure adjust_angle(x, y, z : in signed; signal xa, ya, za : out signed) is
    variable quad : unsigned(1 downto 0);  
    variable zp : signed(z'length-1 downto 0) := z;
    variable yp : signed(y'length-1 downto 0) := y;
    variable xp : signed(x'length-1 downto 0) := x;
  begin

    -- 0-based quadrant number of angle
    quad := unsigned(zp(zp'high downto zp'high-1));

    if quad = 1 or quad = 2 then -- Rotate into quadrant 0 and 3 (right half of plane)
      xp := -xp;
      yp := -yp;
      -- Add 180 degrees (flip the sign bit)
      zp := (not zp(zp'left)) & zp(zp'left-1 downto 0);
    end if;

    xa <= xp;
    ya <= yp;
    za <= zp;
  end procedure;

  --## Perform CORDIC rotation mode operation.
  --#  This synthesizes to a pure combinational architecture.
  procedure rotate(iterations : in integer; -- Number of CORDIC iterations
    x, y, z : in signed;                    -- X,Y point and angle
    signal xr, yr, zr : out signed          -- Post-CORDIC result point and angle
  ) is

    variable xp, yp, xp2, yp2 : signed(x'range);
    variable zp, zp2 : signed(z'range);
    variable z_inc : integer;
  begin
    xp := x; yp := y; zp := z;

    for i in 0 to iterations-1 loop

      z_inc := integer(arctan(2.0**(-i)) * 2.0**z'length / MATH_2_PI);

      if zp(zp'high) = '1' then -- negative
        xp2 := xp + yp / 2**i;
        yp2 := yp - xp / 2**i;
        zp2 := zp + z_inc;
      else
        xp2 := xp - yp / 2**i;
        yp2 := yp + xp / 2**i;
        zp2 := zp - z_inc;
      end if;

      xp := xp2; yp := yp2; zp := zp2;
    end loop;

    xr <= xp; yr <= yp; zr <= zp;
  end procedure;

  --## Perform CORDIC vector mode operation.
  --#  This synthesizes to a pure combinational architecture.
  procedure vector(iterations : in integer; -- Number of CORDIC iterations
    x, y, z : in signed;                    -- X,Y point and angle
    signal xr, yr, zr : out signed          -- Post-CORDIC result point and angle
  ) is

    variable xp, yp, xp2, yp2 : signed(x'range);
    variable zp, zp2 : signed(z'range);
    variable z_inc : integer;
  begin
    xp := x; yp := y; zp := z;

    for i in 0 to iterations-1 loop

      z_inc := integer(arctan(2.0**(-i)) * 2.0**z'length / MATH_2_PI);

      if yp(yp'high) = '0' then -- positive
        xp2 := xp + yp / 2**i;
        yp2 := yp - xp / 2**i;
        zp2 := zp + z_inc;
      else
        xp2 := xp - yp / 2**i;
        yp2 := yp + xp / 2**i;
        zp2 := zp - z_inc;
      end if;

      xp := xp2; yp := yp2; zp := zp2;
    end loop;

    xr <= xp; yr <= yp; zr <= zp;
  end procedure;


  function overall_quantization_error(iterations : positive; frac_bits : positive) return real is
    constant k : real := cordic_gain(iterations);
    variable g, p : real;
    variable approx_error, rounding_error : real;
  begin
    approx_error := k - k * cos(arctan(2.0**(-iterations + 1)));

    g := 0.0;
    for j in 1 to iterations - 1 loop
      p := 1.0;
      for i in j to iterations - 1 loop
        p := p * sqrt(1.0 + 2.0**(-2*i));
      end loop;
      g := g + p;
    end loop;

    g := g + 1.0;

    rounding_error := 2.0**(-real(frac_bits) - 0.5)*(g/k + 1.0);

    return approx_error + rounding_error;
  end function;

  function effective_fractional_bits(iterations, frac_bits : positive) return real is
  begin
    return -log2(overall_quantization_error(iterations, frac_bits));
  end function;

end package body;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library extras;
use extras.cordic.all;


entity cordic_pipelined is
  generic (
    SIZE       : positive;
    ITERATIONS : positive;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Mode : in cordic_mode;

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
    variable negative : boolean;
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      x_pl <= (others => (others => '0'));
      y_pl <= (others => (others => '0'));
      z_pl <= (others => (others => '0'));

    elsif rising_edge(Clock) then
      for i in 1 to ITERATIONS loop
        if Mode = cordic_rotate then
          negative := z_array(i-1)(z'high) = '1';
        else
          negative := y_array(i-1)(y'high) = '0';
        end if;

        --if z_array(i-1)(z'high) = '1' then -- z is negative
        if negative then
          x_pl(i) <= x_array(i-1) + (y_array(i-1) / 2**(i-1));
          y_pl(i) <= y_array(i-1) - (x_array(i-1) / 2**(i-1));
          z_pl(i) <= z_array(i-1) + ATAN_TABLE(i-1);
        else -- z or y is positive
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.cordic.all;
use extras.pipelining.all;

entity cordic_flex_pipelined is
  generic (
    SIZE               : positive;
    ITERATIONS         : positive;
    PIPELINE_STAGES    : natural;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Mode  : in cordic_mode;

    X : in signed(SIZE-1 downto 0);
    Y : in signed(SIZE-1 downto 0);
    Z : in signed(SIZE-1 downto 0);

    X_result : out signed(SIZE-1 downto 0);
    Y_result : out signed(SIZE-1 downto 0);
    Z_result : out signed(SIZE-1 downto 0)
  );
end entity;

architecture rtl of cordic_flex_pipelined is
  signal x_result_pre : signed(X'range);
  signal y_result_pre : signed(Y'range);
  signal z_result_pre : signed(Z'range);
begin

  m: process(Mode, X, Y, Z) is
  begin
    if Mode = cordic_rotate then
      rotate(ITERATIONS, X, Y, Z, x_result_pre, y_result_pre, z_result_pre);
    else
      vector(ITERATIONS, X, Y, Z, x_result_pre, y_result_pre, z_result_pre);
    end if;
  end process;

  pl_x: pipeline_s
    generic map (
      PIPELINE_STAGES => PIPELINE_STAGES,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    ) port map (
      Clock => Clock,
      Reset => Reset,
      Sig_in => x_result_pre,
      Sig_out => X_result
    );

  pl_y: pipeline_s
    generic map (
      PIPELINE_STAGES => PIPELINE_STAGES,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    ) port map (
      Clock => Clock,
      Reset => Reset,
      Sig_in => y_result_pre,
      Sig_out => Y_result
    );

  pl_z: pipeline_s
    generic map (
      PIPELINE_STAGES => PIPELINE_STAGES,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    ) port map (
      Clock => Clock,
      Reset => Reset,
      Sig_in => z_result_pre,
      Sig_out => Z_result
    );

end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library extras;
use extras.cordic.all;

entity cordic_sequential is
  generic (
    SIZE       : positive;
    ITERATIONS : positive;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Data_valid   : in std_ulogic;  --# Load new input data
    Busy         : out std_ulogic; --# Generating new result
    Result_valid : out std_ulogic; --# Flag when result is valid
    Mode         : in cordic_mode; --# Rotation or vector mode selection

    X : in signed(SIZE-1 downto 0);
    Y : in signed(SIZE-1 downto 0);
    Z : in signed(SIZE-1 downto 0);

    X_result : out signed(SIZE-1 downto 0);
    Y_result : out signed(SIZE-1 downto 0);
    Z_result : out signed(SIZE-1 downto 0)
  );
end entity;

architecture rtl of cordic_sequential is
  type signed_array is array (natural range <>) of signed(SIZE-1 downto 0);

  function gen_atan_table(size : positive; iterations : positive) return signed_array is
    variable table : signed_array(0 to ITERATIONS-1);
  begin
    for i in table'range loop
      table(i) := to_signed(integer(arctan(2.0**(-i)) * 2.0**size / MATH_2_PI), size);
    end loop;

    return table;
  end function;

  constant ATAN_TABLE : signed_array(0 to ITERATIONS-1) := gen_atan_table(SIZE, ITERATIONS);

  signal xr : signed(X'range);
  signal yr : signed(Y'range);
  signal zr : signed(Z'range);

  signal x_shift : signed(X'range);
  signal y_shift : signed(Y'range);

  subtype iter_count is integer range 0 to ITERATIONS;

  signal cur_iter : iter_count;
begin

  cordic: process(Clock, Reset) is
    variable negative : boolean;
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      xr <= (others => '0');
      yr <= (others => '0');
      zr <= (others => '0');
      cur_iter <= 0;
      Result_valid <= '0';
      Busy <= '0';
    elsif rising_edge(Clock) then
      if Data_valid = '1' then
        xr <= X;
        yr <= Y;
        zr <= Z;
        cur_iter <= 0;
        Result_valid <= '0';
        Busy <= '1';
      else
        if cur_iter /= ITERATIONS then
        --if cur_iter(ITERATIONS) /= '1' then
          if Mode = cordic_rotate then
            negative := zr(z'high) = '1';
          else
            negative := yr(y'high) = '0';
          end if;

          --if zr(z'high) = '1' then -- z or y is negative
          if negative then
            xr <= xr + y_shift; --(yr / 2**(cur_iter));
            yr <= yr - x_shift; --(xr / 2**(cur_iter));
            zr <= zr + ATAN_TABLE(cur_iter);
          else -- z or y is positive
            xr <= xr - y_shift; --(yr / 2**(cur_iter));
            yr <= yr + x_shift; --(xr / 2**(cur_iter));
            zr <= zr - ATAN_TABLE(cur_iter);
          end if;

          cur_iter <= cur_iter + 1;
          --cur_iter <= '0' & cur_iter(0 to ITERATIONS-1);
        end if;

        if cur_iter = ITERATIONS-1 then
          Result_valid <= '1';
          Busy <= '0';
        end if;
      end if;

    end if;
  end process;

  x_shift <= shift_right(xr, cur_iter);
  y_shift <= shift_right(yr, cur_iter);


  X_result <= xr;
  Y_result <= yr;
  Z_result <= zr;

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library extras;
use extras.cordic.all;

entity sincos_sequential is
  generic (
    SIZE       : positive;   -- Width of parameters
    ITERATIONS : positive;   -- Number of CORDIC iterations
    FRAC_BITS  : positive;   -- Total fractional bits
    MAGNITUDE  : real := 1.0;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Data_valid   : in std_ulogic;  --# Load new input data
    Busy         : out std_ulogic; --# Generating new result
    Result_valid : out std_ulogic; --# Flag when result is valid

    Angle : in signed(SIZE-1 downto 0); -- Angle in brads (2**SIZE brads = 2*pi radians)

    Sin   : out signed(SIZE-1 downto 0);  -- Sine of Angle
    Cos   : out signed(SIZE-1 downto 0)   -- Cosine of Angle
  );
end entity;

architecture rtl of sincos_sequential is
  signal xa, ya, za, x_result, y_result : signed(Angle'range);
  signal rv_loc : std_ulogic;
begin

  adj: process(Clock, Reset) is
    constant Y : signed(Angle'range) := (others => '0');
    constant X : signed(Angle'range) := --to_signed(1, Angle'length);
      to_signed(integer(MAGNITUDE/cordic_gain(ITERATIONS) * 2.0 ** FRAC_BITS), Angle'length);
  begin

    -- 
    if Reset = RESET_ACTIVE_LEVEL then
      xa <= (others => '0');
      ya <= (others => '0');
      za <= (others => '0');
    elsif rising_edge(Clock) then
      adjust_angle(X, Y, Angle, xa, ya, za);
    end if;
  end process;

  c: cordic_sequential
    generic map (
      SIZE => SIZE,
      ITERATIONS => ITERATIONS,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    ) port map (
      Clock => Clock,
      Reset => Reset,
      Data_valid => Data_valid,
      Result_valid => rv_loc,
      Busy => Busy,
      Mode => cordic_rotate,

      X => xa,
      Y => ya,
      Z => za,

      X_result => x_result,
      Y_result => y_result,
      Z_result => open
    );

  -- Capture the sin and cos when iteration is done
  reg: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      Cos <= (others => '0');
      Sin <= (others => '0');
      Result_valid <= '0';
    elsif rising_edge(Clock) then
      Result_valid <= rv_loc;

      if rv_loc = '1' then -- Capture result
        Cos <= x_result;
        Sin <= y_result;
      end if;
    end if;
  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library extras;
use extras.cordic.all;

entity sincos_pipelined is
  generic (
    SIZE       : positive;       -- Width of parameters
    ITERATIONS : positive; -- Number of CORDIC iterations
    FRAC_BITS  : positive;  -- Total fractional bits
    MAGNITUDE  : real := 1.0;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    --Load  : in std_ulogic;  -- Start processing a new angle value
    --Done  : out std_ulogic; -- Indicates when iterations are complete

    Angle : in signed(SIZE-1 downto 0); -- Angle in brads (2**SIZE brads = 2*pi radians)

    Sin   : out signed(SIZE-1 downto 0);  -- Sine of Angle
    Cos   : out signed(SIZE-1 downto 0)   -- Cosine of Angle
  );
end entity;

architecture rtl of sincos_pipelined is
  signal xa, ya, za : signed(Angle'range);
begin

  adj: process(Clock, Reset) is
    constant Y : signed(Angle'range) := (others => '0');
    constant X : signed(Angle'range) := --to_signed(1, Angle'length);
      to_signed(integer(MAGNITUDE/cordic_gain(ITERATIONS) * 2.0 ** FRAC_BITS), Angle'length);
  begin

    -- 
    if Reset = RESET_ACTIVE_LEVEL then
      xa <= (others => '0');
      ya <= (others => '0');
      za <= (others => '0');
    elsif rising_edge(Clock) then
      adjust_angle(X, Y, Angle, xa, ya, za);
    end if;
  end process;

  c: cordic_pipelined
    generic map (
      SIZE => SIZE,
      ITERATIONS => ITERATIONS,
      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
    ) port map (
      Clock => Clock,
      Reset => Reset,

      Mode => cordic_rotate,

      X => xa,
      Y => ya,
      Z => za,

      X_result => Cos,
      Y_result => Sin,
      Z_result => open
    );

end architecture;


