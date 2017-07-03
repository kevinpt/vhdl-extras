.. Generated from ../rtl/extras/pipelining.vhdl on 2017-07-02 23:54:30.209108
.. vhdl:package:: extras.pipelining


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
  
  :generic PIPELINE_STAGES: Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING: Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in: Signal from block to be pipelined
  :ptype Sig_in: in std_ulogic
  :port Sig_out: Pipelined result
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
  
  :generic PIPELINE_STAGES: Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING: Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in: Signal from block to be pipelined
  :ptype Sig_in: in std_ulogic_vector
  :port Sig_out: Pipelined result
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
  
  :generic PIPELINE_STAGES: Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING: Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in: Signal from block to be pipelined
  :ptype Sig_in: in std_logic_vector
  :port Sig_out: Pipelined result
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
  
  :generic PIPELINE_STAGES: Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING: Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: None
  :ptype Reset: in std_ulogic
  :port Sig_in: Signal from block to be pipelined
  :ptype Sig_in: in unsigned
  :port Sig_out: Pipelined result
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
  
  :generic PIPELINE_STAGES: Number of pipeline stages to insert
  :gtype PIPELINE_STAGES: positive
  :generic ATTR_REG_BALANCING: Control propagation direction (Xilinx only)
  :gtype ATTR_REG_BALANCING: string
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Sig_in: Signal from block to be pipelined
  :ptype Sig_in: in signed
  :port Sig_out: Pipelined result
  :ptype Sig_out: out signed

fixed_delay_line
~~~~~~~~~~~~~~~~

.. symbolator::

  component fixed_delay_line is
  generic (
    STAGES : natural
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    --# {{data|}}
    Data_in : in std_ulogic;
    Data_out : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: fixed_delay_line

  Fixed delay line for std_ulogic data.
  
  :generic STAGES: Number of delay stages (0 for short circuit)
  :gtype STAGES: natural
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Data_in: Input data
  :ptype Data_in: in std_ulogic
  :port Data_out: Delayed output data
  :ptype Data_out: out std_ulogic

fixed_delay_line_sulv
~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component fixed_delay_line_sulv is
  generic (
    STAGES : natural
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    --# {{data|}}
    Data_in : in std_ulogic_vector;
    Data_out : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: fixed_delay_line_sulv

  Fixed delay line for std_ulogic_vector data.
  
  :generic STAGES: Number of delay stages (0 for short circuit)
  :gtype STAGES: natural
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Data_in: Input data
  :ptype Data_in: in std_ulogic_vector
  :port Data_out: Delayed output data
  :ptype Data_out: out std_ulogic_vector

fixed_delay_line_signed
~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component fixed_delay_line_signed is
  generic (
    STAGES : natural
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    --# {{data|}}
    Data_in : in signed;
    Data_out : out signed
  );
  end component;

|


.. vhdl:entity:: fixed_delay_line_signed

  Fixed delay line for signed data.
  
  :generic STAGES: Number of delay stages (0 for short circuit)
  :gtype STAGES: natural
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Data_in: Input data
  :ptype Data_in: in signed
  :port Data_out: Delayed output data
  :ptype Data_out: out signed

fixed_delay_line_unsigned
~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component fixed_delay_line_unsigned is
  generic (
    STAGES : natural
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    --# {{data|}}
    Data_in : in unsigned;
    Data_out : out unsigned
  );
  end component;

|


.. vhdl:entity:: fixed_delay_line_unsigned

  Fixed delay line for unsigned data.
  
  :generic STAGES: Number of delay stages (0 for short circuit)
  :gtype STAGES: natural
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Data_in: Input data
  :ptype Data_in: in unsigned
  :port Data_out: Delayed output data
  :ptype Data_out: out unsigned

dynamic_delay_line_sulv
~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component dynamic_delay_line_sulv is
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    Address : in unsigned;
    --# {{data|}}
    Data_in : in std_ulogic_vector;
    Data_out : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: dynamic_delay_line_sulv

  Fixed delay line for std_ulogic_vector data.
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Address: Selected delay stage
  :ptype Address: in unsigned
  :port Data_in: Input data
  :ptype Data_in: in std_ulogic_vector
  :port Data_out: Delayed output data
  :ptype Data_out: out std_ulogic_vector

dynamic_delay_line_signed
~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component dynamic_delay_line_signed is
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    Address : in unsigned;
    --# {{data|}}
    Data_in : in signed;
    Data_out : out signed
  );
  end component;

|


.. vhdl:entity:: dynamic_delay_line_signed

  Fixed delay line for signed data.
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Address: Selected delay stage
  :ptype Address: in unsigned
  :port Data_in: Input data
  :ptype Data_in: in signed
  :port Data_out: Delayed output data
  :ptype Data_out: out signed

dynamic_delay_line_unsigned
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

  component dynamic_delay_line_unsigned is
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    Address : in unsigned;
    --# {{data|}}
    Data_in : in unsigned;
    Data_out : out unsigned
  );
  end component;

|


.. vhdl:entity:: dynamic_delay_line_unsigned

  Fixed delay line for unsigned data.
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Address: Selected delay stage
  :ptype Address: in unsigned
  :port Data_in: Input data
  :ptype Data_in: in unsigned
  :port Data_out: Delayed output data
  :ptype Data_out: out unsigned
