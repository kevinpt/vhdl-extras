.. Generated from ../rtl/extras/strings_maps.vhdl on 2017-04-02 22:57:53.150584
.. vhdl:package:: strings_maps

Types
-----

.. vhdl:type:: character_set

.. vhdl:type:: character_range

.. vhdl:type:: character_ranges

.. vhdl:type:: character_mapping

Subtypes
--------

.. vhdl:subtype:: character_sequence

Subprograms
-----------


.. vhdl:function:: function to_set(ranges : character_ranges) return character_set;

  :param ranges: 
  :type ranges: character_ranges

  Conversion between character sets and ranges

.. vhdl:function:: function to_set(span : character_range) return character_set;

  :param span: 
  :type span: character_range


.. vhdl:function:: function to_ranges(set : character_set) return character_ranges;

  :param set: 
  :type set: character_set


.. vhdl:function:: function is_in(element : character; set : character_set) return boolean;

  :param element: 
  :type element: character
  :param set: 
  :type set: character_set

  Test for membership in a character set

.. vhdl:function:: function is_subset(elements : character_set; set : character_set) return boolean;

  :param elements: 
  :type elements: character_set
  :param set: 
  :type set: character_set


.. vhdl:function:: function to_set(sequence : character_sequence) return character_set;

  :param sequence: 
  :type sequence: character_sequence

  Conversion between character sets and sequences

.. vhdl:function:: function to_set(singleton : character) return character_set;

  :param singleton: 
  :type singleton: character


.. vhdl:function:: function to_sequence(set : character_set) return character_sequence;

  :param set: 
  :type set: character_set


.. vhdl:function:: function value(cmap : character_mapping; element : character) return character;

  :param cmap: 
  :type cmap: character_mapping
  :param element: 
  :type element: character

  Look up the mapping for a character

.. vhdl:function:: function to_mapping(from : character_sequence; to_seq : character_sequence) return character_mapping;

  :param from: 
  :type from: character_sequence
  :param to_seq: 
  :type to_seq: character_sequence

  Create a mapping from two sequences

.. vhdl:function:: function to_domain(cmap : character_mapping) return character_sequence;

  :param cmap: 
  :type cmap: character_mapping

  Return the from sequence for a mapping

.. vhdl:function:: function to_range(cmap : character_mapping) return character_sequence;

  :param cmap: 
  :type cmap: character_mapping

  Return the to_seq sequence for a mapping
