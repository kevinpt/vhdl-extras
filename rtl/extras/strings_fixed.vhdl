--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# strings_fixed.vhdl - Fixed length string library
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
--# DEPENDENCIES: strings strings_maps strings_maps_constants
--#
--# DESCRIPTION:
--#  This package provides a string library for operating on fixed length
--#  strings. This is a clone of the Ada'95 library Ada.Strings.Fixed. It is a
--#  nearly complete implementation with only the procedures taking character
--#  mapping functions omitted because of VHDL limitations.
--------------------------------------------------------------------

library extras;
use extras.strings.all;
use extras.strings_maps.all;
use extras.strings_maps_constants.all;

package strings_fixed is

  --## Move source to target.
  --# Args:
  --#  source:  String to move
  --#  target:  Destingation string
  --#  drop:    Truncation mode
  --#  justify: Alignment mode
  --#  pad :    Padding character for target when longer than source
  procedure move( source : in string; target : out string; drop : in truncation := error;
    justify : in alignment := left; pad : in character := ' ' );

  --## Find the index of the first occurance of pattern in source from the
  --#  beginning or end.
  --# Args:
  --#  source:  String to search
  --#  pattern: Search pattern
  --#  going:   Search direction
  --#  mapping: Optional mapping applied to source string
  --# Returns:
  --#  Index position of pattern or 0 if not found.
  function index( source : string; pattern : string; going : direction := forward;
    mapping : character_mapping := identity ) return natural;

  --## Find the index of first occurance of a character from set in source.
  --# Args:
  --#  source: String to search
  --#  set:    Character set to search for
  --#  test:   Check for characters inside or outside the set
  --#  going:  Search direction
  --# Returns:
  --#  Index position of first matching character or 0 if not found.
  function index( source : string; set : character_set; test : membership := inside;
    going : direction := forward ) return natural;

  --## Find the index of the first non-space character in source.
  --# Args:
  --#  source: String to search
  --#  going:  Search direction
  --# Returns:
  --#  Index position of first non-space character or 0 if none found.
  function index_non_blank( source : string; going : direction := forward ) return natural;

  --## Count the occurrences of pattern in source.
  --# Args:
  --#  source:  String to count patterns in
  --#  pattern: Pattern to count in source string
  --# Returns:
  --#  Number or times pattern occurs in the source string.
  function count( source : string; pattern : string;
    mapping : character_mapping := identity ) return natural;

  --## Count the occurrences of characters from set in source.
  --# Args:
  --#  source: String to count characters in
  --#  set:    Character set to count
  --# Returns:
  --#  Number of times a character from set occurs in the source string.
  function count( source : string; set : character_set ) return natural;

  --## Return the indices of a slice of source that satisfies the membership
  --#  selection for the character set.
  --# Args:
  --#  source: String to search for the token
  --#  set:    Character set for the token
  --#  test:   Check for characters inside or outside the set
  --#  first:  Start index of the token
  --#  last:   End index of the token or 0 if not found
  procedure find_token( source : in string; set : in character_set; test : in membership;
    first : out positive; last : out natural );

  --## Convert a source string with the provided character mapping.
  --# Args:
  --#  source:  String to translate
  --#  mapping: Mapping to apply
  --# Returns:
  --#  New string with applied mapping.
  function translate( source : string; mapping : character_mapping ) return string;

  --## Convert a source string with the provided character mapping.
  --# Args:
  --#  source:  String to translate
  --#  mapping: Mapping to apply
  procedure translate( source : inout string; mapping : in character_mapping );

  --## Replace a slice of the source string with the contents of by.
  --# Args:
  --#  source: String to replace
  --#  low:    Start of the slice (inclusive)
  --#  high:   End of the slice (inclusive)
  --#  by:     String to insert into slice position
  --# Returns:
  --#  New string with replaced slice.
  function replace_slice( source : string; low : positive; high : natural; by : string )
    return string;

  --## Replace a slice of the source string with the contents of by.
  --# Args:
  --#  source:  String to replace
  --#  low:     Start of the slice (inclusive)
  --#  high:    End of the slice (inclusive)
  --#  by:      String to insert into slice position
  --#  drop:    Truncation mode
  --#  justify: Alignment mode
  --#  pad :    Padding character when result is shorter than original string
  procedure replace_slice( source : inout string; low : in positive; high : in natural;
    by : in string; drop : in truncation := error ; justify : in alignment := left;
    pad : in character := ' ' );

  --## Insert the string new_item before the selected index in source.
  --# Args:
  --#  source:   String to insert into
  --#  before:   Index position for insertion
  --#  new_item: String to insert
  --# Returns:
  --#  Source string with new_item inserted.  
  function insert(source : string; before : positive; new_item : string ) return string;

  --## Insert the string new_item before the selected index in source.
  --# Args:
  --#  source:   String to insert into
  --#  before:   Index position for insertion
  --#  new_item: String to insert
  --#  drop:     Truncation mode
  procedure insert( source : inout string; before : in positive; new_item : in string;
    drop : in truncation := error );

  --## Overwrite new_item into source starting at the selected position.
  --# Args:
  --#  source:   String to overwrite
  --#  position: Index position for overwrite
  --#  new_item: String to write into source
  --# Returns:
  --#  New string with overwritten item.
  function overwrite( source : string; position : positive; new_item : string ) return string;

  --## Overwrite new_item into source starting at the selected position.
  --# Args:
  --#  source:   String to overwrite
  --#  position: Index position for overwrite
  --#  new_item: String to write into source
  --#  drop:     Truncation mode
  procedure overwrite( source : inout string; position : in positive; new_item : in string;
    drop : in truncation := right);

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  --# Args:
  --#  source:  String to delete a slice from
  --#  from:    Start index (inclusive)
  --#  through: End index (inclusive)
  --# Returns:
  --#  New string with a slice deleted.
  function delete( source : string; from : positive; through : natural ) return string;

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  --# Args:
  --#  source:  String to delete a slice from
  --#  from:    Start index (inclusive)
  --#  through: End index (inclusive)
  --#  justify: Position of shortened result in string
  --#  pad:     Character to use as padding for shortened string
  procedure delete( source : inout string; from : in positive; through : in natural;
    justify : in alignment := left; pad : in character := ' ');

  --## Remove space characters from leading, trailing, or both ends of source.
  --# Args:
  --#  source: String to trim
  --#  side:   Which end to trim
  --# Returns:
  --#  Source string with space trimmed.
  function trim( source : string; side : trim_end ) return string;

  --## Remove space characters from leading, trailing, or both ends of source.
  --# Args:
  --#  source:  String to trim
  --#  side:    Which end to trim
  --#  justify: Position of shortened result in string
  --#  pad:     Character to use as padding for shortened string
  procedure trim( source : inout string; side : in trim_end; justify : in alignment := left;
    pad : in character := ' ' );

  --## Remove all leading characters in left and trailing characters in right
  --#  from source.
  --# Args:
  --#  source:  String to trim
  --#  left:    Index position for start trim
  --#  right:   Index position for end trim
  --# Returns:
  --#  Source string with ends trimmed.
  function trim( source : string; left : character_set; right : character_set ) return string;

  --## Remove all leading characters in left and trailing characters in right
  --#  from source.
  --# Args:
  --#  source:  String to trim
  --#  left:    Index position for start trim
  --#  right:   Index position for end trim
  --#  justify: Position of shortened result in string
  --#  pad:     Character to use as padding for shortened string
  procedure trim( source : inout string; left : in character_set; right : in character_set;
    justify : in alignment := extras.strings.left; pad : in character := ' ' );

  --## Return the first count characters from source.
  --# Args:
  --#  source: String to slice from
  --#  count:  Number of characters to take from the start of source
  --#  pad:    Characters to pad with if source length is less than count
  --# Returns:
  --#  A string of length count.
  function head( source : string; count : natural; pad : character := ' ' ) return string;

  --## Return the first count characters from source.
  --# Args:
  --#  source:  String to slice from
  --#  count:   Number of characters to take from the start of source
  --#  justify: Position of shortened result in string  
  --#  pad:     Characters to pad with if source length is less than count
  procedure head( source : inout string; count : in natural; justify : in alignment := left;
    pad : in character := ' ');

  --## Return the last count characters from source.
  --# Args:
  --#  source: String to slice from
  --#  count:  Number of characters to take from the end of source
  --#  pad:    Characters to pad with if source length is less than count
  --# Returns:
  --#  A string of length count.
  function tail( source : string; count : natural; pad : character := ' ' ) return string;

  --## Return the last count characters from source.
  --# Args:
  --#  source:  String to slice from
  --#  count:   Number of characters to take from the end of source
  --#  justify: Position of shortened result in string
  --#  pad:     Characters to pad with if source length is less than count
  procedure tail( source : inout string; count : in natural; justify : in alignment := left;
    pad : in character := ' ' );

  --## Replicate a character left number of times.
  --# Args:
  --#  left:  Number of times to repeat the right operand
  --#  right: Character to repeat in string
  --# Returns:
  --#  String with repeated character.
  function "*" ( left : natural; right : character ) return string;

  --## Replicate a string left number of times.
  --# Args:
  --#  left:  Number of times to repeat the right operand
  --#  right: String to repeat in result string
  --# Returns:
  --#  String with repeated substring.
  function "*" ( left : natural; right : string ) return string;

  --## Compute hash value of a string.
  --# Args:
  --#  key: String to be hashed
  --# Returns:
  --#  Hash value.
  function hash( key : string ) return natural;

end package;


package body strings_fixed is

  --## Move source to target
  procedure move( source : in string; target : out string; drop : in truncation := error;
    justify : in alignment := left; pad : in character := ' ' ) is

    alias src : string(1 to source'length) is source;
    alias tgt : string(1 to target'length) is target;

    variable tpad, lpad : natural;
    variable can_trim : boolean;
  begin

    if src'length = tgt'length then
      tgt := src;
    elsif src'length < tgt'length then -- pad
      case justify is
        when left =>
          tgt(1 to src'length) := src;
          tgt(src'length+1 to tgt'length) := (tgt'length-src'length) * pad;

        when right =>
          tgt(1 to tgt'length-src'length) := (tgt'length-src'length) * pad;
          tgt(tgt'length - src'length + 1 to tgt'length) := src;

        when center =>
          lpad := (tgt'length - src'length) / 2;
          tgt(1 to lpad) := lpad * pad;
          tgt(lpad+1 to src'length+lpad) := src;
          tgt(src'length+lpad+1 to tgt'length) := (tgt'length-src'length-lpad) * pad;

      end case;
    else -- target is smaller, trim source
      case drop is
        when left =>
          tgt := src(src'length - tgt'length + 1 to src'length);

        when right =>
          tgt := src(1 to tgt'length);

        when error =>
          case justify is
            when left =>
              can_trim := true;
              for i in tgt'length + 1 to src'length loop
                if src(i) /= pad then
                  can_trim := false;
                  exit;
                end if;
              end loop;

              if can_trim then
                tgt := src(1 to tgt'length);
              else
                report "Unable to trim oversize string"
                  severity error;
              end if;

            when right =>
              can_trim := true;
              for i in 1 to src'length - tgt'length loop
                if src(i) /= pad then
                  can_trim := false;
                  exit;
                end if;
              end loop;

              if can_trim then
                tgt := src(src'length-tgt'length+1 to src'length);
              else
                report "Unable to trim oversize string"
                  severity error;
              end if;

            when center =>
              report "Unable to trim oversize string"
                severity error;
          end case;

      end case;
    end if;
  end procedure;


  --## Find the index of the first occurance of pattern in source from the
  --#  beginning or end
  function index( source : string; pattern : string; going : direction := forward;
    mapping : character_mapping := identity )
    return natural is

    constant src : string(1 to source'length) := translate(source, mapping);
    alias pat : string(1 to pattern'length) is pattern;

  begin
    case going is
      when forward =>
        for i in 1 to src'length - pat'length + 1 loop
          if src(i to i+pat'length-1) = pat then
            return source'left-1 + i;
          end if;
        end loop;

      when backward =>
        for i in src'length - pat'length + 1 downto 1 loop
          if src(i to i+pat'length-1) = pat then
            return source'left-1 + i;
          end if;
        end loop;
    end case;

    return 0;
  end function;


  --## Find the index of first occurance of a character from set in source
  function index( source : string; set : character_set; test : membership := inside;
    going : direction := forward ) return natural is
  begin
    case going is
      when forward =>
        for i in source'range loop
          if (test = inside and is_in(source(i), set)) or
             (test = outside and (not is_in(source(i), set))) then
            return i;
          end if;
        end loop;

      when backward =>
        for i in source'reverse_range loop
          if (test = inside and is_in(source(i), set)) or
             (test = outside and (not is_in(source(i), set))) then
            return i;
          end if;
        end loop;
    end case;

    return 0;
  end function;


  --## Find the index of the first non-space character in source
  function index_non_blank( source : string; going : direction := forward ) return natural is
  begin
    case going is
      when forward =>
        for i in source'range loop
          if source(i) /= ' ' then
            return i;
          end if;
        end loop;
      when backward =>
        for i in source'reverse_range loop
          if source(i) /= ' ' then
            return i;
          end if;
        end loop;
    end case;

    return 0;
  end function;


  --## Count the occurrences of pattern in source
  function count( source : string; pattern : string;
    mapping : character_mapping := identity ) return natural is

    constant src : string(1 to source'length) := translate(source, mapping);
    alias pat : string(1 to pattern'length) is pattern;

    variable c : natural := 0;
  begin
    assert pat'length > 0
      report "Zero length pattern"
      severity error;

    for i in 1 to src'length - pat'length + 1 loop
      if src(i to i+pat'length-1) = pat then
        c := c + 1;
      end if;
    end loop;

    return c;
  end function;

  --## Count the occurrences of characters from set in source
  function count( source : string; set : character_set ) return natural is
    variable c : natural := 0;
  begin
    for i in source'range loop
      if is_in(source(i), set) then
        c := c + 1;
      end if;
    end loop;

    return c;
  end function;


  --## Return the indices of a slice of source that satisfies the membership
  --#  selection for the character set.
  procedure find_token( source : in string; set : in character_set; test : in membership;
    first : out positive; last : out natural ) is
  begin
    for i in source'range loop
      if (test = inside and is_in(source(i), set)) or
        (test = outside and (not is_in(source(i), set))) then

        first := i;

        for j in i + 1 to source'right loop
          if not ((test = inside and is_in(source(j), set)) or
            (test = outside and (not is_in(source(j), set)))) then

            last := j - 1;
            return;
          end if;
        end loop;

        last := source'right;
        return;

      end if;
    end loop;

    first := source'left;
    last := 0;
  end procedure;


  --## Convert a source string with the provided character mapping
  function translate( source : string; mapping : character_mapping ) return string is
    alias src : string(1 to source'length) is source;
    variable result : string(1 to source'length);
  begin
    for i in src'range loop
      result(i) := mapping(src(i));
    end loop;

    return result;
  end function;

  --## Convert a source string with the provided character mapping
  procedure translate( source : inout string; mapping : in character_mapping ) is
    variable result : string(1 to source'length);
  begin
    for i in source'range loop
      source(i) := mapping(source(i));
    end loop;
  end procedure;


  --## Replace a slice of the source string with the contents of by
  function replace_slice( source : string; low : positive; high : natural; by : string )
    return string is
  begin
    assert (low <= source'right+1) and (high >= source'left-1)
      report "Slice out of range"
      severity error;

    if high >= low then
      return source(source'left to low-1) & by & source(high+1 to source'right);
    else
      return insert(source, low, by);
    end if;
  end function;

  --## Replace a slice of the source string with the contents of by
  procedure replace_slice( source : inout string; low : in positive; high : in natural;
    by : in string; drop : in truncation := error ; justify : in alignment := left;
    pad : in character := ' ' ) is
  begin
    move(replace_slice(source, low, high, by), source, drop, justify, pad);
  end procedure;


  --## Insert the string new_item before the selected index in source
  function insert(source : string; before : positive; new_item : string ) return string is
  begin
    assert (before >= source'left) and (before <= source'right+1)
      report "Invalid index"
      severity error;

    return source(source'left to before-1) & new_item & source(before to source'right);
  end function;

  --## Insert the string new_item before the selected index in source
  procedure insert( source : inout string; before : in positive; new_item : in string;
    drop : in truncation := error ) is
  begin
    move(insert(source, before, new_item), source, drop);
  end procedure;


  --## Overwrite new_item into source starting at the selected position
  function overwrite( source : string; position : positive; new_item : string ) return string is
  begin
    assert (position >= source'left) and (position <= source'right+1)
      report "Invalid index"
      severity error;

    return source(source'left to position-1) & new_item
      & source(position+new_item'length to source'right);
  end function;

  --## Overwrite new_item into source starting at the selected position
  procedure overwrite( source : inout string; position : in positive; new_item : in string;
    drop : in truncation := right) is
  begin
    move(overwrite(source, position, new_item), source, drop);
  end procedure;


  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  function delete( source : string; from : positive; through : natural ) return string is
  begin
    if from <= through then
      return replace_slice(source, from, through, "");
    else
      return source;
    end if;
  end function;

  --## Delete a slice from source. If from is greater than through, source is
  --#  unmodified.
  procedure delete( source : inout string; from : in positive; through : in natural;
    justify : in alignment := left; pad : in character := ' ') is
  begin
    move(delete(source, from, through), source, justify => justify, pad => pad);
  end procedure;


  --## Remove space characters from leading, trailing, or both ends of source
  function trim( source : string; side : trim_end ) return string is
    alias src : string(1 to source'length) is source;

    variable ltrim, rtrim : natural;
  begin

    ltrim := 0;
    for i in src'range loop
      if src(i) /= ' ' then -- not space
        ltrim := i;
        exit;
      end if;
    end loop;

    if ltrim = 0 then
      return "";

    else
      rtrim := src'right;
      for i in src'reverse_range loop
        if src(i) /= ' ' then -- not space
          rtrim := i;
          exit;
        end if;
      end loop;

      case side is
        when left  => return src(ltrim to src'right);
        when right => return src(1 to rtrim);
        when both  => return src(ltrim to rtrim);
      end case;
    end if;

  end function;

  --## Remove space characters from leading, trailing, or both ends of source
  procedure trim( source : inout string; side : in trim_end; justify : in alignment := left;
    pad : in character := ' ' ) is
  begin
    move(trim(source, side), source, justify => justify, pad => pad);
  end procedure;

  --## Remove all leading characters in left and trailing characters in right
  --#  from source
  function trim( source : string; left : character_set; right : character_set ) return string is
    variable ltrim, rtrim : natural;
  begin
    ltrim := index(source, left, outside, forward);
    if ltrim = 0 then
      return "";
    end if;

    rtrim := index(source, right, outside, backward);
    if rtrim = 0 then
      return "";
    end if;

    return source(ltrim to rtrim);
  end function;

  --## Remove all leading characters in left and trailing characters in right
  --#  from source
  procedure trim( source : inout string; left : in character_set; right : in character_set;
    justify : in alignment := extras.strings.left; pad : in character := ' ' ) is
  begin
    move(trim(source, left, right), source, justify => justify, pad => pad);
  end procedure;


  --## Return the first count characters from source
  function head( source : string; count : natural; pad : character := ' ' ) return string is
    alias src : string(1 to source'length) is source;
  begin
    if count <= src'length then
      return src(1 to count);
    else
      return src & (count - src'length) * pad;
    end if;
  end function;

  --## Return the first count characters from source
  procedure head( source : inout string; count : in natural; justify : in alignment := left;
    pad : in character := ' ') is
    variable s2 : string(1 to source'length) := source;
  begin
    move(head(s2, count, pad), source, justify => justify, pad => pad);
  end procedure;


  --## Return the last count characters from source
  function tail( source : string; count : natural; pad : character := ' ' ) return string is
    alias src : string(1 to source'length) is source;
  begin
    if count <= src'length then
      return src(src'right-count+1 to src'right);
    else
      return (count - src'length) * pad & src;
    end if;
  end function;

  --## Return the last count characters from source
  procedure tail( source : inout string; count : in natural; justify : in alignment := left;
    pad : in character := ' ' ) is
  begin
    move(tail(source, count, pad), source, justify => justify, pad => pad);
  end procedure;

  --## Replicate a character left number of times
  function "*" ( left : natural; right : character ) return string is
    variable str : string(1 to left);
  begin
    str := string'(str'range => right);

    return str;
  end function;

  --## Replicate a string left number of times
  function "*" ( left : natural; right : string ) return string is
    variable str : string(1 to left*right'length);
  begin
    if left > 0 then
      for i in 1 to left loop
        str(1 + right'length*(i-1) to right'length*i) := right;
      end loop;

      return str;
    else
      return "";
    end if;
  end function;

  --## Compute hash value of a string
  function hash( key : string ) return natural is
    variable h : natural := 5381;
  begin
    -- Hash using djb2 algorithm (slightly modified using mod 2**31-1)
    for i in key'range loop
      h := (h * 33 + character'pos(key(i))) mod natural'high;
    end loop;

    return h;
  end function;

end package body;
