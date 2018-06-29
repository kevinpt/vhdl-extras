==============
text_buffering
==============

`extras/text_buffering.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/text_buffering.vhdl>`_


Dependencies
------------

:doc:`strings_unbounded`

Description
-----------

This package provides a facility for storing buffered text. It can be used
to represent the contents of a text file as a linked list of dynamically
allocated strings for each line. A text file can be read into a buffer and
the resulting data structure can be incorporated into records passable
to procedures without having to maintain a separate file handle.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  variable buf    : text_buffer;
  variable at_end : boolean;
  variable tl     : unbounded_string;

  -- Add lines of text to a buffer
  append("First line", buf);
  append("Second line", buf);
  write("example.txt", buf);
  free(buf);

  -- Read a file into a buffer and iterate over its lines
  load_buffer("example.txt", buf);
  endbuffer(buf, at_end);
  while not at_end loop
   nextline(buf, tl);
   endbuffer(buf, at_end);
  end loop;
  free(buf);
    

    
.. include:: auto/text_buffering.rst

