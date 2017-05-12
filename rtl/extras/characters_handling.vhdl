--------------------------------------------------------------------
--  _    __ __  __ ____   __   =                                  --
-- | |  / // / / // __ \ / /   =                                  --
-- | | / // /_/ // / / // /    =    .__  |/ _/_  .__   .__    __  --
-- | |/ // __  // /_/ // /___  =   /___) |  /   /   ) /   )  (_ ` --
-- |___//_/ /_//_____//_____/  =  (___  /| (_  /     (___(_ (__)  --
--                           =====     /                          --
--                            ===                                 --
-----------------------------  =  ----------------------------------
--# characters_handling.vhdl - Implementation of ada.characters.handling
--# $Id:$
--# Freely available from VHDL-extras (http://github.com/kevinpt/vhdl-extras)
--#
--# Copyright © 2010 Kevin Thibedeau
--# (kevin 'period' thibedeau 'at' gmail 'punto' com)
--#
--# Permission is hereby granted, free of charge, to any person obtaining a copy
--# of this software and associated documentation files (the "Software"), to deal
--# in the Software without restriction, including without limitation the rights
--# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--# copies of the Software, and to permit persons to whom the Software is
--# furnished to do so, subject to the following conditions:
--#
--# The above copyright notice and this permission notice shall be included in
--# all copies or substantial portions of the Software.
--#
--# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--# THE SOFTWARE.
--#
--# DEPENDENCIES : strings_maps_constants
--#
--# DESCRIPTION:
--#  This is a package of functions that replicate the behavior of the Ada
--#  standard library package ada.characters.handling. Included are functions
--#  to test for different character classifications and perform conversion
--#  of characters and strings to upper and lower case.
--------------------------------------------------------------------

package characters_handling is

  --%% Character class tests
  
  --## Alphanumeric character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if alphanumeric character.
  function Is_Alphanumeric      ( Ch : character ) return boolean;
  
  --## Letter character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if letter character.
  function Is_Letter            ( Ch : character ) return boolean;
  
  --## Control character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if control character.
  function Is_Control           ( Ch : character ) return boolean;
  
  --## Digit character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if digit character.
  function Is_Digit             ( Ch : character ) return boolean;
  alias Is_Decimal_Digit is Is_Digit[character return boolean];

  --## Hexadecimal digit character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if hexadecimal character.
  function Is_Hexadecimal_Digit ( Ch : character ) return boolean;

  --## Basic character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if basic character.
  function Is_Basic             ( Ch : character ) return boolean; -- unaccented

  --## Graphic character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if graphic character.
  function Is_Graphic           ( Ch : character ) return boolean;

  --## Lower-case character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if lower-case character.
  function Is_Lower             ( Ch : character ) return boolean;

  --## Upper-case character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if upper-case character.
  function Is_Upper             ( Ch : character ) return boolean;

  --## Special character test.
  --# Args:
  --#  Ch: Character to test
  --# Returns:
  --#  true if special character.
  function Is_Special           ( Ch : character ) return boolean; -- punctuation

  --%% Case conversions
  
  --## Convert a character to lower-case.
  --# Args:
  --#  Ch: Character to convert
  --# Returns:
  --#  Converted character.
  function To_Lower( Ch : character ) return character;
  
  --## Convert a string to lower-case.
  --# Args:
  --#  Source: String to convert
  --# Returns:
  --#  Converted string.
  function To_Lower( Source : string ) return string;

  --## Convert a character to upper-case.
  --# Args:
  --#  Ch: Character to convert
  --# Returns:
  --#  Converted character.
  function To_Upper( Ch : character ) return character;
  
  --## Convert a string to upper-case.
  --# Args:
  --#  Source: String to convert
  --# Returns:
  --#  Converted string.
  function To_Upper( Source : string ) return string;
  
  --## Convert a character to its basic (unaccented) form.
  --# Args:
  --#  Ch: Character to convert
  --# Returns:
  --#  Converted character.
  function To_Basic( Ch : character ) return character;
  
  --## Convert a string to its basic (unaccented) form.
  --# Args:
  --#  Source: String to convert
  --# Returns:
  --#  Converted string.
  function To_Basic( Source : string ) return string;

end package;

library extras;
use extras.strings_maps_constants.all;

package body characters_handling is

  subtype class_mask is bit_vector(7 downto 0);

  -- character class masks
  constant Cc : class_mask := X"01"; -- Is_Control
  constant Nd : class_mask := X"02"; -- Is_Digit
  constant Nx : class_mask := X"04"; -- Is_Hexadecimal_Digit
  constant Lu : class_mask := X"08"; -- Is_Upper
  constant Ll : class_mask := X"10"; -- Is_Lower
  constant Zp : class_mask := X"20"; -- Is_Special
  constant Lb : class_mask := X"40"; -- Is_Basic

  constant LE : class_mask := Lu or Ll; -- Is_Letter
  constant AN : class_mask := LE or Nd; -- Is_Alphanumeric
  constant GR : class_mask := AN or Zp; -- Is_Graphic

  constant Bu : class_mask := Lu or Lb; -- uppercase basic
  constant Bl : class_mask := Ll or Lb; -- lowercase basic
  constant D  : class_mask := Nd or Nx; -- decimal digit
  constant XU : class_mask := Bu or Nx; -- uppercase hex digit
  constant XL : class_mask := Bl or Nx; -- lowercase hex digit


  type cclass_array is array ( character ) of class_mask;
  constant cclass_table : cclass_array :=
    ( Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- NUL SOH STX ETX  EOT ENQ ACK BEL
      Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- BS  HT  LF  VT   FF  CR  SO  SI
      Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- DLE DC1 DC2 DC3  DC4 NAK SYN ETB
      Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- CAN EM  SUB ESC  FSP GSP RSP USP
      Zp, Zp, Zp, Zp,  Zp, Zp, Zp, Zp,   -- ' ' !   "   #    $   %   &   '
      Zp, Zp, Zp, Zp,  Zp, Zp, Zp, Zp,   -- (   )   *   +    ,   -   .   /
       D,  D,  D,  D,   D,  D,  D,  D,   -- 0   1   2   3    4   5   6   7
       D,  D, Zp, Zp,  Zp, Zp, Zp, Zp,   -- 8   9   :   ;    <   =   >   ?
      Zp, XU, XU, XU,  XU, XU, XU, Bu,   -- @   A   B   C    D   E   F   G
      Bu, Bu, Bu, Bu,  Bu, Bu, Bu, Bu,   -- H   I   J   K    L   M   N   O
      Bu, Bu, Bu, Bu,  Bu, Bu, Bu, Bu,   -- P   Q   R   S    T   U   V   W
      Bu, Bu, Bu, Zp,  Zp, Zp, Zp, Zp,   -- X   Y   Z   [    \   ]   ^   _
      Zp, XL, XL, XL,  XL, XL, XL, Bl,   -- `   a   b   c    d   e   f   g
      Bl, Bl, Bl, Bl,  Bl, Bl, Bl, Bl,   -- h   i   j   k    l   m   n   o
      Bl, Bl, Bl, Bl,  Bl, Bl, Bl, Bl,   -- p   q   r   s    t   u   v   w
      Bl, Bl, Bl, Zp,  Zp, Zp, Zp, Cc,   -- x   y   z   {    |   }   ~   DEL

   -- Begin Latin-1 extensions
      Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- c128 - c135
      Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- c136 - c143
      Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- c144 - c151
      Cc, Cc, Cc, Cc,  Cc, Cc, Cc, Cc,   -- c152 - c159
      Zp, Zp, Zp, Zp,  Zp, Zp, Zp, Zp,   -- NBSP - Section Sign
      Zp, Zp, Zp, Zp,  Zp, Zp, Zp, Zp,   -- Diaeresis - Macron
      Zp, Zp, Zp, Zp,  Zp, Zp, Zp, Zp,   -- Degree Sign - Middle Dot
      Zp, Zp, Zp, Zp,  Zp, Zp, Zp, Zp,   -- Cedilla - Inverted Question
      Lu, Lu, Lu, Lu,  Lu, Lu, Bu, Lu,   -- UC A Grave - UC C Cedilla
      Lu, Lu, Lu, Lu,  Lu, Lu, Lu, Lu,   -- UC E Grave - UC I Diaeresis
      Bu, Lu, Lu, Lu,  Lu, Lu, Lu, Zp,   -- UC Icelandic Eth - Multiplication Sign
      Lu, Lu, Lu, Lu,  Lu, Lu, Bu, Bl,   -- UC O Oblique Stroke - LC German Sharp S
      Ll, Ll, Ll, Ll,  Ll, Ll, Bl, Ll,   -- LC A Grave - LC C Cedilla
      Ll, Ll, Ll, Ll,  Ll, Ll, Ll, Ll,   -- LC E Grave - LC I Diaeresis
      Bl, Ll, Ll, Ll,  Ll, Ll, Ll, Zp,   -- LC Icelandic Eth - Division Sign
      Ll, Ll, Ll, Ll,  Ll, Ll, Bl, Ll    -- LC O Oblique stroke - LC Y Diaeresis
     );


  function Is_Alphanumeric( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and AN) /= (class_mask'range => '0');
  end function;

  function Is_Letter( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and LE) /= (class_mask'range => '0');
  end function;

  function Is_Control( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and Cc) /= (class_mask'range => '0');
  end function;

  function Is_Digit( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and Nd) /= (class_mask'range => '0');
  end function;

  function Is_Hexadecimal_Digit( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and Nx) /= (class_mask'range => '0');
  end function;

  function Is_Basic ( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and Lb) /= (class_mask'range => '0');
  end function;

  function Is_Graphic( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and GR) /= (class_mask'range => '0');
  end function;

  function Is_Lower( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and Ll) /= (class_mask'range => '0');
  end function;

  function Is_Upper( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and Lu) /= (class_mask'range => '0');
  end function;

  function Is_Special( Ch : character ) return boolean is
  begin
    return (cclass_table(ch) and Zp) /= (class_mask'range => '0');
  end function;


  --## Lower case conversions
  function To_Lower( Ch : character ) return character is
  begin
    return LOWER_CASE_MAP(ch);
  end function;

  function To_Lower( source : string ) return string is
    alias src : string(1 to source'length) is source;
    variable result : string(1 to source'length);
  begin
    for i in src'range loop
      result(i) := LOWER_CASE_MAP(src(i));
    end loop;

    return result;
  end function;

  --## Upper case conversions
  function To_Upper( Ch : character ) return character is
  begin
    return UPPER_CASE_MAP(ch);
  end function;

  function To_Upper( source : string ) return string is
    alias src : string(1 to source'length) is source;
    variable result : string(1 to source'length);
  begin
    for i in src'range loop
      result(i) := UPPER_CASE_MAP(src(i));
    end loop;

    return result;
  end function;

  --## Basic (unaccented) conversions
  function To_Basic( Ch : character ) return character is
  begin
    return BASIC_MAP(ch);
  end function;

  function To_Basic( source : string ) return string is
    alias src : string(1 to source'length) is source;
    variable result : string(1 to source'length);
  begin
    for i in src'range loop
      result(i) := BASIC_MAP(src(i));
    end loop;

    return result;
  end function;

end package body;
