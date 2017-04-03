.. Generated from ../rtl/extras/characters_handling.vhdl on 2017-04-02 22:57:53.169129
.. vhdl:package:: characters_handling

Subprograms
-----------


.. vhdl:function:: function Is_Alphanumeric(ch : character) return boolean;

  :param ch: 
  :type ch: character

  Character class tests

.. vhdl:function:: function Is_Letter(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Control(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Digit(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Hexadecimal_Digit(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Basic(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Graphic(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Lower(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Upper(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function Is_Special(ch : character) return boolean;

  :param ch: 
  :type ch: character


.. vhdl:function:: function To_Lower(ch : character) return character;

  :param ch: 
  :type ch: character

  Case conversions

.. vhdl:function:: function To_Lower(source : string) return string;

  :param source: 
  :type source: string


.. vhdl:function:: function To_Upper(ch : character) return character;

  :param ch: 
  :type ch: character


.. vhdl:function:: function To_Upper(source : string) return string;

  :param source: 
  :type source: string


.. vhdl:function:: function To_Basic(ch : character) return character;

  :param ch: 
  :type ch: character


.. vhdl:function:: function To_Basic(source : string) return string;

  :param source: 
  :type source: string

