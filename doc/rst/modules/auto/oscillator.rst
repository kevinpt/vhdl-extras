.. Generated from ../rtl/extras/oscillator.vhdl on 2018-06-28 23:37:28.705068
.. vhdl:package:: extras.oscillator


Components
----------


fixed_oscillator
~~~~~~~~~~~~~~~~

.. symbolator::
  :name: oscillator-fixed_oscillator

  component fixed_oscillator is
  generic (
    SYS_CLOCK_FREQ : frequency;
    OUTPUT_FREQ : frequency;
    TOLERANCE : real;
    SIZE : positive;
    ITERATIONS : positive;
    MAGNITUDE : real;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    --# {{data|}}
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0);
    Angle : out signed(SIZE-1 downto 0);
    Synth_clock : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: fixed_oscillator

  Oscillator with a fixed frequency output.
  Samples are generated on every clock cycle.
  
  :generic SYS_CLOCK_FREQ: System clock frequency
  :gtype SYS_CLOCK_FREQ: frequency
  :generic OUTPUT_FREQ: Generated frequency
  :gtype OUTPUT_FREQ: frequency
  :generic TOLERANCE: Error tolerance
  :gtype TOLERANCE: real
  :generic SIZE: Width of operands
  :gtype SIZE: positive
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic MAGNITUDE: Scale factor for Sin and Cos
  :gtype MAGNITUDE: real
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Sin: Sine output
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: Cosine output
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: Phase angle in brads
  :ptype Angle: out signed(SIZE-1 downto 0)
  :port Synth_clock: Generated clock
  :ptype Synth_clock: out std_ulogic

fixed_oscillator_sequential
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: oscillator-fixed_oscillator_sequential

  component fixed_oscillator_sequential is
  generic (
    SYS_CLOCK_FREQ : frequency;
    OUTPUT_FREQ : frequency;
    TOLERANCE : real;
    SIZE : positive;
    ITERATIONS : positive;
    MAGNITUDE : real;
    CAPTURE_RESULT : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Result_valid : out std_ulogic;
    --# {{data|}}
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0);
    Angle : out signed(SIZE-1 downto 0);
    Synth_clock : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: fixed_oscillator_sequential

  Oscillator with a fixed frequency output.
  Samples are generated on after every ITERATIONS clock cycles.
  
  :generic SYS_CLOCK_FREQ: System clock frequency
  :gtype SYS_CLOCK_FREQ: frequency
  :generic OUTPUT_FREQ: Generated frequency
  :gtype OUTPUT_FREQ: frequency
  :generic TOLERANCE: Error tolerance
  :gtype TOLERANCE: real
  :generic SIZE: Width of operands
  :gtype SIZE: positive
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic MAGNITUDE: Scale factor for Sin and Cos
  :gtype MAGNITUDE: real
  :generic CAPTURE_RESULT: Register outputs when valid
  :gtype CAPTURE_RESULT: boolean
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Result_valid: New samples are ready
  :ptype Result_valid: out std_ulogic
  :port Sin: Sine output
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: Cosine output
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: Phase angle in brads
  :ptype Angle: out signed(SIZE-1 downto 0)
  :port Synth_clock: Generated clock
  :ptype Synth_clock: out std_ulogic

dynamic_oscillator
~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: oscillator-dynamic_oscillator

  component dynamic_oscillator is
  generic (
    SYS_CLOCK_FREQ : real;
    MIN_TGT_FREQ : natural;
    TOLERANCE : real;
    SIZE : natural;
    ITERATIONS : positive;
    MAGNITUDE : real;
    FREQ_SCALE : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Dyn_freq : in unsigned;
    --# {{data|}}
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0);
    Angle : out signed(SIZE-1 downto 0);
    Synth_clock : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: dynamic_oscillator

  
  :generic SYS_CLOCK_FREQ: System clock frequency
  :gtype SYS_CLOCK_FREQ: real
  :generic MIN_TGT_FREQ: Lowest supported output frequency
  :gtype MIN_TGT_FREQ: natural
  :generic TOLERANCE: Error tolerance
  :gtype TOLERANCE: real
  :generic SIZE: Width of operands
  :gtype SIZE: natural
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic MAGNITUDE: Scale factor for Sin and Cos magnitude
  :gtype MAGNITUDE: real
  :generic FREQ_SCALE: Scale factor for target frequency
  :gtype FREQ_SCALE: natural
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Dyn_freq: Dynamic frequency in FIXME
  :ptype Dyn_freq: in unsigned
  :port Sin: Sine output
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: Cosine output
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: Phase angle in brads
  :ptype Angle: out signed(SIZE-1 downto 0)
  :port Synth_clock: Generated clock
  :ptype Synth_clock: out std_ulogic

dynamic_oscillator_sequential
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: oscillator-dynamic_oscillator_sequential

  component dynamic_oscillator_sequential is
  generic (
    SYS_CLOCK_FREQ : real;
    MIN_TGT_FREQ : natural;
    TOLERANCE : real;
    SIZE : natural;
    ITERATIONS : positive;
    MAGNITUDE : real;
    FREQ_SCALE : natural;
    CAPTURE_RESULT : boolean;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Dyn_freq : in unsigned;
    --# {{data|}}
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0);
    Angle : out signed(SIZE-1 downto 0);
    Synth_clock : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: dynamic_oscillator_sequential

  
  :generic SYS_CLOCK_FREQ: System clock frequency
  :gtype SYS_CLOCK_FREQ: real
  :generic MIN_TGT_FREQ: Lowest supported output frequency
  :gtype MIN_TGT_FREQ: natural
  :generic TOLERANCE: Error tolerance
  :gtype TOLERANCE: real
  :generic SIZE: Width of operands
  :gtype SIZE: natural
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic MAGNITUDE: Scale factor for Sin and Cos magnitude
  :gtype MAGNITUDE: real
  :generic FREQ_SCALE: Scale factor for target frequency
  :gtype FREQ_SCALE: natural
  :generic CAPTURE_RESULT: Register outputs when valid
  :gtype CAPTURE_RESULT: boolean
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Dyn_freq: Dynamic frequency in FIXME
  :ptype Dyn_freq: in unsigned
  :port Sin: Sine output
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: Cosine output
  :ptype Cos: out signed(SIZE-1 downto 0)
  :port Angle: Phase angle in brads
  :ptype Angle: out signed(SIZE-1 downto 0)
  :port Synth_clock: Generated clock
  :ptype Synth_clock: out std_ulogic
