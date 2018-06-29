.. Generated from ../rtl/extras/sizing.vhdl on 2018-06-28 23:37:28.729892
.. vhdl:package:: extras.sizing


Subprograms
-----------


.. vhdl:function:: function floor_log(n : positive; b : positive) return natural;

   Compute the integer result of the function floor(log(n)).
  
  
  :param n: Number to take logarithm of
  :type n: positive
  :param b: Base for the logarithm
  :type b: positive
  :returns: Approximate logarithm of n rounded down.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     size := floor_log(20, 2);
  


.. vhdl:function:: function ceil_log(n : positive; b : positive) return natural;

   Compute the integer result of the function ceil(log(n)) where b is the base.
  
  
  :param n: Number to take logarithm of
  :type n: positive
  :param b: Base for the logarithm
  :type b: positive
  :returns: Approximate logarithm of n rounded up.
  
  
  .. rubric:: Example:
  
  .. code-block:: vhdl
  
     size := ceil_log(20, 2);
  


.. vhdl:function:: function floor_log2(n : positive) return natural;

   Compute the integer result of the function floor(log2(n)).
  
  
  :param n: Number to take logarithm of
  :type n: positive
  :returns: Approximate base-2 logarithm of n rounded down.
  


.. vhdl:function:: function ceil_log2(n : positive) return natural;

   Compute the integer result of the function ceil(log2(n)).
  
  
  :param n: Number to take logarithm of
  :type n: positive
  :returns: Approximate base-2 logarithm of n rounded up.
  


.. vhdl:function:: function bit_size(n : natural) return natural;

   Compute the total number of bits needed to represent a number in binary.
  
  
  :param n: Number to compute size from
  :type n: natural
  :returns: Number of bits.
  


.. vhdl:function:: function encoding_size(n : positive) return natural;

   Compute the number of bits needed to encode n items.
  
  
  :param n: Number to compute size from
  :type n: positive
  :returns: Number of bits.
  


.. vhdl:function:: function signed_size(n : integer) return natural;

   Compute the total number of bits to represent a 2's complement signed
   integer in binary.
  
  
  :param n: Number to compute size from
  :type n: integer
  :returns: Number of bits.
  

