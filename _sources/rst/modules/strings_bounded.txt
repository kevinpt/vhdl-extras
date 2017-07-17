===============
strings_bounded
===============

`extras_2008/strings_bounded.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/strings_bounded.vhdl>`_


Dependencies
------------

:doc:`strings`,
:doc:`strings_maps`,
:doc:`strings_maps_constants`,
:doc:`strings_fixed`


Description
-----------

This package provides a string library for operating on bounded length
strings. This is a clone of the Ada'95 library ``Ada.Strings.Bounded``. It
is a nearly complete implementation with only the procedures taking
character mapping functions omitted because of VHDL limitations.
This package requires support for VHDL-2008 package generics. The
maximum size of a bounded string is established by instantiating a new
package with the ``MAX`` generic set to the desired size.

Unlike :doc:`fixed length strings <strings_fixed>` which must always be
padded to their full length, bounded strings can have any length up to the
maximum set when the package is instantiated.

Example usage
~~~~~~~~~~~~~

.. code-block:: vhdl

  -- Instantiate the package with a maximum length
  library extras_2008;
  package s20 is new extras_2008.strings_bounded
    generic map(MAX => 20);
  use work.s20.all;
  ...
  variable str : bounded_string; -- String with up to 20 characters
  variable l   : natural;
  ...
  str := to_bounded_string("abc");
  l := length(str); -- returns 3
  append(str, "def");
  l := length(str); -- returns 6
  
  
  
.. include:: auto/strings_bounded.rst

