.. Generated from ../rtl/extras/text_buffering.vhdl on 2018-06-28 23:37:29.021524
.. vhdl:package:: extras.text_buffering


Types
-----


.. vhdl:type:: buffer_line_acc

  Pointer to next node in list.

.. vhdl:type:: buffer_line

  Linked list node of text lines.

.. vhdl:type:: text_buffer

  Buffer of text lines.

Subprograms
-----------


.. vhdl:procedure:: procedure load_buffer(Fh : text; Buf : out text_buffer);

   Load a text file object into a buffer.
  
  :param Fh: File handle
  :type Fh: None text
  :param Buf: Buffer created from file contents
  :type Buf: out text_buffer


.. vhdl:procedure:: procedure load_buffer(Fname : in string; Buf : out text_buffer);

   Load a file into a buffer.
  
  :param Fname: Name of text file to read
  :type Fname: in string
  :param Buf: Buffer created from file contents
  :type Buf: out text_buffer


.. vhdl:procedure:: procedure append_file(Fh : text; Buf : inout text_buffer);

   Append a text file object to an existing buffer.
  
  :param Fh: File handle
  :type Fh: None text
  :param Buf: Buffer to append onto
  :type Buf: inout text_buffer


.. vhdl:procedure:: procedure append_file(Fname : in string; Buf : inout text_buffer);

   Append a text file to an existing buffer.
  
  :param Fname: Name of text file to read
  :type Fname: in string
  :param Buf: Buffer to append onto
  :type Buf: inout text_buffer


.. vhdl:procedure:: procedure append(One_line : in unbounded_string; Buf : inout text_buffer);

   Append an unbounded string to a buffer.
  
  :param One_line: String to append
  :type One_line: in unbounded_string
  :param Buf: Buffer to append onto
  :type Buf: inout text_buffer


.. vhdl:procedure:: procedure append(One_line : in string; Buf : inout text_buffer);

   Append a string to a buffer
  
  :param One_line: String to append
  :type One_line: in string
  :param Buf: Buffer to append onto
  :type Buf: inout text_buffer


.. vhdl:procedure:: procedure write(Fh : text; Buf : in text_buffer);

   Write a buffer to a text file object.
  
  :param Fh: File handle
  :type Fh: None text
  :param Buf: Buffer to write into the file
  :type Buf: in text_buffer


.. vhdl:procedure:: procedure write(Fname : string; Buf : in text_buffer);

   Write a buffer to a text file.
  
  :param Fname: Name of text file to write
  :type Fname: None string
  :param Buf: Buffer to write into the file
  :type Buf: in text_buffer


.. vhdl:procedure:: procedure nextline(Buf : inout text_buffer; Tl : inout unbounded_string);

   Retrieve the current line from a buffer.
  
  :param Buf: Buffer to get line from
  :type Buf: inout text_buffer
  :param Tl: Current line in the buffer
  :type Tl: inout unbounded_string


.. vhdl:procedure:: procedure setline(Buf : inout text_buffer; N : in positive);

   Move to a specific line in the buffer.
  
  :param Buf: Buffer to seek into
  :type Buf: inout text_buffer
  :param N: Line number (zero based)
  :type N: in positive


.. vhdl:procedure:: procedure endbuffer(Buf : in text_buffer; At_end : out boolean);

   Check if the end of the buffer has been reached.
  
  :param Buf: Buffer to test
  :type Buf: in text_buffer
  :param At_end: true when the buffer line pointer is at the end
  :type At_end: out boolean


.. vhdl:procedure:: procedure free(Buf : inout text_buffer);

   Deallocate the buffer contents
  
  :param Buf: Buffer to free
  :type Buf: inout text_buffer

