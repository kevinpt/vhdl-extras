========
binaryio
========

`extras/binaryio.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/binaryio.vhdl>`_


Dependencies
------------

None

Description
-----------

This package provides procedures to perform general purpose binary I/O on
files. The number of bytes read or written is controlled by the width of
array passed to the procedures. An endianness parameter determines the byte
order. These procedures do not handle packed binary data. Reading and
writing arrays that are not multiples of 8 in length will consume or
produce additional padding bits in the file. Sign extension is performed
when writing padded signed arrays.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  file fh  : octet_file open read_mode is "foo.bin";
  file fh2 : octet_file open write_mode is "out.bin";
  signal uword : unsigned(15 downto 0);
  signal sword : signed(19 downto 0);
  ...
  read(fh, little_endian, uword); -- read 16 bits from two octets
  read(fh, big_endian, sword);    -- read 20 bits from three octets
  ...
  write(fh2, little_endian, uword);
  write(fh2, big_endian, sword);


.. include:: auto/binaryio.rst

