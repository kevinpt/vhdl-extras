--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# strings_maps_constants.vhdl - Constants for use with character mapping
--# $Id$
--# Freely available from VHDL-extras (http://code.google.com/p/vhdl-extras)
--#
--# Copyright © 2014 Kevin Thibedeau
--# (kevin 'period' thibedeau 'at' gmail 'punto' com)
--#
--# Permission is hereby granted, free of charge, to any person obtaining a
--# copy of this software and associated documentation files (the "Software"),
--# to deal in the Software without restriction, including without limitation
--# the rights to use, copy, modify, merge, publish, distribute, sublicense,
--# and/or sell copies of the Software, and to permit persons to whom the
--# Software is furnished to do so, subject to the following conditions:
--#
--# The above copyright notice and this permission notice shall be included in
--# all copies or substantial portions of the Software.
--#
--# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--# DEALINGS IN THE SOFTWARE.
--#
--# DEPENDENCIES: strings_maps, characters_latin_1
--#
--# DESCRIPTION:
--#  This package provides constants for various character sets from the range
--#  of Latin-1 and mappings for upper case, lower case, and basic (unaccented)
--#  characters. It is a clone of the Ada'95 package
--#  Ada.Strings.Maps.Constants.
--------------------------------------------------------------------

library extras;
use extras.strings_maps.all;

package strings_maps_constants is

  constant NULL_SET : character_set := (others => false);
  constant IDENTITY : character_mapping;

  constant CONTROL_SET           : character_set;
  constant GRAPHIC_SET           : character_set;
  constant LETTER_SET            : character_set;
  constant LOWER_SET             : character_set;
  constant UPPER_SET             : character_set;
  constant BASIC_SET             : character_set;
  constant DECIMAL_DIGIT_SET     : character_set;
  constant HEXADECIMAL_DIGIT_SET : character_set;
  constant ALPHANUMERIC_SET      : character_set;
  constant SPECIAL_SET           : character_set;
  constant ISO_646_SET           : character_set;

  constant LOWER_CASE_MAP : character_mapping;
  constant UPPER_CASE_MAP : character_mapping;
  constant BASIC_MAP      : character_mapping;

end package;

library extras;
use extras.characters_latin_1.all;

package body strings_maps_constants is

  function generate_identity_mapping return character_mapping is
    variable result : character_mapping;
  begin
    for ch in character_mapping'range loop
      result(ch) := ch;
    end loop;

    return result;
  end function;

  constant IDENTITY : character_mapping := generate_identity_mapping;



