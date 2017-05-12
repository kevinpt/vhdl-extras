.. Generated from ../rtl/extras/binaryio.vhdl on 2017-05-07 22:53:55.764008
.. vhdl:package:: binaryio


Types
-----


.. vhdl:type:: octet_file


.. vhdl:type:: endianness


Subprograms
-----------


.. vhdl:procedure:: procedure read(Fh : octet_file; Octet_order : endianness; Word : out unsigned);

  Read binary data into an unsigned vector.


  :param Fh: File handle
  :type Fh: None octet_file
  :param Octet_order: Endianness of the octets
  :type Octet_order: None endianness
  :param Word: Data read from the file
  :type Word: out unsigned


.. vhdl:procedure:: procedure read(Fh : octet_file; Octet_order : endianness; Word : out signed);

  Read binary data into a signed vector.


  :param Fh: File handle
  :type Fh: None octet_file
  :param Octet_order: Endianness of the octets
  :type Octet_order: None endianness
  :param Word: Data read from the file
  :type Word: out signed


.. vhdl:procedure:: procedure write(Fh : octet_file; Octet_order : endianness; Word : unsigned);

  Write an unsigned vector to a file.


  :param Fh: File handle
  :type Fh: None octet_file
  :param Octet_order: Endianness of the octets
  :type Octet_order: None endianness
  :param Word: Data to write into the file
  :type Word: None unsigned


.. vhdl:procedure:: procedure write(Fh : octet_file; Octet_order : endianness; Word : signed);

  Write a signed vector to a file.


  :param Fh: File handle
  :type Fh: None octet_file
  :param Octet_order: Endianness of the octets
  :type Octet_order: None endianness
  :param Word: Data to write into the file
  :type Word: None signed

