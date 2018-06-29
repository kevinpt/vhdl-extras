.. Generated from ../rtl/extras_2008/common_2008.vhdl on 2018-06-28 23:37:30.056215
.. vhdl:package:: extras_2008.common


Types
-----


.. vhdl:type:: sulv_array

  Array of std_ulogic_vector.

.. vhdl:type:: slv_array

  Array of std_logic_vector.

.. vhdl:type:: unsigned_array

  Array of unsigned.

.. vhdl:type:: signed_array

  Array of signed.

Subprograms
-----------


.. vhdl:function:: function to_slv_array(A : sulv_array) return slv_array;

   Convert std_ulogic_vector array to std_logic_vector array.
  
  :param A: Array to convert
  :type A: sulv_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_sulv_array(A : slv_array) return sulv_array;

   Convert std_logic_vector array to std_ulogic_vector array.
  
  :param A: Array to convert
  :type A: slv_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_unsigned_array(A : sulv_array) return unsigned_array;

   Convert std_ulogic_vector array to unsigned array.
  
  :param A: Array to convert
  :type A: sulv_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_sulv_array(A : unsigned_array) return sulv_array;

   Convert unsigned array to std_ulogic_vector array.
  
  :param A: Array to convert
  :type A: unsigned_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_signed_array(A : sulv_array) return signed_array;

   Convert std_ulogic_vector array to signed array.
  
  :param A: Array to convert
  :type A: sulv_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_sulv_array(A : signed_array) return sulv_array;

   Convert signed array to std_ulogic_vector array.
  
  :param A: Array to convert
  :type A: signed_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_unsigned_array(A : slv_array) return unsigned_array;

   Convert std_logic_vector array to unsigned array.
  
  :param A: Array to convert
  :type A: slv_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_slv_array(A : unsigned_array) return slv_array;

   Convert unsigned array to std_logic_vector array.
  
  :param A: Array to convert
  :type A: unsigned_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_signed_array(A : slv_array) return signed_array;

   Convert std_logic_vector array to signed array.
  
  :param A: Array to convert
  :type A: slv_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_slv_array(A : signed_array) return slv_array;

   Convert signed array to std_logic_vector array.
  
  :param A: Array to convert
  :type A: signed_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_signed_array(A : unsigned_array) return signed_array;

   Convert unsigned array to signed array.
  
  :param A: Array to convert
  :type A: unsigned_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_unsigned_array(A : signed_array) return unsigned_array;

   Convert signed array to unsigned array.
  
  :param A: Array to convert
  :type A: signed_array
  :returns: Array with new type.
  


.. vhdl:function:: function to_sulv_array(A : std_ulogic_vector) return sulv_array;

   Convert a scaler std_ulogic_vector to a single element std_ulogic_vector array.
  
  :param A: Vector
  :type A: std_ulogic_vector
  :returns: Array with new type.
  


.. vhdl:function:: function to_slv_array(A : std_logic_vector) return slv_array;

   Convert a scaler std_logic_vector to a single element std_logic_vector array.
  
  :param A: Vector
  :type A: std_logic_vector
  :returns: Array with new type.
  


.. vhdl:function:: function to_unsigned_array(A : unsigned) return unsigned_array;

   Convert a scaler unsigned to a single element unsigned array.
  
  :param A: Vector
  :type A: unsigned
  :returns: Array with new type.
  


.. vhdl:function:: function to_signed_array(A : signed) return signed_array;

   Convert a scaler signed to a single element signed array.
  
  :param A: Vector
  :type A: signed
  :returns: Array with new type.
  

