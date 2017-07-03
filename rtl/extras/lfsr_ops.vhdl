--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# lfsr_ops.vhdl - Linear Feedback Shift Registers
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010 Kevin Thibedeau
--# (kevin 'period' thibedeau 'at' gmail 'punto' com)
--#
--# Permission is hereby granted, free of charge, to any person obtaining a
--# copy of this software and associated documentation files (the "Software"),
--# to deal in the Software without restriction, including without limitation
--# the rights to use, copy, modify, merge, publish, distribute, sublicense,
--# and/or sell copies of the Software, and to permit persons to whom the
--# Software is furnished to do so, subject to the following conditions:
--#
--# The above copyright notice and this permission notice shall be included in
--# all copies or substantial portions of the Software.
--#
--# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--# DEALINGS IN THE SOFTWARE.
--#
--# DEPENDENCIES: none
--#
--# DESCRIPTION:
--#  This package includes implementations of Linear Feedback Shift Registers.
--#  Two architectures are provided: Galois and Fibonacci. They can be used
--#  interchangeably with the only difference being in the organization of the
--#  taps. With Galois a single feedback bit is XORed across all taps with the
--#  neighboring register. With Fibonacci the taps are XORed together to produce
--#  a feedback bit that is shifted into the register. The Galois
--#  implementation has the more desireable property of shorter feedback delay
--#  however it will only enjoy this advantage over Fibonacci in the case of
--#  ASIC implementations and FPGAs with discrete XOR resources. For LUT based
--#  FPGAs most Fibonacci tap configurations can fit within a single LUT and
--#  the routing delays will be roughly equivalent to the Galois version.
--#
--#  The Galois LFSR is constructed so that it shifts right while the Fibonacci
--#  LFSR shifts left. This arrangement makes the rightmost bit of both
--#  LFSRs follow the same pattern for the same coefficients albeit with an
--#  unspecified phase shift between them. Technically, since the Fibonacci is
--#  a pure shift register, all of its bits follow the same pattern (but
--#  phased).
--#
--#  Note that if you are interested in using all LFSR bits to represent a
--#  pseudo-random number you should consider the Wolfram LCAR structure
--#  provided elsewhere in the VHDL-extras library. It produces more suitable
--#  randomness in its state register without the correlation between
--#  neighboring bits that the LFSR implementations do. However, these LFSRs
--#  are sufficient for producing a pseudo-random signal on a single bit.
--#
--#  The LFSRs are each implemented in a function that determines the next
--#  state of the LFSR based on the current state. These functions have two
--#  configuration parameters: Kind and Full_cycle.
--#
--#  The Kind parameter specifies whether to implement a normal circuit with
--#  XORs or to invert the logic and use XNORs. The difference between the two
--#  is that for 'normal', the all-0's state is inacessible while for
--#  'inverted' the all-1's state is inaccessible. If the LFSR is initialized
--#  in these inaccessible states it will be unable to change states.
--#
--#  The other parameter, Full_cycle, will add logic to make the invalid states
--#  reachable. When a maximal length polynomial is used, normally only 2**n-1
--#  states are reachable. With Full_cycle true, the LFSR will enter all 2**n
--#  possible states.
--#
--#  The functions use unconstrained arrays for the state and tap_map. They can
--#  implement an LFSR of any size from 2-bits and up. The only requirement is
--#  that the tap_map be one bit shorter than the state register since it works
--#  on the "spaces" between the register bits. The code is written with the
--#  intent of using 1-based ascending ranges for the arrays but any ranges
--#  will work correctly.
--#
--#  A table of coefficients for maximal length polynomials covering 2 to
--#  100-bit LFSRs is provided in LFSR_COEFF_TABLE. You can use these to
--#  generate a tap_map signal with the lfsr_taps() function. You can build a
--#  tap_map for any arbitrary set of coefficients with the to_tap_map()
--#  function. Since tap_map is a signal it is possible to switch coefficient
--#  sets in the middle of operation if desired. If you implement it as a
--#  constant the LFSR will have it's logic reduced to the optimal form in
--#  synthesis.
--#
--#  In addition to the LFSR functions, a pair of components (fibonacci_lfsr
--#  and galois_lfsr) are available for use outside of a process. All
--#  implementations have an INIT_ZERO generic that can be used to start
--#  an LFSR in the all 0's state and set the Kind to 'inverted'. When true the
--#  initial state switches from all 1's to all 0's and XORs are replaced with
--#  XNORs. The FULL_CYCLE generic activates the full cycle option described
--#  above.
--#
--# EXAMPLE USAGE:
--#    signal state, statec : std_ulogic_vector(1 to 8);
--#
--#    -- Get predefined maximal length polynomial
--#    constant TAP_MAP : std_ulogic_vector(1 to state'length-1) :=
--#      lfsr_taps(state'length);
--#    ...
--#    -- Implement LFSR in a process
--#    state <= next_galois_lfsr(state, TAP_MAP, inverted, Full_cycle => true);
--#    ...
--#    -- Implement LFSR as a component
--#    gl: galois_lfsr
--#      generic map (
--#        INIT_ZERO  => true,
--#        FULL_CYCLE => true
--#      ) port map (
--#        Clock   => clock,
--#        Reset   => reset,
--#        Enable  => enable,
--#        Tap_map => TAP_MAP,
--#        State   => statec
--#      );
--#
--#  Generate taps for any arbitrary polynomial:
--#    -- G(x) = x**11 + x**9 + x**8 + x**7 + x**2 + 1  (CRC-11)
--#    signal crc_state : std_ulogic_vector(1 to 11);
--#    signal crc_taps  : std_ulogic_vector(1 to crc_state'length-1);
--#    ...
--#    -- Discard the default feedback/forward taps:
--#    --                x**9 + x**8 + x**7 + x**2
--#    crc_taps <= to_tap_map((9, 8, 7, 2), crc_taps'length);
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package lfsr_ops is

  --## Array of LFSR coefficients. Passed as an argument to
  --#  :vhdl:func:`~extras.lfsr_ops.to_tap_map`.
  type lfsr_coefficients is array(natural range <>) of natural;

  --## Convert a coefficient list to an expanded vector with a '1' in the place.
  --#  of each coefficient.
  --# Args:
  --#  C: Coefficient definition list
  --#  Map_length: Size of the coefficient vector
  --#  Reverse: Reverse order of coefficients
  --# Returns:
  --#  Vector of coefficients.
  function to_tap_map( C : lfsr_coefficients; Map_length : positive;
    Reverse : boolean := false ) return std_ulogic_vector;

  --## Lookup a predefined tap coefficients from the table.
  --# Args:
  --#  Size: Size of the coefficient vector
  --# Returns:
  --#  Vector of coefficients.
  function lfsr_taps( Size : positive ) return std_ulogic_vector;


  --## Type of LFSR: normal (init to 0's) or inverted (init to 1's).
  type lfsr_kind is (normal, inverted);

  --## Iterate the next state in a Galois LFSR.
  --# Args:
  --#  State: Current state of the LFSR
  --#  Tap_map: Coefficient vector
  --#  Kind: Normal or inverted. Normal initializes with all ones.
  --#  Full_cycle: Generate a full 2**n cycle when true
  --# Returns:
  --#  New state for the LFSR.
  function next_galois_lfsr( State : std_ulogic_vector; Tap_map : std_ulogic_vector;
    constant Kind : lfsr_kind := normal; constant Full_cycle : boolean := false )
    return std_ulogic_vector;

  --## Iterate the next state in a Fibonacci LFSR.
  --# Args:
  --#  State: Current state of the LFSR
  --#  Tap_map: Coefficient vector
  --#  Kind: Normal or inverted. Normal initializes with all ones.
  --#  Full_cycle: Generate a full 2**n cycle when true
  --# Returns:
  --#  New state for the LFSR.
  function next_fibonacci_lfsr( State : std_ulogic_vector; Tap_map : std_ulogic_vector;
    constant Kind : lfsr_kind := normal; constant Full_cycle : boolean := false )
    return std_ulogic_vector;

  --## Galois LFSR. With Maximal length coefficients it will cycle through
  --#  (2**n)-1 states when FULL_CYCLE = false, 2**n when true.
  component galois_lfsr is
    generic (
      INIT_ZERO  : boolean := false;         --# Initialize register to zeroes when true
      FULL_CYCLE : boolean := false;         --# Implement a full 2**n cycle
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock  : in std_ulogic; --# System clock
      Reset  : in std_ulogic; --# Asynchronous reset
      Enable : in std_ulogic; --# Synchronous enable

      --# {{control|}}
      Tap_map : in std_ulogic_vector; --# '1' for taps that receive feedback
      
      --# {{data|}}
      State   : out std_ulogic_vector --# The LFSR state register
    );
  end component;

  --## Fibonacci LFSR. With Maximal length coefficients it will cycle through
  --#  (2**n)-1 states when FULL_CYCLE = false, 2**n states when true.
  component fibonacci_lfsr is
    generic (
      INIT_ZERO  : boolean := false;         --# Initialize register to zeroes when true
      FULL_CYCLE : boolean := false;         --# Implement a full 2**n cycle
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock  : in std_ulogic; --# System clock
      Reset  : in std_ulogic; --# Asynchronous reset
      Enable : in std_ulogic; --# Synchronous enable

      --# {{control|}}
      Tap_map : in std_ulogic_vector; --# '1' for taps that receive feedback
      
      --# {{data|}}
      State   : out std_ulogic_vector --# The LFSR state register
    );
  end component;

end package;

-- NOTE: package body is at end of file


-- Galois LFSR structure:
--
--  .->[1]-X--[2]--X-[3]-...-X-[n]-->--.
--  |      ^       ^         ^         |
--  |      |       |         |         |
--  |      *-tm(1) *-tm(2)   *-tm(n-1) |
--  |__/___|_______|_____..._|____/____|
--     \                          \
--
--  X = XOR   * = AND   [n] = bit-n of state register   tm(n) = tap_map bit-n

library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.lfsr_ops.all;

--## Basic Galois LFSR. With Maximal length coefficients it will cycle through
--#  (2**n)-1 states
entity galois_lfsr is
  generic (
    INIT_ZERO  : boolean := false;
    FULL_CYCLE : boolean := false;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock  : in std_ulogic;
    Reset  : in std_ulogic; -- Asynchronous reset
    Enable : in std_ulogic; -- Synchronous enable

    Tap_map : in std_ulogic_vector; -- '1' for taps that receive feedback
    State   : out std_ulogic_vector -- The LFSR state register
  );
end entity;

architecture rtl of galois_lfsr is
  signal sr : std_ulogic_vector(1 to State'length);

begin
  assert Tap_map'length = State'length-1
    report "Tap_map must be one bit shorter than the state register"
    severity failure;

  reg: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      if INIT_ZERO then
        sr <= (others => '0');
      else
        sr <= (others => '1');
      end if;
    elsif rising_edge(Clock) then
      if Enable = '1' then
        if INIT_ZERO then
          sr <= next_galois_lfsr(sr, Tap_map, inverted, FULL_CYCLE);
        else
          sr <= next_galois_lfsr(sr, Tap_map, normal, FULL_CYCLE);
        end if;

      end if;
    end if;
  end process;

  State <= sr;
end architecture;



-- Fibonacci LFSR Structure:
--
--  .-<-[1]-.--[2]--.-[3]-...-.-[n]<----.
--  |       |       |         |         |
--  |       v       v         v         |
--  |       *-tm(1) *-tm(2)   *-tm(n-1) |
--  |       |       |         |         |
--  '--->---X-------X-----...-X--->-----'
--
--  X = XOR   * = AND   [n] = bit-n of state register   tm(n) = tap_map bit-n
library ieee;
use ieee.std_logic_1164.all;

library extras;
use extras.lfsr_ops.all;

entity fibonacci_lfsr is
  generic (
    INIT_ZERO  : boolean := false;
    FULL_CYCLE : boolean := false;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock  : in std_ulogic;
    Reset  : in std_ulogic; -- Asynchronous reset
    Enable : in std_ulogic; -- Synchronous enable

    Tap_map : in std_ulogic_vector; -- '1' for taps that generate feedback
    State   : out std_ulogic_vector -- The LFSR state register
  );
end entity;

--## Standard Fibonacci LFSR. Incapable of reaching all 0's (or all 1's if
--#  INIT_ZERO is true)
architecture rtl of fibonacci_lfsr is
  signal sr : std_ulogic_vector(1 to State'length);

begin
  assert Tap_map'length = State'length-1
    report "Tap_map must be one bit shorter than the state register"
    severity failure;

  reg: process(Clock, Reset)
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      if INIT_ZERO then
        sr <= (others => '0');
      else
        sr <= (others => '1');
      end if;
    elsif rising_edge(Clock) then
      if Enable = '1' then
        if INIT_ZERO then
          sr <= next_fibonacci_lfsr(sr, Tap_map, inverted, FULL_CYCLE);
        else
          sr <= next_fibonacci_lfsr(sr, Tap_map, normal, FULL_CYCLE);
        end if;

      end if;
    end if;
  end process;

  State <= sr;
end architecture;


package body lfsr_ops is

-- PRIVATE functions:
-- ==================

  function or_reduce( v : std_ulogic_vector ) return std_ulogic is
    variable result : std_ulogic := '0';
  begin
    for i in v'range loop
      result := result or v(i);
    end loop;

    return result;
  end function;

  function and_reduce( v : std_ulogic_vector ) return std_ulogic is
    variable result : std_ulogic := '1';
  begin
    for i in v'range loop
      result := result and v(i);
    end loop;

    return result;
  end function;


-- PUBLIC functions:
-- =================

  function next_galois_lfsr( State : std_ulogic_vector; Tap_map : std_ulogic_vector;
    constant Kind : lfsr_kind := normal; constant Full_cycle : boolean := false )
    return std_ulogic_vector is

    alias sr : std_ulogic_vector(1 to State'length) is State;
    
    variable extra_state, fb_bit : std_ulogic;

    variable fb : std_ulogic_vector(Tap_map'range);
    variable result : std_ulogic_vector(sr'range);
  begin

  -- Galois LFSR structure:
  --
  --  .->[1]-X--[2]--X-[3]-...-X-[n]-->--.
  --  |      ^       ^         ^         |
  --  |      |       |         |         |
  --  |      *-tm(1) *-tm(2)   *-tm(n-1) |
  --  |__/___|_______|_____..._|____/____|
  --     \                          \
  --
  --  X = XOR   * = AND   [n] = bit-n of state register   tm(n) = tap_map bit-n

    if Full_cycle = false then -- Plain feedback
      -- For maximal length polymonials, the LFSR will skip one state:
      --   all-'0's for normal, all-'1's for inverted
      fb_bit := sr(sr'right);
    else
      -- Insert an extra state so maximal length polynomials will cover all states
      if Kind = normal then
        -- Detect when all but the right most bit is a '0'
        extra_state := not or_reduce(sr(1 to sr'right-1));
      else -- inverted
        -- Detect when all but the right most bit is a '1'
        extra_state := and_reduce(sr(1 to sr'right-1));
      end if;

      -- Invert the feedback bit to enter and exit the inserted state
      fb_bit := extra_state xor sr(sr'right);
    end if;

    fb := (others => fb_bit); -- Replicate the feedback bit to all taps
    
    if Kind = normal then
      result := fb_bit & (sr(1 to sr'right-1) xor (fb and Tap_map)); -- right shift
    else
      result := fb_bit & (sr(1 to sr'right-1) xnor (fb or not Tap_map)); -- right shift
    end if;

    return result;
  end function;


  function next_fibonacci_lfsr( State : std_ulogic_vector; Tap_map : std_ulogic_vector;
    constant Kind : lfsr_kind := normal; constant Full_cycle : boolean := false )
    return std_ulogic_vector is

    alias sr : std_ulogic_vector(1 to State'length) is State;
    
    variable extra_state, fb_bit : std_ulogic;
    
    variable taps : std_ulogic_vector(Tap_map'range);
    variable result : std_ulogic_vector(sr'range);
  begin
  -- Fibonacci LFSR Structure:
  --
  --  .-<-[1]-.--[2]--.-[3]-...-.-[n]<----.
  --  |       |       |         |         |
  --  |       v       v         v         |
  --  |       *-tm(1) *-tm(2)   *-tm(n-1) |
  --  |       |       |         |         |
  --  '--->---X-------X-----...-X--->-----'
  --
  --  X = XOR   * = AND   [n] = bit-n of state register   tm(n) = tap_map bit-n

    if Full_cycle = false then -- Plain feedback
      -- For maximal length polymonials, the LFSR will skip one state:
      --   all-'0's for normal, all-'1's for inverted
      fb_bit := sr(1); -- bit-1 is always in the feedback path
    else
      -- Insert an extra state so maximal length polynomials will cover all states
      if Kind = normal then
        -- Detect when all but the right most bit is a '0'
        extra_state := not or_reduce(sr(2 to sr'right));
      else -- inverted
        -- Detect when all but the right most bit is a '1'
        extra_state := and_reduce(sr(2 to sr'right));     
      end if;

       -- Invert the feedback bit to enter and exit the inserted state     
      fb_bit := extra_state xor sr(1);
    end if;

    taps := sr(2 to sr'right) and Tap_map; -- select active taps

    -- XOR the taps together. In synthesis, unused taps will optimize away.
    for i in taps'range loop
      fb_bit := fb_bit xor taps(i);
    end loop;

    if Kind = inverted then -- switch to XNOR
      fb_bit := not fb_bit;
    end if;
  
    result := sr(2 to sr'right) & fb_bit; -- left shift and append feedback
    return result;
  end function;


  --## Convert a coefficient list to an expanded vector with a '1' in the place
  --#  of each coefficient.
  function to_tap_map( C : lfsr_coefficients; Map_length : positive;
    Reverse : boolean := false ) return std_ulogic_vector is

    variable tm : std_ulogic_vector(0 to Map_length) := (others => '0');
    variable tm_d : std_ulogic_vector(tm'high downto tm'low);
  begin

    for i in C'range loop
      tm(C(i)) := '1';
    end loop;

    if Reverse = false then -- keep ascending range
      return tm(1 to tm'high); -- slice off dummy bit-0

    else -- reverse bits for descending range 

      for i in tm'range loop
        tm_d(i) := tm(i);
      end loop;

      return tm_d(tm_d'high downto 1); -- slice off dummy bit-0
    end if;
  end function;


  -- The following is a table of coefficients that produce maximal length
  -- sequences. The table index corresponds to the length of the shift
  -- register.
  
  -- These coefficients are taken from  primitive polynomials listed in
  -- "Built-in Test for VLSI: Pseudorandom Techniques" Bardell, McAnney, and
  -- Savir 1987. In the full representation of the polynomials there are two
  -- additional coefficients 0 and n representing the special fixed "taps" for
  -- an n-bit LFSR. Since these two are not XOR taps they are omitted to
  -- simplify the sharing between the Galois and Fibonacci implementations. The
  -- 0's that appear in the following list are dummy placeholders needed to pad
  -- out arrays with only one or two taps.
  type coefficient_list is array(natural range <>) of lfsr_coefficients(1 to 3);

  constant LFSR_COEFF_TABLE : coefficient_list(2 to 100) := (
    (1,0,0),   -- 2
    (1,0,0),   -- 3
    (1,0,0),   -- 4
    (2,0,0),   -- 5
    (1,0,0),   -- 6
    (1,0,0),   -- 7
    (6,5,1),   -- 8
    (4,0,0),   -- 9
    (3,0,0),   -- 10
    (2,0,0),   -- 11
    (7,4,3),   -- 12
    (4,3,1),   -- 13
    (12,11,1), -- 14
    (1,0,0),   -- 15
    (5,3,2),   -- 16
    (3,0,0),   -- 17
    (7,0,0),   -- 18
    (6,5,1),   -- 19
    (3,0,0),   -- 20
    (2,0,0),   -- 21
    (1,0,0),   -- 22
    (5,0,0),   -- 23
    (4,3,1),   -- 24
    (3,0,0),   -- 25
    (8,7,1),   -- 26
    (8,7,1),   -- 27
    (3,0,0),   -- 28
    (2,0,0),   -- 29
    (16,15,1), -- 30
    (3,0,0),   -- 31
    (28,27,1), -- 32
    (13,0,0),  -- 33
    (15,14,1), -- 34
    (2,0,0),   -- 35
    (11,0,0),  -- 36
    (12,10,2), -- 37
    (6,5,1),   -- 38
    (4,0,0),   -- 39
    (21,19,2), -- 40
    (3,0,0),   -- 41
    (23,22,1), -- 42
    (6,5,1),   -- 43
    (27,26,1), -- 44
    (4,3,1),   -- 45
    (21,20,1), -- 46
    (5,0,0),   -- 47
    (28,27,1), -- 48
    (9,0,0),   -- 49
    (27,26,1), -- 50
    (16,15,1), -- 51
    (3,0,0),   -- 52
    (16,15,1), -- 53
    (37,36,1), -- 54
    (24,0,0),  -- 55
    (22,21,1), -- 56
    (7,0,0),   -- 57
    (19,0,0),  -- 58
    (22,21,1), -- 59
    (1,0,0),   -- 60
    (16,15,1), -- 61
    (57,56,1), -- 62
    (1,0,0),   -- 63
    (4,3,1),   -- 64
    (18,0,0),  -- 65
    (10,9,1),  -- 66
    (10,9,1),  -- 67
    (9,0,0),   -- 68
    (29,27,2), -- 69
    (16,15,1), -- 70
    (6,0,0),   -- 71
    (53,47,6), -- 72
    (25,0,0),  -- 73
    (16,15,1), -- 74
    (11,10,1), -- 75
    (36,35,1), -- 76
    (31,30,1), -- 77
    (20,19,1), -- 78
    (9,0,0),   -- 79
    (38,37,1), -- 80
    (4,0,0),   -- 81
    (38,35,3), -- 82
    (46,45,1), -- 83
    (13,0,0),  -- 84
    (28,27,1), -- 85
    (13,12,1), -- 86
    (13,0,0),  -- 87
    (72,71,1), -- 88
    (38,0,0),  -- 89
    (19,18,1), -- 90
    (84,83,1), -- 91
    (13,12,1), -- 92
    (2,0,0),   -- 93
    (21,0,0),  -- 94
    (11,0,0),  -- 95
    (49,47,2), -- 96
    (6,0,0),   -- 97
    (11,0,0),  -- 98
    (47,45,2), -- 99
    (37,0,0)   -- 100
  );

  --## Lookup a predefined tap coefficients from the table
  function lfsr_taps( Size : positive ) return std_ulogic_vector is
    variable result : std_ulogic_vector(1 to Size-1);
  begin
    assert (Size >= LFSR_COEFF_TABLE'low) and (Size <= LFSR_COEFF_TABLE'high)
      report "Size is out of range for predefined LCAR rules"
      severity failure;
    
    result := to_tap_map(LFSR_COEFF_TABLE(Size), Size - 1);
    return result;
  end function;

end package body;
