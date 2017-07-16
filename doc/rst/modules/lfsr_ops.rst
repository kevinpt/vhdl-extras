========
lfsr_ops
========

`extras/lfsr_ops.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/lfsr_ops.vhdl>`_


Dependencies
------------

None

Description
-----------

This package includes implementations of Linear Feedback Shift Registers.
Two architectures are provided: Galois and Fibonacci. They can be used
interchangeably with the only difference being in the organization of the
taps. With Galois a single feedback bit is XORed across all taps with the
neighboring register. With Fibonacci the taps are XORed together to produce
a feedback bit that is shifted into the register. The Galois
implementation has the more desireable property of shorter feedback delay
however it will only enjoy this advantage over Fibonacci in the case of
ASIC implementations and FPGAs with discrete XOR resources. For LUT based
FPGAs most Fibonacci tap configurations can fit within a single LUT and
the routing delays will be roughly equivalent to the Galois version.

The Galois LFSR is constructed so that it shifts right while the Fibonacci
LFSR shifts left. This arrangement makes the rightmost bit of both
LFSRs follow the same pattern for the same coefficients albeit with an
unspecified phase shift between them. Technically, since the Fibonacci is
a pure shift register, all of its bits follow the same pattern (but
phased).

Note that if you are interested in using all LFSR bits to represent a
pseudo-random number you should consider the :doc:`Wolfram LCAR structure <lcar_ops>`
provided elsewhere in the VHDL-extras library. It produces more suitable
randomness in its state register without the correlation between
neighboring bits that the LFSR implementations do. However, these LFSRs
are sufficient for producing a pseudo-random signal on a single bit.

The LFSRs are each implemented in a function that determines the next
state of the LFSR based on the current state. These functions have two
configuration parameters: ``Kind`` and ``Full_cycle``.

The ``Kind`` parameter specifies whether to implement a normal circuit with
XORs or to invert the logic and use XNORs. The difference between the two
is that for 'normal', the all-0's state is inacessible while for
'inverted' the all-1's state is inaccessible. If the LFSR is initialized
in these inaccessible states it will be unable to change states.

The other parameter, ``Full_cycle``, will add logic to make the invalid states
reachable. When a maximal length polynomial is used, normally only :math:`2^n-1`
states are reachable. With ``Full_cycle`` true, the LFSR will enter all :math:`2^n`
possible states.

The functions use unconstrained arrays for the ``State`` and ``Tap_map``. They can
implement an LFSR of any size from 2-bits and up. The only requirement is
that the ``Tap_map`` be one bit shorter than the state register since it works
on the "spaces" between the register bits. The code is written with the
intent of using 1-based ascending ranges for the arrays but any ranges
will work correctly.

A table of coefficients for maximal length polynomials covering 2 to
100-bit LFSRs is provided in ``LFSR_COEFF_TABLE``. You can use these to
generate a ``Tap_map`` signal with the :vhdl:func:`~extras.lfsr_ops.lfsr_taps` function. You can build a
``Tap_map`` for any arbitrary set of coefficients with the :vhdl:func:`~extras.lfsr_ops.to_tap_map`
function. Since ``Tap_map`` is a signal it is possible to switch coefficient
sets in the middle of operation if desired. If you implement it as a
constant the LFSR will have it's logic reduced to the optimal form in
synthesis.

In addition to the LFSR functions, a pair of components (:vhdl:entity:`~extras.lfsr_ops.fibonacci_lfsr`
and :vhdl:entity:`~extras.lfsr_ops.galois_lfsr`) are available for use outside of a process. All
implementations have an ``INIT_ZERO`` generic that can be used to start
an LFSR in the all 0's state and set the ``Kind`` to 'inverted'. When true the
initial state switches from all 1's to all 0's and XORs are replaced with
XNORs. The ``FULL_CYCLE`` generic activates the full cycle option described
above.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  signal state, statec : std_ulogic_vector(1 to 8);

  -- Get predefined maximal length polynomial
  constant TAP_MAP : std_ulogic_vector(1 to state'length-1) :=
    lfsr_taps(state'length);
  ...
  -- Implement LFSR in a process
  state <= next_galois_lfsr(state, TAP_MAP, inverted, Full_cycle => true);
  ...
  -- Implement LFSR as a component
  gl: galois_lfsr
    generic map (
      INIT_ZERO  => true,
      FULL_CYCLE => true
    ) port map (
      Clock   => clock,
      Reset   => reset,
      Enable  => enable,
      Tap_map => TAP_MAP,
      State   => statec
    );

Generate taps for any arbitrary polynomial:

.. code-block:: vhdl

  -- G(x) = x**11 + x**9 + x**8 + x**7 + x**2 + 1  (CRC-11)
  signal crc_state : std_ulogic_vector(1 to 11);
  signal crc_taps  : std_ulogic_vector(1 to crc_state'length-1);
  ...
  -- Discard the default feedback/forward taps:
  --                x**9 + x**8 + x**7 + x**2
  crc_taps <= to_tap_map((9, 8, 7, 2), crc_taps'length);

    
.. include:: auto/lfsr_ops.rst

