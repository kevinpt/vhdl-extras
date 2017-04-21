======
muxing
======

`extras/muxing.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/muxing.vhdl>`_

`extras_2008/muxing_2008.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras_2008/muxing_2008.vhdl>`_


Dependencies
------------

None

Description
-----------

A set of routines for creating parameterized multiplexers, decoders,
and demultiplexers

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


.. include:: auto/muxing.rst

