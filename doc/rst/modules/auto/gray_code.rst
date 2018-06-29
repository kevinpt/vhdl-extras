.. Generated from ../rtl/extras/gray_code.vhdl on 2018-06-28 23:37:29.198622
.. vhdl:package:: extras.gray_code


Components
----------


gray_counter
~~~~~~~~~~~~

.. symbolator::
  :name: gray_code-gray_counter

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


.. vhdl:entity:: gray_counter

  An example Gray code counter implementation. This counter maintains an
  internal binary register and converts its output to Gray code stored in a
  separate register.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Load: Synchronous load, active high
  :ptype Load: in std_ulogic
  :port Enable: Synchronous enable, active high
  :ptype Enable: in std_ulogic
  :port Binary_load: Loadable binary value
  :ptype Binary_load: in unsigned
  :port Binary: Binary count
  :ptype Binary: out unsigned
  :port Gray: Gray code count
  :ptype Gray: out unsigned

Subprograms
-----------


.. vhdl:function:: function to_gray(Binary : std_ulogic_vector) return std_ulogic_vector;

   Convert binary to Gray code.
  
  :param Binary: Binary value
  :type Binary: std_ulogic_vector
  :returns: Gray-coded vector.
  


.. vhdl:function:: function to_gray(Binary : std_logic_vector) return std_logic_vector;

   Convert binary to Gray code.
  
  :param Binary: Binary value
  :type Binary: std_logic_vector
  :returns: Gray-coded vector.
  


.. vhdl:function:: function to_gray(Binary : unsigned) return unsigned;

   Convert binary to Gray code.
  
  :param Binary: Binary value
  :type Binary: unsigned
  :returns: Gray-coded vector.
  


.. vhdl:function:: function to_binary(Gray : std_ulogic_vector) return std_ulogic_vector;

   Convert Gray code to binary.
  
  :param Binary: Gray-coded value
  :returns: Decoded binary value.
  


.. vhdl:function:: function to_binary(Gray : std_logic_vector) return std_logic_vector;

   Convert Gray code to binary.
  
  :param Binary: Gray-coded value
  :returns: Decoded binary value.
  


.. vhdl:function:: function to_binary(Gray : unsigned) return unsigned;

   Convert Gray code to binary.
  
  :param Binary: Gray-coded value
  :returns: Decoded binary value.
  

