.. Generated from ../rtl/extras/fifos.vhdl on 2017-04-20 23:04:36.993671
.. vhdl:package:: fifos


Components
----------


simple_fifo
~~~~~~~~~~~

.. symbolator::

  component simple_fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    We : in std_ulogic;
    Wr_data : in std_ulogic_vector;
    Re : in std_ulogic;
    Rd_data : out std_ulogic_vector;
    Empty : out std_ulogic;
    Full : out std_ulogic;
    Almost_empty_thresh : in natural;
    Almost_full_thresh : in natural;
    Almost_empty : out std_ulogic;
    Almost_full : out std_ulogic
  );
  end component;

|


|


.. vhdl:entity:: simple_fifo

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic MEM_SIZE: 
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: 
  :gtype SYNC_READ: boolean
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port We: 
  :ptype We: in std_ulogic
  :port Wr_data: 
  :ptype Wr_data: in std_ulogic_vector
  :port Re: 
  :ptype Re: in std_ulogic
  :port Rd_data: 
  :ptype Rd_data: out std_ulogic_vector
  :port Empty: 
  :ptype Empty: out std_ulogic
  :port Full: 
  :ptype Full: out std_ulogic
  :port Almost_empty_thresh: 
  :ptype Almost_empty_thresh: in natural
  :port Almost_full_thresh: 
  :ptype Almost_full_thresh: in natural
  :port Almost_empty: 
  :ptype Almost_empty: out std_ulogic
  :port Almost_full: 
  :ptype Almost_full: out std_ulogic

fifo
~~~~

.. symbolator::

  component fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    Wr_clock : in std_ulogic;
    Wr_reset : in std_ulogic;
    We : in std_ulogic;
    Wr_data : in std_ulogic_vector;
    Rd_clock : in std_ulogic;
    Rd_reset : in std_ulogic;
    Re : in std_ulogic;
    Rd_data : out std_ulogic_vector;
    Empty : out std_ulogic;
    Full : out std_ulogic;
    Almost_empty_thresh : in natural;
    Almost_full_thresh : in natural;
    Almost_empty : out std_ulogic;
    Almost_full : out std_ulogic
  );
  end component;

|


|


.. vhdl:entity:: fifo

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic MEM_SIZE: 
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: 
  :gtype SYNC_READ: boolean
  :port Wr_clock: 
  :ptype Wr_clock: in std_ulogic
  :port Wr_reset: 
  :ptype Wr_reset: in std_ulogic
  :port We: 
  :ptype We: in std_ulogic
  :port Wr_data: 
  :ptype Wr_data: in std_ulogic_vector
  :port Rd_clock: 
  :ptype Rd_clock: in std_ulogic
  :port Rd_reset: 
  :ptype Rd_reset: in std_ulogic
  :port Re: 
  :ptype Re: in std_ulogic
  :port Rd_data: 
  :ptype Rd_data: out std_ulogic_vector
  :port Empty: 
  :ptype Empty: out std_ulogic
  :port Full: 
  :ptype Full: out std_ulogic
  :port Almost_empty_thresh: 
  :ptype Almost_empty_thresh: in natural
  :port Almost_full_thresh: 
  :ptype Almost_full_thresh: in natural
  :port Almost_empty: 
  :ptype Almost_empty: out std_ulogic
  :port Almost_full: 
  :ptype Almost_full: out std_ulogic

packet_fifo
~~~~~~~~~~~

.. symbolator::

  component packet_fifo is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    MEM_SIZE : positive;
    SYNC_READ : boolean
  );
  port (
    Wr_clock : in std_ulogic;
    Wr_reset : in std_ulogic;
    We : in std_ulogic;
    Wr_data : in std_ulogic_vector;
    Keep : in std_ulogic;
    Discard : in std_ulogic;
    Rd_clock : in std_ulogic;
    Rd_reset : in std_ulogic;
    Re : in std_ulogic;
    Rd_data : out std_ulogic_vector;
    Empty : out std_ulogic;
    Full : out std_ulogic;
    Almost_empty_thresh : in natural;
    Almost_full_thresh : in natural;
    Almost_empty : out std_ulogic;
    Almost_full : out std_ulogic
  );
  end component;

|


|


.. vhdl:entity:: packet_fifo

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic MEM_SIZE: 
  :gtype MEM_SIZE: positive
  :generic SYNC_READ: 
  :gtype SYNC_READ: boolean
  :port Wr_clock: 
  :ptype Wr_clock: in std_ulogic
  :port Wr_reset: 
  :ptype Wr_reset: in std_ulogic
  :port We: 
  :ptype We: in std_ulogic
  :port Wr_data: 
  :ptype Wr_data: in std_ulogic_vector
  :port Keep: 
  :ptype Keep: in std_ulogic
  :port Discard: 
  :ptype Discard: in std_ulogic
  :port Rd_clock: 
  :ptype Rd_clock: in std_ulogic
  :port Rd_reset: 
  :ptype Rd_reset: in std_ulogic
  :port Re: 
  :ptype Re: in std_ulogic
  :port Rd_data: 
  :ptype Rd_data: out std_ulogic_vector
  :port Empty: 
  :ptype Empty: out std_ulogic
  :port Full: 
  :ptype Full: out std_ulogic
  :port Almost_empty_thresh: 
  :ptype Almost_empty_thresh: in natural
  :port Almost_full_thresh: 
  :ptype Almost_full_thresh: in natural
  :port Almost_empty: 
  :ptype Almost_empty: out std_ulogic
  :port Almost_full: 
  :ptype Almost_full: out std_ulogic
