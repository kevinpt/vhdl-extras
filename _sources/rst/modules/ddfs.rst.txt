====
ddfs
====

`extras/ddfs.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/ddfs.vhdl>`_


Dependencies
------------

:doc:`sizing`
:doc:`arithmetic`

Description
-----------

This package provides a set of functions and a component used for
implementing a Direct Digital Frequency Synthesizer (DDFS). The DDFS
component is a simple accumulator that increments by a pre computed value
each cycle. The MSB of the accumulator switches at the requested frequency
established by the :vhdl:func:`~extras.ddfs_pkg.ddfs_increment` function. The provided functions perform
computations with real values and, as such, are only synthesizable when
used to define constants.

There are two sets of functions for generating the increment values needed
by the DDFS accumulator. One set is used to compute static increments that
are assigned to constants. The other functions work in conjunction with a
procedure to dynamically generate the increment value using a single
inferred multiplier.

It is possible to generate multiple frequencies by computing more than one
increment constant and multiplexing between them. The :vhdl:func:`~extras.ddfs_pkg.ddfs_size` function
should be called with the smallest target frequency to be used to
guarantee the requested tolerance is met. You can alternately set a fixed size and compute the
effective tolerance with :vhdl:func:`~extras.ddfs_pkg.ddfs_tolerance`.


For simulation reporting, you can compute the effective output frequency with the :vhdl:func:`~extras.ddfs_pkg.ddfs_frequency` function and the error ratio
with :vhdl:func:`~extras.ddfs_pkg.ddfs_error`. 

The utility function :vhdl:func:`~extras.ddfs_pkg.resize_fractional` will truncate unwanted LSBs when downsizing the generated DDFS accumulator value.

Example usage
~~~~~~~~~~~~~

The :vhdl:func:`~extras.ddfs_pkg.ddfs_size` and :vhdl:func:`~extras.ddfs_pkg.ddfs_increment`
functions are used to compute static increment values:

.. code-block:: vhdl

  constant SYS_FREQ  : real    := 50.0e6; -- 50 MHz
  constant TGT_FREQ  : real    := 2600.0; -- 2600 Hz
  constant DDFS_TOL  : real    := 0.001;  -- 0.1%
  constant SIZE      : natural := ddfs_size(SYS_FREQ, TGT_FREQ, DDFS_TOL);
  constant INCREMENT : unsigned(SIZE-1 downto 0) :=
                               ddfs_increment(SYS_FREQ, TGT_FREQ, SIZE);
  ...
  whistle: ddfs
    port map (
      Clock => clock,
      Reset => reset,

      Enable     => '1',
      Load_phase => '0',
      New_phase  => unsigned'"",

      Increment   => INCREMENT,
      Accumulator => accum,
      Synth_clock => synth_tone, -- Signal with ~2600 Hz clock
      Synth_pulse => open
    );
  ...
  -- Report the DDFS precision (simulation only)
  report "True synthesized frequency: "
    & real'image(ddfs_frequency(SYS_FREQ, TGT_FREQ, SIZE)
  report "DDFS error: " & real'image(ddfs_error(SYS_FREQ, TGT_FREQ, SIZE)

The alternate set of functions :vhdl:func:`~extras.ddfs_pkg.min_fraction_bits`,
:vhdl:func:`~extras.ddfs_pkg.ddfs_dynamic_factor`, and :vhdl:func:`~extras.ddfs_pkg.ddfs_dynamic_inc` are used to precompute a multiplier factor
that is used to dynamically generate an increment value in synthesizable logic:

.. code-block:: vhdl

  constant MIN_TGT_FREQ : natural := 27;
  constant MAX_TGT_FREQ : natural := 4200;
  constant FRAC_BITS    : natural := min_fraction_bits(SYS_FREQ, 
                                        MIN_TGT_FREQ, SIZE, DDFS_TOL);
  constant DDFS_FACTOR  : natural := ddfs_dynamic_factor(SYS_FREQ, SIZE,
                                                         FRAC_BITS);
  signal dyn_freq : unsigned(bit_size(MAX_TGT_FREQ)-1 downto 0);
  signal dyn_inc  : unsigned(SIZE-1 downto 0);
  ...
  dyn_freq <= to_unsigned(261, dyn_freq'length); -- Middle C
  ...
  dyn_freq <= to_unsigned(440, dyn_freq'length); -- Change to A4
  ...
  -- Wrap ddfs_dynamic_inc in a sequencial process to synthesize a
  -- multiplier with registered product.
  dyn: process(clock, reset) is
  begin
    if reset = '1' then
      dyn_inc <= (others => '0');
    elsif rising_edge(clock) then
      ddfs_dynamic_inc(DDFS_FACTOR, FRAC_BITS, dyn_freq, dyn_inc);
    end if;
  end process;

  fsynth: ddfs
    port map (
      Clock => clock,
      Reset => reset,

      Enable     => '1',
      Load_phase => '0',
      New_phase  => unsigned'"",

      Increment   => dyn_inc,
      Accumulator => accum,
      Synth_clock => synth_tone,
      Synth_pulse => open
    );

    
.. include:: auto/ddfs.rst

