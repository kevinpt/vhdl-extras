.. Generated from ../rtl/extras/lcar_ops.vhdl on 2017-04-02 22:57:52.910339
.. vhdl:package:: lcar_ops

Types
-----

.. vhdl:type:: foo

.. vhdl:type:: baz

Subtypes
--------

.. vhdl:subtype:: bar

Subprograms
-----------


.. vhdl:function:: function next_wolfram_lcar(State : std_ulogic_vector; Rule_map : std_ulogic_vector; Left_in : std_ulogic; Right_in : std_ulogic) return std_ulogic_vector;

  :param State: Current state of the LCAR cells
  :type State: std_ulogic_vector
  :param Rule_map: Rules for each cell; '1' -> 150, '0' -> 90
  :type Rule_map: std_ulogic_vector
  :param Left_in: Left side input to LCAR
  :type Left_in: std_ulogic
  :param Right_in: Right side input to LCAR
  :type Right_in: std_ulogic
  :returns:   Next iteration of the LCAR rules which becomes the new state

  Determine the next state of the LCAR defined by the Rule_map.
  

.. vhdl:function:: function lcar_rule(Size : positive) return std_ulogic_vector;

  :param Size: Number of LCAR cells
  :type Size: positive
  :returns:   Predefined rule map

  Lookup a predefined rule set from the table.
  
