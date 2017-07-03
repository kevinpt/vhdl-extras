=========
gray_code
=========

`extras/gray_code.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/gray_code.vhdl>`_

Dependencies
------------

None

Description
-----------

This package provides functions to convert between Gray code and binary.
An example implementation of a Gray code counter is also included.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  -- Conversion functions
  signal bin, gray, bin2 : std_ulogic_vector(7 downto 0);
  ...
  bin  <= X"C5";
  gray <= to_gray(bin);
  bin2 <= to_binary(gray);
  
  -- Gray code counter
  gc: gray_counter
    port map (
      Clock       => clock,
      Reset       => reset,
      Load        => '0', -- Not using load feature
      Enable      => '1', -- Count continuously
      Binary_load => (binary_count'range => '0'), -- Unused load port
      Binary      => binary_count, -- Internal binary count value
      Gray        => gray_count    -- Gray coded count
  );

    

    
.. include:: auto/gray_code.rst

