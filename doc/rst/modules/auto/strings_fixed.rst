.. Generated from ../rtl/extras/strings_fixed.vhdl on 2018-06-28 23:37:28.566470
.. vhdl:package:: extras.strings_fixed


Subprograms
-----------


.. vhdl:procedure:: procedure move(source : in string; target : out string; drop : in truncation := error; justify : in alignment := left; pad : in character := ' ');

   Move source to target.
  
  :param source: String to move
  :type source: in string
  :param target: Destingation string
  :type target: out string
  :param drop: Truncation mode
  :type drop: in truncation
  :param justify: Alignment mode
  :type justify: in alignment
  :param pad: Padding character for target when longer than source
  :type pad: in character


.. vhdl:function:: function index(source : string; pattern : string; going : direction := forward; mapping : character_mapping := identity) return natural;

   Find the index of the first occurance of pattern in source from the
   beginning or end.
  
  :param source: String to search
  :type source: string
  :param pattern: Search pattern
  :type pattern: string
  :param going: Search direction
  :type going: direction
  :param mapping: Optional mapping applied to source string
  :type mapping: character_mapping
  :returns: Index position of pattern or 0 if not found.
  


.. vhdl:function:: function index(source : string; set : character_set; test : membership := inside; going : direction := forward) return natural;

   Find the index of first occurance of a character from set in source.
  
  :param source: String to search
  :type source: string
  :param set: Character set to search for
  :type set: character_set
  :param test: Check for characters inside or outside the set
  :type test: membership
  :param going: Search direction
  :type going: direction
  :returns: Index position of first matching character or 0 if not found.
  


.. vhdl:function:: function index_non_blank(source : string; going : direction := forward) return natural;

   Find the index of the first non-space character in source.
  
  :param source: String to search
  :type source: string
  :param going: Search direction
  :type going: direction
  :returns: Index position of first non-space character or 0 if none found.
  


.. vhdl:function:: function count(source : string; pattern : string; mapping : character_mapping := identity) return natural;

   Count the occurrences of pattern in source.
  
  :param source: String to count patterns in
  :type source: string
  :param pattern: Pattern to count in source string
  :type pattern: string
  :returns: Number or times pattern occurs in the source string.
  


.. vhdl:function:: function count(source : string; set : character_set) return natural;

   Count the occurrences of characters from set in source.
  
  :param source: String to count characters in
  :type source: string
  :param set: Character set to count
  :type set: character_set
  :returns: Number of times a character from set occurs in the source string.
  


.. vhdl:procedure:: procedure find_token(source : in string; set : in character_set; test : in membership; first : out positive; last : out natural);

   Return the indices of a slice of source that satisfies the membership
   selection for the character set.
  
  :param source: String to search for the token
  :type source: in string
  :param set: Character set for the token
  :type set: in character_set
  :param test: Check for characters inside or outside the set
  :type test: in membership
  :param first: Start index of the token
  :type first: out positive
  :param last: End index of the token or 0 if not found
  :type last: out natural


.. vhdl:function:: function translate(source : string; mapping : character_mapping) return string;

   Convert a source string with the provided character mapping.
  
  :param source: String to translate
  :type source: string
  :param mapping: Mapping to apply
  :type mapping: character_mapping
  :returns: New string with applied mapping.
  


.. vhdl:procedure:: procedure translate(source : inout string; mapping : in character_mapping);

   Convert a source string with the provided character mapping.
  
  :param source: String to translate
  :type source: inout string
  :param mapping: Mapping to apply
  :type mapping: in character_mapping


.. vhdl:function:: function replace_slice(source : string; low : positive; high : natural; by : string) return string;

   Replace a slice of the source string with the contents of by.
  
  :param source: String to replace
  :type source: string
  :param low: Start of the slice (inclusive)
  :type low: positive
  :param high: End of the slice (inclusive)
  :type high: natural
  :param by: String to insert into slice position
  :type by: string
  :returns: New string with replaced slice.
  


.. vhdl:procedure:: procedure replace_slice(source : inout string; low : in positive; high : in natural; by : in string; drop : in truncation := error; justify : in alignment := left; pad : in character := ' ');

   Replace a slice of the source string with the contents of by.
  
  :param source: String to replace
  :type source: inout string
  :param low: Start of the slice (inclusive)
  :type low: in positive
  :param high: End of the slice (inclusive)
  :type high: in natural
  :param by: String to insert into slice position
  :type by: in string
  :param drop: Truncation mode
  :type drop: in truncation
  :param justify: Alignment mode
  :type justify: in alignment
  :param pad: Padding character when result is shorter than original string
  :type pad: in character


.. vhdl:function:: function insert(source : string; before : positive; new_item : string) return string;

   Insert the string new_item before the selected index in source.
  
  :param source: String to insert into
  :type source: string
  :param before: Index position for insertion
  :type before: positive
  :param new_item: String to insert
  :type new_item: string
  :returns: Source string with new_item inserted.
  


.. vhdl:procedure:: procedure insert(source : inout string; before : in positive; new_item : in string; drop : in truncation := error);

   Insert the string new_item before the selected index in source.
  
  :param source: String to insert into
  :type source: inout string
  :param before: Index position for insertion
  :type before: in positive
  :param new_item: String to insert
  :type new_item: in string
  :param drop: Truncation mode
  :type drop: in truncation


.. vhdl:function:: function overwrite(source : string; position : positive; new_item : string) return string;

   Overwrite new_item into source starting at the selected position.
  
  :param source: String to overwrite
  :type source: string
  :param position: Index position for overwrite
  :type position: positive
  :param new_item: String to write into source
  :type new_item: string
  :returns: New string with overwritten item.
  


.. vhdl:procedure:: procedure overwrite(source : inout string; position : in positive; new_item : in string; drop : in truncation := right);

   Overwrite new_item into source starting at the selected position.
  
  :param source: String to overwrite
  :type source: inout string
  :param position: Index position for overwrite
  :type position: in positive
  :param new_item: String to write into source
  :type new_item: in string
  :param drop: Truncation mode
  :type drop: in truncation


.. vhdl:function:: function delete(source : string; from : positive; through : natural) return string;

   Delete a slice from source. If from is greater than through, source is
   unmodified.
  
  :param source: String to delete a slice from
  :type source: string
  :param from: Start index (inclusive)
  :type from: positive
  :param through: End index (inclusive)
  :type through: natural
  :returns: New string with a slice deleted.
  


.. vhdl:procedure:: procedure delete(source : inout string; from : in positive; through : in natural; justify : in alignment := left; pad : in character := ' ');

   Delete a slice from source. If from is greater than through, source is
   unmodified.
  
  :param source: String to delete a slice from
  :type source: inout string
  :param from: Start index (inclusive)
  :type from: in positive
  :param through: End index (inclusive)
  :type through: in natural
  :param justify: Position of shortened result in string
  :type justify: in alignment
  :param pad: Character to use as padding for shortened string
  :type pad: in character


.. vhdl:function:: function trim(source : string; side : trim_end) return string;

   Remove space characters from leading, trailing, or both ends of source.
  
  :param source: String to trim
  :type source: string
  :param side: Which end to trim
  :type side: trim_end
  :returns: Source string with space trimmed.
  


.. vhdl:procedure:: procedure trim(source : inout string; side : in trim_end; justify : in alignment := left; pad : in character := ' ');

   Remove space characters from leading, trailing, or both ends of source.
  
  :param source: String to trim
  :type source: inout string
  :param side: Which end to trim
  :type side: in trim_end
  :param justify: Position of shortened result in string
  :type justify: in alignment
  :param pad: Character to use as padding for shortened string
  :type pad: in character


.. vhdl:function:: function trim(source : string; left : character_set; right : character_set) return string;

   Remove all leading characters in left and trailing characters in right
   from source.
  
  :param source: String to trim
  :type source: string
  :param left: Index position for start trim
  :type left: character_set
  :param right: Index position for end trim
  :type right: character_set
  :returns: Source string with ends trimmed.
  


.. vhdl:procedure:: procedure trim(source : inout string; left : in character_set; right : in character_set; justify : in alignment := extras.strings.left; pad : in character := ' ');

   Remove all leading characters in left and trailing characters in right
   from source.
  
  :param source: String to trim
  :type source: inout string
  :param left: Index position for start trim
  :type left: in character_set
  :param right: Index position for end trim
  :type right: in character_set
  :param justify: Position of shortened result in string
  :type justify: in alignment
  :param pad: Character to use as padding for shortened string
  :type pad: in character


.. vhdl:function:: function head(source : string; count : natural; pad : character := ' ') return string;

   Return the first count characters from source.
  
  :param source: String to slice from
  :type source: string
  :param count: Number of characters to take from the start of source
  :type count: natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: character
  :returns: A string of length count.
  


.. vhdl:procedure:: procedure head(source : inout string; count : in natural; justify : in alignment := left; pad : in character := ' ');

   Return the first count characters from source.
  
  :param source: String to slice from
  :type source: inout string
  :param count: Number of characters to take from the start of source
  :type count: in natural
  :param justify: Position of shortened result in string
  :type justify: in alignment
  :param pad: Characters to pad with if source length is less than count
  :type pad: in character


.. vhdl:function:: function tail(source : string; count : natural; pad : character := ' ') return string;

   Return the last count characters from source.
  
  :param source: String to slice from
  :type source: string
  :param count: Number of characters to take from the end of source
  :type count: natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: character
  :returns: A string of length count.
  


.. vhdl:procedure:: procedure tail(source : inout string; count : in natural; justify : in alignment := left; pad : in character := ' ');

   Return the last count characters from source.
  
  :param source: String to slice from
  :type source: inout string
  :param count: Number of characters to take from the end of source
  :type count: in natural
  :param justify: Position of shortened result in string
  :type justify: in alignment
  :param pad: Characters to pad with if source length is less than count
  :type pad: in character


.. vhdl:function:: function "*"(left : natural; right : character) return string;

   Replicate a character left number of times.
  
  :param left: Number of times to repeat the right operand
  :type left: natural
  :param right: Character to repeat in string
  :type right: character
  :returns: String with repeated character.
  


.. vhdl:function:: function "*"(left : natural; right : string) return string;

   Replicate a string left number of times.
  
  :param left: Number of times to repeat the right operand
  :type left: natural
  :param right: String to repeat in result string
  :type right: string
  :returns: String with repeated substring.
  


.. vhdl:function:: function hash(key : string) return natural;

   Compute hash value of a string.
  
  :param key: String to be hashed
  :type key: string
  :returns: Hash value.
  

