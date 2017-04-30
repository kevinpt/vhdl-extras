.. Generated from ../rtl/extras_2008/random_20xx.vhdl on 2017-04-25 22:17:58.605044
.. vhdl:package:: extras_2008.random


Subprograms
-----------


.. vhdl:procedure:: procedure seed(s : in positive);

  Seed the PRNG with a number s


  :param s: 
  :type s: in positive


.. vhdl:procedure:: procedure seed(s1 : None; s2 : in positive);

  Seed the PRNG with s1 and s2. This offers more
  random initialization than the one argument version
  of seed.


  :param s1: 
  :type s1: None None
  :param s2: 
  :type s2: in positive


.. vhdl:function:: function random return real;

  Generate a random real




.. vhdl:function:: function random return natural;

  Generate a random natural




.. vhdl:function:: function random return boolean;

  Generate a random boolean




.. vhdl:function:: function random return character;

  Generate a random character




.. vhdl:function:: function random(size : positive) return bit_vector;

  Generate a random bit_vector of size bits


  :param size: 
  :type size: positive


.. vhdl:function:: function randint(min : None; max : integer) return integer;

  Generate a random integer between min and max inclusive
  Note that the span max - min must be less than integer'high.


  :param min: 
  :type min: None
  :param max: 
  :type max: integer


.. vhdl:function:: function randtime(min : None; max : time) return time;

  Generate a random time between min and max inclusive
  Note that the span max - min must be less than time'high.


  :param min: 
  :type min: None
  :param max: 
  :type max: time


.. vhdl:procedure:: procedure seed(s1 : None; s2 : in positive);



  :param s1: 
  :type s1: None None
  :param s2: 
  :type s2: in positive


.. vhdl:function:: function random return real;




