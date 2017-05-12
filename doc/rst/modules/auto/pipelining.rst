.. Generated from ../rtl/extras/pipelining.vhdl on 2017-05-07 22:53:56.132683
.. vhdl:package:: pipelining


Components
----------


pipeline_ul
~~~~~~~~~~~

.. symbolator::

  component pipeline_ul is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Sig_in : in std_ulogic;
    Sig_out : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: pipeline_ul

  Pipeline registers for std_ulogic and std_logic.


  :generic PIPELINE_STAGES:  Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING:  Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL:  Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock:  System clock
  :ptype Clock: in std_ulogic
  :port Reset:  Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in:  Signal from block to be pipelined
  :ptype Sig_in: in std_ulogic
  :port Sig_out:  Pipelined result
  :ptype Sig_out: out std_ulogic

pipeline_sulv
~~~~~~~~~~~~~

.. symbolator::

  component pipeline_sulv is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Sig_in : in std_ulogic_vector;
    Sig_out : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: pipeline_sulv

  Pipeline registers for std_ulogic_vector.


  :generic PIPELINE_STAGES:  Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING:  Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL:  Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock:  System clock
  :ptype Clock: in std_ulogic
  :port Reset:  Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in:  Signal from block to be pipelined
  :ptype Sig_in: in std_ulogic_vector
  :port Sig_out:  Pipelined result
  :ptype Sig_out: out std_ulogic_vector

pipeline_slv
~~~~~~~~~~~~

.. symbolator::

  component pipeline_slv is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Sig_in : in std_logic_vector;
    Sig_out : out std_logic_vector
  );
  end component;

|


.. vhdl:entity:: pipeline_slv

  Pipeline registers for std_logic_vector.


  :generic PIPELINE_STAGES:  Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING:  Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL:  Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock:  System clock
  :ptype Clock: in std_ulogic
  :port Reset:  Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in:  Signal from block to be pipelined
  :ptype Sig_in: in std_logic_vector
  :port Sig_out:  Pipelined result
  :ptype Sig_out: out std_logic_vector

pipeline_u
~~~~~~~~~~

.. symbolator::

  component pipeline_u is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Sig_in : in unsigned;
    Sig_out : out unsigned
  );
  end component;

|


.. vhdl:entity:: pipeline_u

  Pipeline registers for unsigned.


  :generic PIPELINE_STAGES:  Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING:  Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL:  Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock:  System clock
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Sig_in:  Signal from block to be pipelined
  :ptype Sig_in: in unsigned
  :port Sig_out:  Pipelined result
  :ptype Sig_out: out unsigned

pipeline_s
~~~~~~~~~~

.. symbolator::

  component pipeline_s is
  generic (
    PIPELINE_STAGES : positive;
    ATTR_REG_BALANCING : string;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Sig_in : in signed;
    Sig_out : out signed
  );
  end component;

|


.. vhdl:entity:: pipeline_s

  Pipeline registers for signed.


  :generic PIPELINE_STAGES:  Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING:  Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL:  Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock:  System clock
  :ptype Clock: in std_ulogic
  :port Reset:  Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in:  Signal from block to be pipelined
  :ptype Sig_in: in signed
  :port Sig_out:  Pipelined result
  :ptype Sig_out: out signed
