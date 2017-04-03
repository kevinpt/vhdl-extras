.. Generated from ../rtl/extras/cordic.vhdl on 2017-04-02 22:57:52.992043
.. vhdl:package:: cordic

Types
-----

.. vhdl:type:: cordic_mode

Subprograms
-----------


.. vhdl:function:: function cordic_gain(iterations : positive) return real;

  :param iterations: 
  :type iterations: positive


.. vhdl:procedure:: procedure adjust_angle(x : in signed; y : in signed; z : in signed; xa : out signed; ya : out signed; za : out signed);

  :param x: 
  :type x: in signed
  :param y: 
  :type y: in signed
  :param z: 
  :type z: in signed
  :param xa: 
  :type xa: out signed
  :param ya: 
  :type ya: out signed
  :param za: 
  :type za: out signed


.. vhdl:procedure:: procedure rotate(iterations : in integer; x : in signed; y : in signed; z : in signed; xr : out signed; yr : out signed; zr : out signed);

  :param iterations: 
  :type iterations: in integer
  :param x: 
  :type x: in signed
  :param y: 
  :type y: in signed
  :param z: 
  :type z: in signed
  :param xr: 
  :type xr: out signed
  :param yr: 
  :type yr: out signed
  :param zr: 
  :type zr: out signed


.. vhdl:procedure:: procedure vector(iterations : in integer; x : in signed; y : in signed; z : in signed; xr : out signed; yr : out signed; zr : out signed);

  :param iterations: 
  :type iterations: in integer
  :param x: 
  :type x: in signed
  :param y: 
  :type y: in signed
  :param z: 
  :type z: in signed
  :param xr: 
  :type xr: out signed
  :param yr: 
  :type yr: out signed
  :param zr: 
  :type zr: out signed


.. vhdl:function:: function effective_fractional_bits(iterations : positive; frac_bits : positive) return real;

  :param iterations: 
  :type iterations: positive
  :param frac_bits: 
  :type frac_bits: positive

