.. Generated from ../rtl/extras_2008/strings_bounded.vhdl on 2018-06-28 23:37:30.027279
.. vhdl:package:: extras_2008.strings_bounded


Types
-----


.. vhdl:type:: bounded_string

  Bounded string object.

Subtypes
--------


.. vhdl:subtype:: length_range

  String length constrained to maximum length set by the ``MAX`` package generic.

Subprograms
-----------


.. vhdl:function:: function length(source : bounded_string) return length_range;

   Return the length of a bounded_string.
  
  :param source: String to check length of
  :type source: bounded_string
  :returns: Length of the string.
  


.. vhdl:function:: function to_bounded_string(source : string; drop : truncation := error) return bounded_string;

   Convert a string to bounded_string.
  
  :param source: String to convert
  :type source: string
  :param drop: Truncation behavior for longer strings
  :type drop: truncation
  :returns: Converted string.
  


.. vhdl:function:: function to_string(source : bounded_string) return string;

   Convert a bounded_string to string.
  
  :param source: String to convert
  :type source: bounded_string
  :returns: Bounded string converted to a plain string.
  


.. vhdl:function:: function append(l : bounded_string; r : bounded_string; drop : truncation := error) return bounded_string;

   Append two bounded_strings.
  
  :param l: Left string
  :type l: bounded_string
  :param r: Right string
  :type r: bounded_string
  :param drop: Truncation behavior for longer strings
  :type drop: truncation
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function append(l : bounded_string; r : string; drop : truncation := error) return bounded_string;

   Append a string to a bounded_string.
  
  :param l: Left string
  :type l: bounded_string
  :param r: Right string
  :type r: string
  :param drop: Truncation behavior for longer strings
  :type drop: truncation
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function append(l : string; r : bounded_string; drop : truncation := error) return bounded_string;

   Append a bounded_string to a string.
  
  :param l: Left string
  :type l: string
  :param r: Right string
  :type r: bounded_string
  :param drop: Truncation behavior for longer strings
  :type drop: truncation
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function append(l : bounded_string; r : character; drop : truncation := error) return bounded_string;

   Append a character to a bounded_string.
  
  :param l: Left string
  :type l: bounded_string
  :param r: Right character
  :type r: character
  :param drop: Truncation behavior for longer strings
  :type drop: truncation
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function append(l : character; r : bounded_string; drop : truncation := error) return bounded_string;

   Append a bounded_string to a character.
  
  :param l: Left character
  :type l: character
  :param r: Right string
  :type r: bounded_string
  :param drop: Truncation behavior for longer strings
  :type drop: truncation
  :returns: String with l and r concatenated.
  


.. vhdl:procedure:: procedure append(source : inout bounded_string; new_item : in bounded_string; drop : in truncation := error);

   Append a bounded_string.
  
  :param source: String to append onto
  :type source: inout bounded_string
  :param new_item: String to append
  :type new_item: in bounded_string
  :param drop: Truncation behavior for longer strings
  :type drop: in truncation


.. vhdl:procedure:: procedure append(source : inout bounded_string; new_item : in string; drop : in truncation := error);

   Append a string.
  
  :param source: String to append onto
  :type source: inout bounded_string
  :param new_item: String to append
  :type new_item: in string
  :param drop: Truncation behavior for longer strings
  :type drop: in truncation


.. vhdl:procedure:: procedure append(source : inout bounded_string; new_item : in character; drop : in truncation := error);

   Append a character.
  
  :param source: String to append onto
  :type source: inout bounded_string
  :param new_item: Character to append
  :type new_item: in character
  :param drop: Truncation behavior for longer strings
  :type drop: in truncation


.. vhdl:function:: function "&"(l : bounded_string; r : bounded_string) return bounded_string;

   Concatenate two strings.
  
  :param l: Left string
  :type l: bounded_string
  :param r: Right string
  :type r: bounded_string
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function "&"(l : bounded_string; r : string) return bounded_string;

   Concatenate a string to a bounded_string.
  
  :param l: Left string
  :type l: bounded_string
  :param r: Right string
  :type r: string
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function "&"(l : string; r : bounded_string) return bounded_string;

   Concatenate a bounded_string to a string.
  
  :param l: Left string
  :type l: string
  :param r: Right string
  :type r: bounded_string
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function "&"(l : bounded_string; r : character) return bounded_string;

   Concatenate a character to a string.
  
  :param l: Left string
  :type l: bounded_string
  :param r: Right character
  :type r: character
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function "&"(l : character; r : bounded_string) return bounded_string;

   Concatenate a string to a character.
  
  :param l: Left character
  :type l: character
  :param r: Right string
  :type r: bounded_string
  :returns: String with l and r concatenated.
  


.. vhdl:function:: function element(source : bounded_string; index : positive) return character;

   Return the character at the index position.
  
  :param source: String to index into
  :type source: bounded_string
  :param index: Position of the character in the string
  :type index: positive
  :returns: Character at the index position.
  


.. vhdl:procedure:: procedure replace_element(source : inout bounded_string; index : in positive; by : in character);

   Replace the character at the index position.
  
  :param source: String to have element replaced
  :type source: inout bounded_string
  :param index: Index position to insert new character
  :type index: in positive
  :param by: Character to place in the string
  :type by: in character


.. vhdl:function:: function slice(source : bounded_string; low : positive; high : natural) return string;

   Return a sliced range of a bounded_string.
  
  :param source: String to slice
  :type source: bounded_string
  :param low: low index of slice (inclusive)
  :type low: positive
  :param high: high index of slice (inclusive)
  :type high: natural
  :returns: Substring of source from low to high.
  


.. vhdl:function:: function "="(l : bounded_string; r : bounded_string) return boolean;

   Test two bounded strings for equality.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l and r are equal.
  


.. vhdl:function:: function "="(l : bounded_string; r : string) return boolean;

   Test a bounded_string and plain string for equality.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: string
  :returns: true when l and r are equal.
  


.. vhdl:function:: function "="(l : string; r : bounded_string) return boolean;

   Test a plain string and a bounded_string for equality.
  
  :param l: First string to compare
  :type l: string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l and r are equal.
  


.. vhdl:function:: function "<"(l : bounded_string; r : bounded_string) return boolean;

   Test two bounded_strings for one lexicographically before the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l lexicographically proceeds r.
  


.. vhdl:function:: function "<"(l : bounded_string; r : string) return boolean;

   Test a bounded_string and a plain string for one lexicographically before the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: string
  :returns: true when l lexicographically proceeds r.
  


.. vhdl:function:: function "<"(l : string; r : bounded_string) return boolean;

   Test a plain string and a bounded_string for one lexicographically before the other.
  
  :param l: First string to compare
  :type l: string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l lexicographically proceeds r.
  


.. vhdl:function:: function "<="(l : bounded_string; r : bounded_string) return boolean;

   Test two bounded_strings for equality or one lexicographically before the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l and r are equal or l lexicographically proceeds r.
  


.. vhdl:function:: function "<="(l : bounded_string; r : string) return boolean;

   Test a bounded_string and a plain string for equality or one lexicographically before the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: string
  :returns: true when l and r are equal or l lexicographically proceeds r.
  


.. vhdl:function:: function "<="(l : string; r : bounded_string) return boolean;

   Test a plain string and a bounded_string for equality or one lexicographically before the other.
  
  :param l: First string to compare
  :type l: string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l and r are equal or l lexicographically proceeds r.
  


.. vhdl:function:: function ">"(l : bounded_string; r : bounded_string) return boolean;

   Test two bounded_strings for one lexicographically after the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l lexicographically follows r.
  


.. vhdl:function:: function ">"(l : bounded_string; r : string) return boolean;

   Test a bounded_string and a plain string for one lexicographically after the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: string
  :returns: true when l lexicographically follows r.
  


.. vhdl:function:: function ">"(l : string; r : bounded_string) return boolean;

   Test a plain string and a bounded_string for one lexicographically after the other.
  
  :param l: First string to compare
  :type l: string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l lexicographically follows r.
  


.. vhdl:function:: function ">="(l : bounded_string; r : bounded_string) return boolean;

   Test two bounded_strings for equality or one lexicographically after the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l and r are equal or l lexicographically follows r.
  


.. vhdl:function:: function ">="(l : bounded_string; r : string) return boolean;

   Test a bounded_string and a plain string for equality or one lexicographically after the other.
  
  :param l: First string to compare
  :type l: bounded_string
  :param r: Second string to compare
  :type r: string
  :returns: true when l and r are equal or l lexicographically follows r.
  


.. vhdl:function:: function ">="(l : string; r : bounded_string) return boolean;

   Test a plain string and a bounded_string for equality or one lexicographically after the other.
  
  :param l: First string to compare
  :type l: string
  :param r: Second string to compare
  :type r: bounded_string
  :returns: true when l and r are equal or l lexicographically follows r.
  


.. vhdl:function:: function index(source : bounded_string; pattern : string; going : direction := forward; mapping : character_mapping := IDENTITY) return natural;

   Find the index of the first occurance of pattern in source from the
   beginning or end.
  
  :param source: String to index into
  :type source: bounded_string
  :param pattern: Pattern to search for
  :type pattern: string
  :param going: Search direction
  :type going: direction
  :param mapping: Optional character mapping applied before the search
  :type mapping: character_mapping
  :returns: Index position of pattern or 0 if not found.
  


.. vhdl:function:: function index(source : bounded_string; set : character_set; test : membership := inside; going : direction := forward) return natural;

   Find the index of first occurance of a character from set in source.
  
  :param source: String to search
  :type source: bounded_string
  :param set: Character set to search for
  :type set: character_set
  :param test: Check for characters inside or outside the set
  :type test: membership
  :param going: Search direction
  :type going: direction
  :returns: Index position of first matching character or 0 if not found.
  


.. vhdl:function:: function index_non_blank(source : bounded_string; going : direction := forward) return natural;

   Find the index of the first non-space character in source.
  
  :param source: String to search
  :type source: bounded_string
  :param going: Search direction
  :type going: direction
  :returns: Index position of first non-space character or 0 if none found.
  


.. vhdl:function:: function count(source : bounded_string; pattern : string; mapping : character_mapping := IDENTITY) return natural;

   Count the occurrences of pattern in source.
  
  :param source: String to count patterns in
  :type source: bounded_string
  :param pattern: Pattern to count in source string
  :type pattern: string
  :returns: Number or times pattern occurs in the source string.
  


.. vhdl:function:: function count(source : bounded_string; set : character_set) return natural;

   Count the occurrences of characters from set in source.
  
  :param source: String to count characters in
  :type source: bounded_string
  :param set: Character set to count
  :type set: character_set
  :returns: Number of times a character from set occurs in the source string.
  


.. vhdl:procedure:: procedure find_token(source : in bounded_string; set : in character_set; test : in membership; first : out positive; last : out natural);

   Return the indices of a slice of source that satisfies the membership
   selection for the character set.
  
  :param source: String to search for the token
  :type source: in bounded_string
  :param set: Character set for the token
  :type set: in character_set
  :param test: Check for characters inside or outside the set
  :type test: in membership
  :param first: Start index of the token
  :type first: out positive
  :param last: End index of the token or 0 if not found
  :type last: out natural


.. vhdl:function:: function translate(source : bounded_string; mapping : character_mapping) return bounded_string;

   Convert a source string with the provided character mapping.
  
  :param source: String to translate
  :type source: bounded_string
  :param mapping: Mapping to apply
  :type mapping: character_mapping
  :returns: New string with applied mapping.
  


.. vhdl:procedure:: procedure translate(source : inout bounded_string; mapping : in character_mapping);

   Convert a source string with the provided character mapping.
  
  :param source: String to translate
  :type source: inout bounded_string
  :param mapping: Mapping to apply
  :type mapping: in character_mapping


.. vhdl:function:: function replace_slice(source : bounded_string; low : positive; high : natural; by : string; drop : truncation := error) return bounded_string;

   Replace a slice of the source string with the contents of by.
  
  :param source: String to replace
  :type source: bounded_string
  :param low: Start of the slice (inclusive)
  :type low: positive
  :param high: End of the slice (inclusive)
  :type high: natural
  :param by: String to insert into slice position
  :type by: string
  :returns: New string with replaced slice.
  


.. vhdl:procedure:: procedure replace_slice(source : inout bounded_string; low : in positive; high : in natural; by : in string; drop : in truncation := error);

   Replace a slice of the source string with the contents of by.
  
  :param source: String to replace
  :type source: inout bounded_string
  :param low: Start of the slice (inclusive)
  :type low: in positive
  :param high: End of the slice (inclusive)
  :type high: in natural
  :param by: String to insert into slice position
  :type by: in string
  :param drop: Truncation mode
  :type drop: in truncation
  :param justify: Alignment mode
  :param pad: Padding character when result is shorter than original string


.. vhdl:function:: function insert(source : bounded_string; before : positive; new_item : string; drop : truncation := error) return bounded_string;

   Insert the string new_item before the selected index in source.
  
  :param source: String to insert into
  :type source: bounded_string
  :param before: Index position for insertion
  :type before: positive
  :param new_item: String to insert
  :type new_item: string
  :returns: Source string with new_item inserted.
  


.. vhdl:procedure:: procedure insert(source : inout bounded_string; before : in positive; new_item : in string; drop : in truncation := error);

   Insert the string new_item before the selected index in source.
  
  :param source: String to insert into
  :type source: inout bounded_string
  :param before: Index position for insertion
  :type before: in positive
  :param new_item: String to insert
  :type new_item: in string
  :param drop: Truncation mode
  :type drop: in truncation


.. vhdl:function:: function overwrite(source : bounded_string; position : positive; new_item : string; drop : truncation := error) return bounded_string;

   Overwrite new_item into source starting at the selected position.
  
  :param source: String to overwrite
  :type source: bounded_string
  :param position: Index position for overwrite
  :type position: positive
  :param new_item: String to write into source
  :type new_item: string
  :returns: New string with overwritten item.
  


.. vhdl:procedure:: procedure overwrite(source : inout bounded_string; position : in positive; new_item : in string; drop : in truncation := error);

   Overwrite new_item into source starting at the selected position.
  
  :param source: String to overwrite
  :type source: inout bounded_string
  :param position: Index position for overwrite
  :type position: in positive
  :param new_item: String to write into source
  :type new_item: in string
  :param drop: Truncation mode
  :type drop: in truncation


.. vhdl:function:: function delete(source : bounded_string; from : positive; through : natural) return bounded_string;

   Delete a slice from source. If from is greater than through, source is
   unmodified.
  
  :param source: String to delete a slice from
  :type source: bounded_string
  :param from: Start index (inclusive)
  :type from: positive
  :param through: End index (inclusive)
  :type through: natural
  :returns: New string with a slice deleted.
  


.. vhdl:procedure:: procedure delete(source : inout bounded_string; from : in positive; through : in natural);

   Delete a slice from source. If from is greater than through, source is
   unmodified.
  
  :param source: String to delete a slice from
  :type source: inout bounded_string
  :param from: Start index (inclusive)
  :type from: in positive
  :param through: End index (inclusive)
  :type through: in natural
  :param justify: Position of shortened result in string
  :param pad: Character to use as padding for shortened string


.. vhdl:function:: function trim(source : bounded_string; side : trim_end) return bounded_string;

   Remove space characters from leading, trailing, or both ends of source.
  
  :param source: String to trim
  :type source: bounded_string
  :param side: Which end to trim
  :type side: trim_end
  :returns: Source string with space trimmed.
  


.. vhdl:procedure:: procedure trim(source : inout bounded_string; side : in trim_end);

   Remove space characters from leading, trailing, or both ends of source.
  
  :param source: String to trim
  :type source: inout bounded_string
  :param side: Which end to trim
  :type side: in trim_end


.. vhdl:function:: function trim(source : bounded_string; left : character_set; right : character_set) return bounded_string;

   Remove all leading characters in left and trailing characters in right
   from source.
  
  :param source: String to trim
  :type source: bounded_string
  :param left: Index position for start trim
  :type left: character_set
  :param right: Index position for end trim
  :type right: character_set
  :returns: Source string with ends trimmed.
  


.. vhdl:procedure:: procedure trim(source : inout bounded_string; left : in character_set; right : in character_set);

   Remove all leading characters in left and trailing characters in right
   from source.
  
  :param source: String to trim
  :type source: inout bounded_string
  :param left: Index position for start trim
  :type left: in character_set
  :param right: Index position for end trim
  :type right: in character_set


.. vhdl:function:: function head(source : bounded_string; count : natural; pad : character := ' '; drop : truncation := error) return bounded_string;

   Return the first count characters from source.
  
  :param source: String to slice from
  :type source: bounded_string
  :param count: Number of characters to take from the start of source
  :type count: natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: character
  :param drop: Truncation behavior
  :type drop: truncation
  :returns: A string of length count.
  


.. vhdl:procedure:: procedure head(source : inout bounded_string; count : in natural; pad : in character := ' '; drop : in truncation := error);

   Return the first count characters from source.
  
  :param source: String to slice from
  :type source: inout bounded_string
  :param count: Number of characters to take from the start of source
  :type count: in natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: in character
  :param drop: Truncation behavior
  :type drop: in truncation


.. vhdl:function:: function tail(source : bounded_string; count : natural; pad : character := ' '; drop : truncation := error) return bounded_string;

   Return the last count characters from source.
  
  :param source: String to slice from
  :type source: bounded_string
  :param count: Number of characters to take from the end of source
  :type count: natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: character
  :param drop: Truncation behavior
  :type drop: truncation
  :returns: A string of length count.
  


.. vhdl:procedure:: procedure tail(source : inout bounded_string; count : in natural; pad : in character := ' '; drop : in truncation := error);

   Return the last count characters from source.
  
  :param source: String to slice from
  :type source: inout bounded_string
  :param count: Number of characters to take from the end of source
  :type count: in natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: in character
  :param drop: Truncation behavior
  :type drop: in truncation


.. vhdl:function:: function "*"(l : natural; r : character) return bounded_string;

   Replicate a character left number of times.
  
  :param left: Number of times to repeat the right operand
  :param right: Character to repeat in string
  :returns: String with repeated character.
  


.. vhdl:function:: function "*"(l : natural; r : string) return bounded_string;

   Replicate a string left number of times.
  
  :param left: Number of times to repeat the right operand
  :param right: String to repeat in result string
  :returns: String with repeated substring.
  


.. vhdl:function:: function "*"(l : natural; r : bounded_string) return bounded_string;

   Replicate a bounded_string left number of times.
  
  :param left: Number of times to repeat the right operand
  :param right: String to repeat in result string
  :returns: String with repeated substring.
  


.. vhdl:function:: function replicate(count : natural; item : character; drop : truncation := error) return bounded_string;

   Replicate a character count number of times.
  
  :param count: Number of times to repeat the item operand
  :type count: natural
  :param item: Character to repeat in string
  :type item: character
  :param drop: Truncation behavior
  :type drop: truncation
  :returns: String with repeated character.
  


.. vhdl:function:: function replicate(count : natural; item : string; drop : truncation := error) return bounded_string;

   Replicate a string count number of times.
  
  :param count: Number of times to repeat the item operand
  :type count: natural
  :param item: String to repeat in result string
  :type item: string
  :param drop: Truncation behavior
  :type drop: truncation
  :returns: String with repeated substring.
  


.. vhdl:function:: function replicate(count : natural; item : bounded_string; drop : truncation := error) return bounded_string;

   Replicate a bounded_string count number of times.
  
  :param count: Number of times to repeat the item operand
  :type count: natural
  :param item: String to repeat in result string
  :type item: bounded_string
  :param drop: Truncation behavior
  :type drop: truncation
  :returns: String with repeated substring.
  

