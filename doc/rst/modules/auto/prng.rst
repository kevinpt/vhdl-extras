.. Generated from ../rtl/extras/prng.vhdl on 2018-06-28 23:37:28.675257
.. vhdl:package:: extras.prng


Components
----------


weak_prng
~~~~~~~~~

.. symbolator::
  :name: prng-weak_prng

  component weak_prng is
  generic (
    STATE_BITS : positive;
    LCAR_RATIO : real;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    Load_seed : in std_ulogic;
    Seed : in std_ulogic_vector;
    Entropy_stream : in std_ulogic;
    Initialized : out std_ulogic;
    Result : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: weak_prng

  
  :generic STATE_BITS:
  :gtype STATE_BITS: positive
  :generic LCAR_RATIO:
  :gtype LCAR_RATIO: real
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: None
  :ptype Enable: in std_ulogic
  :port Load_seed: None
  :ptype Load_seed: in std_ulogic
  :port Seed: None
  :ptype Seed: in std_ulogic_vector
  :port Entropy_stream: None
  :ptype Entropy_stream: in std_ulogic
  :port Initialized: None
  :ptype Initialized: out std_ulogic
  :port Result: None
  :ptype Result: out std_ulogic_vector

xorshift128plus
~~~~~~~~~~~~~~~

.. symbolator::
  :name: prng-xorshift128plus

  component xorshift128plus is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    Load_seed : in std_ulogic;
    Seed : in unsigned(127 downto 0);
    Result : out unsigned(63 downto 0)
  );
  end component;

|


.. vhdl:entity:: xorshift128plus

  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: None
  :ptype Enable: in std_ulogic
  :port Load_seed: None
  :ptype Load_seed: in std_ulogic
  :port Seed: None
  :ptype Seed: in unsigned(127 downto 0)
  :port Result: None
  :ptype Result: out unsigned(63 downto 0)
