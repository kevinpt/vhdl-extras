.. Generated from ../rtl/extras/memory.vhdl on 2017-04-20 23:04:37.169090
.. vhdl:package:: memory


Types
-----


.. vhdl:type:: rom_format


Components
----------


dual_port_ram
~~~~~~~~~~~~~

.. symbolator::

  component dual_port_ram is
  generic (
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    Wr_clock : in std_ulogic;
    We : in std_ulogic;
    Wr_addr : in natural;
    Wr_data : in std_ulogic_vector;
    Rd_clock : in std_ulogic;
    Re : in std_ulogic;
    Rd_addr : in natural;
    Rd_data : out std_ulogic_vector
  );
  end component;

|


|


.. vhdl:entity:: dual_port_ram

  :generic MEM_SIZE: 
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: 
  :gtype SYNC_READ: boolean
  :port Wr_clock: 
  :ptype Wr_clock: in std_ulogic
  :port We: 
  :ptype We: in std_ulogic
  :port Wr_addr: 
  :ptype Wr_addr: in natural
  :port Wr_data: 
  :ptype Wr_data: in std_ulogic_vector
  :port Rd_clock: 
  :ptype Rd_clock: in std_ulogic
  :port Re: 
  :ptype Re: in std_ulogic
  :port Rd_addr: 
  :ptype Rd_addr: in natural
  :port Rd_data: 
  :ptype Rd_data: out std_ulogic_vector

rom
~~~

.. symbolator::

  component rom is
  generic (
    ROM_FILE : string;
    FORMAT : rom_format;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    Clock : in std_ulogic;
    Re : in std_ulogic;
    Addr : in natural;
    Data : out std_ulogic_vector
  );
  end component;

|


|


.. vhdl:entity:: rom

  :generic ROM_FILE: 
  :gtype ROM_FILE: string
  :generic FORMAT: 
  :gtype FORMAT: rom_format
  :generic MEM_SIZE: 
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: 
  :gtype SYNC_READ: boolean
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Re: 
  :ptype Re: in std_ulogic
  :port Addr: 
  :ptype Addr: in natural
  :port Data: 
  :ptype Data: out std_ulogic_vector
