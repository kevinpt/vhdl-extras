============
hamming_edac
============

`extras/hamming_edac.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/hamming_edac.vhdl>`_

Dependencies
------------

:doc:`sizing <sizing>`

Description
-----------

This package provides functions that perform single-bit error detection
and correction using Hamming code. Encoded data is represented in the
:vhdl:type:`~extras.hamming_edac.ecc_vector` type with the data preserved in normal sequence using array
indices from data'length-1 downto 0. The Hamming parity bits p are
represented in the encoded array as negative indices from -1 downto -p.
The parity bits are sequenced with the most significant on the left (-1)
and the least significant on the right (-p). This arrangement provides for
easy removal of the parity bits by slicing the data portion out of the
encoded array. These functions have no upper limit in the size of data
they can handle. For practical reasons, these functions should not be used
with less than four data bits.

The layout of an :vhdl:type:`~extras.hamming_edac.ecc_vector` is determined by its range. All objects of
this type must use a descending range with a positive upper bound and a
negative lower bound. Note that the conversion function
:vhdl:func:`~extras.hamming_edac.to_ecc_vec` does
not produce a result that meets this requirement so it should not be
invoked directly as a parameter to a function expecting a proper
``ecc_vector``.

Hamming ``ecc_vector`` layout:

.. parsed-literal::

                             MSb         LSb
  [(data'length - 1) <-> 0] [-1 <-> -parity_size]
            data               Hamming parity

The output from :vhdl:func:`~extras.hamming_edac.hamming_encode` produces an ``ecc_vector`` with this layout.
Depending on the hardware implementation it may be desirable to interleave
the parity bits with the data to protect against certain failures that may
go undetected when encoded data is distributed across multiple memory
devices. Use :vhdl:func:`~extras.hamming_edac.hamming_interleave` to perform this reordering of bits.

Background
~~~~~~~~~~

The Hamming code is developed by interleaving the parity bits
and data together such that the parity bits occupy the powers of 2 in the
array indices. This interleaved array is known as the message. In
decoding, the parity bits form a vector that represents an unsigned
integer indicating the position of any erroneous bit in the message. The
non-error condition is reserved as an all zeroes coding of the parity
bits. This means that for :math:`p` parity bits, the message length :math:`m` can't be
longer than :math:`(2^p)-1`. The number of data bits :math:`k` is :math:`m - p`. Any particular
Hamming code is referred to using the nomenclature :math:`(m, k)` to identify the
message and data sizes. Here are the maximum data sizes for the set of
messages that are perfectly coded :math:`(m = (2^p)-1)`:

  (3,1) (7,4) (15,11) (31,26) (63,57) (127,120) ...


Minimum message sizes for power of 2 data sizes:

  (5,2) (7,4) (12,8) (21,16) (38,32) (71,64) ...

When the data size :math:`k` is a power of 2 greater than or equal to 4, the
minimum message size :math:`m = \lceil{\log_{2}k}\rceil + 1 + k`. For other values of :math:`k`
greater than 4 this relation is a, possibly minimal, upper bound for the
message size.

Synthesis
~~~~~~~~~

The XOR operations for the parity bits are iteratively
generated and form long chains of gates. To achieve minimal delay you
should ensure that your synthesizer rearranges these chains into minimal
depth trees of XOR gates. The synthesized logic is purely combinational.
In most cases registers should be added to remove glitches on the outputs.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  signal word, corrected_word : std_ulogic_vector(15 downto 0);
  constant WORD_MSG_SIZE : positive := hamming_message_size(word'length);
  signal hamming_word :
    ecc_vector(word'high downto -hamming_parity_size(WORD_MSG_SIZE));
  ...
  hamming_word <= hamming_encode(word);
  ... <SEU or transmission error flips a bit>
  corrected_word <= hamming_decode(hamming_word);
  if hamming_has_error(hamming_word) then ... -- check for error

Note that :vhdl:func:`~extras.hamming_edac.hamming_decode` and
:vhdl:func:`~extras.hamming_edac.hamming_has_error` will synthesize with some
common logic. Use the alternate versions in conjunction with
:vhdl:func:`~extras.hamming_edac.hamming_interleave` and
:vhdl:func:`~extras.hamming_edac.hamming_parity` to conserve logic when both are used:

.. code-block:: vhdl

  variable message : std_ulogic_vector(hamming_word'length downto 1);
  variable syndrome : unsigned(-hamming_word'low downto 1);
  ...
  message  := hamming_interleave(hamming_word);
  syndrome := hamming_parity(message);
  corrected_word <= hamming_decode(message, syndrome);
  if hamming_has_error(syndrome) then ... -- check for error

Similary, it is possible to share logic between the encoder and decoder if
they are co-located and not used simultaneously:

.. code-block:: vhdl

  if encoding then
    txrx_data   := word;
    txrx_parity := (others => '0');
  else -- decoding
    txrx_data   := get_data(received_word);
    txrx_parity := get_parity(received_word);
  end if;
  message        := hamming_interleave(txrx_data, txrx_parity);
  parity_bits    := hamming_parity(message); -- also acts as the syndrome
  hamming_word   <= hamming_encode(word, parity_bits);
  corrected_word <= hamming_decode(message, parity_bits);

    
    
.. include:: auto/hamming_edac.rst

