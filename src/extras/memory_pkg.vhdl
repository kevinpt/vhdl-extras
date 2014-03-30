--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# memory_pkg.vhdl - Generic memories
--# $Id$
--# Freely available from VHDL-extras (http://code.google.com/p/vhdl-extras)
--#
--# Copyright © 2014 Kevin Thibedeau
--# (kevin 'dot' thibedeau 'at' gmail 'punto' com)
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
--#  This package provides general purpose components for inferred RAM and ROM.
--#  These memories share a SYNC_READ generic which will optionally generate synchronous
--#  or asynchronous read ports for each instance. On Xilinx devices asynchronous
--#  read forces the synthesis of distributed RAM using LUTs rather than BRAMs.
--#
--#  The ROM component gets its contents using synthesizable file IO to read a list
--#  of binary or hex values.
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package memory_pkg is

  component dual_port_ram is
    generic (
      MEM_SIZE  : positive;
      SYNC_READ : boolean := true
    );
    port (
      Wr_clock : in std_ulogic;
      We       : in std_ulogic;
      Wr_addr  : in natural range 0 to MEM_SIZE-1;
      Wr_data  : in std_ulogic_vector;

      Rd_clock : in std_ulogic;
      Re       : in std_ulogic;
      Rd_addr  : in natural range 0 to MEM_SIZE-1;
      Rd_data  : out std_ulogic_vector
    );
  end component;

  type rom_format is (BINARY_TEXT, HEX_TEXT);

  component rom is
    generic (
      ROM_FILE  : string;
      FORMAT    : rom_format;
      MEM_SIZE  : positive;
      SYNC_READ : boolean := true
    );
    port (
      Clock : in std_ulogic;
      Re    : in std_ulogic;
      Addr  : in natural range 0 to MEM_SIZE-1;
      Data  : out std_ulogic_vector
    );
  end component;


end package;



library ieee;
use ieee.std_logic_1164.all;

entity dual_port_ram is
  generic (
    MEM_SIZE  : positive;
    SYNC_READ : boolean := true
  );
  port (
    Wr_clock : in std_ulogic;
    We       : in std_ulogic;
    Wr_addr  : in natural range 0 to MEM_SIZE-1;
    Wr_data  : in std_ulogic_vector;

    Rd_clock : in std_ulogic;
    Re       : in std_ulogic;
    Rd_addr  : in natural range 0 to MEM_SIZE-1;
    Rd_data  : out std_ulogic_vector
  );
end entity;

architecture rtl of dual_port_ram is
  type ram_type is array (0 to MEM_SIZE-1) of std_ulogic_vector(Wr_data'length-1 downto 0);
  signal ram : ram_type;

  signal sync_rdata : std_ulogic_vector(Rd_data'range);
begin

  wr: process(Wr_clock)
  begin
    if rising_edge(Wr_clock) then
      if We = '1' then
        ram(Wr_addr) <= Wr_data;
      end if;
    end if;
  end process;

  sread: if SYNC_READ = true generate
  rd: process(Rd_clock)
  begin
    if rising_edge(Rd_clock) then
      if Re = '1' then
        sync_rdata <= ram(Rd_addr);
      end if;
    end if;
  end process;
  end generate;

  Rd_data <= ram(Rd_addr) when SYNC_READ = false else sync_rdata;

end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;
use ieee.std_logic_textio.all;

use std.textio.all;

library extras;
use extras.memory_pkg.all;

entity rom is
  generic (
    ROM_FILE  : string;
    FORMAT    : rom_format;
    MEM_SIZE  : positive;
    SYNC_READ : boolean := true
  );
  port (
    Clock : in std_ulogic;
    Re    : in std_ulogic;
    Addr  : in natural range 0 to MEM_SIZE-1;
    Data  : out std_ulogic_vector
  );
end entity;

architecture rtl of rom is
  type rom_type is array (0 to MEM_SIZE-1) of bit_vector(Data'length-1 downto 0);

  procedure char_to_hex(ch: in character; nibble: out bit_vector(3 downto 0)) is
    variable cp, val : integer;
  begin
    cp := character'pos(ch);
    val := 0;
    if cp >= character'pos('0') or cp <= character'pos('9') then
      val := cp - character'pos('0');
    elsif cp >= character'pos('A') or cp <= character'pos('F') then
      val := cp - character'pos('A');
    elsif cp >= character'pos('a') or cp <= character'pos('f') then
      val := cp - character'pos('a');
    end if;

    nibble := bit_vector(to_unsigned(val, 4));
  end procedure;

  procedure read_hex(l: inout line; hex: out bit_vector) is
    variable ch: character;
    variable nibble : bit_vector(3 downto 0);
    variable h: bit_vector(hex'length-1 downto 0) := (others => '0');
    variable i : natural := h'left;
    variable good : boolean;
  begin
    loop
      read(l, ch, good);
      exit when ch /= ' ' and ch /= CR and ch /= HT;
    end loop;

    --while l.all'length > 0 loop
    --for x in 1 to 3 loop
    --for x in l'length / 4 loop
    while good loop
      char_to_hex(ch, nibble);

      h := h(h'left-4 downto 0) & nibble;
      i := i - 4;

      exit when i < 0;

      read(l, ch, good);
    end loop;

    hex := h;
  end procedure;

  impure function init_rom(File_name: in string; format: in rom_format) return rom_type is
    file fh : text open read_mode is File_name;
    variable ln : line;
    variable hex : std_logic_vector(Data'range);
    variable rom_v : rom_type;
  begin
    for a in rom_type'range loop
      readline(fh, ln);

      if format = HEX_TEXT then
        --read_hex(ln, rom_v(a));
        hread(ln, hex);
        rom_v(a) := to_bitvector(hex);
      else -- binary text
        read(ln, rom_v(a));
      end if;
    end loop;
    
    return rom_v;
  end function;

  signal rom_mem : rom_type := init_rom(ROM_FILE, FORMAT);

  signal sync_rdata : std_ulogic_vector(Data'range);
begin

  rd: process(Clock)
  begin
    if rising_edge(Clock) then
      if Re = '1' then
        sync_rdata <= to_stdulogicvector(rom_mem(Addr));
      end if;
    end if;
  end process;

  Data <= to_stdulogicvector(rom_mem(Addr)) when SYNC_READ = false else sync_rdata;

end architecture;
