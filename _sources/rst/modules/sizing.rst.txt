======
sizing
======

`extras/sizing.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/sizing.vhdl>`_

Dependencies
------------

None

Description
-----------

This package provides functions used to compute integer approximations
of logarithms. The primary use of these functions is to determine the
size of arrays using the :vhdl:func:`~extras.sizing.bit_size[natural return natural]` and :vhdl:func:`~extras.sizing.encoding_size[positive return natural]` functions. When put to
maximal use it is possible to create designs that eliminate hardcoded
ranges and automatically resize their signals and variables by changing a
few key constants or generics.

These functions can be used in most synthesizers to compute ranges for
arrays. The core functionality is provided in the :vhdl:func:`~extras.sizing.ceil_log[positive,positive return natural]` and
:vhdl:func:`~extras.sizing.floor_log[positive,positive return natural]` subprograms. These compute the logarithm in any integer base.
For convenenience, base-2 functions are also provided along with the array
sizing functions. See the :doc:`bcd_conversion` implementation
of :vhdl:func:`~extras.bcd_conversion.decimal_size` for a practical
example of computing integer logs in base-10 using this package.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  constant MAX_COUNT  : natural := 1000;
  constant COUNT_SIZE : natural := bit_size(MAX_COUNT);
  signal counter : unsigned(COUNT_SIZE-1 downto 0);
  ...
  counter <= to_unsigned(MAX_COUNT, COUNT_SIZE);
  -- counter will resize itself as MAX_COUNT is changed
    
.. include:: auto/sizing.rst

