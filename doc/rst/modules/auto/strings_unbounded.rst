.. Generated from ../rtl/extras/strings_unbounded.vhdl on 2018-06-28 23:37:28.643702
.. vhdl:package:: extras.strings_unbounded


Subtypes
--------


.. vhdl:subtype:: unbounded_string

  A subtype of the textio ``line`` type to form a coupling between libraries.

Subprograms
-----------


.. vhdl:function:: function to_unbounded_string(source : string) return unbounded_string;

   Convert a string to unbounded_string.
  
  :param source: String to convert into unbounded_string
  :type source: string
  :returns: A converted string.
  


.. vhdl:function:: function to_unbounded_string(length : natural) return unbounded_string;

   Allocate a string of length.
  
  :param length: Length of the new string
  :type length: natural
  :returns: A new string of the requested length.
  


.. vhdl:procedure:: procedure to_string(source : in unbounded_string; dest : out string);

   Copy a unbounded_string to the string dest.
  
  :param source: String to copy
  :type source: in unbounded_string
  :param dest: Copy destination
  :type dest: out string


.. vhdl:procedure:: procedure initialize(source : inout unbounded_string);

   Create an empty unbounded_string.
  
  :param source: String to initialize
  :type source: inout unbounded_string


.. vhdl:procedure:: procedure free(source : inout unbounded_string);

   Free allocated memory for source.
  
  :param source: Deallocate an unbounded_string
  :type source: inout unbounded_string


.. vhdl:procedure:: procedure length(source : in unbounded_string; len : out natural);

   Return the length of a unbounded_string.
  
  :param source: String to check length of
  :type source: in unbounded_string
  :param len: Length of the string
  :type len: out natural


.. vhdl:procedure:: procedure copy(source : in unbounded_string; dest : inout unbounded_string; max : in integer := -1);

   Copy at most max characters from source to the unallocated dest.
  
  :param source: String to copy
  :type source: in unbounded_string
  :param dest: Destination of copy
  :type dest: inout unbounded_string
  :param max: Maximum number of characters to copy
  :type max: in integer


.. vhdl:procedure:: procedure copy(source : in string; dest : inout unbounded_string; max : in integer := -1);

   Copy at most max characters from source to the unallocated dest.
  
  :param source: String to copy
  :type source: in string
  :param dest: Destination of copy
  :type dest: inout unbounded_string
  :param max: Maximum number of characters to copy
  :type max: in integer


.. vhdl:procedure:: procedure append(source : inout unbounded_string; new_item : in unbounded_string);

   Append unbounded_string new_item to source.
  
  :param source: String to append onto
  :type source: inout unbounded_string
  :param new_item: String to append
  :type new_item: in unbounded_string


.. vhdl:procedure:: procedure append(source : inout unbounded_string; new_item : in string);

   Append string new_item to source.
  
  :param source: String to append onto
  :type source: inout unbounded_string
  :param new_item: String to append
  :type new_item: in string


.. vhdl:procedure:: procedure append(source : inout unbounded_string; new_item : in character);

   Append character new_item to source.
  
  :param source: String to append onto
  :type source: inout unbounded_string
  :param new_item: Character to append
  :type new_item: in character


.. vhdl:procedure:: procedure element(source : in unbounded_string; index : in positive; el : out character);

   Lookup the character in source at index.
  
  :param source: String to index into
  :type source: in unbounded_string
  :param index: Position of element to retrieve
  :type index: in positive
  :param el: Character at index position
  :type el: out character


.. vhdl:procedure:: procedure replace_element(source : inout unbounded_string; index : in positive; by : in character);

   Replace the character in source at index with by.
  
  :param source: String to modify
  :type source: inout unbounded_string
  :param index: Position of element to modify
  :type index: in positive
  :param by: New character to place in index position
  :type by: in character


.. vhdl:procedure:: procedure slice(source : in unbounded_string; low : in positive; high : in positive; result : inout unbounded_string);

   Extract a slice from source.
  
  :param source: String to slice
  :type source: in unbounded_string
  :param low: Start index of slice (inclusive)
  :type low: in positive
  :param high: End index of slice (inclusive)
  :type high: in positive
  :param result: Sliced string
  :type result: inout unbounded_string


.. vhdl:procedure:: procedure eq(left : in unbounded_string; right : in unbounded_string; result : out boolean);

   Test if left is identical to right.
  
  :param left: Left string
  :type left: in unbounded_string
  :param right: Right string
  :type right: in unbounded_string
  :param result: true when strings are identical.
  :type result: out boolean


.. vhdl:procedure:: procedure eq(left : in unbounded_string; right : in string; result : out boolean);

   Test if left is identical to right.
  
  :param left: Left string
  :type left: in unbounded_string
  :param right: Right string
  :type right: in string
  :param result: true when strings are identical.
  :type result: out boolean


.. vhdl:procedure:: procedure count(source : in unbounded_string; pattern : in string; val : out natural);

   Count the occurrences of pattern in source.
  
  :param source: String to count patterns in
  :type source: in unbounded_string
  :param pattern: Pattern to count in source string
  :type pattern: in string
  :param val: Number or times pattern occurs in the source string.
  :type val: out natural


.. vhdl:procedure:: procedure delete(source : inout unbounded_string; from : in positive; through : in natural);

   Delete a slice from source. If from is greater than through, source is
   unmodified.
  
  :param source: String to delete a slice from
  :type source: inout unbounded_string
  :param from: Start index (inclusive)
  :type from: in positive
  :param through: End index (inclusive)
  :type through: in natural


.. vhdl:procedure:: procedure find_token(source : in unbounded_string; set : in character_set; test : in membership; first : out positive; last : out natural);

   Return the indices of a slice of source that satisfies the membership
   selection for the character set.
  
  :param source: String to search for the token
  :type source: in unbounded_string
  :param set: Character set for the token
  :type set: in character_set
  :param test: Check for characters inside or outside the set
  :type test: in membership
  :param first: Start index of the token
  :type first: out positive
  :param last: End index of the token or 0 if not found
  :type last: out natural


.. vhdl:procedure:: procedure head(source : inout unbounded_string; count : in natural; pad : in character := ' ');

   Return the first count characters from source.
  
  :param source: String to slice head from
  :type source: inout unbounded_string
  :param count: Number of characters to take from the start of source
  :type count: in natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: in character


.. vhdl:procedure:: procedure insert(source : inout unbounded_string; before : in positive; new_item : in string);

   Insert the string new_item before the selected index in source.
  
  :param source: String to insert into
  :type source: inout unbounded_string
  :param before: Index position for insertion
  :type before: in positive
  :param new_item: String to insert
  :type new_item: in string


.. vhdl:procedure:: procedure overwrite(source : inout unbounded_string; position : in positive; new_item : in string);

   Overwrite new_item into source starting at the selected position.
  
  :param source: String to overwrite
  :type source: inout unbounded_string
  :param position: Index position for overwrite
  :type position: in positive
  :param new_item: String to write into source
  :type new_item: in string


.. vhdl:procedure:: procedure replace_slice(source : inout unbounded_string; low : in positive; high : in natural; by : in string);

   Replace a slice of the source string with the contents of by.
  
  :param source: String to replace
  :type source: inout unbounded_string
  :param low: Start of the slice (inclusive)
  :type low: in positive
  :param high: End of the slice (inclusive)
  :type high: in natural
  :param by: String to insert into slice position
  :type by: in string


.. vhdl:procedure:: procedure tail(source : inout unbounded_string; count : in natural; pad : in character := ' ');

   Return the last count characters from source.
  
  :param source: String to slice tail from
  :type source: inout unbounded_string
  :param count: Number of characters to take from the end of source
  :type count: in natural
  :param pad: Characters to pad with if source length is less than count
  :type pad: in character


.. vhdl:procedure:: procedure translate(source : inout unbounded_string; mapping : in character_mapping);

   Convert a source string with the provided character mapping.
  
  :param source: String to translate
  :type source: inout unbounded_string
  :param mapping: Mapping to apply
  :type mapping: in character_mapping


.. vhdl:procedure:: procedure trim(source : inout unbounded_string; side : in trim_end);

   Remove space characters from leading, trailing, or both ends of source.
  
  :param source: String to trim
  :type source: inout unbounded_string
  :param side: Which end to trim
  :type side: in trim_end


.. vhdl:procedure:: procedure trim(source : inout unbounded_string; left : in character_set; right : in character_set);

   Remove all leading characters in left and trailing characters in right
   from source.
  
  :param source: String to trim
  :type source: inout unbounded_string
  :param left: Index position for start trim
  :type left: in character_set
  :param right: Index position for end trim
  :type right: in character_set

