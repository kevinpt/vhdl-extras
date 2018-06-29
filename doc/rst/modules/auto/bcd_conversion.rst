.. Generated from ../rtl/extras/bcd_conversion.vhdl on 2018-06-28 23:37:29.130821
.. vhdl:package:: extras.bcd_conversion


Components
----------


binary_to_bcd
~~~~~~~~~~~~~

.. symbolator::
  :name: bcd_conversion-binary_to_bcd

  component binary_to_bcd is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Convert : in std_ulogic;
    Done : out std_ulogic;
    --# {{data|}}
    Binary : in unsigned;
    BCD : out unsigned
  );
  end component;

|


.. vhdl:entity:: binary_to_bcd

  Convert a binary input to BCD encoding. A conversion by asserting ``Convert``.
  The ``BCD`` output is valid when the ``Done`` signal goes high.
  
  This component will operate with any size binary array of 4 bits or larger
  and produces a BCD array whose length is 4 times the value returned by the
  :vhdl:func:`~bcd_conversion.decimal_size` function.
  The conversion of an n-bit binary number will take n cycles to complete.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Convert: Start conversion when high
  :ptype Convert: in std_ulogic
  :port Done: Indicates completed conversion
  :ptype Done: out std_ulogic
  :port Binary: Binary data to convert
  :ptype Binary: in unsigned
  :port BCD: Converted output. Retained until next conversion
  :ptype BCD: out unsigned

bcd_to_binary
~~~~~~~~~~~~~

.. symbolator::
  :name: bcd_conversion-bcd_to_binary

  component bcd_to_binary is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    --# {{control|}}
    Convert : in std_ulogic;
    Done : out std_ulogic;
    --# {{data|}}
    BCD : in unsigned;
    Binary : out unsigned
  );
  end component;

|


.. vhdl:entity:: bcd_to_binary

  Convert a BCD encoded input to binary. A conversion by asserting ``Convert``.
  The ``Binary`` output is valid when the ``Done`` signal goes high.
  
  The length of the input must be a multiple of four. The binary array produced will be
  large enough to hold the maximum decimal value of the BCD input. Its
  length will be ``bit_size(10**(Bcd'length/4) - 1)``. The conversion of a BCD
  number to an n-bit binary number will take n+3 cycles to complete.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Convert: Start conversion when high
  :ptype Convert: in std_ulogic
  :port Done: Indicates completed conversion
  :ptype Done: out std_ulogic
  :port BCD: BCD data to convert
  :ptype BCD: in unsigned
  :port Binary: Converted output. Retained until next conversion
  :ptype Binary: out unsigned

Subprograms
-----------


.. vhdl:function:: function decimal_size(n : natural) return natural;

   Calculate the number of decimal digits needed to represent a number n.
  
  :param n: Value to calculate digits for
  :type n: natural
  :returns: Decimal digits for n.
  


.. vhdl:function:: function to_bcd(Binary : unsigned) return unsigned;

   Convert binary number to BCD encoding
   This uses the double-dabble algorithm to perform the BCD conversion. It
   will operate with any size binary array and return a BCD array whose
   length is 4 times the value returned by the decimal_size function.
  
  :param Binary: Binary encoded value
  :type Binary: unsigned
  :returns: BCD encoded result.
  


.. vhdl:function:: function to_binary(Bcd : unsigned) return unsigned;

   Convert a BCD number to binary encoding
   This uses the double-dabble algorithm in reverse. The length of the
   input must be a multiple of four. The returned binary array will be
   large enough to hold the maximum decimal value of the BCD input. Its
   length will be bit_size(10**(Bcd'length/4) - 1).
  
  :param Bcd: BCD encoded value
  :type Bcd: unsigned
  :returns: Binary encoded result.
  

