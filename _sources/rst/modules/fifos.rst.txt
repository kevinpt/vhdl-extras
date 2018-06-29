=====
fifos
=====

`extras/fifos.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/fifos.vhdl>`_


Dependencies
------------

:doc:`memory <memory>`,
:doc:`sizing <sizing>`,
:doc:`synchronizing <synchronizing>`

Description
-----------

This package implements a set of generic FIFO components. There are three
variants. All use the same basic interface for the read/write ports and
status flags. The FIFOs have the following differences:

:vhdl:entity:`~extras.fifos.simple_fifo`
  Basic minimal FIFO for use in a single clock domain. This
  component lacks the synchronizing logic needed for the
  other two FIFOs and will synthesize more compactly.

:vhdl:entity:`~extras.fifos.fifo`
  General FIFO with separate domains for read and write ports.

:vhdl:entity:`~extras.fifos.packet_fifo`
  Extension of ``fifo`` component with ability to discard
  written data before it is read. Useful for managing
  packetized protocols with error detection at the end.

All of these FIFOs use the :vhdl:entity:`~extras.memory.dual_port_ram` component from the memory package.
Reads can be performed concurrently with writes. The dual_port_ram
``SYNC_READ`` generic is provided on the FIFO components to select between
synchronous or asynchronous read ports. When ``SYNC_READ`` is false,
distributed memory will be synthesized rather than RAM primitives. The
read port will update one cycle earlier than when ``SYNC_READ`` is true.

The ``MEM_SIZE`` generic is used to set the number of words stored in the
FIFO. The read and write ports are unconstrained arrays. The size of
the words is established by the signals attached to the ports.

The FIFOs have the following status flags:

+-------------+-------------------------------------------------------+
|Empty        | '1' when FIFO is empty                                |
+-------------+-------------------------------------------------------+
|Full         | '1' when FIFO is full                                 |
+-------------+-------------------------------------------------------+
|Almost_empty | '1' when there are less than ``Almost_empty_thresh``  |
|             | words in the FIFO. '0' when completely empty.         |
+-------------+-------------------------------------------------------+
|Almost_full  | '1' when there are less than ``Almost_full_thresh``   |
|             | unused words in the FIFO. '0' when completely full.   |
+-------------+-------------------------------------------------------+

Note that the almost empty and full flags are kept inactive when the
empty or full conditions are true.

For the dual clock domain FIFOs, the ``Full`` and ``Almost_full`` flags are
registered on the write port clock domain. The ``Empty`` and ``Almost_empty``
flags are registered on the read port clock domain. If the ``Almost_*``
thresholds are connected to signals they will need to be registered
in their corresponding domains.

Writes and reads can be performed continuously on successive cycles
until the Full or Empty flags become active. No effort is made to detect
overflow or underflow conditions. External logic can be used to check for
writes when full or reads when empty if necessary.

The dual clock domain FIFOs use four-phase synchronization to pass
internal address pointers across domains. This results in delayed
updating of the status flags after writes and reads are performed.
Proper operation is guaranteed but you will see behavior such as the
full condition persisting for a few cycles after space has been freed by
a read. This will add some latency in the flow of data through these FIFOs
but will not cause overflow or underflow to occur. This only affects
cross-domain flag updates that *deassert* the flags. Assertion of the
flags will not be delayed. i.e. a read when the FIFO contains one entry
will assert the Empty flag one cycle later. Likewise, a write when the
FIFO has one empty entry left will assert the Full flag one cycle later.

The :vhdl:entity:`~extras.fifos.simple_fifo` component always updates all of its status flags on the
cycle after a read or write regardless of whether thay are asserted or
deasserted. 

The ``Almost_*`` flags use more complex comparison logic than the ``Full`` and
``Empty flags``. You can save some synthesized logic and boost clock speeds by
leaving them unconnected (open) if they are not needed in a design.
Similarly, if the thresholds are connected to constants rather than
signals, the comparison logic will be reduced during synthesis.

The :vhdl:entity:`~extras.fifos.packet_fifo` component has two additional control signals ``Keep`` and
``Discard``. When writing to the FIFO, the internal address pointers are
not updated on the read port domain until ``Keep`` is pulsed high. If written
data is not needed it can be dropped by pulsing ``Discard`` high. It is not
possible to discard data once ``Keep`` has been applied. Reads can be
performed concurrently with writes but the ``Empty`` flag will activate if
previously kept data is consumed even if new data has been written but
not yet retained with ``Keep``.

    
.. include:: auto/fifos.rst

