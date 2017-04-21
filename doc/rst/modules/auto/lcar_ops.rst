.. Generated from ../rtl/extras/lcar_ops.vhdl on 2017-04-20 23:04:36.954658
.. vhdl:package:: lcar_ops


Components
----------


wolfram_lcar
~~~~~~~~~~~~

.. symbolator::

  component wolfram_lcar is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    Rule_map : in std_ulogic_vector;
    Left_in : in std_ulogic;
    Right_in : in std_ulogic;
    State : out std_ulogic_vector
  );
  end component;

|


|


.. vhdl:entity:: wolfram_lcar

  :generic RESET_ACTIVE_LEVEL: 
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  :port Clock: 
  :ptype Clock: in std_ulogic
  :port Reset:  Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable:  Synchronous enable
  :ptype Enable: in std_ulogic
  :port Rule_map:  Rules for each cell '1' -> 150, '0' -> 90
  :ptype Rule_map: in std_ulogic_vector
  :port Left_in:  Left side input to LCAR
  :ptype Left_in: in std_ulogic
  :port Right_in:  Right side input to LCAR
  :ptype Right_in: in std_ulogic
  :port State:  The state of each cell
  :ptype State: out std_ulogic_vector

Subprograms
-----------


.. vhdl:function:: function next_wolfram_lcar(State : std_ulogic_vector; Rule_map : std_ulogic_vector; Left_in : std_ulogic; Right_in : std_ulogic) return std_ulogic_vector;

  :param State: 
  :type State: std_ulogic_vector
  :param Rule_map: 
  :type Rule_map: std_ulogic_vector
  :param Left_in: 
  :type Left_in: std_ulogic
  :param Right_in: 
  :type Right_in: std_ulogic
  :returns:   Next iteration of the LCAR rules which becomes the new state

  Determine the next state of the LCAR defined by the Rule_map.
  

.. vhdl:function:: function lcar_rule(Size : positive) return std_ulogic_vector;

  :param Size: 
  :type Size: positive
  :returns:   Predefined rule map

  Lookup a predefined rule set from the table.
  
