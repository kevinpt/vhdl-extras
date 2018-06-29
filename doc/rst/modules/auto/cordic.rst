.. Generated from ../rtl/extras/cordic.vhdl on 2018-06-28 23:37:28.609517
.. vhdl:package:: extras.cordic


Types
-----


.. vhdl:type:: cordic_mode

  Rotation or vector mode selection.

Components
----------


cordic_pipelined
~~~~~~~~~~~~~~~~

.. symbolator::
  :name: cordic-cordic_pipelined

  component cordic_pipelined is
  generic (
    SIZE : positive;
    ITERATIONS : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Mode : in cordic_mode;
    --# {{data|}}
    X : in signed(SIZE-1 downto 0);
    Y : in signed(SIZE-1 downto 0);
    Z : in signed(SIZE-1 downto 0);
    X_result : out signed(SIZE-1 downto 0);
    Y_result : out signed(SIZE-1 downto 0);
    Z_result : out signed(SIZE-1 downto 0)
  );
  end component;

|


.. vhdl:entity:: cordic_pipelined

  CORDIC with pipeline registers between each stage.
  
  :generic SIZE: Width of operands
  :gtype SIZE: positive
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Mode: Rotation or vector mode selection
  :ptype Mode: in cordic_mode
  :port X: X coordinate
  :ptype X: in signed(SIZE-1 downto 0)
  :port Y: Y coordinate
  :ptype Y: in signed(SIZE-1 downto 0)
  :port Z: Z coordinate (angle in brads)
  :ptype Z: in signed(SIZE-1 downto 0)
  :port X_result: X result
  :ptype X_result: out signed(SIZE-1 downto 0)
  :port Y_result: Y result
  :ptype Y_result: out signed(SIZE-1 downto 0)
  :port Z_result: Z result
  :ptype Z_result: out signed(SIZE-1 downto 0)

cordic_sequential
~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: cordic-cordic_sequential

  component cordic_sequential is
  generic (
    SIZE : positive;
    ITERATIONS : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Data_valid : in std_ulogic;
    Busy : out std_ulogic;
    Result_valid : out std_ulogic;
    Mode : in cordic_mode;
    --# {{data|}}
    X : in signed(SIZE-1 downto 0);
    Y : in signed(SIZE-1 downto 0);
    Z : in signed(SIZE-1 downto 0);
    X_result : out signed(SIZE-1 downto 0);
    Y_result : out signed(SIZE-1 downto 0);
    Z_result : out signed(SIZE-1 downto 0)
  );
  end component;

|


.. vhdl:entity:: cordic_sequential

  CORDIC with a single stage applied iteratively.
  
  :generic SIZE: Width of operands
  :gtype SIZE: positive
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Data_valid: Load new input data
  :ptype Data_valid: in std_ulogic
  :port Busy: Generating new result
  :ptype Busy: out std_ulogic
  :port Result_valid: Flag when result is valid
  :ptype Result_valid: out std_ulogic
  :port Mode: Rotation or vector mode selection
  :ptype Mode: in cordic_mode
  :port X: X coordinate
  :ptype X: in signed(SIZE-1 downto 0)
  :port Y: Y coordinate
  :ptype Y: in signed(SIZE-1 downto 0)
  :port Z: Z coordinate (angle in brads)
  :ptype Z: in signed(SIZE-1 downto 0)
  :port X_result: X result
  :ptype X_result: out signed(SIZE-1 downto 0)
  :port Y_result: Y result
  :ptype Y_result: out signed(SIZE-1 downto 0)
  :port Z_result: Z result
  :ptype Z_result: out signed(SIZE-1 downto 0)

cordic_flex_pipelined
~~~~~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: cordic-cordic_flex_pipelined

  component cordic_flex_pipelined is
  generic (
    SIZE : positive;
    ITERATIONS : positive;
    PIPELINE_STAGES : natural;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Mode : in cordic_mode;
    --# {{data|}}
    X : in signed(SIZE-1 downto 0);
    Y : in signed(SIZE-1 downto 0);
    Z : in signed(SIZE-1 downto 0);
    X_result : out signed(SIZE-1 downto 0);
    Y_result : out signed(SIZE-1 downto 0);
    Z_result : out signed(SIZE-1 downto 0)
  );
  end component;

|


.. vhdl:entity:: cordic_flex_pipelined

  CORDIC with pipelining implemented with register retiming.
  This variant can be used to have more or fewer pipeline stages than
  the number of iterations to fine tune performance and resource usage.
  
  :generic SIZE: Width of operands
  :gtype SIZE: positive
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic PIPELINE_STAGES: Number of register stages
  :gtype PIPELINE_STAGES: natural
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Mode: Rotation or vector mode selection
  :ptype Mode: in cordic_mode
  :port X: X coordinate
  :ptype X: in signed(SIZE-1 downto 0)
  :port Y: Y coordinate
  :ptype Y: in signed(SIZE-1 downto 0)
  :port Z: Z coordinate (angle in brads)
  :ptype Z: in signed(SIZE-1 downto 0)
  :port X_result: X result
  :ptype X_result: out signed(SIZE-1 downto 0)
  :port Y_result: Y result
  :ptype Y_result: out signed(SIZE-1 downto 0)
  :port Z_result: Z result
  :ptype Z_result: out signed(SIZE-1 downto 0)

sincos_pipelined
~~~~~~~~~~~~~~~~

.. symbolator::
  :name: cordic-sincos_pipelined

  component sincos_pipelined is
  generic (
    SIZE : positive;
    ITERATIONS : positive;
    FRAC_BITS : positive;
    MAGNITUDE : real;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Angle : in signed(SIZE-1 downto 0);
    --# {{data|}}
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0)
  );
  end component;

|


.. vhdl:entity:: sincos_pipelined

  Compute Sine and Cosine with a pipelined CORDIC implementation.
  
  :generic SIZE: Width of operands
  :gtype SIZE: positive
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic FRAC_BITS: Total fractional bits
  :gtype FRAC_BITS: positive
  :generic MAGNITUDE: Scale factor for vector length
  :gtype MAGNITUDE: real
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Angle: Angle in brads (2**SIZE brads = 2*pi radians)
  :ptype Angle: in signed(SIZE-1 downto 0)
  :port Sin: Sine of Angle
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: Cosine of Angle
  :ptype Cos: out signed(SIZE-1 downto 0)

sincos_sequential
~~~~~~~~~~~~~~~~~

.. symbolator::
  :name: cordic-sincos_sequential

  component sincos_sequential is
  generic (
    SIZE : positive;
    ITERATIONS : positive;
    FRAC_BITS : positive;
    MAGNITUDE : real;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Data_valid : in std_ulogic;
    Busy : out std_ulogic;
    Result_valid : out std_ulogic;
    Angle : in signed(SIZE-1 downto 0);
    --# {{data|}}
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0)
  );
  end component;

|


.. vhdl:entity:: sincos_sequential

  Compute Sine and Cosine with a sequential CORDIC implementation.
  
  :generic SIZE: Width of operands
  :gtype SIZE: positive
  :generic ITERATIONS: Number of iterations for CORDIC algorithm
  :gtype ITERATIONS: positive
  :generic FRAC_BITS: Total fractional bits
  :gtype FRAC_BITS: positive
  :generic MAGNITUDE: Scale factor for vector length
  :gtype MAGNITUDE: real
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Data_valid: Load new input data
  :ptype Data_valid: in std_ulogic
  :port Busy: Generating new result
  :ptype Busy: out std_ulogic
  :port Result_valid: Flag when result is valid
  :ptype Result_valid: out std_ulogic
  :port Angle: Angle in brads (2**SIZE brads = 2*pi radians)
  :ptype Angle: in signed(SIZE-1 downto 0)
  :port Sin: Sine of Angle
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: Cosine of Angle
  :ptype Cos: out signed(SIZE-1 downto 0)

Subprograms
-----------


.. vhdl:function:: function cordic_gain(Iterations : positive) return real;

   Compute vector length gain after applying CORDIC.
  
  :param Iterations: Number of iterations
  :type Iterations: positive
  :returns: Gain factor.
  


.. vhdl:procedure:: procedure adjust_angle(X : in signed; Y : in signed; Z : in signed; Xa : out signed; Ya : out signed; Za : out signed);

   Correct angle so that it lies in quadrant 1 or 4.
  
  :param X: X coordinate
  :type X: in signed
  :param Y: Y coordinate
  :type Y: in signed
  :param Z: Z coordinate (angle)
  :type Z: in signed
  :param Xa: Adjusted X coordinate
  :type Xa: out signed
  :param Ya: Adjusted Y coordinate
  :type Ya: out signed
  :param Za: Adjusted Z coordinate (angle)
  :type Za: out signed


.. vhdl:procedure:: procedure rotate(iterations : in integer; X : in signed; Y : in signed; Z : in signed; Xr : out signed; Yr : out signed; Zr : out signed);

   Apply a single iteration of CORDIC rotation mode.
  
  :param X: X coordinate
  :type X: in signed
  :param Y: Y coordinate
  :type Y: in signed
  :param Z: Z coordinate (angle)
  :type Z: in signed
  :param Xr: Rotated X coordinate
  :type Xr: out signed
  :param Yr: Rotated Y coordinate
  :type Yr: out signed
  :param Zr: Rotated Z coordinate (angle)
  :type Zr: out signed


.. vhdl:procedure:: procedure vector(iterations : in integer; X : in signed; Y : in signed; Z : in signed; Xr : out signed; Yr : out signed; Zr : out signed);

   Apply a single iteration of CORDIC vector mode.
  
  :param X: X coordinate
  :type X: in signed
  :param Y: Y coordinate
  :type Y: in signed
  :param Z: Z coordinate (angle)
  :type Z: in signed
  :param Xr: Vectored X coordinate
  :type Xr: out signed
  :param Yr: Vectored Y coordinate
  :type Yr: out signed
  :param Zr: Vectored Z coordinate (angle)
  :type Zr: out signed


.. vhdl:function:: function effective_fractional_bits(Iterations : positive; Frac_bits : positive) return real;

   Compute the number of usable fractional bits in CORDIC result.
  
  :param Iterations: Number of CORDIC iterations
  :type Iterations: positive
  :param Frac_bits: Fractional bits in the input coordinates
  :type Frac_bits: positive
  :returns: Effective number of fractional bits.
  

