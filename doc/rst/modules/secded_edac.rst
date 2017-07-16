===========
secded_edac
===========

`extras/secded_edac.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/secded_edac.vhdl>`_

Dependencies
------------

* :doc:`sizing`,
* :doc:`hamming_edac`,
* :doc:`parity_ops`

Description
-----------

This package implements Single Error Correction, Double Error Detection
(SECDED) by extending the Hamming code with an extra overall parity bit.
It is built on top of the functions implemented in :doc:`hamming_edac`.
The :vhdl:type:`~extras.hamming_edac.ecc_vector` is extended with an additional
parity bit to the right of the Hamming parity as shown below.

SECDED ``ecc_vector`` layout:

.. parsed-literal::

                             MSb            LSb
  [(data'length - 1) <-> 0] [-1 <-> -(parity_size - 1)] [-parity_size]
            data               Hamming parity          SECDED parity bit

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  signal word, corrected_word : std_ulogic_vector(15 downto 0);
  constant WORD_MSG_SIZE : positive := secded_message_size(word'length);
  signal secded_word :
    ecc_vector(word'high downto -secded_parity_size(WORD_MSG_SIZE));
  ...
  secded_word <= secded_encode(word);
  ... <SEU or transmission error flips a bit>
  corrected_word <= secded_decode(hamming_word);
  errors := secded_has_errors(secded_word);
  if errors(single_bit) or errors(double_bit) then ... -- check for error

As with ``hamming_edac``, it is possible to share logic between the decoder
and error checker and also between an encoder and decoder that don't
operate simultaneously. Refer to :doc:`hamming_edac` and :doc:`secded_codec`
for examples of this approach.

    
.. include:: auto/secded_edac.rst

