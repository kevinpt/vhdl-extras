.. Generated from ../rtl/extras/strings_fixed.vhdl on 2017-04-02 22:57:52.964493
.. vhdl:package:: strings_fixed

Subprograms
-----------


.. vhdl:procedure:: procedure move(source : in string; target : out string; drop : in truncation; justify : in alignment; pad : in character);

  :param source: 
  :type source: in string
  :param target: 
  :type target: out string
  :param drop: 
  :type drop: in truncation
  :param justify: 
  :type justify: in alignment
  :param pad: 
  :type pad: in character

  Move source to target

.. vhdl:function:: function index(source : string; pattern : string; going : direction; mapping : character_mapping) return natural;

  :param source: 
  :type source: string
  :param pattern: 
  :type pattern: string
  :param going: 
  :type going: direction
  :param mapping: 
  :type mapping: character_mapping

  Find the index of the first occurance of pattern in source from the
  beginning or end

.. vhdl:function:: function index(source : string; set : character_set; test : membership; going : direction) return natural;

  :param source: 
  :type source: string
  :param set: 
  :type set: character_set
  :param test: 
  :type test: membership
  :param going: 
  :type going: direction

  Find the index of first occurance of a character from set in source

.. vhdl:function:: function index_non_blank(source : string; going : direction) return natural;

  :param source: 
  :type source: string
  :param going: 
  :type going: direction

  Find the index of the first non-space character in source

.. vhdl:function:: function count(source : string; pattern : string; mapping : character_mapping) return natural;

  :param source: 
  :type source: string
  :param pattern: 
  :type pattern: string
  :param mapping: 
  :type mapping: character_mapping

  Count the occurrences of pattern in source

.. vhdl:function:: function count(source : string; set : character_set) return natural;

  :param source: 
  :type source: string
  :param set: 
  :type set: character_set

  Count the occurrences of characters from set in source

.. vhdl:procedure:: procedure find_token(source : in string; set : in character_set; test : in membership; first : out positive; last : out natural);

  :param source: 
  :type source: in string
  :param set: 
  :type set: in character_set
  :param test: 
  :type test: in membership
  :param first: 
  :type first: out positive
  :param last: 
  :type last: out natural

  Return the indices of a slice of source that satisfies the membership
  selection for the character set.

.. vhdl:function:: function translate(source : string; mapping : character_mapping) return string;

  :param source: 
  :type source: string
  :param mapping: 
  :type mapping: character_mapping

  Convert a source string with the provided character mapping

.. vhdl:procedure:: procedure translate(source : inout string; mapping : in character_mapping);

  :param source: 
  :type source: inout string
  :param mapping: 
  :type mapping: in character_mapping

  Convert a source string with the provided character mapping

.. vhdl:function:: function replace_slice(source : string; low : positive; high : natural; by : string) return string;

  :param source: 
  :type source: string
  :param low: 
  :type low: positive
  :param high: 
  :type high: natural
  :param by: 
  :type by: string

  Replace a slice of the source string with the contents of by

.. vhdl:procedure:: procedure replace_slice(source : inout string; low : in positive; high : in natural; by : in string; drop : in truncation; justify : in alignment; pad : in character);

  :param source: 
  :type source: inout string
  :param low: 
  :type low: in positive
  :param high: 
  :type high: in natural
  :param by: 
  :type by: in string
  :param drop: 
  :type drop: in truncation
  :param justify: 
  :type justify: in alignment
  :param pad: 
  :type pad: in character

  Replace a slice of the source string with the contents of by

.. vhdl:function:: function insert(source : string; before : positive; new_item : string) return string;

  :param source: 
  :type source: string
  :param before: 
  :type before: positive
  :param new_item: 
  :type new_item: string

  Insert the string new_item before the selected index in source

.. vhdl:procedure:: procedure insert(source : inout string; before : in positive; new_item : in string; drop : in truncation);

  :param source: 
  :type source: inout string
  :param before: 
  :type before: in positive
  :param new_item: 
  :type new_item: in string
  :param drop: 
  :type drop: in truncation

  Insert the string new_item before the selected index in source

.. vhdl:function:: function overwrite(source : string; position : positive; new_item : string) return string;

  :param source: 
  :type source: string
  :param position: 
  :type position: positive
  :param new_item: 
  :type new_item: string

  Overwrite new_item into source starting at the selected position

.. vhdl:procedure:: procedure overwrite(source : inout string; position : in positive; new_item : in string; drop : in truncation);

  :param source: 
  :type source: inout string
  :param position: 
  :type position: in positive
  :param new_item: 
  :type new_item: in string
  :param drop: 
  :type drop: in truncation

  Overwrite new_item into source starting at the selected position

.. vhdl:function:: function delete(source : string; from : positive; through : natural) return string;

  :param source: 
  :type source: string
  :param from: 
  :type from: positive
  :param through: 
  :type through: natural

  Delete a slice from source. If from is greater than through, source is
  unmodified.

.. vhdl:procedure:: procedure delete(source : inout string; from : in positive; through : in natural; justify : in alignment; pad : in character);

  :param source: 
  :type source: inout string
  :param from: 
  :type from: in positive
  :param through: 
  :type through: in natural
  :param justify: 
  :type justify: in alignment
  :param pad: 
  :type pad: in character

  Delete a slice from source. If from is greater than through, source is
  unmodified.

.. vhdl:function:: function trim(source : string; side : trim_end) return string;

  :param source: 
  :type source: string
  :param side: 
  :type side: trim_end

  Remove space characters from leading, trailing, or both ends of source

.. vhdl:procedure:: procedure trim(source : inout string; side : in trim_end; justify : in alignment; pad : in character);

  :param source: 
  :type source: inout string
  :param side: 
  :type side: in trim_end
  :param justify: 
  :type justify: in alignment
  :param pad: 
  :type pad: in character

  Remove space characters from leading, trailing, or both ends of source

.. vhdl:function:: function trim(source : string; left : character_set; right : character_set) return string;

  :param source: 
  :type source: string
  :param left: 
  :type left: character_set
  :param right: 
  :type right: character_set

  Remove all leading characters in left and trailing characters in right
  from source

.. vhdl:procedure:: procedure trim(source : inout string; left : in character_set; right : in character_set; justify : in alignment; pad : in character);

  :param source: 
  :type source: inout string
  :param left: 
  :type left: in character_set
  :param right: 
  :type right: in character_set
  :param justify: 
  :type justify: in alignment
  :param pad: 
  :type pad: in character

  Remove all leading characters in left and trailing characters in right
  from source

.. vhdl:function:: function head(source : string; count : natural; pad : character) return string;

  :param source: 
  :type source: string
  :param count: 
  :type count: natural
  :param pad: 
  :type pad: character

  Return the first count characters from source

.. vhdl:procedure:: procedure head(source : inout string; count : in natural; justify : in alignment; pad : in character);

  :param source: 
  :type source: inout string
  :param count: 
  :type count: in natural
  :param justify: 
  :type justify: in alignment
  :param pad: 
  :type pad: in character

  Return the first count characters from source

.. vhdl:function:: function tail(source : string; count : natural; pad : character) return string;

  :param source: 
  :type source: string
  :param count: 
  :type count: natural
  :param pad: 
  :type pad: character

  Return the last count characters from source

.. vhdl:procedure:: procedure tail(source : inout string; count : in natural; justify : in alignment; pad : in character);

  :param source: 
  :type source: inout string
  :param count: 
  :type count: in natural
  :param justify: 
  :type justify: in alignment
  :param pad: 
  :type pad: in character

  Return the last count characters from source

.. vhdl:function:: function hash(key : string) return natural;

  :param key: 
  :type key: string

  Replicate a character left number of times
  Replicate a string left number of times
  Compute hash value of a string
