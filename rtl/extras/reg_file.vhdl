--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# reg_file.vhdl - General purpose register file
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2014 Kevin Thibedeau
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
--# DEPENDENCIES: muxing
--#
--# DESCRIPTION:
--#  This package provides a general purpose register file. This version is
--#  implemented in VHDL-93 syntax and the register width is fixed at 16-bits
--#  by default. This source must be modified to alter the size of the
--#  reg_word type if a register size other than 16-bits is needed. The
--#  implementation in reg_file_2008 uses a generic package to avoid this if
--#  tool support for VHDL-2008 is available.
--#
--#  The register file provides an addressable read write port for external
--#  access as well as a set of signals that allow simultaneous access to
--#  registers for internal logic. The register file has a number of special
--#  behaviors controlled by generics.
--#
--#  DIRECT_READ_BIT_MASK is an array of masks that establish which bits of each
--#  register are read directly from internal signals rather than registered
--#  bits. When set to '1' a bit is accessed from the Direct_read port input
--#  rather than the register file on a read operation. The masks permit mixing
--#  these bits with registered bits within the same register. Direct-read
--#  register bits can still be written but their contents can't be read back.
--#  
--#  STROBE_BIT_MASK is an array of masks that establish which bits of each
--#  register are considered "strobe" bits. Strobe bits are self clearing
--#  when a '1' is written to them. There is no effect when '0' is written. They
--#  are used to initiate control actions from a momentary pulsed signal.
--#
--#  The REGISTER_INPUTS generic provides optional registration of the
--#  inputs on the external control port.
--#
--#  Synthesis note: This component creates a wide decoder and mux for
--#  accessing the register file from the external control port. Large register
--#  files will see significant combinational delay from these elements and
--#  care should be taken when using this component in high speed designs.
--#
--# EXAMPLE USAGE:
--#
--#   -- Create a register with 4 16-bit words:
--#   --    0: strobe bits in bit 0 & 1
--#   --    1: normal
--#   --    2: normal
--#   --    3: direct read in bits 7-0
--#
--#   library extras; use extras.reg_file_pkg.all;
--#   use extras.sizing.bit_size;
--#
--#   constant NUM_REGS : natural := 4;
--#   subtype my_reg_array is reg_array(0 to NUM_REGS-1);
--#
--#   constant STROBE_BIT_MASK : my_reg_array := (
--#       0      => X"0003",
--#       1 to 3 => (others => '0')
--#     );
--#
--#   constant DIRECT_READ_BIT_MASK : my_reg_array := (
--#       0|1|2  => (others => '0'), -- Alternate selection of elements with |
--#       3      => X"00FF"
--#     );
--#
--#   signal reg_sel : unsigned(bit_size(NUM_REGS)-1 downto 0);
--#   signal we      : std_ulogic;
--#   signal wr_data, rd_data : reg_word;
--#   signal registers, direct_read : my_reg_array;
--#   signal reg_written : std_ulogic_vector(my_reg_array'range);
--#   ...
--#
--#   rf : reg_file
--#     generic map (
--#       DIRECT_READ_BIT_MASK => DIRECT_READ_BIT_MASK,
--#       STROBE_BIT_MASK      => STROBE_BIT_MASK
--#     )
--#     port map (
--#       Clock => clock,
--#       Reset => reset,
--#
--#       Clear => '0', -- No need to clear the registers
--#
--#       Reg_sel => reg_sel,
--#       We      => we,
--#       Wr_data => wr_data,
--#       Rd_data => rd_data,
--#
--#       Registers   => registers,
--#       Direct_Read => direct_read,
--#       Reg_written => reg_written
--#     );
--#
--#   ...
--#
--#   pulse_control <= registers(0)(0); -- Access strobe bit-0
--#
--#   -- direct_read must be fully assigned (unused parts will optimize away
--#   -- in synthesis)
--#   direct_read(0 to 2) <= (others => (others => '0'));
--#   direct_read(3)(7 downto 0) <= internal_byte; -- Connect internal signal
--#   direct_read(3)(15 downto 8) <= (others => '0');
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package reg_file_pkg is

  -- ******************************************************************
  -- Redefine this subtype as needed to suit the required register size
  -- ******************************************************************

  --## Register word vector. Modify this to use different word sizes.
  subtype reg_word is std_ulogic_vector(15 downto 0);

  --## Array of register words.
  type reg_array is array(natural range <>) of reg_word;

  --# Flexible register file with support for strobed outputs.
  component reg_file is
    generic (
      RESET_ACTIVE_LEVEL : std_ulogic := '1'; --# Asynch. reset control level
      DIRECT_READ_BIT_MASK : reg_array;  --# Masks indicating which register bits are directly read
      STROBE_BIT_MASK      : reg_array;  --# Masks indicating which register bits clear themselves after a write of '1'
      REGISTER_INPUTS    : boolean := true  --# Register the input ports when true
      );
    port (
      --# {{clocks|}}
      Clock : in std_ulogic;           --# System clock
      Reset : in std_ulogic;           --# Asynchronous reset

      --# {{control|}}
      Clear : in std_ulogic;            --# Initialize all registers to '0'

      -- Addressable external control port
      --# {{data|Addressed port}}
      Reg_sel : in  unsigned;           --# Register address for write and read 
      We      : in  std_ulogic;         --# Write to selected register
      Wr_data : in  reg_word;           --# Write port
      Rd_data : out reg_word;           --# Read port

      -- Internal file contents
      --# {{Registers}}
      Registers   : out reg_array;  --# Register file contents
      Direct_read : in  reg_array;  --# Read-only signals direct from external logic
      Reg_written : out std_ulogic_vector  --# Status flags indicating when each register is written
      );
  end component;
end package;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library extras;
use extras.reg_file_pkg.all;
use extras.muxing.decode;

entity reg_file is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic := '1';
    DIRECT_READ_BIT_MASK : reg_array;  -- Masks indicating which register bits are directly read
    STROBE_BIT_MASK      : reg_array;  -- Masks indicating which register bits clear themselves after a write of '1'
    REGISTER_INPUTS    : boolean := true  -- Register the input ports when true
    );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Clear : in std_ulogic;            -- Initialize all registers to '0'

    -- Addressable external control port
    Reg_sel : in  unsigned;           -- Register address for write and read 
    We      : in  std_ulogic;         -- Write to selected register
    Wr_data : in  reg_word;           -- Write port
    Rd_data : out reg_word;           -- Read port

    -- Internal file contents
    Registers   : out reg_array;  -- Register file contents
    Direct_read : in  reg_array;  -- Read-only signals direct from external logic
    Reg_written : out std_ulogic_vector  -- Status flags indicating when each register is written
    );
end entity;

architecture rtl of reg_file is
  signal reg_sel_reg   : unsigned(Reg_sel'range);
  signal we_reg     : std_logic;
  -- Resolved type to avoid warnings in generate blocks
  signal wr_data_reg   : std_logic_vector(reg_word'range);
  signal registers_loc : reg_array(Registers'range);
begin

  ri : if REGISTER_INPUTS generate
    process(Clock, Reset) is
    begin
      if Reset = RESET_ACTIVE_LEVEL then
        reg_sel_reg <= (others => '0');
        we_reg      <= '0';
        wr_data_reg <= (others => '0');
      elsif rising_edge(Clock) then
        reg_sel_reg <= Reg_sel;
        we_reg      <= We;
        wr_data_reg <= to_stdlogicvector(Wr_data);
      end if;
    end process;
  end generate;

  nri : if not REGISTER_INPUTS generate
    reg_sel_reg <= Reg_sel;
    we_reg   <= We;
    wr_data_reg <= to_stdlogicvector(Wr_data);
  end generate;

  process(Clock, Reset) is
    variable mux_val        : reg_word;
    variable reg_sel_onehot : std_ulogic_vector(Registers'range);
  begin

    if Reset = RESET_ACTIVE_LEVEL then
      registers_loc <= (others            => (others => '0'));
      Reg_written   <= (Reg_written'range => '0');
      Rd_data       <= (others            => '0');
    elsif rising_edge(Clock) then
      reg_sel_onehot := decode(reg_sel_reg, reg_sel_onehot'length);

      -- Write control
      if Clear = '1' then
        registers_loc <= (others => (others => '0'));
      else
        for i in Registers'range loop
          if we_reg = '1' and reg_sel_onehot(i) = '1' then
            registers_loc(i) <= to_stdulogicvector(wr_data_reg);
            Reg_written(i)   <= '1';
          else -- Not writing
            -- Clear bits defined as strobes
            registers_loc(i) <= registers_loc(i) and not STROBE_BIT_MASK(i);
            Reg_written(i)   <= '0';
          end if;
        end loop;

      end if;

      -- Read control
      for i in Registers'range loop
        if reg_sel_onehot(i) = '1' then
          -- Bitwise mux
          -- This generates no logic and just implements wiring to select whether
          -- each Rd_data bit comes from the internal register or direct from the
          -- Direct_read signals
          mux_val := (Direct_read(i) and DIRECT_READ_BIT_MASK(i))
                     or (registers_loc(i) and not DIRECT_READ_BIT_MASK(i));

          Rd_data <= mux_val;
        end if;
      end loop;

    end if;

  end process;

  Registers <= registers_loc;

end architecture;
