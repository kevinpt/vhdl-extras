=================
strings_unbounded
=================

`extras/strings_unbounded.vhdl <https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/strings_unbounded.vhdl>`_


Dependencies
------------

:doc:`strings`,
:doc:`strings_maps`,
:doc:`strings_fixed`

Description
-----------

This package provides a string library for operating on unbounded length
strings. This is a clone of the Ada'95 library ``Ada.Strings.Unbounded``. Due
to the VHDL restriction on using access types as function parameters only
a limited subset of the Ada library is reproduced. The unbounded strings
are represented by the subtype :vhdl:type:`~extras.strings_unbounded.unbounded_string`
which is derived from line to ease interoperability with ``std.textio.line`` 
and :vhdl:type:`~extras.strings_unbounded.unbounded_string` are of
type access to string. Their contents are dynamically allocated. Because
operators cannot be provided, a new set of "copy" procedures are included
to simplify duplication of an existing unbounded string.

    
.. include:: auto/strings_unbounded.rst

