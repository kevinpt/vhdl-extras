.. Generated from ../rtl/extras/reg_file.vhdl on 2018-06-28 23:37:28.444060
.. vhdl:package:: extras.reg_file_pkg


Types
-----


.. vhdl:type:: reg_array

  Array of register words.

Subtypes
--------


.. vhdl:subtype:: reg_word

  Register word vector. Modify this to use different word sizes.

Components
----------


reg_file
~~~~~~~~

.. symbolator::
  :name: reg_file_pkg-reg_file

  component reg_file is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    DIRECT_READ_BIT_MASK : reg_array;
    STROBE_BIT_MASK : reg_array;
    REGISTER_INPUTS : boolean
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Clear : in std_ulogic;
    --# {{data|Addressed port}}
    Reg_sel : in unsigned;
    We : in std_ulogic;
    Wr_data : in reg_word;
    Rd_data : out reg_word;
    --# {{Registers}}
    Registers : out reg_array;
    Direct_read : in reg_array;
    Reg_written : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: reg_file

  Flexible register file with support for strobed outputs.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic DIRECT_READ_BIT_MASK: Masks indicating which register bits are directly read
  :gtype DIRECT_READ_BIT_MASK: reg_array
  :generic STROBE_BIT_MASK: Masks indicating which register bits clear themselves after a write of '1'
  :gtype STROBE_BIT_MASK: reg_array
  :generic REGISTER_INPUTS: Register the input ports when true
  :gtype REGISTER_INPUTS: boolean
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Clear: Initialize all registers to '0'
  :ptype Clear: in std_ulogic
  :port Reg_sel: Register address for write and read
  :ptype Reg_sel: in unsigned
  :port We: Write to selected register
  :ptype We: in std_ulogic
  :port Wr_data: Write port
  :ptype Wr_data: in reg_word
  :port Rd_data: Read port
  :ptype Rd_data: out reg_word
  :port Registers: Register file contents
  :ptype Registers: out reg_array
  :port Direct_read: Read-only signals direct from external logic
  :ptype Direct_read: in reg_array
  :port Reg_written: Status flags indicating when each register is written
  :ptype Reg_written: out std_ulogic_vector
