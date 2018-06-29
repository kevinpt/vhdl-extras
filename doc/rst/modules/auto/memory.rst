.. Generated from ../rtl/extras/memory.vhdl on 2018-06-28 23:37:28.866907
.. vhdl:package:: extras.memory


Types
-----


.. vhdl:type:: rom_format

  Data file format. Either binary or ASCII hex.

Components
----------


dual_port_ram
~~~~~~~~~~~~~

.. symbolator::
  :name: memory-dual_port_ram

  component dual_port_ram is
  generic (
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    --# {{data|Write port}}
    Wr_clock : in std_ulogic;
    We : in std_ulogic;
    Wr_addr : in natural;
    Wr_data : in std_ulogic_vector;
    --# {{Read port}}
    Rd_clock : in std_ulogic;
    Re : in std_ulogic;
    Rd_addr : in natural;
    Rd_data : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: dual_port_ram

  A dual-ported RAM supporting writes and reads from separate clock domains.
  
  :generic MEM_SIZE: Number or words in memory
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: Register outputs of read port memory
  :gtype SYNC_READ: boolean
  
  :port Wr_clock: Write port clock
  :ptype Wr_clock: in std_ulogic
  :port We: Write enable
  :ptype We: in std_ulogic
  :port Wr_addr: Write port address
  :ptype Wr_addr: in natural
  :port Wr_data: Write port data
  :ptype Wr_data: in std_ulogic_vector
  :port Rd_clock: Read port clock
  :ptype Rd_clock: in std_ulogic
  :port Re: Read enable
  :ptype Re: in std_ulogic
  :port Rd_addr: Read port address
  :ptype Rd_addr: in natural
  :port Rd_data: Read port data
  :ptype Rd_data: out std_ulogic_vector

rom
~~~

.. symbolator::
  :name: memory-rom

  component rom is
  generic (
    ROM_FILE : string;
    FORMAT : rom_format;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{data|}}
    Re : in std_ulogic;
    Addr : in natural;
    Data : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: rom

  A synthesizable ROM using a file to specify the contents.
  
  :generic ROM_FILE: Name of file with ROM data
  :gtype ROM_FILE: string
  :generic FORMAT: File encoding
  :gtype FORMAT: rom_format
  :generic MEM_SIZE: Number or words in memory
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: Register outputs of read port memory
  :gtype SYNC_READ: boolean
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Re: Read enable
  :ptype Re: in std_ulogic
  :port Addr: Read address
  :ptype Addr: in natural
  :port Data: Data at current address
  :ptype Data: out std_ulogic_vector
