.. Generated from ../rtl/extras/cordic.vhdl on 2017-04-20 23:04:37.052225
.. vhdl:package:: cordic


Types
-----


.. vhdl:type:: cordic_mode


Components
----------


cordic_pipelined
~~~~~~~~~~~~~~~~

.. symbolator::

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


|


.. vhdl:entity:: cordic_pipelined

  :generic SIZE: 
  :gtype SIZE: positive
  :generic ITERATIONS: 
  :gtype ITERATIONS: positive
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Mode: 
  :ptype Mode: in cordic_mode
  :port X: 
  :ptype X: in signed(SIZE-1 downto 0)
  :port Y: 
  :ptype Y: in signed(SIZE-1 downto 0)
  :port Z: 
  :ptype Z: in signed(SIZE-1 downto 0)
  :port X_result: 
  :ptype X_result: out signed(SIZE-1 downto 0)
  :port Y_result: 
  :ptype Y_result: out signed(SIZE-1 downto 0)
  :port Z_result: 
  :ptype Z_result: out signed(SIZE-1 downto 0)

cordic_sequential
~~~~~~~~~~~~~~~~~

.. symbolator::

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
    Load : in std_ulogic;
    Done : out std_ulogic;
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


|


.. vhdl:entity:: cordic_sequential

  :generic SIZE: 
  :gtype SIZE: positive
  :generic ITERATIONS: 
  :gtype ITERATIONS: positive
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Load: 
  :ptype Load: in std_ulogic
  :port Done: 
  :ptype Done: out std_ulogic
  :port Mode: 
  :ptype Mode: in cordic_mode
  :port X: 
  :ptype X: in signed(SIZE-1 downto 0)
  :port Y: 
  :ptype Y: in signed(SIZE-1 downto 0)
  :port Z: 
  :ptype Z: in signed(SIZE-1 downto 0)
  :port X_result: 
  :ptype X_result: out signed(SIZE-1 downto 0)
  :port Y_result: 
  :ptype Y_result: out signed(SIZE-1 downto 0)
  :port Z_result: 
  :ptype Z_result: out signed(SIZE-1 downto 0)

cordic_flex_pipelined
~~~~~~~~~~~~~~~~~~~~~

.. symbolator::

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


|


.. vhdl:entity:: cordic_flex_pipelined

  :generic SIZE: 
  :gtype SIZE: positive
  :generic ITERATIONS: 
  :gtype ITERATIONS: positive
  :generic PIPELINE_STAGES: 
  :gtype PIPELINE_STAGES: natural
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Mode: 
  :ptype Mode: in cordic_mode
  :port X: 
  :ptype X: in signed(SIZE-1 downto 0)
  :port Y: 
  :ptype Y: in signed(SIZE-1 downto 0)
  :port Z: 
  :ptype Z: in signed(SIZE-1 downto 0)
  :port X_result: 
  :ptype X_result: out signed(SIZE-1 downto 0)
  :port Y_result: 
  :ptype Y_result: out signed(SIZE-1 downto 0)
  :port Z_result: 
  :ptype Z_result: out signed(SIZE-1 downto 0)

sincos_pipelined
~~~~~~~~~~~~~~~~

.. symbolator::

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


|


.. vhdl:entity:: sincos_pipelined

  :generic SIZE: 
  :gtype SIZE: positive
  :generic ITERATIONS: 
  :gtype ITERATIONS: positive
  :generic FRAC_BITS: 
  :gtype FRAC_BITS: positive
  :generic MAGNITUDE: 
  :gtype MAGNITUDE: real
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Angle: 
  :ptype Angle: in signed(SIZE-1 downto 0)
  :port Sin: 
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: 
  :ptype Cos: out signed(SIZE-1 downto 0)

sincos_sequential
~~~~~~~~~~~~~~~~~

.. symbolator::

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
    Load : in std_ulogic;
    Done : out std_ulogic;
    Angle : in signed(SIZE-1 downto 0);
    --# {{data|}}
    Sin : out signed(SIZE-1 downto 0);
    Cos : out signed(SIZE-1 downto 0)
  );
  end component;

|


|


.. vhdl:entity:: sincos_sequential

  :generic SIZE: 
  :gtype SIZE: positive
  :generic ITERATIONS: 
  :gtype ITERATIONS: positive
  :generic FRAC_BITS: 
  :gtype FRAC_BITS: positive
  :generic MAGNITUDE: 
  :gtype MAGNITUDE: real
  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Load: 
  :ptype Load: in std_ulogic
  :port Done: 
  :ptype Done: out std_ulogic
  :port Angle: 
  :ptype Angle: in signed(SIZE-1 downto 0)
  :port Sin: 
  :ptype Sin: out signed(SIZE-1 downto 0)
  :port Cos: 
  :ptype Cos: out signed(SIZE-1 downto 0)

Subprograms
-----------


.. vhdl:function:: function cordic_gain(iterations : positive) return real;

  :param iterations: 
  :type iterations: positive


.. vhdl:procedure:: procedure adjust_angle(x : in signed; y : in signed; z : in signed; xa : out signed; ya : out signed; za : out signed);

  :param x: 
  :type x: in signed
  :param y: 
  :type y: in signed
  :param z: 
  :type z: in signed
  :param xa: 
  :type xa: out signed
  :param ya: 
  :type ya: out signed
  :param za: 
  :type za: out signed


.. vhdl:procedure:: procedure rotate(iterations : in integer; x : in signed; y : in signed; z : in signed; xr : out signed; yr : out signed; zr : out signed);

  :param iterations: 
  :type iterations: in integer
  :param x: 
  :type x: in signed
  :param y: 
  :type y: in signed
  :param z: 
  :type z: in signed
  :param xr: 
  :type xr: out signed
  :param yr: 
  :type yr: out signed
  :param zr: 
  :type zr: out signed


.. vhdl:procedure:: procedure vector(iterations : in integer; x : in signed; y : in signed; z : in signed; xr : out signed; yr : out signed; zr : out signed);

  :param iterations: 
  :type iterations: in integer
  :param x: 
  :type x: in signed
  :param y: 
  :type y: in signed
  :param z: 
  :type z: in signed
  :param xr: 
  :type xr: out signed
  :param yr: 
  :type yr: out signed
  :param zr: 
  :type zr: out signed


.. vhdl:function:: function effective_fractional_bits(iterations : positive; frac_bits : positive) return real;

  :param iterations: 
  :type iterations: positive
  :param frac_bits: 
  :type frac_bits: positive

