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
than BRAMs. When ``SYNC_READ`` is false the Read enable input is unused.

The ROM component gets its contents using synthesizable file IO to read a
list of binary or hex values.
    
    
.. include:: auto/memory.rst

