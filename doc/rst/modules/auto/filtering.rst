.. Generated from ../rtl/extras_2008/filtering.vhdl on 2018-06-28 23:37:29.915180
.. vhdl:package:: extras_2008.filtering


Subtypes
--------


.. vhdl:subtype:: attenuation_factor

  Attenuation gain from 0.0 to 1.0.

Components
----------


fir_filter
~~~~~~~~~~

.. symbolator::
  :name: filtering-fir_filter

  component fir_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Coefficients : in signed_array;
    --# {{data|Write port}}
    Data_valid : in std_ulogic;
    Data : in signed;
    Busy : out std_ulogic;
    --# {{Read port}}
    Result_valid : out std_ulogic;
    Result : out signed;
    In_use : in std_ulogic
  );
  end component;

|


.. vhdl:entity:: fir_filter

  Finite Impulse Response filter.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Coefficients: Filter tap coefficients
  :ptype Coefficients: in signed_array
  :port Data_valid: Indicate when ``Data`` is valid
  :ptype Data_valid: in std_ulogic
  :port Data: Data input to the filter
  :ptype Data: in signed
  :port Busy: Indicate when filter is ready to accept new data
  :ptype Busy: out std_ulogic
  :port Result_valid: Indicates when a new filter result is valid
  :ptype Result_valid: out std_ulogic
  :port Result: Filtered output
  :ptype Result: out signed
  :port In_use: Request to keep ``Result`` unchanged
  :ptype In_use: in std_ulogic

lowpass_filter
~~~~~~~~~~~~~~

.. symbolator::
  :name: filtering-lowpass_filter

  component lowpass_filter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic;
    ALPHA : real;
    REGISTERED_MULTIPLY : boolean
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|}}
    Data : in signed;
    Result : out signed
  );
  end component;

|


.. vhdl:entity:: lowpass_filter

  First order lowpass filter.
  This filter operates in two modes. When REGISTERED_MULTIPLY is false
  the filter processes a new data sample on every clock cycle.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :generic ALPHA: Alpha parameter computed with lowpass_alpha()
  :gtype ALPHA: real
  :generic REGISTERED_MULTIPLY: Control registration of internal mutiplier
  :gtype REGISTERED_MULTIPLY: boolean
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Data: Data input to the filter
  :ptype Data: in signed
  :port Result: Filtered output
  :ptype Result: out signed

attenuate
~~~~~~~~~

.. symbolator::
  :name: filtering-attenuate

  component attenuate is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Gain : in signed;
    --# {{data|Write port}}
    Data_valid : in std_ulogic;
    Data : in signed;
    --# {{Read port}}
    Result_valid : out std_ulogic;
    Result : out signed
  );
  end component;

|


.. vhdl:entity:: attenuate

  Scale samples by an attenuation factor.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Gain: Attenuation factor
  :ptype Gain: in signed
  :port Data_valid: Indicate when ``Data`` is valid
  :ptype Data_valid: in std_ulogic
  :port Data: Data input to the filter
  :ptype Data: in signed
  :port Result_valid: Indicates when a new filter result is valid
  :ptype Result_valid: out std_ulogic
  :port Result: Filtered output
  :ptype Result: out signed

sampler
~~~~~~~

.. symbolator::
  :name: filtering-sampler

  component sampler is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|Write port}}
    Data_valid : in std_ulogic;
    Data : in std_ulogic;
    --# {{Read port}}
    Result_valid : out std_ulogic;
    Result : out signed
  );
  end component;

|


.. vhdl:entity:: sampler

  Convert binary data into numeric samples.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Data_valid: Indicate when ``Data`` is valid
  :ptype Data_valid: in std_ulogic
  :port Data: Data input to the filter
  :ptype Data: in std_ulogic
  :port Result_valid: Indicates when a new filter result is valid
  :ptype Result_valid: out std_ulogic
  :port Result: Filtered output
  :ptype Result: out signed

sample_and_hold
~~~~~~~~~~~~~~~

.. symbolator::
  :name: filtering-sample_and_hold

  component sample_and_hold is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{data|Write port}}
    Data_valid : in std_ulogic;
    Data : in signed;
    Busy : out std_ulogic;
    --# {{Read port}}
    Result_valid : out std_ulogic;
    Result : out signed;
    In_use : in std_ulogic
  );
  end component;

|


.. vhdl:entity:: sample_and_hold

  Capture and hold data samples.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Data_valid: Indicate when ``Data`` is valid
  :ptype Data_valid: in std_ulogic
  :port Data: Data input to the filter
  :ptype Data: in signed
  :port Busy: Indicate when filter is ready to accept new data
  :ptype Busy: out std_ulogic
  :port Result_valid: Indicates when a new filter result is valid
  :ptype Result_valid: out std_ulogic
  :port Result: Filtered output
  :ptype Result: out signed
  :port In_use: Request to keep ``Result`` unchanged
  :ptype In_use: in std_ulogic

Subprograms
-----------


.. vhdl:function:: function attenuation_gain(Factor : attenuation_factor; Size : positive) return signed;

   Convert attenuation factor into a signed factor
  
  :param Factor: Factor for gain value
  :type Factor: attenuation_factor
  :param Size: Number of bits in the result
  :type Size: positive
  :returns: Signed value representing the Factor scaled to the range of Size.
  


.. vhdl:function:: function lowpass_alpha(Tau : real; Sample_period : real) return real;

   Compute the alpha value for a lowpass filter
  
  :param Tau: Time constant
  :type Tau: real
  :param Sample_period: Sample period of the filtered data
  :type Sample_period: real
  :returns: Alpha constant passed to the lowpass_filter component.
  

