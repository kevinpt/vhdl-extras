.. Generated from ../rtl/extras/fifos.vhdl on 2018-06-28 23:37:28.517436
.. vhdl:package:: extras.fifos


Components
----------


simple_fifo
~~~~~~~~~~~

.. symbolator::
  :name: fifos-simple_fifo

  component simple_fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|Write port}}
    We : in std_ulogic;
    Wr_data : in std_ulogic_vector;
    --# {{Read port}}
    Re : in std_ulogic;
    Rd_data : out std_ulogic_vector;
    --# {{Status}}
    Empty : out std_ulogic;
    Full : out std_ulogic;
    Almost_empty_thresh : in natural;
    Almost_full_thresh : in natural;
    Almost_empty : out std_ulogic;
    Almost_full : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: simple_fifo

  Basic FIFO implementatioin for use on a single clock domain.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic MEM_SIZE: Number or words in FIFO
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: Register outputs of read port memory
  :gtype SYNC_READ: boolean
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port We: Write enable
  :ptype We: in std_ulogic
  :port Wr_data: Write data into FIFO
  :ptype Wr_data: in std_ulogic_vector
  :port Re: Read enable
  :ptype Re: in std_ulogic
  :port Rd_data: Read data from FIFO
  :ptype Rd_data: out std_ulogic_vector
  :port Empty: Empty flag
  :ptype Empty: out std_ulogic
  :port Full: Full flag
  :ptype Full: out std_ulogic
  :port Almost_empty_thresh: Capacity level when almost empty
  :ptype Almost_empty_thresh: in natural
  :port Almost_full_thresh: Capacity level when almost full
  :ptype Almost_full_thresh: in natural
  :port Almost_empty: Almost empty flag
  :ptype Almost_empty: out std_ulogic
  :port Almost_full: Almost full flag
  :ptype Almost_full: out std_ulogic

fifo
~~~~

.. symbolator::
  :name: fifos-fifo

  component fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    --# {{data|Write port}}
    Wr_clock : in std_ulogic;
    Wr_reset : in std_ulogic;
    We : in std_ulogic;
    Wr_data : in std_ulogic_vector;
    --# {{Read port}}
    Rd_clock : in std_ulogic;
    Rd_reset : in std_ulogic;
    Re : in std_ulogic;
    Rd_data : out std_ulogic_vector;
    --# {{Status}}
    Empty : out std_ulogic;
    Full : out std_ulogic;
    Almost_empty_thresh : in natural;
    Almost_full_thresh : in natural;
    Almost_empty : out std_ulogic;
    Almost_full : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: fifo

  General purpose FIFO best used to transfer data across clock domains.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic MEM_SIZE: Number or words in FIFO
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: Register outputs of read port memory
  :gtype SYNC_READ: boolean
  
  :port Wr_clock: Write port clock
  :ptype Wr_clock: in std_ulogic
  :port Wr_reset: Asynchronous write port reset
  :ptype Wr_reset: in std_ulogic
  :port We: Write enable
  :ptype We: in std_ulogic
  :port Wr_data: Write data into FIFO
  :ptype Wr_data: in std_ulogic_vector
  :port Rd_clock: Read port clock
  :ptype Rd_clock: in std_ulogic
  :port Rd_reset: Asynchronous read port reset
  :ptype Rd_reset: in std_ulogic
  :port Re: Read enable
  :ptype Re: in std_ulogic
  :port Rd_data: Read data from FIFO
  :ptype Rd_data: out std_ulogic_vector
  :port Empty: Empty flag
  :ptype Empty: out std_ulogic
  :port Full: Full flag
  :ptype Full: out std_ulogic
  :port Almost_empty_thresh: Capacity level when almost empty
  :ptype Almost_empty_thresh: in natural
  :port Almost_full_thresh: Capacity level when almost full
  :ptype Almost_full_thresh: in natural
  :port Almost_empty: Almost empty flag
  :ptype Almost_empty: out std_ulogic
  :port Almost_full: Almost full flag
  :ptype Almost_full: out std_ulogic

packet_fifo
~~~~~~~~~~~

.. symbolator::
  :name: fifos-packet_fifo

  component packet_fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    --# {{data|Write port}}
    Wr_clock : in std_ulogic;
    Wr_reset : in std_ulogic;
    We : in std_ulogic;
    Wr_data : in std_ulogic_vector;
    Keep : in std_ulogic;
    Discard : in std_ulogic;
    --# {{Read port}}
    Rd_clock : in std_ulogic;
    Rd_reset : in std_ulogic;
    Re : in std_ulogic;
    Rd_data : out std_ulogic_vector;
    --# {{Status}}
    Empty : out std_ulogic;
    Full : out std_ulogic;
    Almost_empty_thresh : in natural;
    Almost_full_thresh : in natural;
    Almost_empty : out std_ulogic;
    Almost_full : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: packet_fifo

  This is a dual port FIFO with the ability to drop partially accumulated data. This permits
  you to take in data that may be corrupted and drop it if a trailing checksum or CRC is not valid.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic MEM_SIZE: Number or words in FIFO
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: Register outputs of read port memory
  :gtype SYNC_READ: boolean
  
  :port Wr_clock: Write port clock
  :ptype Wr_clock: in std_ulogic
  :port Wr_reset: Asynchronous write port reset
  :ptype Wr_reset: in std_ulogic
  :port We: Write enable
  :ptype We: in std_ulogic
  :port Wr_data: Write data into FIFO
  :ptype Wr_data: in std_ulogic_vector
  :port Keep: Store current write packet
  :ptype Keep: in std_ulogic
  :port Discard: Drop current erite packet
  :ptype Discard: in std_ulogic
  :port Rd_clock: Read port clock
  :ptype Rd_clock: in std_ulogic
  :port Rd_reset: Asynchronous read port reset
  :ptype Rd_reset: in std_ulogic
  :port Re: Read enable
  :ptype Re: in std_ulogic
  :port Rd_data: Read data from FIFO
  :ptype Rd_data: out std_ulogic_vector
  :port Empty: Empty flag
  :ptype Empty: out std_ulogic
  :port Full: Full flag
  :ptype Full: out std_ulogic
  :port Almost_empty_thresh: Capacity level when almost empty
  :ptype Almost_empty_thresh: in natural
  :port Almost_full_thresh: Capacity level when almost full
  :ptype Almost_full_thresh: in natural
  :port Almost_empty: Almost empty flag
  :ptype Almost_empty: out std_ulogic
  :port Almost_full: Almost full flag
  :ptype Almost_full: out std_ulogic
