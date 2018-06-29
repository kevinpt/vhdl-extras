======
muxing
======

`extras/muxing.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/muxing.vhdl>`_

`extras_2008/muxing_2008.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras_2008/muxing_2008.vhdl>`_


Dependencies
------------

:doc:`common_2008` (for muxing_2008)

Description
-----------

A set of routines for creating parameterized multiplexers, decoders,
and demultiplexers. The VHDL-2008 version has an additional :vhdl:func:`~extras_2008.muxing.mux`
function that can select from multi-bit inputs implemented in
VHDL-2008 syntax.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  signal sel : unsigned(3 downto 0);
  signal d, data : std_ulogic_vector(0 to 2**sel'length-1);
  signal d2  : std_ulogic_vector(0 to 10);
  signal m   : std_ulogic;
  ...
  d <= decode(sel);             -- Full binary decode
  d2 <= decode(sel, d2'length); -- Partial decode

  m <= mux(data, sel);          -- Mux with internal decoder
  m <= mux(data, d);            -- Mux with external decoder

  d2 <= demux(m, sel, d2'length);

Muxing vectors with VHDL-2008:

.. code-block:: vhdl

  library extras_2008;
  use extras_2008.muxing.all;
  use extras_2008.common.sulv_array;
  
  signal sel : unsigned(3 downto 0);
  signal m : std_ulogic_vector(7 downto 0);
  signal data : sulv_array(0 to 2**sel'length-1)(m'range);
  ...
  m <= mux(data, sel);


.. include:: auto/muxing.rst

VHDL-2008 variant
-----------------

.. include:: auto/muxing_2008.rst

