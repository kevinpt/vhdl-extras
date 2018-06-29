--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# arithmetic.vhdl - Pipelined arithmetic operations
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2017 Kevin Thibedeau
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
--# DEPENDENCIES: pipelining
--#
--# DESCRIPTION:
--#  This is an implementation of general purpose pipelined adder. It can be configured
--#  for any number of stages and bit widths. The adder is divided into a number of slices
--#  each of which is a conventional adder. The maximum carry chain length is reduced to
--#  ceil(bit-length / slices).
--#  
--#  --[]-[]-[Slice]--> Sum_3
--#  --[]-[Slice]-[]--> Sum_2
--#  --[Slice]-[]-[]--> Sum_1
--#
--# EXAMPLE USAGE:
--#  -- 16-bit adder partitioned into 4 4-bit slices
--#  signal A, B, Sum : unsigned(15 downto 0);
--#
--#  pa: pipelined_adder
--#    generic map (
--#      SLICES => 4,
--#      CONST_B_INPUT => false,
--#      RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
--#    )
--#    port map (
--#      Clock => clock,
--#      Reset => reset,
--#
--#      A => A,
--#      B => B,
--#
--#      Sum => Sum
--#    );
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package arithmetic is

  --## Variable size pipelined adder.
  component pipelined_adder is
    generic (
      SLICES             : positive;         --# Number of pipeline stages
      CONST_B_INPUT      : boolean := false; --# Optimize when the B input is constant
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic; --# System clock
      Reset : in std_ulogic; --# Asynchronous reset

      --# {{data|}}
      A     : in unsigned; --# Addend A
      B     : in unsigned; --# Addend B
      Sum   : out unsigned --# Result sum of A and B
    );
  end component;

end package;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.pipelining.fixed_delay_line_unsigned;

-- Single slice of a pipelined adder
entity adder_slice is
  generic (
    SLICES             : positive;         --# Number of slices
    SLICE_IX           : natural;          --# Index of this slice
    CONST_B_INPUT      : boolean := false; --# Optimize when the B input is constant
    RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
  );
  port (
    Clock     : in std_ulogic;
    Reset     : in std_ulogic;
    
    A         : in unsigned;
    B         : in unsigned;
    Carry_in  : in std_ulogic;

    Sum       : out unsigned;
    Carry_out : out std_ulogic
  );
end entity;

architecture rtl of adder_slice is
  signal A_dly      : unsigned(A'range);
  signal A_expanded : unsigned(A'length downto 0);

  signal B_dly      : unsigned(B'range);
  signal B_expanded : unsigned(A'length downto 0);

  
  signal cin : unsigned(0 downto 0);
  signal cin_expanded : unsigned(A'length downto 0);
  
  signal sum_loc : unsigned(A'length downto 0); -- Extra bit for carry out
  signal sum_dly : unsigned(A'length-1 downto 0);
begin

  dly_A: fixed_delay_line_unsigned
    generic map (
      STAGES => SLICE_IX
    )
    port map (
      Clock => Clock,

      Enable => '1',

      Data_in => A,
      Data_out => A_dly
    );

  -- Expand by one bit so we can capture the carry out
  A_expanded <= resize(A_dly, A_expanded'length);


  -- We skip the delay on the B input if it is treated as a constant
  bd: if CONST_B_INPUT = false generate
    dly_B: fixed_delay_line_unsigned
      generic map (
        STAGES => SLICE_IX
      )
      port map (
        Clock => Clock,

        Enable => '1',

        Data_in => B,
        Data_out => B_dly
      );
  end generate;

  -- Expand by one bit so we can capture the carry out
  with CONST_B_INPUT select
    B_expanded <= resize(B_dly, B_expanded'length) when false,
      resize(B, B_expanded'length) when others;
  

  cin(0) <= Carry_in;
  cin_expanded <= resize(cin, cin_expanded'length);
  sum_loc <= A_expanded + B_expanded + cin_expanded;

  -- Register the carry bit
  carry: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      Carry_out <= '0';
    elsif rising_edge(Clock) then
      Carry_out <= sum_loc(sum_loc'high);
    end if;
  end process;

  -- Add pipeline delays to sum
  dly_out: fixed_delay_line_unsigned
    generic map (
      STAGES => SLICES - SLICE_IX
    )
    port map (
      Clock => Clock,

      Enable => '1',

      Data_in => sum_loc(sum_loc'high-1 downto 0),
      Data_out => sum_dly
    );

  Sum <= sum_dly;
end architecture;




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipelined_adder is
  generic (
    SLICES             : positive;
    CONST_B_INPUT      : boolean := false;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    
    A     : in unsigned;
    B     : in unsigned;
    Sum   : out unsigned
  );
end entity;

architecture rtl of pipelined_adder is

  component adder_slice is
    generic (
      SLICES             : positive;
      SLICE_IX           : natural;
      CONST_B_INPUT      : boolean := false;
      RESET_ACTIVE_LEVEL : std_ulogic := '1'
    );
    port (
      Clock     : in std_ulogic;
      Reset     : in std_ulogic;
      
      A         : in unsigned;
      B         : in unsigned;
      Carry_in  : in std_ulogic;

      Sum       : out unsigned;
      Carry_out : out std_ulogic
    );
  end component;
  
  constant SLICE_SIZE : positive := (A'length + SLICES - 1) / SLICES;
  
  signal A_exp     : unsigned(SLICE_SIZE*SLICES-1 downto 0);
  signal B_exp     : unsigned(SLICE_SIZE*SLICES-1 downto 0);
  signal Sum_exp   : unsigned(SLICE_SIZE*SLICES-1 downto 0);

  signal slice_carry : std_ulogic_vector(0 to SLICES);
  signal sum_loc   : unsigned(SLICE_SIZE*SLICES-1 downto 0);
  
begin

  A_exp <= resize(A, A_exp'length);
  B_exp <= resize(B, B_exp'length);
  
  slice_carry(0) <= '0';
  
  gs: for SLICE_IX in 0 to SLICES-1 generate
    slc: adder_slice
      generic map (
        SLICES => SLICES,
        SLICE_IX => SLICE_IX,
        CONST_B_INPUT => CONST_B_INPUT,
        RESET_ACTIVE_LEVEL => RESET_ACTIVE_LEVEL
      )
      port map (
        Clock => Clock,
        Reset => Reset,

        A        => A_exp(SLICE_SIZE * (SLICE_IX + 1) - 1 downto SLICE_SIZE * SLICE_IX),
        B        => B_exp(SLICE_SIZE * (SLICE_IX + 1) - 1 downto SLICE_SIZE * SLICE_IX),
        Carry_in => slice_carry(SLICE_IX),

        Sum => sum_loc(SLICE_SIZE * (SLICE_IX + 1) - 1 downto SLICE_SIZE * SLICE_IX),
        Carry_out => slice_carry(SLICE_IX+1)
      );
  end generate;
  
  Sum <= slice_carry(slice_carry'high) & sum_loc(Sum'length-2 downto 0);
end architecture;


