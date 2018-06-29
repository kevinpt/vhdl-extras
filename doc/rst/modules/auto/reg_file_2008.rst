.. Generated from ../rtl/extras_2008/reg_file_2008.vhdl on 2018-06-28 23:37:30.084771
.. vhdl:package:: extras_2008.reg_file_pkg


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

  Flexible register file with support for strobed outputs. This variant
  uses VHDL-2008 syntax to define the reg_array type as an unconstrained
  array-of-arrays. Any register width can be instantiated without needing
  to modify the library.
  
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
  :port Rd_data: Internal file contents
  :ptype Rd_data: out reg_word
  :port Registers: Register file contents
  :ptype Registers: out reg_array
  :port Direct_read: Read-only signals direct from external logic
  :ptype Direct_read: in reg_array
  :port Reg_written: Status flags indicating when each register is written
  :ptype Reg_written: out std_ulogic_vector
