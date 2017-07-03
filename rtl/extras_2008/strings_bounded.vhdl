--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# strings_bounded.vhdl - Bounded length string library
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
--# DEPENDENCIES: strings strings_maps strings_maps_constants strings_fixed
--#
--# DESCRIPTION:
--#  This package provides a string library for operating on bounded length
--#  strings. This is a clone of the Ada'95 library Ada.Strings.Bounded. It
--#  is a nearly complete implementation with only the procedures taking
--#  character mapping functions omitted because of VHDL limitations.
--#  This package requires support for VHDL-2008 package generics. The
--#  maximum size of a bounded string is established by instantiating a new
--#  package with the MAX generic set to the desired size.
--#
--# EXAMPLE USAGE:
--#  library extras_2008;
--#  package s20 is new extras_2008.strings_bounded
--#    generic map(MAX => 20);
--#  use work.s20.all;
--#  ...
--#  variable str : bounded_string; -- String with up to 20 characters
--#  variable l   : natural;
--#  ...
--#  str := to_bounded_string("abc");
--#  l := length(str); -- returns 3
--#  append(str, "def");
--#  l := length(str); -- returns 6
--------------------------------------------------------------------

library extras;
use extras.strings.all;
use extras.strings_maps.all;
use extras.strings_maps_constants.all;
use extras.strings_fixed;

package strings_bounded is
  generic (MAX : positive); -- Maximum length of a bounded string

  --# String length constrained to maximum length set by the ``MAX`` package generic.
  subtype length_range is natural range 0 to MAX;

  --# Bounded string object.
  type bounded_string is record
    length : length_range;
    data   : string(1 to MAX);
  end record;

  --## Return the length of a bounded_string.
  --# Args:
  --#  source: String to check length of
  --# Returns:
  --#  Length of the string.
  function length( source : bounded_string ) return length_range;

  --## Convert a string to bounded_string.
  --# Args:
  --#  source: String to convert
  --#  drop:   Truncation behavior for longer strings
  --# Returns:
  --#  Converted string.
  function to_bounded_string( source : string; drop : truncation := error ) return bounded_string;

  --## Convert a bounded_string to string.
  --# Args:
  --#  source: String to convert
  --# Returns:
  --#  Bounded string converted to a plain string.
  function to_string( source : bounded_string ) return string;

  --## Append two bounded_strings.
  --# Args:
  --#  l: Left string
  --#  r: Right string
  --#  drop: Truncation behavior for longer strings
  --# Returns:
  --#  String with l and r concatenated.
  function append( l, r : bounded_string; drop : truncation := error ) return bounded_string;

  --## Append a string to a bounded_string.
  --# Args:
  --#  l: Left string
  --#  r: Right string
  --#  drop: Truncation behavior for longer strings
  --# Returns:
  --#  String with l and r concatenated.
  function append( l : bounded_string; r : string; drop : truncation := error )
    return bounded_string;

  --## Append a bounded_string to a string.
  --# Args:
  --#  l: Left string
  --#  r: Right string
  --#  drop: Truncation behavior for longer strings
  --# Returns:
  --#  String with l and r concatenated.
  function append( l : string; r : bounded_string; drop : truncation := error )
    return bounded_string;

  --## Append a character to a bounded_string.
  --# Args:
  --#  l: Left string
  --#  r: Right character
  --#  drop: Truncation behavior for longer strings
  --# Returns:
  --#  String with l and r concatenated.
  function append( l : bounded_string; r : character; drop : truncation := error )
    return bounded_string;

  --## Append a bounded_string to a character.
  --# Args:
  --#  l: Left character
  --#  r: Right string
  --#  drop: Truncation behavior for longer strings
  --# Returns:
  --#  String with l and r concatenated.
  function append( l : character; r : bounded_string; drop : truncation := error )
    return bounded_string;

  --## Append a bounded_string.
  --# Args:
  --#  source:   String to append onto
  --#  new_item: String to append
  --#  drop:     Truncation behavior for longer strings
  procedure append( source : inout bounded_string; new_item : in bounded_string;
    drop : in truncation := error );

  --## Append a string.
  --# Args:
  --#  source:   String to append onto
  --#  new_item: String to append
  --#  drop:     Truncation behavior for longer strings
  procedure append( source : inout bounded_string; new_item : in string;
    drop : in truncation := error );

  --## Append a character.
  --# Args:
  --#  source:   String to append onto
  --#  new_item: Character to append
  --#  drop:     Truncation behavior for longer strings
  procedure append( source : inout bounded_string; new_item : in character;
    drop : in truncation := error );


  --## Concatenate two strings.
  --# Args:
  --#  l: Left string
  --#  r: Right string
  --# Returns:
  --#  String with l and r concatenated.
  function "&"( l, r : bounded_string ) return bounded_string;

  --## Concatenate a string to a bounded_string.
  --# Args:
  --#  l: Left string
  --#  r: Right string
  --# Returns:
  --#  String with l and r concatenated.
  function "&"( l : bounded_string; r : string ) return bounded_string;

  --## Concatenate a bounded_string to a string.
  --# Args:
  --#  l: Left string
  --#  r: Right string
  --# Returns:
  --#  String with l and r concatenated.
  function "&"( l : string; r : bounded_string ) return bounded_string;

  --## Concatenate a character to a string.
  --# Args:
  --#  l: Left string
  --#  r: Right character
  --# Returns:
  --#  String with l and r concatenated.
  function "&"( l : bounded_string; r : character ) return bounded_string;

  --## Concatenate a string to a character.
  --# Args:
  --#  l: Left character
  --#  r: Right string
  --# Returns:
  --#  String with l and r concatenated.
  function "&"( l : character; r : bounded_string ) return bounded_string;

  --## Return the character at the index position.
  --# Args:
  --#  source: String to index into
  --#  index:  Position of the character in the string
  --# Returns:
  --#  Character at the index position.
  function element( source : bounded_string; index : positive ) return character;

  --## Replace the character at the index position.
  --# Args:
  --#  source: String to have element replaced
  --#  index:  Index position to insert new character
  --#  by:     Character to place in the string
  procedure replace_element( source : inout bounded_string; index : in positive;
    by : in character );

  --## Return a sliced range of a bounded_string.
  --# Args:
  --#  source: String to slice
  --#  low:    low index of slice (inclusive)
  --#  high:   high index of slice (inclusive)
  --# Returns:
  --#  Substring of source from low to high.
  function slice( source : bounded_string; low : positive; high : natural ) return string;

  --## Test two bounded strings for equality.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal.
  function "="( l, r : bounded_string ) return boolean;

  --## Test a bounded_string and plain string for equality.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal.
  function "="( l : bounded_string; r : string ) return boolean;

  --## Test a plain string and a bounded_string for equality.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal.
  function "="( l : string; r : bounded_string ) return boolean;

  --## Test two bounded_strings for one lexicographically before the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l lexicographically proceeds r.
  function "<"( l, r : bounded_string ) return boolean;

  --## Test a bounded_string and a plain string for one lexicographically before the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l lexicographically proceeds r.
  function "<"( l : bounded_string; r : string ) return boolean;

  --## Test a plain string and a bounded_string for one lexicographically before the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l lexicographically proceeds r.
  function "<"( l : string; r : bounded_string ) return boolean;

  --## Test two bounded_strings for equality or one lexicographically before the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal or l lexicographically proceeds r.
  function "<="( l, r : bounded_string ) return boolean;

  --## Test a bounded_string and a plain string for equality or one lexicographically before the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal or l lexicographically proceeds r.
  function "<="( l : bounded_string; r : string ) return boolean;

  --## Test a plain string and a bounded_string for equality or one lexicographically before the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal or l lexicographically proceeds r.
  function "<="( l : string; r : bounded_string ) return boolean;

  --## Test two bounded_strings for one lexicographically after the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l lexicographically follows r.
  function ">"( l, r : bounded_string ) return boolean;

  --## Test a bounded_string and a plain string for one lexicographically after the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l lexicographically follows r.
  function ">"( l : bounded_string; r : string ) return boolean;

  --## Test a plain string and a bounded_string for one lexicographically after the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l lexicographically follows r.
  function ">"( l : string; r : bounded_string ) return boolean;

  --## Test two bounded_strings for equality or one lexicographically after the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal or l lexicographically follows r.
  function ">="( l, r : bounded_string ) return boolean;

  --## Test a bounded_string and a plain string for equality or one lexicographically after the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal or l lexicographically follows r.
  function ">="( l : bounded_string; r : string ) return boolean;

  --## Test a plain string and a bounded_string for equality or one lexicographically after the other.
  --# Args:
  --#  l: First string to compare
  --#  r: Second string to compare
  --# Returns:
  --#  true when l and r are equal or l lexicographically follows r.
  function ">="( l : string; r : bounded_string ) return boolean;


  --## Find the index of the first occurance of pattern in source from the
  --#  beginning or end.
  --# Args:
  --#  source:  String to index into
  --#  pattern: Pattern to search for
  --#  going:   Search direction
  --#  mapping: Optional character mapping applied before the search
  --# Returns:
  --#  Index position of pattern or 0 if not found.
  function index( source : bounded_string; pattern : string; going : direction := forward;
    mapping : character_mapping := IDENTITY ) return natural;

  --## Find the index of first occurance of a character from set in source.
  --# Args:
  --#  source: String to search
  --#  set:    Character set to search for
  --#  test:   Check for characters inside or outside the set
  --#  going:  Search direction
  --# Returns:
  --#  Index position of first matching character or 0 if not found.
  function index( source : bounded_string; set : character_set; test : membership := inside;
    going : direction := forward ) return natural;

  --## Find the index of the first non-space character in source.
  --# Args:
  --#  source: String to search
  --#  going:  Search direction
  --# Returns:
  --#  Index position of first non-space character or 0 if none found.
  function index_non_blank( source : bounded_string; going : direction := forward ) return natural;

  --## Count the occurrences of pattern in source.
  --# Args:
  --#  source:  String to count patterns in
  --#  pattern: Pattern to count in source string
  --# Returns:
  --#  Number or times pattern occurs in the source string.
  function count( source : bounded_string; pattern : string; mapping : character_mapping := IDENTITY )
    return natural;

  --## Count the occurrences of characters from set in source.
  --# Args:
  --#  source: String to count characters in
  --#  set:    Character set to count
  --# Returns:
  --#  Number of times a character from set occurs in the source string.
  function count( source : bounded_string; set : character_set ) return natural;

  --## Return the indices of a slice of source that satisfies the membership
  --#  selection for the character set.
  --# Args:
  --#  source: String to search for the token
  --#  set:    Character set for the token
  --#  test:   Check for characters inside or outside the set
  --#  first:  Start index of the token
  --#  last:   End index of the token or 0 if not found
  procedure find_token( source : in bounded_string; set : in character_set;
    test : in membership; first : out positive; last : out natural );

  --## Convert a source string with the provided character mapping.
  --# Args:
  --#  source:  String to translate
  --#  mapping: Mapping to apply
  --# Returns:
  --#  New string with applied mapping.
  function translate( source : bounded_string; mapping : character_mapping ) return bounded_string;

  --## Convert a source string with the provided character mapping.
  --# Args:
  --#  source:  String to translate
  --#  mapping: Mapping to apply
  procedure translate( source : inout bounded_string; mapping : in character_mapping );

  --## Replace a slice of the source string with the contents of by.
  --# Args:
  --#  source: String to replace
  --#  low:    Start of the slice (inclusive)
  --#  high:   End of the slice (inclusive)
  --#  by:     String to insert into slice position
  --# Returns:
  --#  New string with replaced slice.
  function replace_slice( source : bounded_string; low : positive; high : natural;
    by : string; drop : truncation := error ) return bounded_string;

  --## Replace a slice of the source string with the contents of by.
  --# Args:
  --#  source:  String to replace
  --#  low:     Start of the slice (inclusive)
  --#  high:    End of the slice (inclusive)
  --#  by:      String to insert into slice position
  --#  drop:    Truncation mode
  --#  justify: Alignment mode
  --#  pad :    Padding character when result is shorter than original string
  procedure replace_slice( source : inout bounded_string; low : in positive; high : in natural;
    by : in string; drop : in truncation := error );

  --## Insert the string new_item before the selected index in source.
  --# Args:
  --#  source:   String to insert into
  --#  before:   Index position for insertion
  --#  new_item: String to insert
  --# Returns:
  --#  Source string with new_item inserted.  
  function insert( source : bounded_string; before : positive; new_item : string;
    drop : truncation := error ) return bounded_string;

  --## Insert the string new_item before the selected index in source.
  --# Args:
  --#  source:   String to insert into
  --#  before:   Index position for insertion
  --#  new_item: String to insert
  --#  drop:     Truncation mode
  procedure insert( source : inout bounded_string; before : in positive; new_item : in string;
    drop : in truncation := error );

  --## Overwrite new_item into source starting at the selected position.
  --# Args:
  --#  source:   String to overwrite
  --#  position: Index position for overwrite
  --#  new_item: String to write into source
  --# Returns:
  --#  New string with overwritten item.
  function overwrite( source : bounded_string; position : positive; new_item : string;
    drop : truncation := error ) return bounded_string;

  --## Overwrite new_item into source starting at the selected position.
  --# Args:
  --#  source:   String to overwrite
  --#  position: Index position for overwrite
  --#  new_item: String to write into source
  --#  drop:     Truncation mode
  procedure overwrite( source : inout bounded_string; position : in positive; new_item : in string;
    drop : in truncation := error );

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  --# Args:
  --#  source:  String to delete a slice from
  --#  from:    Start index (inclusive)
  --#  through: End index (inclusive)
  --# Returns:
  --#  New string with a slice deleted.
  function delete( source : bounded_string; from : positive; through : natural )
    return bounded_string;

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  --# Args:
  --#  source:  String to delete a slice from
  --#  from:    Start index (inclusive)
  --#  through: End index (inclusive)
  --#  justify: Position of shortened result in string
  --#  pad:     Character to use as padding for shortened string
  procedure delete( source : inout bounded_string; from : in positive; through : in natural );

  --## Remove space characters from leading, trailing, or both ends of source.
  --# Args:
  --#  source: String to trim
  --#  side:   Which end to trim
  --# Returns:
  --#  Source string with space trimmed.
  function trim( source : bounded_string; side : trim_end ) return bounded_string;

  --## Remove space characters from leading, trailing, or both ends of source.
  --# Args:
  --#  source:  String to trim
  --#  side:    Which end to trim
  procedure trim( source : inout bounded_string; side : in trim_end );

  --## Remove all leading characters in left and trailing characters in right
  --#  from source.
  --# Args:
  --#  source:  String to trim
  --#  left:    Index position for start trim
  --#  right:   Index position for end trim
  --# Returns:
  --#  Source string with ends trimmed.
  function trim( source : bounded_string; left : character_set; right : character_set )
    return bounded_string;

  --## Remove all leading characters in left and trailing characters in right
  --#  from source.
  --# Args:
  --#  source:  String to trim
  --#  left:    Index position for start trim
  --#  right:   Index position for end trim
  procedure trim( source : inout bounded_string; left : in character_set; right : in character_set );

  --## Return the first count characters from source.
  --# Args:
  --#  source: String to slice from
  --#  count:  Number of characters to take from the start of source
  --#  pad:    Characters to pad with if source length is less than count
  --#  drop:   Truncation behavior
  --# Returns:
  --#  A string of length count.
  function head( source : bounded_string; count : natural; pad : character := ' ';
    drop : truncation := error ) return bounded_string;

  --## Return the first count characters from source.
  --# Args:
  --#  source:  String to slice from
  --#  count:   Number of characters to take from the start of source
  --#  pad:     Characters to pad with if source length is less than count
  --#  drop:    Truncation behavior
  procedure head( source : inout bounded_string; count : in natural; pad : in character := ' ';
    drop : in truncation := error );

  --## Return the last count characters from source.
  --# Args:
  --#  source: String to slice from
  --#  count:  Number of characters to take from the end of source
  --#  pad:    Characters to pad with if source length is less than count
  --#  drop:   Truncation behavior
  --# Returns:
  --#  A string of length count.
  function tail( source : bounded_string; count : natural; pad : character := ' ';
    drop : truncation := error ) return bounded_string;

  --## Return the last count characters from source.
  --# Args:
  --#  source:  String to slice from
  --#  count:   Number of characters to take from the end of source
  --#  pad:     Characters to pad with if source length is less than count
  --#  drop:    Truncation behavior
  procedure tail( source : inout bounded_string; count : in natural; pad : in character := ' ';
    drop : in truncation := error );

  --## Replicate a character left number of times.
  --# Args:
  --#  left:  Number of times to repeat the right operand
  --#  right: Character to repeat in string
  --# Returns:
  --#  String with repeated character.
  function "*"( l : natural; r : character ) return bounded_string;

  --## Replicate a string left number of times.
  --# Args:
  --#  left:  Number of times to repeat the right operand
  --#  right: String to repeat in result string
  --# Returns:
  --#  String with repeated substring.

  function "*"( l : natural; r : string ) return bounded_string;

  --## Replicate a bounded_string left number of times.
  --# Args:
  --#  left:  Number of times to repeat the right operand
  --#  right: String to repeat in result string
  --# Returns:
  --#  String with repeated substring.
  function "*"( l : natural; r : bounded_string ) return bounded_string;

  --## Replicate a character count number of times.
  --# Args:
  --#  count: Number of times to repeat the item operand
  --#  item:  Character to repeat in string
  --#  drop:  Truncation behavior
  --# Returns:
  --#  String with repeated character.
  function replicate( count : natural; item : character; drop : truncation := error )
    return bounded_string;

  --## Replicate a string count number of times.
  --# Args:
  --#  count: Number of times to repeat the item operand
  --#  item:  String to repeat in result string
  --#  drop:  Truncation behavior
  --# Returns:
  --#  String with repeated substring.
  function replicate( count : natural; item : string; drop : truncation := error )
    return bounded_string;

  --## Replicate a bounded_string count number of times.
  --# Args:
  --#  count: Number of times to repeat the item operand
  --#  item:  String to repeat in result string
  --#  drop:  Truncation behavior
  --# Returns:
  --#  String with repeated substring.
  function replicate( count : natural; item : bounded_string; drop : truncation := error )
    return bounded_string;

end package;

package body strings_bounded is

  --## Return the length of a bounded_string
  function length( source : bounded_string ) return length_range is
  begin
    return source.length;
  end function;

  --## Convert a string to bounded_string
  function to_bounded_string( source : string; drop : truncation := error ) return bounded_string is

    variable result : bounded_string;
  begin
    if source'length <= MAX then
      result.length := source'length;
      result.data(1 to source'length) := source;
    else
      case drop is
        when left =>
          result.length := MAX;
          result.data(1 to MAX) := source(source'right - MAX + 1 to source'right);

        when right =>
          result.length := MAX;
          result.data(1 to MAX) := source(source'left to source'left - 1 + MAX);

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Convert a bounded_string to string
  function to_string( source : bounded_string ) return string is
  begin
    return source.data(1 to source.length);
  end function;

  --## Append a bounded_string
  function append( l, r : bounded_string; drop : truncation := error ) return bounded_string is
    variable result : bounded_string;
    constant nlen : natural := l.length + r.length;
  begin
    if nlen <= MAX then
      result.length := nlen;
      result.data(1 to l.length) := l.data(1 to l.length);
      result.data(l.length+1 to nlen) := r.data(1 to r.length);
    else
      result.length := MAX;

      case drop is
        when left =>
          if r.length >= MAX then
            result.data := r.data;
          else
            result.data(1 to MAX - r.length) := l.data(l.length - MAX + r.length + 1 to l.length);
            result.data(MAX - r.length + 1 to MAX) := r.data(1 to r.length);
          end if;

        when right =>
          if l.length >= MAX then
            result.data := l.data;
          else
            result.data(1 to l.length) := l.data(1 to l.length);
            result.data(l.length+1 to MAX) := r.data(1 to MAX - l.length);
          end if;

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Append a string
  function append( l : bounded_string; r : string; drop : truncation := error )
    return bounded_string is
    alias ra : string(1 to r'length) is r;
    variable result : bounded_string;
    constant nlen : natural := l.length + ra'length;
  begin
    if nlen <= MAX then
      result.length := nlen;
      result.data(1 to l.length) := l.data(1 to l.length);
      result.data(l.length+1 to nlen) := ra;
    else
      result.length := MAX;

      case drop is
        when left =>
          if ra'length >= MAX then
            result.data(1 to MAX) := ra(ra'right - MAX + 1 to ra'right);
          else
            result.data(1 to MAX - ra'length) := l.data(l.length - MAX + ra'length + 1 to l.length);
            result.data(MAX - ra'length + 1 to MAX) := ra;
          end if;

        when right =>
          if l.length >= MAX then
            result.data := l.data;
          else
            result.data(1 to l.length) := l.data(1 to l.length);
            result.data(l.length+1 to MAX) := ra(1 to MAX - l.length);
          end if;

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Append a bounded_string to a string
  function append( l : string; r : bounded_string; drop : truncation := error )
    return bounded_string is
    alias la : string(1 to l'length) is l;
    variable result : bounded_string;
    constant nlen : natural := la'length + r.length;
  begin
    if nlen <= MAX then
      result.length := nlen;
      result.data(1 to la'length) := la;
      result.data(la'length + 1 to la'length + r.length) := r.data(1 to r.length);
    else
      result.length := MAX;

      case drop is
        when left =>
          if r.length >= MAX then
            result.data(1 to MAX) := r.data(r.length - MAX + 1 to r.length);
          else
            result.data(1 to MAX - r.length) := la(la'right - MAX + r.length + 1 to la'right);
            result.data(MAX - r.length + 1 to MAX) := r.data(1 to r.length);
          end if;

        when right =>
          if la'length >= MAX then
            result.data := la(1 to MAX);
          else
            result.data(1 to la'length) := la;
            result.data(la'length + 1 to MAX) := r.data(1 to MAX - la'length);
          end if;

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Append a character
  function append( l : bounded_string; r : character; drop : truncation := error )
    return bounded_string is

    variable result : bounded_string;
    constant nlen : natural := l.length + 1;
  begin
    if nlen <= MAX then
      result.length := nlen;
      result.data(1 to l.length) := l.data(1 to l.length);
      result.data(l.length+1) := r;
    else

      case drop is
        when left =>
          result.length := MAX;
          result.data(1 to MAX - 1) := l.data(2 to MAX);
          result.data(MAX) := r;

        when right =>
          return l;

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Append a bounded_string to a character
  function append( l : character; r : bounded_string; drop : truncation := error )
    return bounded_string is

    variable result : bounded_string;
    constant nlen : natural := r.length + 1;
  begin
    if nlen <= MAX then
      result.length := nlen;
      result.data(1) := l;
      result.data(2 to nlen) := r.data(1 to r.length);
    else

      case drop is
        when left =>
          return r;

        when right =>
          result.length := MAX;
          result.data(1) := l;
          result.data(2 to MAX) := r.data(1 to MAX-1);

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Append a bounded_string
  procedure append( source : inout bounded_string; new_item : in bounded_string;
    drop : in truncation := error ) is

    constant llen : natural := source.length;
    constant rlen : natural := new_item.length;
    constant nlen : natural := llen + rlen;
  begin

    if nlen <= MAX then
      source.length := nlen;
      source.data(llen+1 to nlen) := new_item.data(1 to rlen);
    else
      source.length := MAX;

      case drop is
        when left =>
          if rlen >= MAX then
            source.data := new_item.data;
          else
            source.data(1 to MAX-rlen) := source.data(llen - MAX + rlen + 1 to llen);
            source.data(MAX - rlen + 1 to MAX) := new_item.data(1 to rlen);
          end if;

        when right =>
          if llen < MAX then
            source.data(llen+1 to MAX) := new_item.data(1 to MAX-llen);
          end if;

        when error =>
          report "String length error" severity error;
      end case;
    end if;
  end procedure;

  --## Append a string
  procedure append( source : inout bounded_string; new_item : in string;
    drop : in truncation := error ) is

    alias nia : string(1 to new_item'length) is new_item;

    constant llen : natural := source.length;
    constant rlen : natural := nia'length;
    constant nlen : natural := llen + rlen;
  begin

    if nlen <= MAX then
      source.length := nlen;
      source.data(llen+1 to nlen) := nia;
    else
      source.length := MAX;

      case drop is
        when left =>
          if rlen >= MAX then
            source.data(1 to MAX) := nia(nia'right - MAX + 1 to nia'right);
          else
            source.data(1 to MAX-rlen) := source.data(llen - MAX + rlen + 1 to llen);
            source.data(MAX - rlen + 1 to MAX) := nia;
          end if;

        when right =>
          if llen < MAX then
            source.data(llen+1 to MAX) := nia(1 to MAX - llen);
          end if;

        when error =>
          report "String length error" severity error;
      end case;
    end if;
  end procedure;

  --## Append a character
  procedure append( source : inout bounded_string; new_item : in character;
    drop : in truncation := error ) is

    constant llen : natural := source.length;
  begin
    if llen < MAX then
      source.length := llen + 1;
      source.data(llen + 1) := new_item;
    else
      source.length := MAX;

      case drop is
        when left =>
          source.data(1 to MAX - 1) := source.data(2 to MAX);
          source.data(MAX) := new_item;

        when right =>
          null;

        when error =>
          report "String length error" severity error;
      end case;
    end if;
  end procedure;


  function "&"( l, r : bounded_string ) return bounded_string is
  begin
    return append(l, r);
  end function;

  function "&"( l : bounded_string; r : string ) return bounded_string is
  begin
    return append(l, r);
  end function;

  function "&"( l : string; r : bounded_string ) return bounded_string is
  begin
    return append(l, r);
  end function;

  function "&"( l : bounded_string; r : character ) return bounded_string is
  begin
    return append(l, r);
  end function;

  function "&"( l : character; r : bounded_string ) return bounded_string is
  begin
    return append(l, r);
  end function;

  --## Return the character at the index position
  function element( source : bounded_string; index : positive ) return character is
  begin
    if index <= source.length then
      return source.data(index);
    else
      report "Index error" severity error;
    end if;

    return NUL;
  end function;

  --## Replace the character at the index position
  procedure replace_element( source : inout bounded_string; index : in positive;
    by : in character ) is
  begin
    if index <= source.length then
      source.data(index) := by;
    else
      report "Index error" severity error;
    end if;
  end procedure;

  --## Return a sliced range of a bounded_string from low to high inclusive
  function slice( source : bounded_string; low : positive; high : natural ) return string is
  begin
    if low > source.length + 1 or high > source.length then
      report "Index error" severity error;
    else
      return source.data(low to high);
    end if;

    return "";
  end function;

  function "="( l, r : bounded_string ) return boolean is
  begin
    return l.length = r.length and l.data(1 to l.length) = r.data(1 to r.length);
  end function;

  function "="( l : bounded_string; r : string ) return boolean is
  begin
    return l.length = r'length and l.data(1 to l.length) = r;
  end function;

  function "="( l : string; r : bounded_string ) return boolean is
  begin
    return l'length = r.length and l = r.data(1 to r.length);
  end function;


  function "<"( l, r : bounded_string ) return boolean is
  begin
    return l.data(1 to l.length) < r.data(1 to r.length);
  end function;

  function "<"( l : bounded_string; r : string ) return boolean is
  begin
    return l.data(1 to l.length) < r;
  end function;

  function "<"( l : string; r : bounded_string ) return boolean is
  begin
    return l < r.data(1 to r.length);
  end function;


  function "<="( l, r : bounded_string ) return boolean is
  begin
    return l.data(1 to l.length) <= r.data(1 to r.length);
  end function;

  function "<="( l : bounded_string; r : string ) return boolean is
  begin
    return l.data(1 to l.length) <= r;
  end function;

  function "<="( l : string; r : bounded_string ) return boolean is
  begin
    return l <= r.data(1 to r.length);
  end function;


  function ">"( l, r : bounded_string ) return boolean is
  begin
    return l.data(1 to l.length) > r.data(1 to r.length);
  end function;

  function ">"( l : bounded_string; r : string ) return boolean is
  begin
    return l.data(1 to l.length) > r;
  end function;

  function ">"( l : string; r : bounded_string ) return boolean is
  begin
    return l > r.data(1 to r.length);
  end function;


  function ">="( l, r : bounded_string ) return boolean is
  begin
    return l.data(1 to l.length) >= r.data(1 to r.length);
  end function;

  function ">="( l : bounded_string; r : string ) return boolean is
  begin
    return l.data(1 to l.length) >= r;
  end function;

  function ">="( l : string; r : bounded_string ) return boolean is
  begin
    return l >= r.data(1 to r.length);
  end function;


  --## Find the index of the first occurance of pattern in source from the
  --#  beginning or end
  function index( source : bounded_string; pattern : string; going : direction := forward;
    mapping : character_mapping := IDENTITY ) return natural is
  begin
    return strings_fixed.index(source.data(1 to source.length), pattern, going, mapping);
  end function;

  --## Find the index of first occurance of a character from set in source
  function index( source : bounded_string; set : character_set; test : membership := inside;
    going : direction := forward ) return natural is
  begin
    return strings_fixed.index(source.data(1 to source.length), set, test, going);
  end function;

  --## Find the index of the first non-space character in source
  function index_non_blank( source : bounded_string; going : direction := forward ) return natural is
  begin
    return strings_fixed.index_non_blank(source.data(1 to source.length), going);
  end function;

  --## Count the occurrences of pattern in source
  function count( source : bounded_string; pattern : string; mapping : character_mapping := IDENTITY )
    return natural is
  begin
    return strings_fixed.count(source.data(1 to source.length), pattern, mapping);
  end function;

  --## Count the occurrences of characters from set in source
  function count( source : bounded_string; set : character_set ) return natural is
  begin
    return strings_fixed.count(source.data(1 to source.length), set);
  end function;

  --## Return the indices of a slice of source that satisfys the membership
  --#  selection for the character set.
  procedure find_token( source : in bounded_string; set : in character_set;
    test : in membership; first : out positive; last : out natural ) is
  begin
    strings_fixed.find_token(source.data(1 to source.length), set, test, first, last);
  end procedure;


  --## Convert a source string with the provided character mapping
  function translate( source : bounded_string; mapping : character_mapping ) return bounded_string is
    variable result : bounded_string;
  begin
    result.length := source.length;
    for i in 1 to source.length loop
      result.data(i) := mapping(source.data(i));
    end loop;

    return result;
  end function;

  --## Convert a source string with the provided character mapping
  procedure translate( source : inout bounded_string; mapping : in character_mapping ) is
  begin
    for i in 1 to source.length loop
      source.data(i) := mapping(source.data(i));
    end loop;
  end procedure;

  --## Replace a slice of the source string with the contents of by
  function replace_slice( source : bounded_string; low : positive; high : natural;
    by : string; drop : truncation := error ) return bounded_string is

    function maximum(a, b : integer) return integer is
    begin
      if a >= b then
        return a;
      else
        return b;
      end if;
    end function;

    constant blen : natural := maximum(0, low-1);
    constant alen : natural := maximum(0, source.length - high);
    constant tlen : natural := blen + by'length + alen;
    constant droplen : integer := tlen - MAX;

    variable result : bounded_string;
  begin
    if low > source.length then
      report "String index error" severity error;
    elsif high < low then
      return insert(source, low, by, drop);
    else
      if droplen <= 0 then
        result.length := tlen;
        result.data(1 to blen) := source.data(1 to blen);
        result.data(low to low + by'length - 1) := by;
        result.data(low + by'length to tlen) := source.data(high+1 to source.length);
      else
        result.length := MAX;

        case drop is
          when left =>
            result.data(MAX - alen + 1 to MAX) := source.data(high+1 to source.length);
            if droplen >= blen then
              result.data(1 to MAX - alen) := by(by'right - MAX + alen + 1 to by'right);
            else
              result.data(blen - droplen + 1 to MAX - alen) := by;
              result.data(1 to blen - droplen) := source.data(droplen + 1 to blen);
            end if;

          when right =>
            result.data(1 to blen) := source.data(1 to blen);
            if droplen > alen then
              result.data(low to MAX) := by(by'left to by'left + MAX - low);
            else
              result.data(low to low + by'length - 1) := by;
              result.data(low + by'length to MAX) := source.data(high+1 to source.length - droplen);
            end if;

          when error =>
            report "String length error" severity error;
        end case;
      end if;
    end if;
    return result;
  end function;

  --## Replace a slice of the source string with the contents of by
  procedure replace_slice( source : inout bounded_string; low : in positive; high : in natural;
    by : in string; drop : in truncation := error ) is
  begin
    source := replace_slice(source, low, high, by, drop);
  end procedure;

  --## Insert the string new_item before the selected index in source
  function insert( source : bounded_string; before : positive; new_item : string;
    drop : truncation := error ) return bounded_string is

    constant nlen : natural := new_item'length;
    constant tlen : natural := source.length + nlen;
    constant blen : natural := before - 1;
    constant alen : integer := source.length - blen;
    constant droplen : integer := tlen - MAX;

    variable result : bounded_string;
  begin
    if alen < 0 then
      report "String index error" severity error;
    elsif droplen <= 0 then
      result.length := tlen;
      result.data(1 to blen) := source.data(1 to blen);
      result.data(before to before + nlen - 1) := new_item;
      result.data(before + nlen to tlen) := source.data(before to source.length);
    else
      result.length := MAX;

      case drop is
        when left =>
          result.data(MAX - alen + 1 to MAX) := source.data(before to source.length);
          if droplen >= blen then
            result.data(1 to MAX - alen) := new_item(new_item'right - MAX + alen + 1 to new_item'right);
          else
            result.data(blen - droplen + 1 to MAX - alen) := new_item;
            result.data(1 to blen - droplen) := source.data(droplen + 1 to blen);
          end if;

        when right =>
          result.data(1 to blen) := source.data(1 to blen);
          if droplen > alen then
            result.data(before to MAX) := new_item(new_item'left to new_item'left + MAX - before);
          else
            result.data(before to before + nlen - 1) := new_item;
            result.data(before + nlen to MAX) := source.data(before to source.length - droplen);
          end if;

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Insert the string new_item before the selected index in source
  procedure insert( source : inout bounded_string; before : in positive; new_item : in string;
    drop : in truncation := error ) is
  begin
    source := insert(source, before, new_item, drop);
  end procedure;

  --## Overwrite new_item into source starting at the selected position
  function overwrite( source : bounded_string; position : positive; new_item : string;
    drop : truncation := error ) return bounded_string is

    constant endpos : natural := position + new_item'length - 1;
    constant droplen : integer := endpos - MAX;
    variable result : bounded_string;
  begin
    if position > source.length + 1 then
      report "String index error" severity error;

    elsif new_item'length = 0 then
      return source;

    elsif endpos <= source.length then
      result.length := source.length;
      result.data(1 to source.length) := source.data(1 to source.length);
      result.data(position to endpos) := new_item;

    elsif endpos <= MAX then
      result.length := endpos;
      result.data(1 to position-1) := source.data(1 to position-1);
      result.data(position to endpos) := new_item;

    else
      result.length := MAX;
      case drop is
        when left =>
          if new_item'length >= MAX then
            result.data(1 to MAX) := new_item(new_item'right - MAX + 1 to new_item'right);
          else
            result.data(1 to MAX - new_item'length) := source.data(droplen + 1 to position - 1);
            result.data(MAX - new_item'length + 1 to MAX) := new_item;
          end if;

        when right =>
          result.data(1 to position-1) := source.data(1 to position-1);
          result.data(position to MAX) := new_item(new_item'left to new_item'right - droplen);

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Overwrite new_item into source starting at the selected position
  procedure overwrite( source : inout bounded_string; position : in positive; new_item : in string;
    drop : in truncation := error ) is
  begin
    source := overwrite(source, position, new_item, drop);
  end procedure;

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  function delete( source : bounded_string; from : positive; through : natural )
    return bounded_string is

    constant slen : natural := source.length;
    constant num_delete : integer := through - from + 1;
    variable result : bounded_string;
  begin
    if num_delete <= 0 then
      return source;

    elsif from > slen + 1 then
      report "String index error" severity error;

    elsif through >= slen then
      result.length := from - 1;
      result.data(1 to from-1) := source.data(1 to from-1);
    else
      result.length := slen - num_delete;
      result.data(1 to from-1) := source.data(1 to from-1);
      result.data(from to result.length) := source.data(through+1 to slen);
    end if;

    return result;
  end function;

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  procedure delete( source : inout bounded_string; from : in positive; through : in natural ) is
    constant slen : natural := source.length;
    constant num_delete : integer := through - from + 1;
  begin
    if num_delete <= 0 then
      return;

    elsif from > source.length + 1 then
      report "String index error" severity error;

    elsif through >= slen then
      source.length := from - 1;
    else
      source.length := slen - num_delete;
      source.data(from to slen - num_delete) := source.data(through+1 to slen);
    end if;
  end procedure;

  --## Remove space characters from leading, trailing, or both ends of source
  function trim( source : bounded_string; side : trim_end ) return bounded_string is
    variable result : bounded_string;
    variable last : natural := source.length;
    variable first : positive := 1;
  begin
    if side = left or side = both then
      while first <= last and source.data(first) = ' ' loop
        first := first + 1;
      end loop;
    end if;

    if side = right or side = both then
      while last >= first and source.data(last) = ' ' loop
        last := last - 1;
      end loop;
    end if;

    result.length := last - first + 1;
    result.data(1 to result.length) := source.data(first to last);
    return result;
  end function;

  --## Remove space characters from leading, trailing, or both ends of source
  procedure trim( source : inout bounded_string; side : in trim_end ) is
    variable temp : string(1 to source.length);
    variable last : natural := source.length;
    variable first : positive := 1;
  begin
    temp := source.data(1 to last);

    if side = left or side = both then
      while first <= last and temp(first) = ' ' loop
        first := first + 1;
      end loop;
    end if;

    if side = right or side = both then
      while last >= first and temp(last) = ' ' loop
        last := last - 1;
      end loop;
    end if;

    source.length := last - first + 1;
    source.data(1 to source.length) := temp(first to last);
  end procedure;

  --## Remove all leading characters in left and trailing characters in right
  --#  from source
  function trim( source : bounded_string; left : character_set; right : character_set )
    return bounded_string is

    variable result : bounded_string;
  begin
    for first in 1 to source.length loop
      if not is_in(source.data(first), left) then
        for last in source.length downto first loop
          if not is_in(source.data(last), right) then
            result.length := last - first + 1;
            result.data(1 to result.length) := source.data(first to last);
            return result;
          end if;
        end loop;
      end if;
    end loop;

    result.length := 0;
    return result;
  end function;

  --## Remove all leading characters in left and trailing characters in right
  --#  from source
  procedure trim( source : inout bounded_string; left : in character_set; right : in character_set ) is
  begin
    for first in 1 to source.length loop
      if not is_in(source.data(first), left) then
        for last in source.length downto first loop
          if not is_in(source.data(last), right) then
            if first = 1 then
              source.length := last;
              return;
            else
              source.length := last - first + 1;
              source.data(1 to source.length) := source.data(first to last);
              return;
            end if;
          end if;
        end loop;
        source.length := 0;
        return;
      end if;
    end loop;

    source.length := 0;
  end procedure;

  --## Return the first count characters from source
  function head( source : bounded_string; count : natural; pad : character := ' ';
    drop : truncation := error ) return bounded_string is

    variable result : bounded_string;
    constant npad : integer := count - source.length;
  begin
    if npad <= 0 then
      result.length := count;
      result.data(1 to count) := source.data(1 to count);
    elsif count <= MAX then
      result.length := count;
      result.data(1 to source.length) := source.data(1 to source.length);
      result.data(source.length+1 to count) := (others => pad);
    else
      result.length := MAX;

      case drop is
        when left =>
          if npad >= MAX then
            result.data := (others => pad);
          else
            result.data(1 to MAX - npad) := source.data(count - MAX + 1 to source.length);
            result.data(MAX - npad + 1 to MAX) := (others => pad);
          end if;
        when right =>
          result.data(1 to source.length) := source.data(1 to source.length);
          result.data(source.length+1 to MAX) := (others => pad);
        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Return the first count characters from source
  procedure head( source : inout bounded_string; count : in natural; pad : in character := ' ';
    drop : in truncation := error ) is
  begin
    source := head(source, count, pad, drop);
  end procedure;

  --## Return the last count characters from source
  function tail( source : bounded_string; count : natural; pad : character := ' ';
    drop : truncation := error ) return bounded_string is

    variable result : bounded_string;
    constant npad : integer := count - source.length;
  begin
    if npad <= 0 then
      result.length := count;
      result.data(1 to count) := source.data(source.length - count + 1 to source.length);
    elsif count <= MAX then
      result.length := count;
      result.data(1 to npad) := (others => pad);
      result.data(npad + 1 to count) := source.data(1 to source.length);
    else
      result.length := MAX;

      case drop is
        when left =>
          result.data(1 to MAX - source.length) := (others => pad);
          result.data(MAX - source.length + 1 to MAX) := source.data(1 to source.length);
        when right =>
          if npad >= MAX then
            result.data := (others => pad);
          else
            result.data(1 to npad) := (others => pad);
            result.data(npad + 1 to MAX) := source.data(1 to MAX - npad);
          end if;
        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;
  end function;

  --## Return the last count characters from source
  procedure tail( source : inout bounded_string; count : in natural; pad : in character := ' ';
    drop : in truncation := error ) is
  begin
    source := tail(source, count, pad, drop);
  end procedure;

  --## Replicate a character left number of times
  function "*"( l : natural; r : character ) return bounded_string is
    variable result : bounded_string;
  begin
    if l > MAX then
      report "Strig length error" severity error;
    else
      result.length := l;
      result.data(1 to l) := (others => r);
    end if;

    return result;
  end function;

  --## Replicate a string left number of times
  function "*"( l : natural; r : string ) return bounded_string is
    variable result : bounded_string;
    variable pos : positive := 1;
    constant rlen : natural := r'length;
    constant nlen : natural := l * rlen;
  begin
    if nlen > MAX then
      report "String index error" severity error;
    else
      result.length := nlen;
      if nlen > 0 then
        for i in 1 to l loop
          result.data(pos to pos + rlen - 1) := r;
          pos := pos + rlen;
        end loop;
      end if;
    end if;

    return result;
  end function;

  --## Replicate a bounded_string left number of times
  function "*"( l : natural; r : bounded_string ) return bounded_string is
    variable result : bounded_string;
    variable pos : positive := 1;
    constant rlen : natural := r.length;
    constant nlen : natural := l * rlen;
  begin
    if nlen > MAX then
      report "String length error" severity error;
    else
      result.length := nlen;
      if nlen > 0 then
        for i in 1 to l loop
          result.data(pos to pos + rlen - 1) := r.data(1 to rlen);
          pos := pos + rlen;
        end loop;
      end if;
    end if;

    return result;
  end function;

  --## Replicate a character count number of times
  function replicate( count : natural; item : character; drop : truncation := error )
    return bounded_string is

    variable result : bounded_string;
  begin
    if count <= MAX then
      result.length := count;
    elsif drop = error then
      report "String length error" severity error;
    else
      result.length := MAX;
    end if;

    result.data(1 to result.length) := (others => item);
    return result;
  end function;

  --## Replicate a string count number of times
  function replicate( count : natural; item : string; drop : truncation := error )
    return bounded_string is

    constant length : integer := count * item'length;
    variable result : bounded_string;
    variable ix : positive;
  begin

    if length <= MAX then
      result.length := length;
      if length > 0 then
        ix := 1;
        for i in 1 to count loop
          result.data(ix to ix + item'length - 1) := item;
          ix := ix + item'length;
        end loop;
      end if;
    else
      result.length := MAX;

      case drop is
        when left =>
          ix := MAX;
          while ix - item'length >= 1 loop
            result.data(ix - item'length + 1 to ix) := item;
            ix := ix - item'length;
          end loop;
          result.data(1 to ix) := item(item'right - ix + 1 to item'right);

        when right =>
          ix := 1;
          while ix + item'length <= MAX + 1 loop
            result.data(ix to ix + item'length - 1) := item;
            ix := ix + item'length;
          end loop;
          result.data(ix to MAX) := item(item'left to item'left + MAX - ix);

        when error =>
          report "String length error" severity error;
      end case;
    end if;

    return result;

  end function;

  --## Replicate a bounded_string count number of times
  function replicate( count : natural; item : bounded_string; drop : truncation := error )
    return bounded_string is
  begin
    return replicate(count, item.data(1 to item.length), drop);
  end function;


end package body;
