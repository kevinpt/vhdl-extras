========
lcar_ops
========

`extras/lcar_ops.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/lcar_ops.vhdl>`_

Dependencies
------------

None

Description
-----------

This package provides a component that implements the `Wolfram Linear
Cellular Automata Register (LCAR) <https://en.wikipedia.org/wiki/Elementary_cellular_automaton>`_
as described in "Statistical Mechanics
of Cellular Automata", Wolfram 1983. The LCAR implemented in `wolfram_lcar`
uses rules 90 and 150 for each cell as defined by an input `Rule_map` where
a '0' indicates rule 90 and '1' indicates rule 150 for the corresponding
cell in the State register.

The LCAR using rules 90 and 150 can produce output equivalent to maximal
length LFSRs but with the advantage of less correlation between bits of
the state register. This makes the LCAR more suitable for pseudo-random
number generation. The predefined `LCAR_*` constants provide rule maps for
maximal length sequences.

For basic pseudo-random state generation it is sufficient to tie the
`Left_in` and `Right_in` inputs to '0'.


.. code-block:: vhdl

    library extras;
    use extras.lcar_ops.all;

    constant WIDTH : positive := 8;
    constant rule : std_ulogic_vector(WIDTH-1 downto 0) := lcar_rule(WIDTH);
    variable state : std_ulogic_vector(WIDTH-1 downto 0) := (others => '1');
    ...
    -- Basic usage with default '0's shifting in from ends
    state := next_wolfram_lcar(state, rule);
    
Components
----------

.. image:: ../../image/sym/lcar_ops-wolfram_lcar.svg

.. code-block:: vhdl

    library extras;
    use extras.lcar_ops.all;

    constant WIDTH : positive := 8;
    constant rule  : std_ulogic_vector(WIDTH-1 downto 0) := lcar_rule(WIDTH);
    signal   state : std_ulogic_vector(WIDTH-1 downto 0) := (others => '1');
    ...
    
    wl: wolfram_lcar
      port map (
        Clock => clock,
        Reset => reset,
        Enable => enable,
        
        Rule_map => rule
        Left_in => '0',
        Right_in => '0',
        
        State => state
      );

    
.. include:: auto/lcar_ops.rst

Testing
-------

.. vhdl:package:: foobar
  :synopsis: friuhiuh
  
  
.. vhdl:type:: myint is integer range(0 to 100)

.. vhdl:function:: foofunc(a : integer(0 to 10); b:positive) return natural

  :param a: This is parameter a
  :param b: This is parameter b
  :returns: The result

  This is a function.
  
  It has parameters:
  
  


.. vhdl:function:: foofunc(q : integer) return natural

  :param q: This is the q parameter

.. vhdl:function:: barfunc return natural

  This is a function.


.. vhdl:procedure:: bazproc(r : in integer; s : out unsigned)

  :param r: R parameter
  :param s: S parameter
  
  This is a procedure xx.
  
  This is the last line.



.. vhdl:entity:: myent port(a : in signed; b : out unsigned)

  :generic G_X: generic x
  :generic G_Y: generic y
  :port a: parameter a
  :port b: parameter b
  :ptype a: in signed
  :gtype G_X: natural

  This is an entity.

Module :vhdl:pkg:`foobar`

Function :vhdl:func:`foobar.foofunc[integer,positive return natural]`

Function2 :vhdl:func:`xyz <foobar.foofunc[integer return natural]>`

Function :vhdl:func:`foobar.barfunc`

Type :vhdl:type:`myint`

No sig :vhdl:func:`foofunc`

Proc reference :vhdl:proc:`bazproc`
 
End modules

