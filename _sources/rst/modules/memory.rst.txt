======
memory
======

`extras/memory.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/memory.vhdl>`_


Dependencies
------------

None

Description
-----------

This package provides general purpose components for inferred RAM and ROM.
These memories share a ``SYNC_READ`` generic which will optionally generate
synchronous or asynchronous read ports for each instance. On Xilinx devices
asynchronous read forces the synthesis of distributed RAM using LUTs rather
than BRAMs. When ``SYNC_READ`` is false the Read enable input is unused and
the read port clock can be tied to '0'.

The ROM component gets its contents using synthesizable file IO to read a
list of binary or hex values.


Example usage
~~~~~~~~~~~~~

Create a 256-byte ROM with contents supplied by the binary image file "rom.img":

.. code-block:: vhdl

  r: rom
    generic map (
      ROM_FILE => "rom.img",
      FORMAT => BINARY_TEXT,
      MEM_SIZE => 256
    )
    port map (
      Clock => clock,
      Re => re,
      Addr => addr,
      Data => data
    );

    
.. include:: auto/memory.rst

