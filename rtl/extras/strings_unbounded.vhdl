--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# strings_unbounded.vhdl - A library for unbounded length strings
--# $Id$
--# Freely available from VHDL-extras (http://code.google.com/p/vhdl-extras)
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
--# DEPENDENCIES: strings strings_maps strings_fixed
--#
--# DESCRIPTION:
--#  This package provides a string library for operating on unbounded length
--#  strings. This is a clone of the Ada'95 library Ada.Strings.Unbounded. Due
--#  to the VHDL restriction on using access types as function parameters only
--#  a limited subset of the Ada library is reproduced. The unbounded strings
--#  are represented by the subtype string_acc which is derived from line to
--#  ease interoperability with std.textio. line and string_acc are of type
--#  access to string. Their contents are dynamically allocated. Because
--#  operators cannot be provided, a new set of "copy" procedures are included
--#  to simplify duplication of an existing unbounded string.
--------------------------------------------------------------------

library std;
use std.textio.all;

library extras;
use extras.strings.all;
use extras.strings_maps.all;

package strings_unbounded is
  -- create a subtype of the textio line type to form a coupling between libraries
  subtype string_acc is line;

  --## Convert a string to string_acc
  function to_string_acc( source : string )  return string_acc;

  --## Allocate a string of length
  function to_string_acc( length : natural ) return string_acc;

  --## Copy a string_acc to the string dest
  procedure to_string( variable source : in string_acc; dest : out string );

  --## Create an empty string_acc
  procedure initialize( source : inout string_acc );

  --## Free allocated memory for source
  procedure free( source : inout string_acc );

  --## Return the length of a string_acc
  procedure length( variable source : in string_acc; len : out natural );

  --## Copy at most max characters from source to the unallocated dest
  procedure copy( variable source : in string_acc; dest : inout string_acc;
    max : in integer := -1 );

  --## Copy at most max characters from source to the unallocated dest
  procedure copy( source : in string; dest : inout string_acc; max : in integer := -1 );

  --## Append string_acc new_item to source
  procedure append( source : inout string_acc; variable new_item : in string_acc );

  --## Append string new_item to source
  procedure append( source : inout string_acc; new_item : in string );

  --## Append character new_item to source
  procedure append( source : inout string_acc; new_item : in character );

  --## Lookup the character in source at index
  procedure element( variable source : in string_acc; index : in positive; el : out character );

  --## Replace the character in source at index with by
  procedure replace_element( source : inout string_acc; index : in positive; by : in character );

  --## Extract a slice from source
  procedure slice( variable source : in string_acc; low : in positive; high : in positive;
    result : inout string_acc );

  --## Test if left is identical to right
  procedure eq( variable left : in string_acc; variable right : in string_acc;
    result : out boolean );

  --## Test if left is identical to right
  procedure eq( variable left : in string_acc; right : in string; result : out boolean );


  -- Procedures derived from equivalents in strings_fixed:
  -- =====================================================

  --## Count the occurances of pattern in source
  procedure count( variable source : in string_acc; pattern : in string;
    val : out natural );

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  procedure delete( source : inout string_acc; from : in positive;
    through : in natural );

  --## Return the indices of a slice of source that satisfys the membership
  --#  selection for the character set.
  procedure find_token( variable source : in string_acc; set : in character_set; test : in membership;
    first : out positive; last : out natural );

  --## Return the first count characters from source
  procedure head( source : inout string_acc; count : in natural;
    pad : in character := ' ');

  --## Insert the string new_item before the selected index in source
  procedure insert( source : inout string_acc; before : in positive;
    new_item : in string );

  --## Overwrite new_item into source starting at the selected position
  procedure overwrite( source : inout string_acc; position : in positive;
    new_item : in string );

  --## Replace a slice of the source string with the contents of by
  procedure replace_slice( source : inout string_acc; low : in positive; high : in natural;
    by : in string );

  --## Return the last count characters from source
  procedure tail( source : inout string_acc; count : in natural;
    pad : in character := ' ' );

  --## Convert a source string with the provided character mapping
  procedure translate( source : inout string_acc; mapping : in character_mapping );

  --## Remove space characters from leading, trailing, or both ends of source
  procedure trim( source : inout string_acc; side : in trim_end );

  --## Remove all leading characters in left and trailing characters in left
  --#  from source
  procedure trim( source : inout string_acc; left : in character_set; right : in character_set);

end package;


library extras;
use extras.strings_fixed.all;

package body strings_unbounded is

  --## Convert a string to string_acc
  function to_string_acc( source : string ) return string_acc is
  begin
    return new string'(source);
  end function;

  --## Allocate a string of length
  function to_string_acc( length : natural ) return string_acc is
  begin
    return new string(1 to length);
  end function;

  --## Copy a string_acc to the string dest
  procedure to_string( variable source : in string_acc; dest : out string )is
  begin
    dest := source.all;
  end procedure;

  --## Create an empty string_acc
  procedure initialize( source : inout string_acc ) is
  begin
    deallocate(source);
    source := new string'("");
  end procedure;

  --## Free allocated memory for source
  procedure free( source : inout string_acc ) is
  begin
    deallocate(source);
  end procedure;

  --## Return the length of a string_acc
  procedure length( variable source : in string_acc; len : out natural ) is
  begin
    assert source /= null
      report "Null string"
      severity error;
    len := source'length;
  end procedure;

  --## Copy at most max characters from source to the unallocated dest
  procedure copy( source : in string; dest : inout string_acc; max : in integer := -1 ) is
    variable size : positive;
  begin

    if max >= 0 and max <= source'length then
      size := max;
    else
      size := source'length;
    end if;

    if size = 0 then
      dest := new string'("");
    else
      dest := new string'(source(1 to size));
    end if;

  end procedure;

  --## Copy at most max characters from source to the unallocated dest
  procedure copy( variable source : in string_acc; dest : inout string_acc;
    max : in integer := -1 ) is

    variable size : positive;
  begin
    assert source /= null
      report "Null string"
      severity error;

    if max >= 0 and max <= source'length then
      size := max;
    else
      size := source'length;
    end if;

    if size = 0 then
      dest := new string'("");
    else
      dest := new string'(source(1 to size));
    end if;

  end procedure;


  --## Append string_acc new_item to source
  procedure append( source : inout string_acc; variable new_item : in string_acc ) is
    variable size : natural;
    variable sa : string_acc;
  begin
    if source = null or source'length = 0 then -- copy new_item
      if new_item /= null and new_item'length > 0 then
        sa := new string'(new_item.all);
        deallocate(source);
        source := sa;
      end if;
    elsif new_item /= null and new_item'length > 0 then
      size := source'length + new_item'length;
      sa := new string(1 to size);
      sa(source'range) := source.all;
      sa(source'high+1 to size) := new_item.all;
      deallocate(source);
      source := sa;
    end if;
  end procedure;

  --## Append string new_item to source
  procedure append( source : inout string_acc; new_item : in string ) is
    variable size : natural;
    variable sa : string_acc;
  begin
    if source = null or source'length = 0 then -- copy new_item
      if new_item'length > 0 then
        sa := new string'(new_item);
        deallocate(source);
        source := sa;
      end if;
    elsif new_item'length > 0 then
      size := source'length + new_item'length;
      sa := new string(1 to size);
      sa(source'range) := source.all;
      sa(source'high+1 to size) := new_item;
      deallocate(source);
      source := sa;
    end if;
  end procedure;

  --## Append character new_item to source
  procedure append( source : inout string_acc; new_item : in character ) is
    variable size : natural;
    variable sa : string_acc;
  begin
    if source = null or source'length = 0 then -- copy new_item
      sa := new string'("" & new_item);
      deallocate(source);
      source := sa;
    else
      size := source'length + 1;
      sa := new string(1 to size);
      sa(source'range) := source.all;
      sa(size) := new_item;
      deallocate(source);
      source := sa;
    end if;
  end procedure;

  --## Lookup the character in source at index
  procedure element( variable source : in string_acc; index : in positive; el : out character ) is
  begin
    if source = null then
      report "Null string"
        severity error;
      el := nul;
    elsif index <= source'high then
      el := source(index);
    else
      report "Index out of bounds"
        severity error;
      el := nul;
    end if;
  end procedure;

  --## Replace the character in source at index with by
  procedure replace_element( source : inout string_acc; index : in positive; by : in character ) is
  begin
    assert source /= null and index <= source'length
      report "Null string or invalid index"
      severity error;

    source(index) := by;
  end procedure;

  --## Extract a slice from source
  procedure slice( variable source : in string_acc; low : in positive; high : in positive;
    result : inout string_acc ) is
  begin
    assert source /= null
      report "Null string"
      severity error;

    if low > source'length+1 or high > source'length then
      report "Index out of bounds"
      severity error;
    else
      result := new string'(source(low to high));
    end if;
  end procedure;

  --## Test if left is identical to right
  procedure eq( variable left : in string_acc; variable right : in string_acc;
    result : out boolean ) is
  begin
    if left /= null and right /= null then
      result := left.all = right.all;
    elsif left = null and right = null then -- both null
      result := true;
    else -- one is null
      result := false;
    end if;
  end procedure;

  --## Test if left is identical to right
  procedure eq( variable left : in string_acc; right : in string; result : out boolean ) is
  begin
    if left /= null then
      result := left.all = right;
    else
      result := false;
    end if;
  end procedure;


  -- Procedures derived from equivalents in strings_fixed:
  -- =====================================================

  --## Count the occurances of pattern in source
  procedure count( variable source : in string_acc; pattern : in string;
    val : out natural ) is
  begin
    val := count(source.all, pattern);
  end procedure;

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  procedure delete( source : inout string_acc; from : in positive;
    through : in natural ) is

    variable old : string_acc := source;
  begin
    source := new string'(delete(old.all, from, through));
    deallocate(old);
  end procedure;

  --## Return the indices of a slice of source that satisfys the membership
  --#  selection for the character set.
  procedure find_token( variable source : in string_acc; set : in character_set; test : in membership;
    first : out positive; last : out natural ) is
  begin
    find_token(source.all, set, test, first, last);
  end procedure;

  --## Return the first count characters from source
  procedure head( source : inout string_acc; count : in natural;
    pad : in character := ' ') is

    variable old : string_acc := source;
  begin
    source := new string'(head(old.all, count, pad));
    deallocate(old);
  end procedure;

  --## Insert the string new_item before the selected index in source
  procedure insert( source : inout string_acc; before : in positive;
    new_item : in string ) is

    variable old : string_acc := source;
  begin
    source := new string'(insert(old.all, before, new_item));
    deallocate(old);
  end procedure;

  --## Overwrite new_item into source starting at the selected position
  procedure overwrite( source : inout string_acc; position : in positive;
    new_item : in string ) is

    variable old : string_acc := source;
  begin

    if position <= source'length - new_item'length + 1 then
      source(position to position + new_item'length - 1) := new_item;
    else
      source := new string'(overwrite(old.all, position, new_item));
      deallocate(old);
    end if;

  end procedure;

  --## Replace a slice of the source string with the contents of by
  procedure replace_slice( source : inout string_acc; low : in positive; high : in natural;
    by : in string ) is

    variable old : string_acc := source;
  begin
    source := new string'(replace_slice(old.all, low, high, by));
    deallocate(old);
  end procedure;

  --## Return the last count characters from source
  procedure tail( source : inout string_acc; count : in natural;
    pad : in character := ' ' ) is

    variable old : string_acc := source;
  begin
    source := new string'(tail(old.all, count, pad));
    deallocate(old);
  end procedure;

  --## Convert a source string with the provided character mapping
  procedure translate( source : inout string_acc; mapping : in character_mapping ) is
  begin
    translate(source.all, mapping);
  end procedure;

  --## Remove space characters from leading, trailing, or both ends of source
  procedure trim( source : inout string_acc; side : in trim_end ) is
    variable old : string_acc := source;
  begin
    source := new string'(trim(old.all, side));
    deallocate(old);
  end procedure;


  --## Remove all leading characters in left and trailing characters in left
  --#  from source
  procedure trim( source : inout string_acc; left : in character_set; right : in character_set) is
    variable old : string_acc := source;
  begin
    source := new string'(trim(old.all, left, right));
    deallocate(old);
    report integer'image(integer'value("12_3"));
  end procedure;

end package body;
