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
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010, 2015 Kevin Thibedeau
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
--#  are represented by the subtype unbounded_string which is derived from line
--#  to ease interoperability with std.textio. line and unbounded_string are of
--#  type access to string. Their contents are dynamically allocated. Because
--#  operators cannot be provided, a new set of "copy" procedures are included
--#  to simplify duplication of an existing unbounded string.
--------------------------------------------------------------------

library std;
use std.textio.all;

library extras;
use extras.strings.all;
use extras.strings_maps.all;

package strings_unbounded is
  --## A subtype of the textio ``line`` type to form a coupling between libraries.
  subtype unbounded_string is line;

  --## Convert a string to unbounded_string.
  --# Args:
  --#  source: String to convert into unbounded_string
  --# Returns:
  --#  A converted string.
  function to_unbounded_string( source : string )  return unbounded_string;

  --## Allocate a string of length.
  --# Args:
  --#  length: Length of the new string
  --# Returns:
  --#  A new string of the requested length.
  function to_unbounded_string( length : natural ) return unbounded_string;

  --## Copy a unbounded_string to the string dest.
  --# Args:
  --#  source: String to copy
  --#  dest: Copy destination
  procedure to_string( variable source : in unbounded_string; dest : out string );

  --## Create an empty unbounded_string.
  --# Args:
  --#  source: String to initialize
  procedure initialize( source : inout unbounded_string );

  --## Free allocated memory for source.
  --# Args:
  --#  source: Deallocate an unbounded_string
  procedure free( source : inout unbounded_string );

  --## Return the length of a unbounded_string.
  --# Args:
  --#  source: String to check length of
  --#  len: Length of the string
  procedure length( variable source : in unbounded_string; len : out natural );

  --## Copy at most max characters from source to the unallocated dest.
  --# Args:
  --#  source: String to copy
  --#  dest:   Destination of copy
  --#  max:    Maximum number of characters to copy
  procedure copy( variable source : in unbounded_string; dest : inout unbounded_string;
    max : in integer := -1 );

  --## Copy at most max characters from source to the unallocated dest.
  --# Args:
  --#  source: String to copy
  --#  dest:   Destination of copy
  --#  max:    Maximum number of characters to copy
  procedure copy( source : in string; dest : inout unbounded_string; max : in integer := -1 );

  --## Append unbounded_string new_item to source.
  --# Args:
  --#  source:   String to append onto
  --#  new_item: String to append
  procedure append( source : inout unbounded_string; variable new_item : in unbounded_string );

  --## Append string new_item to source.
  --# Args:
  --#  source:   String to append onto
  --#  new_item: String to append
  procedure append( source : inout unbounded_string; new_item : in string );

  --## Append character new_item to source.
  --# Args:
  --#  source:   String to append onto
  --#  new_item: Character to append
  procedure append( source : inout unbounded_string; new_item : in character );

  --## Lookup the character in source at index.
  --# Args:
  --#  source: String to index into
  --#  index:  Position of element to retrieve
  --#  el:     Character at index position
  procedure element( variable source : in unbounded_string; index : in positive; el : out character );

  --## Replace the character in source at index with by.
  --# Args:
  --#  source: String to modify
  --#  index:  Position of element to modify
  --#  by:     New character to place in index position
  procedure replace_element( source : inout unbounded_string; index : in positive; by : in character );

  --## Extract a slice from source.
  --# Args:
  --#  source: String to slice
  --#  low:    Start index of slice (inclusive)
  --#  high:   End index of slice (inclusive)
  --#  result: Sliced string
  procedure slice( variable source : in unbounded_string; low : in positive; high : in positive;
    result : inout unbounded_string );

  --## Test if left is identical to right.
  --# Args:
  --#  left:   Left string
  --#  right:  Right string
  --#  result: true when strings are identical.
  procedure eq( variable left : in unbounded_string; variable right : in unbounded_string;
    result : out boolean );

  --## Test if left is identical to right.
  --# Args:
  --#  left:   Left string
  --#  right:  Right string
  --#  result: true when strings are identical.
  procedure eq( variable left : in unbounded_string; right : in string; result : out boolean );


  -- Procedures derived from equivalents in strings_fixed:
  -- =====================================================

  --## Count the occurrences of pattern in source.
  --# Args:
  --#  source:  String to count patterns in
  --#  pattern: Pattern to count in source string
  --#  val:     Number or times pattern occurs in the source string.
  procedure count( variable source : in unbounded_string; pattern : in string;
    val : out natural );

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  --# Args:
  --#  source:  String to delete a slice from
  --#  from:    Start index (inclusive)
  --#  through: End index (inclusive)
  procedure delete( source : inout unbounded_string; from : in positive;
    through : in natural );

  --## Return the indices of a slice of source that satisfies the membership
  --#  selection for the character set.
  --# Args:
  --#  source: String to search for the token
  --#  set:    Character set for the token
  --#  test:   Check for characters inside or outside the set
  --#  first:  Start index of the token
  --#  last:   End index of the token or 0 if not found
  procedure find_token( variable source : in unbounded_string; set : in character_set; test : in membership;
    first : out positive; last : out natural );

  --## Return the first count characters from source.
  --# Args:
  --#  source: String to slice head from
  --#  count:  Number of characters to take from the start of source
  --#  pad:    Characters to pad with if source length is less than count
  procedure head( source : inout unbounded_string; count : in natural;
    pad : in character := ' ');

  --## Insert the string new_item before the selected index in source.
  --# Args:
  --#  source:   String to insert into
  --#  before:   Index position for insertion
  --#  new_item: String to insert
  procedure insert( source : inout unbounded_string; before : in positive;
    new_item : in string );

  --## Overwrite new_item into source starting at the selected position.
  --# Args:
  --#  source:   String to overwrite
  --#  position: Index position for overwrite
  --#  new_item: String to write into source
  procedure overwrite( source : inout unbounded_string; position : in positive;
    new_item : in string );

  --## Replace a slice of the source string with the contents of by.
  --# Args:
  --#  source: String to replace
  --#  low:    Start of the slice (inclusive)
  --#  high:   End of the slice (inclusive)
  --#  by:     String to insert into slice position
  procedure replace_slice( source : inout unbounded_string; low : in positive; high : in natural;
    by : in string );

  --## Return the last count characters from source.
  --# Args:
  --#  source: String to slice tail from
  --#  count:  Number of characters to take from the end of source
  --#  pad:    Characters to pad with if source length is less than count
  procedure tail( source : inout unbounded_string; count : in natural;
    pad : in character := ' ' );

  --## Convert a source string with the provided character mapping.
  --# Args:
  --#  source:  String to translate
  --#  mapping: Mapping to apply
  procedure translate( source : inout unbounded_string; mapping : in character_mapping );

  --## Remove space characters from leading, trailing, or both ends of source.
  --# Args:
  --#  source: String to trim
  --#  side:   Which end to trim
  procedure trim( source : inout unbounded_string; side : in trim_end );

  --## Remove all leading characters in left and trailing characters in right
  --#  from source.
  --# Args:
  --#  source:  String to trim
  --#  left:    Index position for start trim
  --#  right:   Index position for end trim
  procedure trim( source : inout unbounded_string; left : in character_set; right : in character_set);

end package;


library extras;
use extras.strings_fixed.all;

package body strings_unbounded is

  --## Convert a string to unbounded_string
  function to_unbounded_string( source : string ) return unbounded_string is
  begin
    return new string'(source);
  end function;

  --## Allocate a string of length
  function to_unbounded_string( length : natural ) return unbounded_string is
  begin
    return new string(1 to length);
  end function;

  --## Copy a unbounded_string to the string dest
  procedure to_string( variable source : in unbounded_string; dest : out string )is
  begin
    dest := source.all;
  end procedure;

  --## Create an empty unbounded_string
  procedure initialize( source : inout unbounded_string ) is
  begin
    deallocate(source);
    source := new string'("");
  end procedure;

  --## Free allocated memory for source
  procedure free( source : inout unbounded_string ) is
  begin
    deallocate(source);
  end procedure;

  --## Return the length of a unbounded_string
  procedure length( variable source : in unbounded_string; len : out natural ) is
  begin
    assert source /= null
      report "Null string"
      severity error;
    len := source'length;
  end procedure;

  --## Copy at most max characters from source to the unallocated dest
  procedure copy( source : in string; dest : inout unbounded_string; max : in integer := -1 ) is
    variable size : natural;
    alias src : string(1 to source'length) is source;
  begin

    if max >= 0 and max <= source'length then
      size := max;
    else
      size := source'length;
    end if;

    if size = 0 then
      dest := new string'("");
    else
      dest := new string'(src(1 to size));
    end if;

  end procedure;

  --## Copy at most max characters from source to the unallocated dest
  procedure copy( variable source : in unbounded_string; dest : inout unbounded_string;
    max : in integer := -1 ) is

    variable size : natural;

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
      dest := new string'(source(source'low to source'low + size - 1));
    end if;

  end procedure;


  --## Append unbounded_string new_item to source
  procedure append( source : inout unbounded_string; variable new_item : in unbounded_string ) is
    variable size : natural;
    variable sa : unbounded_string;
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
      sa(1 to source'length) := source.all;
      sa(source'length+1 to size) := new_item.all;

      deallocate(source);
      source := sa;
    end if;
  end procedure;

  --## Append string new_item to source
  procedure append( source : inout unbounded_string; new_item : in string ) is
    variable size : natural;
    variable sa : unbounded_string;
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
      sa(1 to source'length) := source.all;
      sa(source'length+1 to size) := new_item;
      deallocate(source);
      source := sa;
    end if;
  end procedure;


  --## Append character new_item to source
  procedure append( source : inout unbounded_string; new_item : in character ) is
    variable size : natural;
    variable sa : unbounded_string;
  begin
    if source = null or source'length = 0 then -- copy new_item
      sa := new string'("" & new_item);
      deallocate(source);
      source := sa;
    else
      size := source'length + 1;
      sa := new string(1 to size);
      sa(1 to source'length) := source.all;
      sa(size) := new_item;
      deallocate(source);
      source := sa;
    end if;
  end procedure;

  --## Lookup the character in source at index
  procedure element( variable source : in unbounded_string; index : in positive; el : out character ) is
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
  procedure replace_element( source : inout unbounded_string; index : in positive; by : in character ) is
  begin
    assert source /= null and index <= source'length
      report "Null string or invalid index"
      severity error;

    source(index) := by;
  end procedure;

  --## Extract a slice from source
  procedure slice( variable source : in unbounded_string; low : in positive; high : in positive;
    result : inout unbounded_string ) is
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
  procedure eq( variable left : in unbounded_string; variable right : in unbounded_string;
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
  procedure eq( variable left : in unbounded_string; right : in string; result : out boolean ) is
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
  procedure count( variable source : in unbounded_string; pattern : in string;
    val : out natural ) is
  begin
    val := count(source.all, pattern);
  end procedure;

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  procedure delete( source : inout unbounded_string; from : in positive;
    through : in natural ) is

    variable old : unbounded_string := source;
  begin
    source := new string'(delete(old.all, from, through));
    deallocate(old);
  end procedure;

  --## Return the indices of a slice of source that satisfys the membership
  --#  selection for the character set.
  procedure find_token( variable source : in unbounded_string; set : in character_set; test : in membership;
    first : out positive; last : out natural ) is
  begin
    find_token(source.all, set, test, first, last);
  end procedure;

  --## Return the first count characters from source
  procedure head( source : inout unbounded_string; count : in natural;
    pad : in character := ' ') is

    variable old : unbounded_string := source;
  begin
    source := new string'(head(old.all, count, pad));
    deallocate(old);
  end procedure;

  --## Insert the string new_item before the selected index in source
  procedure insert( source : inout unbounded_string; before : in positive;
    new_item : in string ) is

    variable old : unbounded_string := source;
  begin
    source := new string'(insert(old.all, before, new_item));
    deallocate(old);
  end procedure;

  --## Overwrite new_item into source starting at the selected position
  procedure overwrite( source : inout unbounded_string; position : in positive;
    new_item : in string ) is

    variable old : unbounded_string := source;
  begin

    if position <= source'length - new_item'length + 1 then
      source(position to position + new_item'length - 1) := new_item;
    else
      source := new string'(overwrite(old.all, position, new_item));
      deallocate(old);
    end if;

  end procedure;

  --## Replace a slice of the source string with the contents of by
  procedure replace_slice( source : inout unbounded_string; low : in positive; high : in natural;
    by : in string ) is

    variable old : unbounded_string := source;
  begin
    source := new string'(replace_slice(old.all, low, high, by));
    deallocate(old);
  end procedure;

  --## Return the last count characters from source
  procedure tail( source : inout unbounded_string; count : in natural;
    pad : in character := ' ' ) is

    variable old : unbounded_string := source;
  begin
    source := new string'(tail(old.all, count, pad));
    deallocate(old);
  end procedure;

  --## Convert a source string with the provided character mapping
  procedure translate( source : inout unbounded_string; mapping : in character_mapping ) is
  begin
    translate(source.all, mapping);
  end procedure;

  --## Remove space characters from leading, trailing, or both ends of source
  procedure trim( source : inout unbounded_string; side : in trim_end ) is
    variable old : unbounded_string := source;
  begin
    source := new string'(trim(old.all, side));
    deallocate(old);
  end procedure;


  --## Remove all leading characters in left and trailing characters in left
  --#  from source
  procedure trim( source : inout unbounded_string; left : in character_set; right : in character_set) is
    variable old : unbounded_string := source;
  begin
    source := new string'(trim(old.all, left, right));
    deallocate(old);
    report integer'image(integer'value("12_3"));
  end procedure;

end package body;
