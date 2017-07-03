--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# binaryio.vhdl - Procedures for binary file I/O
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
--#  This package provides procedures to perform general purpose binary I/O on
--#  files. The number of bytes read or written is controlled by the width of
--#  array passed to the procedures. An endianness parameter determines the byte
--#  order. These procedures do not handle packed binary data. Reading and
--#  writing arrays that are not multiples of 8 in length will consume or
--#  produce additional padding bits in the file. Sign extension is performed
--#  when writing padded signed arrays.
--#
--# EXAMPLE USAGE:
--#  file fh : octet_file open read_mode is "foo.bin";
--#  signal uword : unsigned(15 downto 0);
--#  signal sword : signed(19 downto 0);
--#  ...
--#  read(fh, little_endian, uword); -- read 16 bits from two octets
--#  read(fh, big_endian, sword);    -- read 20 bits from three octets
--------------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

package binaryio is

  -- Define octet as a character type to avoid issues with simulators
  -- that read and write metadata to binary files of integer types
  alias octet is character;

  --# File of 8-bit bytes.
  type octet_file is file of octet;

  --# Endianness of multi-byte words.
  --#
  --# * little-endian = least significant octet first : 1234, 123, etc.
  --# * big-endian    = most significant octet first  : 4321, 321, etc.
  type endianness is ( little_endian, big_endian );

  --%% Binary read and write procedures 
  
  --## Read binary data into an unsigned vector.
  --# Args:
  --#  Fh:          File handle
  --#  Octet_order: Endianness of the octets
  --#  Word:        Data read from the file
  procedure read( file Fh : octet_file; Octet_order : endianness; Word : out unsigned );

  --## Read binary data into a signed vector.
  --# Args:
  --#  Fh:          File handle
  --#  Octet_order: Endianness of the octets
  --#  Word:        Data read from the file
  procedure read( file Fh : octet_file; Octet_order : endianness; Word : out signed );

  --## Write an unsigned vector to a file.
  --# Args:
  --#  Fh:          File handle
  --#  Octet_order: Endianness of the octets
  --#  Word:        Data to write into the file
  procedure write( file Fh : octet_file; Octet_order : endianness; Word : unsigned );

  --## Write a signed vector to a file.
  --# Args:
  --#  Fh:          File handle
  --#  Octet_order: Endianness of the octets
  --#  Word:        Data to write into the file. Will be sign extended if not a multiple of 8-bits.
  procedure write( file Fh : octet_file; Octet_order : endianness; Word : signed );

end package;

package body binaryio is

  type octet_vector is array (natural range <>) of octet;

  --## Read an unsigned value
  procedure read( file Fh : octet_file; Octet_order : endianness;
    Word : out unsigned ) is
    
    constant NUM_OCTETS : positive := (Word'length - 1)/8 + 1;
    variable octets : octet_vector(1 to NUM_OCTETS);
    variable bv : unsigned(NUM_OCTETS*8-1 downto 0);
    variable bit_pos : integer;
  begin

    -- read octets
    for i in octets'range loop
      if not endfile(Fh) then
        read(Fh, octets(i));
      else
        report "End of file reached before read completed"
          severity error;
        exit;
      end if;
    end loop;

    bit_pos := bv'left;
    if Octet_order = little_endian then
      for i in octets'reverse_range loop
        bv(bit_pos downto bit_pos-7) := to_unsigned(octet'pos(octets(i)), 8);
        bit_pos := bit_pos - 8;
      end loop;
    else -- big-endian
      for i in octets'range loop
        bv(bit_pos downto bit_pos-7) := to_unsigned(octet'pos(octets(i)), 8);
        bit_pos := bit_pos - 8;
      end loop;
    end if;

    Word := resize(bv, Word'length);

  end procedure;

  --## Read a signed value
  procedure read( file Fh : octet_file; Octet_order : endianness; Word : out signed ) is

    constant NUM_OCTETS : positive := (Word'length - 1)/8 + 1;
    variable word_uns : unsigned(NUM_OCTETS*8-1 downto 0);
  begin
    read(Fh, Octet_order, word_uns);
    
    -- convert to signed with possible sign extension
    Word := resize(signed(word_uns), Word'length);

  end procedure;


  --## Write an unsigned value
  procedure write( file Fh : octet_file; Octet_order : endianness;
    Word : unsigned ) is

    constant NUM_OCTETS : positive := (Word'length - 1)/8 + 1;
    variable word_aligned : unsigned(NUM_OCTETS*8-1 downto 0);
    variable octets : octet_vector(1 to NUM_OCTETS);
  begin
    word_aligned := resize(Word, word_aligned'length);

    for i in octets'range loop
      octets(i) := octet'val(to_integer(word_aligned((i*8)-1 downto (i-1)*8)));
    end loop;
    
    if Octet_order = little_endian then
      for i in octets'range loop
        write(Fh, octets(i));
      end loop;
    else -- big-endian
      for i in octets'reverse_range loop
        write(Fh, octets(i));
      end loop;
    end if;
    
  end procedure;

  --## Write a signed value
  procedure write( file Fh : octet_file; Octet_order : endianness; Word : signed ) is
    constant NUM_OCTETS : positive := (Word'length - 1)/8 + 1;
    variable word_aligned : signed(NUM_OCTETS*8-1 downto 0);
  begin

    -- perform any sign extension  
    word_aligned := resize(Word, word_aligned'length);

    write(Fh, Octet_order, unsigned(word_aligned));

  end procedure;

end package body;
