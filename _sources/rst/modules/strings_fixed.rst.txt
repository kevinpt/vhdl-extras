=============
strings_fixed
=============

`extras/strings_fixed.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/strings_fixed.vhdl>`_


Dependencies
------------

:doc:`strings`,
:doc:`strings_maps`,
:doc:`strings_maps_constants`

Description
-----------

This package provides a string library for operating on fixed length
strings. This is a clone of the Ada'95 library ``Ada.Strings.Fixed``. It is a
nearly complete implementation with only the procedures taking character
mapping functions omitted because of VHDL limitations.

These are functions for operating on the native VHDL string type. Any operation
that results in a shorter string must be padded with additional characters to fill
out the entire string.
    
    
.. include:: auto/strings_fixed.rst

