--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# strings_maps.vhdl - Functions for character set operations
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
--#  This package provides types and functions for manipulating character sets.
--#  It is a clone of the Ada'95 package Ada.Strings.Maps.
--------------------------------------------------------------------

package strings_maps is

  --# Array of boolean flag bits indexed by ``character``.
  type character_set is array(character) of boolean;

  --# Inclusive range of characters within the Latin-1 set.
  type character_range is record
    low : character;
    high : character;
  end record;

  --# Collection of character ranges.
  type character_ranges is array( positive range <> ) of character_range;

  --%% Conversion between character sets and ranges
  
  --## Convert ranges to a character set
  --# Args:
  --#  ranges: List of character ranges in the set
  --# Returns:
  --#  A character set with the requested ranges.
  function to_set( ranges : character_ranges ) return character_set;

  --## Convert range to a character set
  --# Args:
  --#  span: Range to build into character set
  --# Returns:
  --#  A character set with the requested range.
  function to_set( span : character_range ) return character_set;
  
  --## Convert a character set into a list of ranges
  --# Args:
  --#  set: Character set to extract ranges from
  --# Returns:
  --#  All contiguous ranges in the set.
  function to_ranges( set : character_set ) return character_ranges;

  -- Operators
  -- The operators "=", "not", "and", "or", and "xor" are implicit

  --## Difference between to character sets
  --# Args:
  --#  left: Set to subtract from
  --#  right: Set to subtract from left
  --# Returns:
  --#  All characters in left not in right.
  function "-" ( left, right : character_set ) return character_set;

  --%% Test for membership in a character set
  
  --## Test if a character is part of a character set
  --# Args:
  --#  element: Character to test for
  --#  set:     Character set to test membership in
  --# Returns:
  --#  true if element is in the set.
  function is_in( element : character; set : character_set ) return boolean;

  --## Test if a character set is a subset of a larget set
  --# Args:
  --#  elements: Character set to test for
  --#  set:     Character set to test membership in
  --# Returns:
  --#  true if elements are in the set.
  function is_subset( elements : character_set; set : character_set ) return boolean;
  alias "<=" is is_subset[character_set, character_set return boolean];

  --# Sequence of characters that compose a character set.
  subtype character_sequence is string;

  --%% Conversion between character sets and sequences
  
  --## Convert a character sequence into a set.
  --# Args:
  --#  sequence: String of characters to build into a set
  --# Returns:
  --#  A character set with all unique characters from sequence.
  function to_set( sequence : character_sequence ) return character_set;
  
  --## Convert a character into a set.
  --# Args:
  --#  singleton: Character to include in the set
  --# Returns:
  --#  A character set with one single character as its member.
  function to_set( singleton : character ) return character_set;

  --## Convert a character set into a sequence string
  --# Args:
  --#  set: Character set to convert
  --# Returns:
  --#  A sequence string with each character from the set.
  function to_sequence( set : character_set ) return character_sequence;

  --# Mapping from one character to another.
  type character_mapping is array(character) of character;

  --## Look up the mapping for a character.
  --# Args:
  --#  cmap:    Map associating Latin-1 characters with a substitute
  --#  element: Character to lookup in the map
  --# Returns:
  --#  The mapped value of the element character.
  function value( cmap : character_mapping; element : character ) return character;
  
  --## Create a mapping from two sequences.
  --# Args:
  --#  from:   Sequence string to use for map indices
  --#  to_seq: Sequence string to use from map values
  --# Returns:
  --#  A new map to convert characters in the from sequence into the to_seq.
  function to_mapping( from, to_seq : character_sequence ) return character_mapping;

  --## Return the from sequence for a mapping.
  --# Args:
  --#  cmap: Character map to extract domain from
  --# Returns:
  --#  The characters used to map from.
  function to_domain( cmap : character_mapping ) return character_sequence;

  --## Return the to_seq sequence for a mapping.
  --# Args:
  --#  cmap: Character map to extract range from
  --# Returns:
  --#  The characters used to map into.
  function to_range( cmap : character_mapping ) return character_sequence;

end package;


package body strings_maps is

-- PRIVATE:
-- ========

  constant NULL_SET : character_set := (others => false);

  function generate_identity_mapping return character_mapping is
    variable result : character_mapping;
  begin
    for ch in character_mapping'range loop
      result(ch) := ch;
    end loop;

    return result;
  end function;

  constant IDENTITY : character_mapping := generate_identity_mapping;



-- PUBLIC:
-- =======

  --## Convert an array of character ranges to a set
  function to_set( ranges : character_ranges ) return character_set is
    variable result : character_set := (others => false);
  begin
    for r in ranges'range loop
      result(ranges(r).low to ranges(r).high) := (others => true);
    end loop;

    return result;
  end function;

  --## Convert a single character range to a set
  function to_set( span : character_range ) return character_set is
    variable result : character_set := (others => false);
  begin
    result(span.low to span.high) := (others => true);
    return result;
  end function;

  --## Convert a character set to a list of ranges
  function to_ranges( set : character_set ) return character_ranges is
    variable max_ranges : character_ranges(1 to set'length/2+1);
    variable ix : natural;
    variable ch : character;
  begin
    ch := character'left;
    ix := 0;

    loop
      while set(ch) = false loop
        exit when ch = character'right;
        ch := character'succ(ch);
      end loop;

      exit when set(ch) = false;

      ix := ix + 1;
      max_ranges(ix).low := ch;

      loop
        exit when set(ch) = false or ch = character'right;
        ch := character'succ(ch);
      end loop;

      if set(ch) = true then
        max_ranges(ix).high := ch;
      else
        max_ranges(ix).high := character'pred(ch);
      end if;

      exit when set(ch) = true or ch = character'right;
    end loop;

    return max_ranges(1 to ix);
  end function;

  --## Subtract right character set from left
  function "-" ( left, right : character_set ) return character_set is
  begin
    return left and (not right);
  end function;

  --## Test for membership in a character set
  function is_in( element : character; set : character_set ) return boolean is
  begin
    return set(element);
  end function;

  --## Test if elements are a subset of set
  function is_subset( elements : character_set; set : character_set ) return boolean is
  begin
    return elements = (elements and set);
  end function;


  --## Convert a character sequence to a set
  function to_set( sequence : character_sequence ) return character_set is
    variable result : character_set := null_set;
  begin
    for i in sequence'range loop
      result(sequence(i)) := true;
    end loop;

    return result;
  end function;

  --## Convert a single character to a set
  function to_set( singleton : character ) return character_set is
    variable result : character_set := null_set;
  begin
    result(singleton) := true;
    return result;
  end function;

  --## Convert a character set to a sequence
  function to_sequence( set : character_set ) return character_sequence is
    variable result : string(1 to character'pos(character'right) + 1);
    variable ix : natural := 0;
  begin
    for ch in set'range loop
      if set(ch) = true then
        ix := ix + 1;
        result(ix) := ch;
      end if;
    end loop;

    return result(1 to ix);
  end function;

  --## Look up the mapping for a character
  function value( cmap : character_mapping; element : character ) return character is
  begin
    return cmap(element);
  end function;

  --## Create a mapping from two sequences
  function to_mapping( from, to_seq : character_sequence ) return character_mapping is
    variable result : character_mapping;
    variable dup_list : character_set := null_set;

    alias fr : character_sequence(1 to from'length) is from;
    alias ts : character_sequence(1 to to_seq'length) is to_seq;
  begin
    assert fr'length = ts'length
      report "Mismatched character sequence lengths"
      severity error;

    result := identity;

    for i in fr'range loop
      assert dup_list(fr(i)) = false
        report "Duplicate character in sequence"
        severity error;

      result(fr(i)) := ts(i);
      dup_list(fr(i)) := true;
    end loop;

    return result;
  end function;

  --## Return the from sequence for a mapping
  function to_domain( cmap : character_mapping ) return character_sequence is
    variable result : string(1 to cmap'length);
    variable ix : natural := 0;
  begin
    for ch in cmap'range loop
      if cmap(ch) /= ch then
        ix := ix + 1;
        result(ix) := ch;
      end if;
    end loop;

    return result(1 to ix);
  end function;

  --## Return the to_seq sequence for a mapping
  function to_range( cmap : character_mapping ) return character_sequence is
    variable result : string(1 to cmap'length);
    variable ix : natural := 0;
  begin
    for ch in cmap'range loop
      if cmap(ch) /= ch then
        ix := ix + 1;
        result(ix) := cmap(ch);
      end if;
    end loop;

    return result(1 to ix);
  end function;

end package body;
