.. Generated from ../rtl/extras/synchronizing.vhdl on 2018-06-28 23:37:28.909058
.. vhdl:package:: extras.synchronizing


Components
----------


bit_synchronizer
~~~~~~~~~~~~~~~~

.. symbolator::
  :name: synchronizing-bit_synchronizer

  component bit_synchronizer is
  generic (
    STAGES : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Bit_in : in std_ulogic;
    Sync : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: bit_synchronizer

  A basic synchronizer with a configurable number of stages.
  The ``Sync`` output is synchronized to the ``Clock`` domain.
  
  :generic STAGES: Number of flip-flops in the synchronizer
  :gtype STAGES: natural
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Bit_in: Unsynchronized signal
  :ptype Bit_in: in std_ulogic
  :port Sync: Synchronized to Clock's domain
  :ptype Sync: out std_ulogic

reset_synchronizer
~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: synchronizing-reset_synchronizer

  component reset_synchronizer is
  generic (
    STAGES : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Sync_reset : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: reset_synchronizer

  Synchronizer for generating a synchronized reset.
  The deactivating edge transition for the ``Sync_reset`` output
  is synchronized to the ``Clock`` domain. Its activating edge remains asynchronous.
  
  :generic STAGES: Number of flip-flops in the synchronizer
  :gtype STAGES: natural
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sync_reset: Synchronized reset
  :ptype Sync_reset: out std_ulogic

handshake_synchronizer
~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: synchronizing-handshake_synchronizer

  component handshake_synchronizer is
  generic (
    STAGES : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock_tx : in std_ulogic;
    Reset_tx : in std_ulogic;
    Clock_rx : in std_ulogic;
    Reset_rx : in std_ulogic;
    --# {{data|Send port}}
    Tx_data : in std_ulogic_vector;
    Send_data : in std_ulogic;
    Sending : out std_ulogic;
    Data_sent : out std_ulogic;
    --# {{Receive port}}
    Rx_data : out std_ulogic_vector;
    New_data : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: handshake_synchronizer

  A handshaking synchronizer for sending an array between clock domains.
  This uses the four-phase handshake protocol.
  
  :generic STAGES: Number of flip-flops in the synchronizer
  :gtype STAGES: natural
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock_tx: Transmitting domain clock
  :ptype Clock_tx: in std_ulogic
  :port Reset_tx: Asynchronous reset for Clock_tx
  :ptype Reset_tx: in std_ulogic
  :port Clock_rx: Receiving domain clock
  :ptype Clock_rx: in std_ulogic
  :port Reset_rx: Asynchronous reset for Clock_rx
  :ptype Reset_rx: in std_ulogic
  :port Tx_data: Data to send
  :ptype Tx_data: in std_ulogic_vector
  :port Send_data: Control signal to send new data
  :ptype Send_data: in std_ulogic
  :port Sending: Active while TX is in process
  :ptype Sending: out std_ulogic
  :port Data_sent: Flag to indicate TX completion
  :ptype Data_sent: out std_ulogic
  :port Rx_data: Data received in clock_rx domain
  :ptype Rx_data: out std_ulogic_vector
  :port New_data: Flag to indicate new data
  :ptype New_data: out std_ulogic
