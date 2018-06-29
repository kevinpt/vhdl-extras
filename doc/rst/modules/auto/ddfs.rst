.. Generated from ../rtl/extras/ddfs.vhdl on 2018-06-28 23:37:28.856560
.. vhdl:package:: extras.ddfs_pkg


Components
----------


ddfs
~~~~

.. symbolator::
  :name: ddfs_pkg-ddfs

  component ddfs is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Increment : in unsigned;
    --# {{data|}}
    Accumulator : out unsigned;
    Synth_clock : out std_ulogic;
    Synth_pulse : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: ddfs

  Synthesize a frequency using a DDFS.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: Enable the DDFS counter
  :ptype Enable: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Increment: Value controlling the synthesized frequency
  :ptype Increment: in unsigned
  :port Accumulator: Internal accumulator value
  :ptype Accumulator: out unsigned
  :port Synth_clock: Synthesized frequency
  :ptype Synth_clock: out std_ulogic
  :port Synth_pulse: Single cycle pulse for rising edge of synth_clock
  :ptype Synth_pulse: out std_ulogic

ddfs_pipelined
~~~~~~~~~~~~~~

.. symbolator::
  :name: ddfs_pkg-ddfs_pipelined

  component ddfs_pipelined is
  generic (
    MAX_CARRY_LENGTH : positive;
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Enable : in std_ulogic;
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Increment : in unsigned;
    --# {{data|}}
    Accumulator : out unsigned;
    Synth_clock : out std_ulogic;
    Synth_pulse : out std_ulogic
  );
  end component;

|


.. vhdl:entity:: ddfs_pipelined

  Synthesize a frequency using a DDFS.
  
  :generic MAX_CARRY_LENGTH:
  :gtype MAX_CARRY_LENGTH: positive
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: Enable the DDFS counter
  :ptype Enable: in std_ulogic
  :port Load_phase: Load a new phase angle
  :ptype Load_phase: in std_ulogic
  :port New_phase: Phase angle to load
  :ptype New_phase: in unsigned
  :port Increment: Value controlling the synthesized frequency
  :ptype Increment: in unsigned
  :port Accumulator: Internal accumulator value
  :ptype Accumulator: out unsigned
  :port Synth_clock: Synthesized frequency
  :ptype Synth_clock: out std_ulogic
  :port Synth_pulse: Single cycle pulse for rising edge of synth_clock
  :ptype Synth_pulse: out std_ulogic

Subprograms
-----------


.. vhdl:function:: function ddfs_size(Sys_freq : real; Target_freq : real; Tolerance : real) return natural;

   Compute the necessary size of a DDFS accumulator based on system and
   target frequencies with a specified tolerance. The DDFS accumulator
   must be at least as large as the result to achieve the requested tolerance.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Target_freq: Desired frequency to generate
  :type Target_freq: real
  :param Tolerance: Error tolerance
  :type Tolerance: real
  :returns: Number of bits needed to generate the target frequency within the allowed tolerance.
  


.. vhdl:function:: function ddfs_tolerance(Sys_freq : real; Target_freq : real; Size : natural) return real;

   Compute the effective frequency tolerance for a specific size and target
   frequency.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Target_freq: Desired frequency to generate
  :type Target_freq: real
  :param Size: Size of the DDFS counter
  :type Size: natural
  :returns: Tolerance for the target frequency with a Size counter.
  


.. vhdl:function:: function ddfs_increment(Sys_freq : real; Target_freq : real; Size : natural) return natural;

   Compute the natural increment value needed to generate a target frequency.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Target_freq: Desired frequency to generate
  :type Target_freq: real
  :param Size: Size of the DDFS counter
  :type Size: natural
  :returns: Increment value needed to generate the target frequency.
  


.. vhdl:function:: function ddfs_increment(Sys_freq : real; Target_freq : real; Size : natural) return unsigned;

   Compute the unsigned increment value needed to generate a target frequency.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Target_freq: Desired frequency to generate
  :type Target_freq: real
  :param Size: Size of the DDFS counter
  :type Size: natural
  :returns: Increment value needed to generate the target frequency.
  


.. vhdl:function:: function min_fraction_bits(Sys_freq : real; Target_freq : real; Size : natural; Tolerance : real) return natural;

   Find the minimum number of fraction bits needed to meet
   the tolerance requirement for a dynamic DDFS. The target
   frequency should be the lowest frequency to ensure proper
   results.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Target_freq: Lowest desired frequency to generate
  :type Target_freq: real
  :param Size: Size of the DDFS counter
  :type Size: natural
  :param Tolerance: Error tolerance
  :type Tolerance: real
  :returns: Increment value needed to generate the target frequency.
  


.. vhdl:function:: function ddfs_dynamic_factor(Sys_freq : real; Size : natural; Fraction_bits : natural) return natural;

   Compute the factor used to generate dynamic increment values.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Size: Size of the DDFS counter
  :type Size: natural
  :param Fraction_bits: Number of fraction bits
  :type Fraction_bits: natural
  :returns: Dynamic increment factor passed into ddfs_dynamic_inc().
  


.. vhdl:procedure:: procedure ddfs_dynamic_inc(Dynamic_factor : in natural; Fraction_bits : in natural; Target_freq : in unsigned; Increment : out unsigned);

   This procedure computes dynamic increment values by multiplying
   the result of a previous call to ddfs_dynamic_factor by the
   integer target frequency. The result is an integer value with
   fractional bits removed.
   This can be synthesized by invocation within a synchronous
   process.
  
  :param Dynamic_factor: Dynamic factor constant
  :type Dynamic_factor: in natural
  :param Fraction_bits: Fraction bits for the dynamic DDFS
  :type Fraction_bits: in natural
  :param Target_freq: Desired frequency to generate
  :type Target_freq: in unsigned
  :param Increment: Increment value needed to generate the target frequency.
  :type Increment: out unsigned


.. vhdl:function:: function ddfs_frequency(Sys_freq : real; Target_freq : real; Size : natural) return real;

   Compute the actual synthesized frequency for the specified accumulator
   size.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Target_freq: Desired frequency to generate
  :type Target_freq: real
  :param Size: Size of the DDFS counter
  :type Size: natural
  :returns: Frequency generated with the provided parameters.
  


.. vhdl:function:: function ddfs_error(Sys_freq : real; Target_freq : real; Size : natural) return real;

   Compute the error between the requested output frequency and the actual
   output frequency.
  
  :param Sys_freq: Clock frequency of the system
  :type Sys_freq: real
  :param Target_freq: Desired frequency to generate
  :type Target_freq: real
  :param Size: Size of the DDFS counter
  :type Size: natural
  :returns: Ratio of generated frequency to target frequency.
  


.. vhdl:function:: function resize_fractional(Phase : unsigned; Size : positive) return unsigned;

   Resize a vector representing a fractional value with the binary point
   preceeding the MSB.
  
  :param Phase: Phase angle in range 0.0 to 1.0.
  :type Phase: unsigned
  :param Size: Number of bits in the result
  :type Size: positive
  :returns: Resized vector containing phase fraction
  


.. vhdl:function:: function radians_to_phase(Radians : real; Size : positive) return unsigned;

   Convert angle in radians to a fractional phase value.
  
  :param Radians: Angle to convert
  :type Radians: real
  :param Size: Number of bits in the result
  :type Size: positive
  :returns: Fraction phase in range 0.0 to 1.0.
  


.. vhdl:function:: function degrees_to_phase(Degrees : real; Size : positive) return unsigned;

   Convert angle in degrees to a fractional phase value.
  
  :param Degrees: Angle to convert
  :type Degrees: real
  :param Size: Number of bits in the result
  :type Size: positive
  :returns: Fraction phase in range 0.0 to 1.0.
  

