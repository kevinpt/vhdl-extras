======
random
======

`extras/random.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/random.vhdl>`_

`extras_2008/random_20xx.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras_2008/random_20xx.vhdl>`_


Dependencies
------------

:doc:`timing_ops <timing_ops>`

Description
-----------

This package provides a general set of pseudo-random number functions.
It is implemented as a wrapper around the ``ieee.math_real.uniform``
procedure and is only suitable for simulation not synthesis. See the
:doc:`LCAR <lcar_ops>` and :doc:`LFSR <lfsr_ops>` packages for synthesizable random generators.

This package makes use of shared variables to keep track of the PRNG
state more conveniently than calling uniform directly. Because
VHDL-2002 broke forward compatability of shared variables there are
two versions of this package. One (random.vhdl) is for VHDL-93 using
the classic shared variable mechanism. The other (random_20xx.vhdl)
is for VHDL-2002 and later using a protected type to manage the
PRNG state. Both files define a package named "random" and only one
can be in use at any time. The user visible subprograms are the same
in both implementations.

The package provides a number of overloaded subprograms for generating
random numbers of various types.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  seed(12345);    -- Initialize PRNG with a seed value
  seed(123, 456); -- Alternate seed procedure

  variable : r : real    := random; -- Generate a random real
  variable : n : natural := random; -- Generate a random natural
  variable : b : boolean := random; -- Generate a random boolean
  -- Generate a random bit_vector of any size
  variable : bv : bit_vector(99 downto 0) := random(100);

  -- Generate a random integer within a specified range
  -- Number between 2 and 10 inclusive
  variable : i : natural := randint(2, 10);

    
.. include:: auto/random.rst

