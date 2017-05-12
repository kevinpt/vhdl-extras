.. Generated from ../rtl/extras_2008/common_2008.vhdl on 2017-05-07 22:23:47.430045
.. vhdl:package:: extras_2008.common


Types
-----


.. vhdl:type:: extras_2008.sulv_array


.. vhdl:type:: extras_2008.slv_array


.. vhdl:type:: extras_2008.unsigned_array


.. vhdl:type:: extras_2008.signed_array


Subprograms
-----------


.. vhdl:function:: function to_slv_array(a : sulv_array) return slv_array;

  Convert std_ulogic_vector array to std_logic_vector array.


  :param a: 
  :type a: sulv_array
  :returns:  Array with new type.


.. vhdl:function:: function to_sulv_array(a : slv_array) return sulv_array;

  Convert std_logic_vector array to std_ulogic_vector array.


  :param a: 
  :type a: slv_array
  :returns:  Array with new type.


.. vhdl:function:: function to_unsigned_array(a : sulv_array) return unsigned_array;

  Convert std_ulogic_vector array to unsigned array.


  :param a: 
  :type a: sulv_array
  :returns:  Array with new type.


.. vhdl:function:: function to_sulv_array(a : unsigned_array) return sulv_array;

  Convert unsigned array to std_ulogic_vector array.


  :param a: 
  :type a: unsigned_array
  :returns:  Array with new type.


.. vhdl:function:: function to_signed_array(a : sulv_array) return signed_array;

  Convert std_ulogic_vector array to signed array.


  :param a: 
  :type a: sulv_array
  :returns:  Array with new type.


.. vhdl:function:: function to_sulv_array(a : signed_array) return sulv_array;

  Convert signed array to std_ulogic_vector array.


  :param a: 
  :type a: signed_array
  :returns:  Array with new type.


.. vhdl:function:: function to_unsigned_array(a : slv_array) return unsigned_array;

  Convert std_logic_vector array to unsigned array.


  :param a: 
  :type a: slv_array
  :returns:  Array with new type.


.. vhdl:function:: function to_slv_array(a : unsigned_array) return slv_array;

  Convert unsigned array to std_logic_vector array.


  :param a: 
  :type a: unsigned_array
  :returns:  Array with new type.


.. vhdl:function:: function to_signed_array(a : slv_array) return signed_array;

  Convert std_logic_vector array to signed array.


  :param a: 
  :type a: slv_array
  :returns:  Array with new type.


.. vhdl:function:: function to_slv_array(a : signed_array) return slv_array;

  Convert signed array to std_logic_vector array.


  :param a: 
  :type a: signed_array
  :returns:  Array with new type.


.. vhdl:function:: function to_signed_array(a : unsigned_array) return signed_array;

  Convert unsigned array to signed array.


  :param a: 
  :type a: unsigned_array
  :returns:  Array with new type.


.. vhdl:function:: function to_unsigned_array(a : signed_array) return unsigned_array;

  Convert signed array to unsigned array.


  :param a: 
  :type a: signed_array
  :returns:  Array with new type.


.. vhdl:function:: function to_sulv_array(a : std_ulogic_vector) return sulv_array;

  Convert a scaler std_ulogic_vector to a single element std_ulogic_vector array.


  :param a: 
  :type a: std_ulogic_vector
  :returns:  Array with new type.


.. vhdl:function:: function to_slv_array(a : std_logic_vector) return slv_array;

  Convert a scaler std_logic_vector to a single element std_logic_vector array.


  :param a: 
  :type a: std_logic_vector
  :returns:  Array with new type.


.. vhdl:function:: function to_unsigned_array(a : unsigned) return unsigned_array;

  Convert a scaler unsigned to a single element unsigned array.


  :param a: 
  :type a: unsigned
  :returns:  Array with new type.


.. vhdl:function:: function to_signed_array(a : signed) return signed_array;

  Convert a scaler signed to a single element signed array.


  :param a: 
  :type a: signed
  :returns:  Array with new type.

