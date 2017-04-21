.. Generated from ../rtl/extras/sizing.vhdl on 2017-04-20 23:04:37.094174
.. vhdl:package:: sizing


Subprograms
-----------


.. vhdl:function:: function floor_log(n : positive; b : positive) return natural;

  :param n: Number to take logarithm of
  :type n: positive
  :param b: Base for the logarithm
  :type b: positive
  :returns:   Approximate logarithm of n rounded down.

  Compute the integer result of the function floor(log(n)).
  

.. vhdl:function:: function ceil_log(n : positive; b : positive) return natural;

  :param n: Number to take logarithm of
  :type n: positive
  :param b: Base for the logarithm
  :type b: positive
  :returns:   Approximate logarithm of n rounded up.

  Compute the integer result of the function ceil(log(n)) where b is the base.
  

.. vhdl:function:: function floor_log2(n : positive) return natural;

  :param n: Number to take logarithm of
  :type n: positive
  :returns:   Approximate base-2 logarithm of n rounded down.

  Compute the integer result of the function floor(log2(n)).
  

.. vhdl:function:: function ceil_log2(n : positive) return natural;

  :param n: Number to take logarithm of
  :type n: positive
  :returns:   Approximate base-2 logarithm of n rounded up.

  Compute the integer result of the function ceil(log2(n)).
  

.. vhdl:function:: function bit_size(n : natural) return natural;

  :param n: Number to compute size from
  :type n: natural
  :returns:   Number of bits.

  Compute the total number of bits needed to represent a number in binary.
  

.. vhdl:function:: function encoding_size(n : positive) return natural;

  :param n: Number to compute size from
  :type n: positive
  :returns:   Number of bits.

  Compute the number of bits needed to encode n items.
  

.. vhdl:function:: function signed_size(n : integer) return natural;

  :param n: Number to compute size from
  :type n: integer
  :returns:   Number of bits.

  Compute the total number of bits to represent a 2's complement signed
  integer in binary.
  
