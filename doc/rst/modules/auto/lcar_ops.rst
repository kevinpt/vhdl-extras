.. Generated from ../rtl/extras/lcar_ops.vhdl on 2018-06-28 23:37:28.480199
.. vhdl:package:: extras.lcar_ops


Components
----------


wolfram_lcar
~~~~~~~~~~~~

.. symbolator::
  :name: lcar_ops-wolfram_lcar

  component wolfram_lcar is
  generic (
    RESET_ACTIVE_LEVEL : std_ulogic
  );
  port (
    --# {{clocks|}}
    Clock : in std_ulogic;
    Reset : in std_ulogic;
    Enable : in std_ulogic;
    --# {{control|}}
    Rule_map : in std_ulogic_vector;
    --# {{data|}}
    Left_in : in std_ulogic;
    Right_in : in std_ulogic;
    State : out std_ulogic_vector
  );
  end component;

|


.. vhdl:entity:: wolfram_lcar

  General purpose implementation of a rule 150/90 LCAR.
  
  :generic RESET_ACTIVE_LEVEL: Asynch. reset control level
  :gtype RESET_ACTIVE_LEVEL: std_ulogic
  
  :port Clock: System clock
  :ptype Clock: in std_ulogic
  :port Reset: Asynchronous reset
  :ptype Reset: in std_ulogic
  :port Enable: Synchronous enable
  :ptype Enable: in std_ulogic
  :port Rule_map: Rules for each cell '1' -> 150, '0' -> 90
  :ptype Rule_map: in std_ulogic_vector
  :port Left_in: Left side input to LCAR
  :ptype Left_in: in std_ulogic
  :port Right_in: Right side input to LCAR
  :ptype Right_in: in std_ulogic
  :port State: The state of each cell
  :ptype State: out std_ulogic_vector

Subprograms
-----------


.. vhdl:function:: function next_wolfram_lcar(State : std_ulogic_vector; Rule_map : std_ulogic_vector; Left_in : std_ulogic := '0'; Right_in : std_ulogic := '0') return std_ulogic_vector;

   Determine the next state of the LCAR defined by the Rule_map.
  
  
  :param State: Current state of the LCAR cells
  :type State: std_ulogic_vector
  :param Rule_map: Rules for each cell; '1' -> 150, '0' -> 90
  :type Rule_map: std_ulogic_vector
  :param Left_in: Left side input to LCAR
  :type Left_in: std_ulogic
  :param Right_in: Right side input to LCAR
  :type Right_in: std_ulogic
  :returns: Next iteration of the LCAR rules which becomes the new state
  


.. vhdl:function:: function lcar_rule(Size : positive) return std_ulogic_vector;

   Lookup a predefined rule set from the table.
  
  :param Size: Number of LCAR cells
  :type Size: positive
  :returns: Rule map for a maximal length sequence.
  

