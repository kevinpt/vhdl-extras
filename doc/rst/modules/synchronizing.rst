=============
synchronizing
=============

`extras/synchronizing.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/synchronizing.vhdl>`_

Dependencies
------------

None

Description
-----------

This package provides a number of synchronizer components for managing
data transmission between clock domains. There are three entities provided:

* :vhdl:entity:`~extras.synchronizing.bit_synchronizer` -- Suitable for synchronizing individual bit-wide signals
* :vhdl:entity:`~extras.synchronizing.reset_synchronizer` -- A special synchronizer for generating asyncronous resets that are synchronously released
* :vhdl:entity:`~extras.synchronizing.handshake_synchronizer` -- A synchronizer using the four-phase protocol to transfer vectors between domains

``bit_synchronizer`` and ``reset_synchronizer`` have a configurable number of stages with a default of 2.


If you need to synchronize a vector of bits together you should use the :vhdl:entity:`~extras.synchronizing.handshake_synchronizer` component. If you generate an array of
:vhdl:entity:`~extras.synchronizing.bit_synchronizer` components instead, there is a risk that some bits will take longer than others and invalid values will appear at the outputs. This is particularly problematic if the vector represents a numeric value. :vhdl:entity:`~extras.synchronizing.bit_synchronizer` can be used safely in an array only if you know the input signal comes from an isochronous domain (same period, different phase).

Synthesis
~~~~~~~~~

Vendor specific synthesis attributes have been included to help prevent undesirable
results. It is important to know that, ideally, synchronizing flip-flops should be placed
as close together as possible. It is also desirable to have the first stage flip-flop
incorporated into the input buffer to minimize input delay. Because of this these components
do not have attributes to guide relative placement of flip-flops to make them contiguous.
Instead you should apply timing constraints to the components that will force the synthesizer into
using an optimal placement.

    
.. include:: auto/synchronizing.rst

