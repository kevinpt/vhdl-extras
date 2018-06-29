.. Generated from ../rtl/extras/strings_maps.vhdl on 2018-06-28 23:37:28.990407
.. vhdl:package:: extras.strings_maps


Types
-----


.. vhdl:type:: character_set

  Array of boolean flag bits indexed by ``character``.

.. vhdl:type:: character_range

  Inclusive range of characters within the Latin-1 set.

.. vhdl:type:: character_ranges

  Collection of character ranges.

.. vhdl:type:: character_mapping

  Mapping from one character to another.

Subtypes
--------


.. vhdl:subtype:: character_sequence

  Sequence of characters that compose a character set.

Subprograms
-----------


.. vhdl:function:: function to_set(ranges : character_ranges) return character_set;

   Convert ranges to a character set
  
  :param ranges: List of character ranges in the set
  :type ranges: character_ranges
  :returns: A character set with the requested ranges.
  


.. vhdl:function:: function to_set(span : character_range) return character_set;

   Convert range to a character set
  
  :param span: Range to build into character set
  :type span: character_range
  :returns: A character set with the requested range.
  


.. vhdl:function:: function to_ranges(set : character_set) return character_ranges;

   Convert a character set into a list of ranges
  
  :param set: Character set to extract ranges from
  :type set: character_set
  :returns: All contiguous ranges in the set.
  


.. vhdl:function:: function "-"(left : character_set; right : character_set) return character_set;

   Difference between to character sets
  
  :param left: Set to subtract from
  :type left: character_set
  :param right: Set to subtract from left
  :type right: character_set
  :returns: All characters in left not in right.
  


.. vhdl:function:: function is_in(element : character; set : character_set) return boolean;

   Test if a character is part of a character set
  
  :param element: Character to test for
  :type element: character
  :param set: Character set to test membership in
  :type set: character_set
  :returns: true if element is in the set.
  


.. vhdl:function:: function is_subset(elements : character_set; set : character_set) return boolean;

   Test if a character set is a subset of a larget set
  
  :param elements: Character set to test for
  :type elements: character_set
  :param set: Character set to test membership in
  :type set: character_set
  :returns: true if elements are in the set.
  


.. vhdl:function:: function to_set(sequence : character_sequence) return character_set;

   Convert a character sequence into a set.
  
  :param sequence: String of characters to build into a set
  :type sequence: character_sequence
  :returns: A character set with all unique characters from sequence.
  


.. vhdl:function:: function to_set(singleton : character) return character_set;

   Convert a character into a set.
  
  :param singleton: Character to include in the set
  :type singleton: character
  :returns: A character set with one single character as its member.
  


.. vhdl:function:: function to_sequence(set : character_set) return character_sequence;

   Convert a character set into a sequence string
  
  :param set: Character set to convert
  :type set: character_set
  :returns: A sequence string with each character from the set.
  


.. vhdl:function:: function value(cmap : character_mapping; element : character) return character;

   Look up the mapping for a character.
  
  :param cmap: Map associating Latin-1 characters with a substitute
  :type cmap: character_mapping
  :param element: Character to lookup in the map
  :type element: character
  :returns: The mapped value of the element character.
  


.. vhdl:function:: function to_mapping(from : character_sequence; to_seq : character_sequence) return character_mapping;

   Create a mapping from two sequences.
  
  :param from: Sequence string to use for map indices
  :type from: character_sequence
  :param to_seq: Sequence string to use from map values
  :type to_seq: character_sequence
  :returns: A new map to convert characters in the from sequence into the to_seq.
  


.. vhdl:function:: function to_domain(cmap : character_mapping) return character_sequence;

   Return the from sequence for a mapping.
  
  :param cmap: Character map to extract domain from
  :type cmap: character_mapping
  :returns: The characters used to map from.
  


.. vhdl:function:: function to_range(cmap : character_mapping) return character_sequence;

   Return the to_seq sequence for a mapping.
  
  :param cmap: Character map to extract range from
  :type cmap: character_mapping
  :returns: The characters used to map into.
  

