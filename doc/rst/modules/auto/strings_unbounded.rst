.. Generated from ../rtl/extras/strings_unbounded.vhdl on 2017-04-02 22:57:53.006381
.. vhdl:package:: strings_unbounded

Subtypes
--------

.. vhdl:subtype:: unbounded_string

Subprograms
-----------


.. vhdl:function:: function to_unbounded_string(source : string) return unbounded_string;

  :param source: 
  :type source: string

  Convert a string to unbounded_string

.. vhdl:function:: function to_unbounded_string(length : natural) return unbounded_string;

  :param length: 
  :type length: natural

  Allocate a string of length

.. vhdl:procedure:: procedure to_string(source : in unbounded_string; dest : out string);

  :param source: 
  :type source: in unbounded_string
  :param dest: 
  :type dest: out string

  Copy a unbounded_string to the string dest

.. vhdl:procedure:: procedure initialize(source : inout unbounded_string);

  :param source: 
  :type source: inout unbounded_string

  Create an empty unbounded_string

.. vhdl:procedure:: procedure free(source : inout unbounded_string);

  :param source: 
  :type source: inout unbounded_string

  Free allocated memory for source

.. vhdl:procedure:: procedure length(source : in unbounded_string; len : out natural);

  :param source: 
  :type source: in unbounded_string
  :param len: 
  :type len: out natural

  Return the length of a unbounded_string

.. vhdl:procedure:: procedure copy(source : in unbounded_string; dest : inout unbounded_string; max : in integer);

  :param source: 
  :type source: in unbounded_string
  :param dest: 
  :type dest: inout unbounded_string
  :param max: 
  :type max: in integer

  Copy at most max characters from source to the unallocated dest

.. vhdl:procedure:: procedure copy(source : in string; dest : inout unbounded_string; max : in integer);

  :param source: 
  :type source: in string
  :param dest: 
  :type dest: inout unbounded_string
  :param max: 
  :type max: in integer

  Copy at most max characters from source to the unallocated dest

.. vhdl:procedure:: procedure append(source : inout unbounded_string; new_item : in unbounded_string);

  :param source: 
  :type source: inout unbounded_string
  :param new_item: 
  :type new_item: in unbounded_string

  Append unbounded_string new_item to source

.. vhdl:procedure:: procedure append(source : inout unbounded_string; new_item : in string);

  :param source: 
  :type source: inout unbounded_string
  :param new_item: 
  :type new_item: in string

  Append string new_item to source

.. vhdl:procedure:: procedure append(source : inout unbounded_string; new_item : in character);

  :param source: 
  :type source: inout unbounded_string
  :param new_item: 
  :type new_item: in character

  Append character new_item to source

.. vhdl:procedure:: procedure element(source : in unbounded_string; index : in positive; el : out character);

  :param source: 
  :type source: in unbounded_string
  :param index: 
  :type index: in positive
  :param el: 
  :type el: out character

  Lookup the character in source at index

.. vhdl:procedure:: procedure replace_element(source : inout unbounded_string; index : in positive; by : in character);

  :param source: 
  :type source: inout unbounded_string
  :param index: 
  :type index: in positive
  :param by: 
  :type by: in character

  Replace the character in source at index with by

.. vhdl:procedure:: procedure slice(source : in unbounded_string; low : in positive; high : in positive; result : inout unbounded_string);

  :param source: 
  :type source: in unbounded_string
  :param low: 
  :type low: in positive
  :param high: 
  :type high: in positive
  :param result: 
  :type result: inout unbounded_string

  Extract a slice from source

.. vhdl:procedure:: procedure eq(left : in unbounded_string; right : in unbounded_string; result : out boolean);

  :param left: 
  :type left: in unbounded_string
  :param right: 
  :type right: in unbounded_string
  :param result: 
  :type result: out boolean

  Test if left is identical to right

.. vhdl:procedure:: procedure eq(left : in unbounded_string; right : in string; result : out boolean);

  :param left: 
  :type left: in unbounded_string
  :param right: 
  :type right: in string
  :param result: 
  :type result: out boolean

  Test if left is identical to right

.. vhdl:procedure:: procedure count(source : in unbounded_string; pattern : in string; val : out natural);

  :param source: 
  :type source: in unbounded_string
  :param pattern: 
  :type pattern: in string
  :param val: 
  :type val: out natural

  Count the occurances of pattern in source

.. vhdl:procedure:: procedure delete(source : inout unbounded_string; from : in positive; through : in natural);

  :param source: 
  :type source: inout unbounded_string
  :param from: 
  :type from: in positive
  :param through: 
  :type through: in natural

  Delete a slice from source. If from is greater than through, source is
  unmodified.

.. vhdl:procedure:: procedure find_token(source : in unbounded_string; set : in character_set; test : in membership; first : out positive; last : out natural);

  :param source: 
  :type source: in unbounded_string
  :param set: 
  :type set: in character_set
  :param test: 
  :type test: in membership
  :param first: 
  :type first: out positive
  :param last: 
  :type last: out natural

  Return the indices of a slice of source that satisfys the membership
  selection for the character set.

.. vhdl:procedure:: procedure head(source : inout unbounded_string; count : in natural; pad : in character);

  :param source: 
  :type source: inout unbounded_string
  :param count: 
  :type count: in natural
  :param pad: 
  :type pad: in character

  Return the first count characters from source

.. vhdl:procedure:: procedure insert(source : inout unbounded_string; before : in positive; new_item : in string);

  :param source: 
  :type source: inout unbounded_string
  :param before: 
  :type before: in positive
  :param new_item: 
  :type new_item: in string

  Insert the string new_item before the selected index in source

.. vhdl:procedure:: procedure overwrite(source : inout unbounded_string; position : in positive; new_item : in string);

  :param source: 
  :type source: inout unbounded_string
  :param position: 
  :type position: in positive
  :param new_item: 
  :type new_item: in string

  Overwrite new_item into source starting at the selected position

.. vhdl:procedure:: procedure replace_slice(source : inout unbounded_string; low : in positive; high : in natural; by : in string);

  :param source: 
  :type source: inout unbounded_string
  :param low: 
  :type low: in positive
  :param high: 
  :type high: in natural
  :param by: 
  :type by: in string

  Replace a slice of the source string with the contents of by

.. vhdl:procedure:: procedure tail(source : inout unbounded_string; count : in natural; pad : in character);

  :param source: 
  :type source: inout unbounded_string
  :param count: 
  :type count: in natural
  :param pad: 
  :type pad: in character

  Return the last count characters from source

.. vhdl:procedure:: procedure translate(source : inout unbounded_string; mapping : in character_mapping);

  :param source: 
  :type source: inout unbounded_string
  :param mapping: 
  :type mapping: in character_mapping

  Convert a source string with the provided character mapping

.. vhdl:procedure:: procedure trim(source : inout unbounded_string; side : in trim_end);

  :param source: 
  :type source: inout unbounded_string
  :param side: 
  :type side: in trim_end

  Remove space characters from leading, trailing, or both ends of source

.. vhdl:procedure:: procedure trim(source : inout unbounded_string; left : in character_set; right : in character_set);

  :param source: 
  :type source: inout unbounded_string
  :param left: 
  :type left: in character_set
  :param right: 
  :type right: in character_set

  Remove all leading characters in left and trailing characters in left
  from source
