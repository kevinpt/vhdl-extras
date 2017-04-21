.. Generated from ../rtl/extras/ddfs.vhdl on 2017-04-20 23:04:37.161144
.. vhdl:package:: ddfs_pkg


Components
----------


ddfs
~~~~

.. symbolator::

  component ddfs is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    Load_phase : in std_ulogic;
    New_phase : in unsigned;
    Increment : in unsigned;
    Accumulator : out unsigned;
    Synth_clock : out std_ulogic;
    Synth_pulse : out std_ulogic
  );
  end component;

|


|


.. vhdl:entity:: ddfs

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset: 
  :ptype Reset: in std_ulogic
  :port Enable: 
  :ptype Enable: in std_ulogic
  :port Load_phase: 
  :ptype Load_phase: in std_ulogic
  :port New_phase: 
  :ptype New_phase: in unsigned
  :port Increment: 
  :ptype Increment: in unsigned
  :port Accumulator: 
  :ptype Accumulator: out unsigned
  :port Synth_clock: 
  :ptype Synth_clock: out std_ulogic
  :port Synth_pulse: 
  :ptype Synth_pulse: out std_ulogic

Subprograms
-----------


.. vhdl:function:: function ddfs_size(sys_freq : real; target_freq : real; tolerance : real) return natural;

  :param sys_freq: 
  :type sys_freq: real
  :param target_freq: 
  :type target_freq: real
  :param tolerance: 
  :type tolerance: real


.. vhdl:function:: function ddfs_tolerance(sys_freq : real; target_freq : real; size : natural) return real;

  :param sys_freq: 
  :type sys_freq: real
  :param target_freq: 
  :type target_freq: real
  :param size: 
  :type size: natural


.. vhdl:function:: function ddfs_increment(sys_freq : real; target_freq : real; size : natural) return natural;

  :param sys_freq: 
  :type sys_freq: real
  :param target_freq: 
  :type target_freq: real
  :param size: 
  :type size: natural


.. vhdl:function:: function ddfs_increment(sys_freq : real; target_freq : real; size : natural) return unsigned;

  :param sys_freq: 
  :type sys_freq: real
  :param target_freq: 
  :type target_freq: real
  :param size: 
  :type size: natural


.. vhdl:function:: function min_fraction_bits(sys_freq : real; target_freq : real; size : natural; tolerance : real) return natural;

  :param sys_freq: 
  :type sys_freq: real
  :param target_freq: 
  :type target_freq: real
  :param size: 
  :type size: natural
  :param tolerance: 
  :type tolerance: real


.. vhdl:function:: function ddfs_dynamic_factor(sys_freq : real; size : natural; fraction_bits : natural) return natural;

  :param sys_freq: 
  :type sys_freq: real
  :param size: 
  :type size: natural
  :param fraction_bits: 
  :type fraction_bits: natural


.. vhdl:procedure:: procedure ddfs_dynamic_inc(dynamic_factor : in natural; fraction_bits : in natural; target_freq : in unsigned; increment : out unsigned);

  :param dynamic_factor: 
  :type dynamic_factor: in natural
  :param fraction_bits: 
  :type fraction_bits: in natural
  :param target_freq: 
  :type target_freq: in unsigned
  :param increment: 
  :type increment: out unsigned


.. vhdl:function:: function ddfs_frequency(sys_freq : real; target_freq : real; size : natural) return real;

  :param sys_freq: 
  :type sys_freq: real
  :param target_freq: 
  :type target_freq: real
  :param size: 
  :type size: natural


.. vhdl:function:: function ddfs_error(sys_freq : real; target_freq : real; size : natural) return real;

  :param sys_freq: 
  :type sys_freq: real
  :param target_freq: 
  :type target_freq: real
  :param size: 
  :type size: natural


.. vhdl:function:: function resize_fractional(phase : unsigned; size : positive) return unsigned;

  :param phase: 
  :type phase: unsigned
  :param size: 
  :type size: positive


.. vhdl:function:: function radians_to_phase(radians : real; size : positive) return unsigned;

  :param radians: 
  :type radians: real
  :param size: 
  :type size: positive


.. vhdl:function:: function degrees_to_phase(degrees : real; size : positive) return unsigned;

  :param degrees: 
  :type degrees: real
  :param size: 
  :type size: positive

