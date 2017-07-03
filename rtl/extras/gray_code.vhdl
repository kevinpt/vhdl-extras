--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# gray_code.vhdl - Functions for Gray code conversions
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
--#  This package provides functions to convert between Gray code and binary.
--#  An example implementation of a Gray code counter is also included.
--#
--#  EXAMPLE USAGE:
--#    -- Conversion functions
--#    signal bin, gray, bin2 : std_ulogic_vector(7 downto 0);
--#    ...
--#    bin  <= X"C5";
--#    gray <= to_gray(bin);
--#    bin2 <= to_binary(gray);
--#
--#    
--#    -- Gray code counter
--#    gc: gray_counter
--#      port map (
--#        Clock       => clock,
--#        Reset       => reset,
--#        Load        => '0', -- Not using load feature
--#        Enable      => '1', -- Count continuously
--#        Binary_load => (binary_count'range => '0'), -- Unused load port
--#        Binary      => binary_count, -- Internal binary count value
--#        Gray        => gray_count    -- Gray coded count
--#    );
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package gray_code is
  --## Convert binary to Gray code.
  --# Args:
  --#  Binary: Binary value
  --# Returns:
  --#  Gray-coded vector.
  function to_gray( Binary : std_ulogic_vector ) return std_ulogic_vector;
  
  --## Convert binary to Gray code.
  --# Args:
  --#  Binary: Binary value
  --# Returns:
  --#  Gray-coded vector.
  function to_gray( Binary : std_logic_vector )  return std_logic_vector;
  
  --## Convert binary to Gray code.
  --# Args:
  --#  Binary: Binary value
  --# Returns:
  --#  Gray-coded vector.
  function to_gray( Binary : unsigned ) return unsigned;

  --## Convert Gray code to binary.
  --# Args:
  --#  Binary: Gray-coded value
  --# Returns:
  --#  Decoded binary value.
  function to_binary( Gray : std_ulogic_vector ) return std_ulogic_vector;
  
  --## Convert Gray code to binary.
  --# Args:
  --#  Binary: Gray-coded value
  --# Returns:
  --#  Decoded binary value.
  function to_binary( Gray : std_logic_vector )  return std_logic_vector;
  
  --## Convert Gray code to binary.
  --# Args:
  --#  Binary: Gray-coded value
  --# Returns:
  --#  Decoded binary value.
  function to_binary( Gray : unsigned ) return unsigned;

  --## An example Gray code counter implementation. This counter maintains an
  --#  internal binary register and converts its output to Gray code stored in a
  --#  separate register.
  component gray_counter is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1' --# Asynch. reset control level
    );
    port (
      --# {{clocks|}}
      Clock  : in std_ulogic; --# System clock
      Reset  : in std_ulogic; --# Asynchronous reset
      
      --# {{control|}}
      Load   : in std_ulogic; --# Synchronous load, active high
      Enable : in std_ulogic; --# Synchronous enable, active high
      
      --# {{data|}}
      Binary_load : in unsigned; --# Loadable binary value
      Binary : out unsigned;     --# Binary count
      Gray   : out unsigned      --# Gray code count
    );
  end component;

end package;

package body gray_code is

  --## Convert binary to Gray code
  function to_gray( Binary : std_ulogic_vector ) return std_ulogic_vector is
    alias b : std_ulogic_vector(Binary'length-1 downto 0) is Binary;
    variable result : std_ulogic_vector(b'range);
  begin
    result := b xor ('0' & b(b'high downto 1));

    return result;
  end function;

  function to_gray( Binary : std_logic_vector ) return std_logic_vector is
  begin
    return to_stdlogicvector(to_gray(to_stdulogicvector(Binary)));
  end function;

  function to_gray( Binary : unsigned ) return unsigned is
  begin
    return unsigned(to_stdlogicvector(
      to_gray(to_stdulogicvector(std_logic_vector(Binary)))
    ));
  end function;


  --## Convert Gray code to binary
  function to_binary( Gray : std_ulogic_vector ) return std_ulogic_vector is
    alias g : std_ulogic_vector(Gray'length-1 downto 0) is Gray;
    variable result : std_ulogic_vector(g'range);
  begin
    result(result'high) := g(g'high);

    for i in g'high-1 downto 0 loop
      result(i) := g(i) xor result(i+1);
    end loop;

    return result;
  end function;

  function to_binary( Gray : std_logic_vector ) return std_logic_vector is
  begin
    return to_stdlogicvector(to_binary(to_stdulogicvector(Gray)));
  end function;

  function to_binary( Gray : unsigned ) return unsigned is
  begin
    return unsigned(to_stdlogicvector(
      to_binary(to_stdulogicvector(std_logic_vector(Gray)))
    ));
  end function;

end package body;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.gray_code.to_gray;

--## An example Gray code counter implementation. This counter maintains an
--#  internal binary register and converts its output to Gray code stored in a
--#  separate register.
entity gray_counter is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1'
  );
  port (
    Clock  : in std_ulogic;
    Reset  : in std_ulogic; -- Asynchronous reset
    Load   : in std_ulogic; -- Synchronous load, active high
    Enable : in std_ulogic; -- Synchronous enable, active high

    Binary_load : in unsigned; -- Loadable binary value
    Binary : out unsigned;     -- Binary count
    Gray   : out unsigned      -- Gray code count
  );
end entity;

architecture rtl of gray_counter is
  signal c : unsigned(Binary'length-1 downto 0);
begin
  bc: process(Clock, Reset)
    variable nc : unsigned(Binary'length-1 downto 0);
  begin
    if Reset = RESET_ACTIVE_LEVEL then
      c <= (others => '0');
      Gray <= (Gray'range => '0');
    elsif rising_edge(Clock) then
      if Load = '1' then
        c <= Binary_load;
      elsif Enable = '1' then
        nc := c + 1;
        c <= nc;

        Gray <= to_gray(nc);
      end if;
    end if;
  end process;

  Binary <= c;

end architecture;
