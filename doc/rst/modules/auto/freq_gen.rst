.. Generated from ../rtl/extras/freq_gen.vhdl on 2017-04-20 23:04:36.936968
.. vhdl:package:: freq_gen_pkg


Components
----------


freq_gen
~~~~~~~~

.. symbolator::

  component freq_gen is
  generic (
    SYS_FREQ : real;
    DDFS_TOL : real;
    SIZE : natural;
    MIN_TGT_FREQ : natural;
    MAX_TGT_FREQ : natural;
    FREQ_SCALE : natural;
    MAGNITUDE : real;
    ITERATIONS : positive
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Dyn_freq : in unsigned;
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0);
    Angle : out signed(SIZE-1 downto 0)
  );
  end component;

|


|


.. vhdl:entity:: freq_gen

  :generic SYS_FREQ: 
  :gtype SYS_FREQ: real
  :generic DDFS_TOL: 
  :gtype DDFS_TOL: real
  :generic SIZE: 
  :gtype SIZE: natural
  :generic MIN_TGT_FREQ: 
  :gtype MIN_TGT_FREQ: natural
  :generic MAX_TGT_FREQ: 
  :gtype MAX_TGT_FREQ: natural
  :generic FREQ_SCALE: 
  :gtype FREQ_SCALE: natural
  :generic MAGNITUDE: 
  :gtype MAGNITUDE: real
  :generic ITERATIONS: 
  :gtype ITERATIONS: positive
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Load_phase: 
  :ptype Load_phase: in std_ulogic
  :port New_phase: 
  :ptype New_phase: in unsigned
  :port Dyn_freq: 
  :ptype Dyn_freq: in unsigned
  :port Sin: 
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: 
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: 
  :ptype Angle: out signed(SIZE-1 downto 0)

freq_gen_pipelined
~~~~~~~~~~~~~~~~~~

.. symbolator::

  component freq_gen_pipelined is
  generic (
    SYS_FREQ : real;
    DDFS_TOL : real;
    SIZE : natural;
    MIN_TGT_FREQ : natural;
    MAX_TGT_FREQ : natural;
    FREQ_SCALE : natural;
    MAGNITUDE : real;
    ITERATIONS : positive
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Dyn_freq : in unsigned;
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0);
    Angle : out signed(SIZE-1 downto 0)
  );
  end component;

|


|


.. vhdl:entity:: freq_gen_pipelined

  :generic SYS_FREQ: 
  :gtype SYS_FREQ: real
  :generic DDFS_TOL: 
  :gtype DDFS_TOL: real
  :generic SIZE: 
  :gtype SIZE: natural
  :generic MIN_TGT_FREQ: 
  :gtype MIN_TGT_FREQ: natural
  :generic MAX_TGT_FREQ: 
  :gtype MAX_TGT_FREQ: natural
  :generic FREQ_SCALE: 
  :gtype FREQ_SCALE: natural
  :generic MAGNITUDE: 
  :gtype MAGNITUDE: real
  :generic ITERATIONS: 
  :gtype ITERATIONS: positive
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Load_phase: 
  :ptype Load_phase: in std_ulogic
  :port New_phase: 
  :ptype New_phase: in unsigned
  :port Dyn_freq: 
  :ptype Dyn_freq: in unsigned
  :port Sin: 
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: 
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: 
  :ptype Angle: out signed(SIZE-1 downto 0)
