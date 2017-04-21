.. Generated from ../rtl/extras/binaryio.vhdl on 2017-04-20 23:04:36.925277
.. vhdl:package:: binaryio


Types
-----


.. vhdl:type:: octet_file


.. vhdl:type:: endianness


Subprograms
-----------


.. vhdl:procedure:: procedure read(file : in octet_file; Fh : in octet_file; Octet_order : in endianness; Word : out unsigned);

  :param file: 
  :type file: in octet_file
  :param Fh: 
  :type Fh: in octet_file
  :param Octet_order: 
  :type Octet_order: in endianness
  :param Word: 
  :type Word: out unsigned

  Binary read and write procedures 

.. vhdl:procedure:: procedure read(file : in octet_file; Fh : in octet_file; Octet_order : in endianness; Word : out signed);

  :param file: 
  :type file: in octet_file
  :param Fh: 
  :type Fh: in octet_file
  :param Octet_order: 
  :type Octet_order: in endianness
  :param Word: 
  :type Word: out signed


.. vhdl:procedure:: procedure write(file : in octet_file; Fh : in octet_file; Octet_order : in endianness; Word : in unsigned);

  :param file: 
  :type file: in octet_file
  :param Fh: 
  :type Fh: in octet_file
  :param Octet_order: 
  :type Octet_order: in endianness
  :param Word: 
  :type Word: in unsigned


.. vhdl:procedure:: procedure write(file : in octet_file; Fh : in octet_file; Octet_order : in endianness; Word : in signed);

  :param file: 
  :type file: in octet_file
  :param Fh: 
  :type Fh: in octet_file
  :param Octet_order: 
  :type Octet_order: in endianness
  :param Word: 
  :type Word: in signed

