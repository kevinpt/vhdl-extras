.. Generated from ../rtl/extras/random.vhdl on 2017-04-02 22:57:53.031587
.. vhdl:package:: random

Subprograms
-----------


.. vhdl:procedure:: procedure seed(s : in positive);

  :param s: 
  :type s: in positive

  Seed the PRNG with a number s

.. vhdl:procedure:: procedure seed(s1 : in positive; s2 : in positive);

  :param s1: 
  :type s1: in positive
  :param s2: 
  :type s2: in positive

  Seed the PRNG with s1 and s2. This offers more
  random initialization than the one argument version
  of seed.

.. vhdl:function:: function random(size : positive) return bit_vector;

  :param size: 
  :type size: positive

  Genrate a random real
  Generate a random natural
  Generate a random boolean
  Generate a random character
  Generate a random bit_vector of size bits

.. vhdl:function:: function randint(min : integer; max : integer) return integer;

  :param min: 
  :type min: integer
  :param max: 
  :type max: integer

  Generate a random integer between min and max inclusive
  Note that the span max - min must be less than integer'high.

.. vhdl:function:: function randtime(min : time; max : time) return time;

  :param min: 
  :type min: time
  :param max: 
  :type max: time

  Generate a random time between min and max inclusive
  Note that the span max - min must be less than time'high.
