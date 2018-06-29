.. Generated from ../rtl/extras_2008/random_20xx.vhdl on 2018-06-28 23:37:30.037475
.. vhdl:package:: extras_2008.random


Subprograms
-----------


.. vhdl:procedure:: procedure seed(S : in positive);

   Seed the PRNG with a number.
  
  :param S: Seed value
  :type S: in positive


.. vhdl:procedure:: procedure seed(S1 : in positive; S2 : in positive);

   Seed the PRNG with s1 and s2. This offers more
   random initialization than the one argument version
   of seed.
  
  :param S1: Seed value 1
  :type S1: in positive
  :param S2: Seed value 2
  :type S2: in positive


.. vhdl:function:: function random return real;

   Generate a random real.
  :returns: Random value.
  


.. vhdl:function:: function random return natural;

   Generate a random natural.
  :returns: Random value.
  


.. vhdl:function:: function random return boolean;

   Generate a random boolean.
  :returns: Random value.
  


.. vhdl:function:: function random return character;

   Generate a random character.
  :returns: Random value.
  


.. vhdl:function:: function random(Size : positive) return bit_vector;

   Generate a random bit_vector of size bits.
  
  :param Size: Length of the random result
  :type Size: positive
  :returns: Random value.
  


.. vhdl:function:: function randint(Min : integer; Max : integer) return integer;

   Generate a random integer between Min and Max inclusive.
   Note that the span Max - Min must be less than integer'high.
  
  :param Min: Minimum value
  :type Min: integer
  :param Max: Maximum value
  :type Max: integer
  :returns: Random value between Min and Max.
  


.. vhdl:function:: function randtime(Min : time; Max : time) return time;

   Generate a random time between Min and Max inclusive.
   Note that the span Max - Min must be less than time'high.
  
  :param Min: Minimum value
  :type Min: time
  :param Max: Maximum value
  :type Max: time
  :returns: Random value between Min and Max.
  

