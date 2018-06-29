.. Generated from ../rtl/extras/characters_handling.vhdl on 2018-06-28 23:37:29.041308
.. vhdl:package:: extras.characters_handling


Subprograms
-----------


.. vhdl:function:: function Is_Alphanumeric(Ch : character) return boolean;

   Alphanumeric character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if alphanumeric character.
  


.. vhdl:function:: function Is_Letter(Ch : character) return boolean;

   Letter character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if letter character.
  


.. vhdl:function:: function Is_Control(Ch : character) return boolean;

   Control character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if control character.
  


.. vhdl:function:: function Is_Digit(Ch : character) return boolean;

   Digit character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if digit character.
  


.. vhdl:function:: function Is_Hexadecimal_Digit(Ch : character) return boolean;

   Hexadecimal digit character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if hexadecimal character.
  


.. vhdl:function:: function Is_Basic(Ch : character) return boolean;

   Basic character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if basic character.
  


.. vhdl:function:: function Is_Graphic(Ch : character) return boolean;

   Graphic character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if graphic character.
  


.. vhdl:function:: function Is_Lower(Ch : character) return boolean;

   Lower-case character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if lower-case character.
  


.. vhdl:function:: function Is_Upper(Ch : character) return boolean;

   Upper-case character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if upper-case character.
  


.. vhdl:function:: function Is_Special(Ch : character) return boolean;

   Special character test.
  
  :param Ch: Character to test
  :type Ch: character
  :returns: true if special character.
  


.. vhdl:function:: function To_Lower(Ch : character) return character;

   Convert a character to lower-case.
  
  :param Ch: Character to convert
  :type Ch: character
  :returns: Converted character.
  


.. vhdl:function:: function To_Lower(Source : string) return string;

   Convert a string to lower-case.
  
  :param Source: String to convert
  :type Source: string
  :returns: Converted string.
  


.. vhdl:function:: function To_Upper(Ch : character) return character;

   Convert a character to upper-case.
  
  :param Ch: Character to convert
  :type Ch: character
  :returns: Converted character.
  


.. vhdl:function:: function To_Upper(Source : string) return string;

   Convert a string to upper-case.
  
  :param Source: String to convert
  :type Source: string
  :returns: Converted string.
  


.. vhdl:function:: function To_Basic(Ch : character) return character;

   Convert a character to its basic (unaccented) form.
  
  :param Ch: Character to convert
  :type Ch: character
  :returns: Converted character.
  


.. vhdl:function:: function To_Basic(Source : string) return string;

   Convert a string to its basic (unaccented) form.
  
  :param Source: String to convert
  :type Source: string
  :returns: Converted string.
  

