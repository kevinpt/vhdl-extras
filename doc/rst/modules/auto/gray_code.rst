.. Generated from ../rtl/extras/gray_code.vhdl on 2017-04-20 23:04:37.435378
.. vhdl:package:: gray_code


Components
----------


gray_counter
~~~~~~~~~~~~

.. symbolator::

  component gray_counter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Load : in std_ulogic;
    Enable : in std_ulogic;
    --# {{data|}}
    Binary_load : in unsigned;
    Binary : out unsigned;
    Gray : out unsigned
  );
  end component;

|

An example Gray code counter implementation. This counter maintains an
internal binary register and converts its output to Gray code stored in a
separate register.

|


.. vhdl:entity:: gray_counter

  :generic RESET_ACTIVE_LEVEL:  Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock:  System clock
  :ptype Clock: in std_ulogic
  :port Reset:  Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Load:  Synchronous load, active high
  :ptype Load: in std_ulogic
  :port Enable:  Synchronous enable, active high
  :ptype Enable: in std_ulogic
  :port Binary_load:  Loadable binary value
  :ptype Binary_load: in unsigned
  :port Binary:  Binary count
  :ptype Binary: out unsigned
  :port Gray:  Gray code count
  :ptype Gray: out unsigned

Subprograms
-----------


.. vhdl:function:: function to_gray(Binary : std_ulogic_vector) return std_ulogic_vector;

  :param Binary: Binary value
  :type Binary: std_ulogic_vector
  :returns:  Gray-coded vector.

  Convert binary to Gray code.

.. vhdl:function:: function to_gray(Binary : std_logic_vector) return std_logic_vector;

  :param Binary: Binary value
  :type Binary: std_logic_vector
  :returns:  Gray-coded vector.

  Convert binary to Gray code.

.. vhdl:function:: function to_gray(Binary : unsigned) return unsigned;

  :param Binary: Binary value
  :type Binary: unsigned
  :returns:  Gray-coded vector.

  Convert binary to Gray code.

.. vhdl:function:: function to_binary(Gray : std_ulogic_vector) return std_ulogic_vector;

  :param Gray: 
  :type Gray: std_ulogic_vector
  :returns:  Decoded binary value.

  Convert Gray code to binary.

.. vhdl:function:: function to_binary(Gray : std_logic_vector) return std_logic_vector;

  :param Gray: 
  :type Gray: std_logic_vector
  :returns:  Decoded binary value.

  Convert Gray code to binary.

.. vhdl:function:: function to_binary(Gray : unsigned) return unsigned;

  :param Gray: 
  :type Gray: unsigned
  :returns:  Decoded binary value.

  Convert Gray code to binary.
