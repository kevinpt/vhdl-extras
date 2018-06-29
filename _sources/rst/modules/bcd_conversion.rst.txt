==============
bcd_conversion
==============

`extras/bcd_conversion.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/bcd_conversion.vhdl>`_

Dependencies
------------

:doc:`sizing`

Description
-----------

This package provides functions and components for performing conversion
between binary and packed Binary Coded Decimal (BCD). The functions
:vhdl:func:`~extras.bcd_conversion.to_bcd` and :vhdl:func:`~extras.bcd_conversion.to_binary`
can be used to create synthesizable combinational
logic for performing a conversion. In synthesized code they are best used
with shorter arrays comprising only a few digits. For larger numbers, the
components :vhdl:entity:`~extras.bcd_conversion.binary_to_bcd` and
:vhdl:entity:`~extras.bcd_conversion.bcd_to_binary` can be used to perform a
conversion over multiple clock cycles. The utility function :vhdl:func:`~extras.bcd_conversion.decimal_size`
can be used to determine the number of decimal digits in a BCD array. Its
result must be multiplied by 4 to get the length of a packed BCD array.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  signal binary  : unsigned(7 downto 0);
  constant DSIZE : natural := decimal_size(2**binary'length - 1);
  signal bcd : unsigned(DSIZE*4-1 downto 0);
  ...
  bcd <= to_bcd(binary);


.. include:: auto/bcd_conversion.rst

