.. Generated from ../rtl/extras/text_buffering.vhdl on 2017-04-20 23:04:37.264877
.. vhdl:package:: text_buffering


Types
-----


.. vhdl:type:: buffer_line_acc


.. vhdl:type:: buffer_line


.. vhdl:type:: text_buffer


Subprograms
-----------


.. vhdl:procedure:: procedure load_buffer(file : in text; fh : in text; buf : out text_buffer);

  :param file: 
  :type file: in text
  :param fh: 
  :type fh: in text
  :param buf: 
  :type buf: out text_buffer

  Load a text file object into a buffer

.. vhdl:procedure:: procedure load_buffer(fname : in string; buf : out text_buffer);

  :param fname: 
  :type fname: in string
  :param buf: 
  :type buf: out text_buffer

  Load a file into a buffer

.. vhdl:procedure:: procedure append_file(file : in text; fh : in text; buf : inout text_buffer);

  :param file: 
  :type file: in text
  :param fh: 
  :type fh: in text
  :param buf: 
  :type buf: inout text_buffer

  Append a text file object to an existing buffer

.. vhdl:procedure:: procedure append_file(fname : in string; buf : inout text_buffer);

  :param fname: 
  :type fname: in string
  :param buf: 
  :type buf: inout text_buffer

  Append a text file to an existing buffer

.. vhdl:procedure:: procedure append(one_line : in unbounded_string; buf : inout text_buffer);

  :param one_line: 
  :type one_line: in unbounded_string
  :param buf: 
  :type buf: inout text_buffer

  Append a string to a buffer

.. vhdl:procedure:: procedure append(one_line : in string; buf : inout text_buffer);

  :param one_line: 
  :type one_line: in string
  :param buf: 
  :type buf: inout text_buffer

  Append a string to a buffer

.. vhdl:procedure:: procedure write(file : in text; fh : in text; buf : in text_buffer);

  :param file: 
  :type file: in text
  :param fh: 
  :type fh: in text
  :param buf: 
  :type buf: in text_buffer

  Write a buffer to a text file object

.. vhdl:procedure:: procedure write(fname : in string; buf : in text_buffer);

  :param fname: 
  :type fname: in string
  :param buf: 
  :type buf: in text_buffer

  Write a buffer to a text file

.. vhdl:procedure:: procedure nextline(buf : inout text_buffer; tl : inout unbounded_string);

  :param buf: 
  :type buf: inout text_buffer
  :param tl: 
  :type tl: inout unbounded_string

  Retrieve the current line from a buffer

.. vhdl:procedure:: procedure setline(buf : inout text_buffer; n : in positive);

  :param buf: 
  :type buf: inout text_buffer
  :param n: 
  :type n: in positive

  Move to a specific line in the buffer

.. vhdl:procedure:: procedure endbuffer(buf : in text_buffer; at_end : out boolean);

  :param buf: 
  :type buf: in text_buffer
  :param at_end: 
  :type at_end: out boolean

  Check if the end of the buffer has been reached

.. vhdl:procedure:: procedure free(buf : inout text_buffer);

  :param buf: 
  :type buf: inout text_buffer

  Deallocate the buffer contents
