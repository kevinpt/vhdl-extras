.. Generated from ../rtl/extras/reg_file.vhdl on 2017-04-20 23:04:36.916746
.. vhdl:package:: reg_file_pkg


Types
-----


.. vhdl:type:: reg_array


Subtypes
--------


.. vhdl:subtype:: reg_word


Components
----------


reg_file
~~~~~~~~

.. symbolator::

  component reg_file is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    DIRECT_READ_BIT_MASK : reg_array;
    STROBE_BIT_MASK : reg_array;
    REGISTER_INPUTS : boolean
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Clear : in std_ulogic;
    Reg_sel : in unsigned;
    We : in std_ulogic;
    Wr_data : in reg_word;
    Rd_data : out reg_word;
    Registers : out reg_array;
    Direct_read : in reg_array;
    Reg_written : out std_ulogic_vector
  );
  end component;

|


|


.. vhdl:entity:: reg_file

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic DIRECT_READ_BIT_MASK: 
  :gtype DIRECT_READ_BIT_MASK: reg_array
  :generic STROBE_BIT_MASK: 
  :gtype STROBE_BIT_MASK: reg_array
  :generic REGISTER_INPUTS: 
  :gtype REGISTER_INPUTS: boolean
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Clear: 
  :ptype Clear: in std_ulogic
  :port Reg_sel: 
  :ptype Reg_sel: in unsigned
  :port We: 
  :ptype We: in std_ulogic
  :port Wr_data: 
  :ptype Wr_data: in reg_word
  :port Rd_data: 
  :ptype Rd_data: out reg_word
  :port Registers: 
  :ptype Registers: out reg_array
  :port Direct_read: 
  :ptype Direct_read: in reg_array
  :port Reg_written: 
  :ptype Reg_written: out std_ulogic_vector
