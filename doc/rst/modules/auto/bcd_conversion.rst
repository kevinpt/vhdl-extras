.. Generated from ../rtl/extras/bcd_conversion.vhdl on 2017-04-02 22:57:53.246227
.. vhdl:package:: bcd_conversion

Subprograms
-----------


.. vhdl:function:: function decimal_size(n : natural) return natural;

  :param n: 
  :type n: natural

  Calculate the number of decimal digits needed to represent a number n

.. vhdl:function:: function to_bcd(Binary : unsigned) return unsigned;

  :param Binary: 
  :type Binary: unsigned

  Conversion functions

.. vhdl:function:: function to_binary(Bcd : unsigned) return unsigned;

  :param Bcd: 
  :type Bcd: unsigned

