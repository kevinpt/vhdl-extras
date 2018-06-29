--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# bit_ops.vhdl - Bitwise operations
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
--# DEPENDENCIES: sizing
--#
--# DESCRIPTION:
--#  This package provides components that count the number of set bits in a
--#  vector. Multiple implementations are available with different performance
--#  characteristics. 
--#
--# EXAMPLE USAGE:
--#
--#  signal value : unsigned(11 downto 0);
--#  signal ones_count : unsigned(bit_size(value'length)-1 downto 0);
--#
--#  -- Basic combinational circuit:
--#  basic: count_ones
--#    port map (
--#      Value => value,
--#      Ones_count => ones_count
--#    );
--#
--#  -- Chunked combinational circuit:
--#  basic: count_ones_chunked
--#    generic map (
--#      TABLE_BITS => 4 -- Constant table with 16 entries
--#    )
--#    port map (
--#      Value => value,
--#      Ones_count => ones_count
--#    );
--#
--#  -- Chunked sequential circuit:
--#  basic: count_ones_sequential
--#    generic map (
--#      TABLE_BITS => 4 -- Constant table with 16 entries
--#    )
--#    port map (
--#      Clock => clock,
--#      Reset => reset,
--#
--#      Start => start,
--#      Busy => busy,
--#      Done  => done,
--#
--#      Value => value,
--#      Ones_count => ones_count
--#    );
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.sizing.bit_size;


package bit_ops is

  --# Vector of natural numbers.
  type natural_vector is array(natural range <>) of natural;

  --## Create a precomputed table of bit counts.
  --# Args:
  --#  Size : Number of bits in vector
  --# Returns:
  --#  Array of bit count values with 2**Size entries.
  function gen_count_ones_table( Size : positive ) return natural_vector;


  --# Count the number of set bits in a vector.
  component count_ones is
    port (
      --# {{data|}}
      Value      : in unsigned; --# Vector to count set bits
      Ones_count : out unsigned --# Number of set bits in ``Value``
    );
  end component;


  --# Count the number of set bits in a vector with a reduced constant table.
  component count_ones_chunked is
    generic (
      TABLE_BITS : positive --# Number of bits for constant table
    );
    port (
      --# {{data|}}
      Value      : in unsigned; --# Vector to count set bits
      Ones_count : out unsigned --# Number of set bits in ``Value``
    );
  end component;

  --# Count the number of set bits in a vector with a reduced constant table.
  component count_ones_sequential is
    generic (
      TABLE_BITS         : positive;  --# Number of bits for constant table
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock      : in std_ulogic; --# System clock
      Reset      : in std_ulogic; --# Asynchronous reset
      
      --# {{control|}}
      Start      : in std_ulogic;  --# Start counting
      Busy       : out std_ulogic; --# Count is in progress
      Done       : out std_ulogic; --# Count is done
      
      --# {{data|}}
      Value      : in unsigned; --# Vector to count set bits
      Ones_count : out unsigned --# Number of set bits in ``Value``
    );
  end component;

end package;

package body bit_ops is

  function gen_count_ones_table( Size : positive ) return natural_vector is
  
    function count_ones(v : unsigned) return natural is
      variable cnt : natural := 0;
    begin
      for i in v'range loop
        if v(i) = '1' then
          cnt := cnt + 1;
        end if;
      end loop;
      
      return cnt;
    end function;

    variable table : natural_vector(0 to 2**Size-1);
  begin
    assert Size <= bit_size(integer'high)
      report "Size is too large. Max is " & integer'image(bit_size(integer'high))
      severity failure;
  
    for i in table'range loop
      table(i) := count_ones(to_unsigned(i, Size));
    end loop;
    
    return table;
  end function;

end package body;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.bit_ops.all;

entity count_ones is
  port (
    Value      : in unsigned;
    Ones_count : out unsigned
  );
end entity;

architecture rtl of count_ones is
  constant ONES_TABLE : natural_vector := gen_count_ones_table(Value'length);
begin

  Ones_count <= to_unsigned(ONES_TABLE(to_integer(Value)), Ones_count'length);

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.bit_ops.all;

entity count_ones_chunked is
  generic (
    TABLE_BITS : positive
  );
  port (
    Value      : in unsigned;
    Ones_count : out unsigned
  );
end entity;

architecture rtl of count_ones_chunked is
  constant ONES_TABLE : natural_vector := gen_count_ones_table(TABLE_BITS);
  
  constant PIECES : natural := (Value'length + TABLE_BITS - 1) / TABLE_BITS;
  signal expanded : unsigned(PIECES*TABLE_BITS - 1 downto 0);

begin

  expanded <= resize(Value, expanded'length);
  
  counter: process(expanded) is
    variable slice : unsigned(TABLE_BITS-1 downto 0);
    variable count : unsigned(Ones_count'length-1 downto 0);
  begin
    count := (others => '0');
    
    for i in 0 to PIECES-1 loop
      slice := expanded((i+1)*TABLE_BITS-1 downto i*TABLE_BITS);
      count := count + ONES_TABLE(to_integer(slice));
    end loop;
    
    Ones_count <= count;
  end process;
  
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.bit_ops.all;
use extras.sizing.bit_size;

entity count_ones_sequential is
  generic (
    TABLE_BITS         : positive;
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock      : in std_ulogic;
    Reset      : in std_ulogic;
    
    Start      : in std_ulogic;
    Busy       : out std_ulogic;
    Done       : out std_ulogic;
    
    Value      : in unsigned;
    Ones_count : out unsigned
  );
end entity;

architecture rtl of count_ones_sequential is
  constant ONES_TABLE : natural_vector := gen_count_ones_table(TABLE_BITS);

  constant PIECES : natural := (Value'length + TABLE_BITS - 1) / TABLE_BITS;
  signal expanded : unsigned(PIECES*TABLE_BITS - 1 downto 0);
  --signal slice : unsigned(TABLE_BITS-1 downto 0);
  
  subtype slice is unsigned(TABLE_BITS-1 downto 0);
  type slice_vec is array(natural range <>) of slice;
  signal slices : slice_vec(PIECES-1 downto 0);
  --signal slices : unsigned(PIECES-1 downto 0)(TABLE_BITS-1 downto 0);

  signal counting : std_ulogic;
  signal count : unsigned(Ones_count'length-1 downto 0);
  
  --subtype piece_index is integer range 0 to PIECES-1;
  --signal ix : piece_index;
  
  signal ix : unsigned(bit_size(PIECES)-1 downto 0);
  
begin

  expanded <= resize(Value, expanded'length);
  --slice <= expanded((ix+1)*TABLE_BITS-1 downto ix*TABLE_BITS);
  
  sg: for i in 0 to PIECES-1 generate
    slices(i) <= expanded((i+1)*TABLE_BITS-1 downto i*TABLE_BITS);
  end generate;
  
  counter: process(Clock, Reset) is
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      Busy <= '0';
      counting <= '0';
      count <= (others => '0');
      ix <= (others => '0');
    elsif rising_edge(Clock) then
      Busy <= '0';
      
      if Start = '1' then -- Start counting down through the pieces
        Busy <= '1';
        counting <= '1';
        count <= (others => '0');
        ix <= to_unsigned(PIECES-1, ix'length);
      elsif counting = '1' then
        Busy <= '1';
        count <= count + ONES_TABLE(to_integer(slices(to_integer(ix))));
        ix <= ix - 1;
      end if;
      
      if ix = 0 then
        counting <= '0';
      end if;
    end if;
  end process;
  
  Done <= '1' when ix = 0 else '0';
  Ones_count <= count;
  
end architecture;

