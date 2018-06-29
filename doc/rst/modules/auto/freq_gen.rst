.. Generated from ../rtl/extras/freq_gen.vhdl on 2017-08-02 00:26:37.695316
.. vhdl:package:: extras.freq_gen_pkg


Components
----------


dynamic_oscillator_sequential
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: freq_gen_pkg-dynamic_oscillator_sequential

  component dynamic_oscillator_sequential is
  generic (
    SYS_CLOCK_FREQ : real;
    MIN_TGT_FREQ : natural;
    TOLERANCE : real;
    SIZE : natural;
    ITERATIONS : positive;
    MAGNITUDE : real;
    CAPTURE_RESULT : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Dyn_freq : in unsigned;
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0);
    Angle : out signed(SIZE-1 downto 0);
    Synth_clock : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: dynamic_oscillator_sequential

  
  :generic SYS_CLOCK_FREQ:
  :gtype SYS_CLOCK_FREQ: real
  :generic MIN_TGT_FREQ:
  :gtype MIN_TGT_FREQ: natural
  :generic TOLERANCE:
  :gtype TOLERANCE: real
  :generic SIZE:
  :gtype SIZE: natural
  :generic ITERATIONS:
  :gtype ITERATIONS: positive
  :generic MAGNITUDE:
  :gtype MAGNITUDE: real
  :generic CAPTURE_RESULT:
  :gtype CAPTURE_RESULT: boolean
  :generic RESET_ACTIVE_LEVEL:
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: None
  :ptype Clock: in std_ulogic
  :port Reset: None
  :ptype Reset: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Dyn_freq: None
  :ptype Dyn_freq: in unsigned
  :port Sin: None
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: None
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: None
  :ptype Angle: out signed(SIZE-1 downto 0)
  :port Synth_clock: None
  :ptype Synth_clock: out std_ulogic

freq_gen_pipelined
~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: freq_gen_pkg-freq_gen_pipelined

  component freq_gen_pipelined is
  generic (
    SYS_FREQ : real;
    DDFS_TOL : real;
    SIZE : natural;
    MIN_TGT_FREQ : natural;
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


.. vhdl:entity:: freq_gen_pipelined

  
  :generic SYS_FREQ:
  :gtype SYS_FREQ: real
  :generic DDFS_TOL:
  :gtype DDFS_TOL: real
  :generic SIZE:
  :gtype SIZE: natural
  :generic MIN_TGT_FREQ:
  :gtype MIN_TGT_FREQ: natural
  :generic FREQ_SCALE:
  :gtype FREQ_SCALE: natural
  :generic MAGNITUDE:
  :gtype MAGNITUDE: real
  :generic ITERATIONS:
  :gtype ITERATIONS: positive
  
  :port Clock: None
  :ptype Clock: in std_ulogic
  :port Reset: None
  :ptype Reset: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Dyn_freq: None
  :ptype Dyn_freq: in unsigned
  :port Sin: None
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: None
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: None
  :ptype Angle: out signed(SIZE-1 downto 0)
