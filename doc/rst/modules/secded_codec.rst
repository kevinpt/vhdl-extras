============
secded_codec
============

`extras/secded_codec.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/secded_codec.vhdl>`_

Dependencies
------------

:doc:`sizing`,
:doc:`pipelining`,
:doc:`hamming_edac`,
:doc:`secded_edac`,
:doc:`parity_ops`

Description
-----------

This package provides a component that implements SECDED EDAC as a
single unified codec. The codec can switch between encoding and decoding
on each clock cycle with a minimum latency of two clock cycles through the
input and output registers. The SECDED logic is capable of correcting
single-bit errors and detecting double-bit errors.

Optional pipelining is available to reduce the maximum delay through the
internal logic. To be effective, you must activate the retiming feature of
the synthesis tool being used. See the notes in :doc:`pipelining` for more
information on how to accomplish this. The pipelining is controlled with
the ``PIPELINE_STAGES`` generic. A value of 0 will disable pipelining.

To facilitate testing, the codec includes an error generator that can
insert single-bit and double-bit errors into the encoded output. When
active, successive bits are flipped on each clock cycle. This feature
provides for the testing of error handling logic in the decoding process.


.. include:: auto/secded_codec.rst

