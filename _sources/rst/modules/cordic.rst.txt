=======
cordic
=======

`extras/cordic.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/cordic.vhdl>`_


Dependencies
------------

:doc:`pipelining <pipelining>`

Description
-----------

This package provides components and procedures used to implement the CORDIC
algorithm for rotations. A variety of implementations are provided to meet different
design requirements. These implementations are flexible in all parameters and are not
constrained by a fixed arctan table.

A pair of procedures provide pure combinational CORDIC implementations:

* rotate procedure - Combinational CORDIC in rotation mode
* vector procedure - Combinational CORDIC in vectoring mode

The CORDIC components provide both rotation or vectoring mode based on
a Mode input:

* cordic_sequential     - Iterative algorithm with minimal hardware
* cordic_pipelined      - One pipeline stage per iteration
* cordic_flex_pipelined - Selectable pipeline stages independent of
                         the number of iterations
A set of wrapper components are provided to conveniently generate
sin and cos:

* sincos_sequential - Iterative algorithm with minimal hardware
* sincos_pipelined  - One pipeline stage per iteration


These CORDIC implementations take a common set of parameters. There are
X, Y, and Z inputs defining the initial vector and angle value. The result
is produced in a set of X, Y, and Z outputs. Depending on which CORDIC
operation you are using, some inputs may be constants and some outputs
may be ignored.

The CORDIC algorithm performs pseudo-rotations that cause an unwanted growth
in the length of the result vector. This growth is a gain parameter that
approaches 1.647 but is dependent on the number of iterations performed. The
:vhdl:func:`~extras.cordic.cordic_gain` function produces a real-valued gain for a specified number of
iterations. This can be converted to a synthesizable integer constant with
the following:

.. code-block:: vhdl

  gain := integer(cordic_gain(ITERATIONS) * 2.0 ** FRAC_BITS)
 
With some operations you can adjust the input vector by dividing by the gain
ahead of time. In other cases you have to correct for the gain after the
CORDIC operation. The gain from pseudo-rotation never affects the Z
parameter.

The following are some of the operations that can be performed with the
CORDIC algorithm:

sin and cos:

 X0 = 1/gain, Y0 = 0, Z0 = angle; rotate → sin(Z0) in Y, cos(Z0) in X

polar to rectangular:

 X0 = magnitude, Y0 = 0, Z0 = angle; rotate → gain*X in X, gain*Y in Y

arctan:

 Y0 = y, X0 = x, Z0 = 0; vector → arctan(Y0/X0) in Z

rectangular to polar:

 Y0 = y, X0 = x, Z0 = 0; vector → gain*magnitude in X, angle in Z

The X and Y parameters are represented as unconstrained signed vectors. You
establish the precision of a CORDIC implementation by selecting the width of
these vectors. The interpretation of these numbers does not affect the
internal CORDIC implementation but most implementations will need them to be
fixed point integers with the maximum number of fractional bits possible.
When calculating sin and cos, the output is constrained to the range +/-1.0.
Thus we only need to reserve two bits for the sign and integral portion of
the numbers. The remaining bits can be fractional. Operations that work on
larger vectors outside of the unit circle need to ensure that a sufficient
number of integer bits are present to prevent overflow of X and Y.

The angle parameter Z should be provided in units of binary-radians or brads.
:math:`2\pi \text{ radians} = 2^\text{size} \text{ brads}` for "size" number of bits. This maps the entire
binary range of Z to the unit circle. The Z parameter is represented by the
signed type in all of these CORDIC implementations but it can be viewed as
an unsigned value. Because of the circular mapping, signed and unsigned
angles are equivalent. It is easiest to think of the angle Z as an integer
without fractional bits like X and Y. There is no risk of overflowing Z
becuase of the circular mapping.

The circular CORDIC algorithm only converges between angles of +/- 99.7
degrees. If you want to use angles covering all four quadrants you must
condition the inputs to the CORDIC algorithm using the :vhdl:func:`~extras.cordic.adjust_angle`
procedure. This will perform conditional negation on X and Y and flip the
sign bit on Z to bring vectors in quadrants 2 and 3 (1-based) into quadrants
1 and 4.


Example usage
~~~~~~~~~~~~~


You can use the two functions :vhdl:func:`~extras.cordic.rotate` and
:vhdl:func:`~extras.cordic.vector` to perform a single iteration cycle of CORDIC.
This can be used for simulation purposes or wrapped in a registered process for specialized
synthesis implementations. The entire CORDIC core will be synthesized as a combinational blob. You can use register retiming techniques to improve the performance.

.. code-block:: vhdl

  signal X, Y, Z, Xr, Yr, Zr : signed(9 downto 0);
  constant ITERATIONS : integer : 5;
  ...
  
  reg: process(clock, reset) is
  begin
    if reset = '1' then
      Xr <= (others => '0');
      Yr <= (others => '0');
      Zr <= (others => '0');
    elsif rising_edge(clock) then
      rotate(ITERATIONS, X, Y, Z, Xr, Yr, Zr);    
    end if;
  end process;


The components implemented in this package offer a number of different synthesizable CORDIC implementations and wrappers to generate Sine and Cosine waveforms.

.. code-block:: vhdl

  constant ITERATIONS : positive := 8;
  
  -- 1 sign bit + 1 integer bit + 8 fraction bits
  signal X, Y, Z, Xr, Yr, Zr : signed(9 downto 0); 

  -- Sequential implementation
  cs: cordic_sequential
    generic map (
      SIZE       => X'length,
      ITERATIONS => ITERATIONS
    )
    port map (
      Clock => clock,
      Reset => reset,
      
      Data_valid   => data_valid,
      Busy         => busy,
      Result_valid => result_valid,
      Mode         => cordic_rotate,
      
      X => X,
      Y => Y,
      Z => Z,
      
      X_result => Xr,
      Y_result => Yr,
      Z_result => Zr
    );


.. include:: auto/cordic.rst


